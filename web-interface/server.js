const express = require('express');
const multer = require('multer');
const cors = require('cors');
const fs = require('fs-extra');
const path = require('path');

const app = express();
const PORT = 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Configurar multer para upload de ROMs
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    const system = req.body.system || 'general';
    const uploadPath = `/app/roms/${system}`;
    fs.ensureDirSync(uploadPath);
    cb(null, uploadPath);
  },
  filename: (req, file, cb) => {
    cb(null, file.originalname);
  }
});

const upload = multer({ 
  storage: storage,
  limits: { fileSize: 2 * 1024 * 1024 * 1024 } // 2GB
});

// Rotas da API
app.get('/api/roms', async (req, res) => {
  try {
    const systems = await fs.readdir('/app/roms');
    const roms = {};
    
    for (const system of systems) {
      const systemPath = path.join('/app/roms', system);
      const stats = await fs.stat(systemPath);
      
      if (stats.isDirectory()) {
        const files = await fs.readdir(systemPath);
        roms[system] = files.filter(file => {
          const ext = path.extname(file).toLowerCase();
          return ['.zip', '.7z', '.rar', '.gba', '.nes', '.snes', '.gb', '.gbc', '.n64', '.iso', '.cue', '.bin'].includes(ext);
        });
      }
    }
    
    res.json(roms);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.post('/api/upload', upload.single('rom'), (req, res) => {
  if (!req.file) {
    return res.status(400).json({ error: 'Nenhum arquivo enviado' });
  }
  
  res.json({ 
    message: 'ROM enviada com sucesso!',
    filename: req.file.filename,
    system: req.body.system
  });
});

app.delete('/api/roms/:system/:filename', async (req, res) => {
  try {
    const filePath = path.join('/app/roms', req.params.system, req.params.filename);
    await fs.remove(filePath);
    res.json({ message: 'ROM removida com sucesso!' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.get('/api/systems', (req, res) => {
  const systems = [
    { id: 'gba', name: 'Game Boy Advance', extensions: ['.gba', '.zip'] },
    { id: 'nes', name: 'Nintendo Entertainment System', extensions: ['.nes', '.zip'] },
    { id: 'snes', name: 'Super Nintendo', extensions: ['.snes', '.smc', '.zip'] },
    { id: 'gb', name: 'Game Boy', extensions: ['.gb', '.zip'] },
    { id: 'gbc', name: 'Game Boy Color', extensions: ['.gbc', '.zip'] },
    { id: 'n64', name: 'Nintendo 64', extensions: ['.n64', '.v64', '.z64', '.zip'] },
    { id: 'psx', name: 'PlayStation', extensions: ['.iso', '.cue', '.bin', '.zip'] },
    { id: 'sega', name: 'Sega Genesis', extensions: ['.smd', '.gen', '.zip'] },
    { id: 'arcade', name: 'Arcade', extensions: ['.zip'] }
  ];
  
  res.json(systems);
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Servidor API rodando na porta ${PORT}`);
});
