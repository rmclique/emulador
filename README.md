# EmulatorJS Docker Interface

Uma interface web completa para executar o EmulatorJS via Docker, permitindo upload e gerenciamento de ROMs de forma fácil e intuitiva.

## 🚀 Características

- **Interface Web Moderna**: Interface responsiva e intuitiva para gerenciar ROMs
- **Upload de ROMs**: Sistema de upload com suporte a múltiplos formatos
- **Múltiplos Sistemas**: Suporte para NES, SNES, GBA, Game Boy, N64, PlayStation e mais
- **Persistência de Dados**: ROMs, saves e screenshots são persistidos em volumes Docker
- **API REST**: API completa para gerenciamento de ROMs
- **Docker Compose**: Deploy simples com um comando

## 🎮 Sistemas Suportados

- **Nintendo**: NES, SNES, Game Boy, Game Boy Color, Game Boy Advance, Nintendo 64
- **Sega**: Master System, Mega Drive/Genesis, Game Gear, Saturn, 32X, CD
- **Atari**: 2600, 5200, 7800, Lynx, Jaguar
- **Commodore**: C64, C128, Amiga, PET, Plus/4, VIC-20
- **Outros**: PlayStation, PSP, Arcade, 3DO, MAME

## 📋 Pré-requisitos

- Docker
- Docker Compose
- Pelo menos 4GB de RAM disponível
- Espaço em disco para ROMs

## 🛠️ Instalação e Uso

### 🖥️ **Instalação Local (Windows/Linux)**

#### Opção 1: Instalação Automática
```bash
# Windows
install.bat

# Linux/Mac
chmod +x install.sh
./install.sh
```

#### Opção 2: Instalação Manual
```bash
# 1. Clone o repositório
git clone <seu-repositorio>
cd emulatorjs-docker-interface

# 2. Execute com Docker Compose
docker-compose up -d

# 3. Acesse a interface
# http://localhost:3000
```

### 🖥️ **Deploy via SSH/PuTTY (VM/Servidor)**

#### **Para VM Ubuntu ARM64:**
```bash
# 1. Preparar ambiente ARM64
wget https://raw.githubusercontent.com/SEU-USUARIO/emulatorjs-docker-interface/main/deploy-arm64.sh
chmod +x deploy-arm64.sh
./deploy-arm64.sh

# 2. Clone e instalar
git clone https://github.com/SEU-USUARIO/emulatorjs-docker-interface.git
cd emulatorjs-docker-interface

# 3. Instalar para ARM64
chmod +x install-arm64.sh
./install-arm64.sh
```

#### **Para VM x86_64:**
```bash
# 1. Preparar ambiente
wget https://raw.githubusercontent.com/SEU-USUARIO/emulatorjs-docker-interface/main/deploy-ssh.sh
chmod +x deploy-ssh.sh
./deploy-ssh.sh

# 2. Clone e instalar
git clone https://github.com/SEU-USUARIO/emulatorjs-docker-interface.git
cd emulatorjs-docker-interface

# 3. Instalar automaticamente
chmod +x install.sh
./install.sh
```

#### **Acessar:**
```bash
# Descobrir IP do servidor
hostname -I

# Acessar no navegador
# http://IP-DO-SERVIDOR:3000
```

## 📁 Estrutura de Diretórios

```
.
├── Dockerfile                 # Configuração do container
├── docker-compose.yml        # Orquestração dos serviços
├── nginx.conf                # Configuração do nginx
├── start.sh                  # Script de inicialização
├── web-interface/            # Interface web
│   ├── index.html           # Página principal
│   ├── style.css            # Estilos CSS
│   ├── script.js            # JavaScript da interface
│   ├── server.js            # API Node.js
│   └── package.json         # Dependências Node.js
├── roms/                     # ROMs (criado automaticamente)
├── saves/                    # Saves dos jogos
└── screenshots/              # Screenshots dos jogos
```

## 🎯 Como Usar

### Upload de ROMs
1. Acesse a interface web
2. Clique em "Upload ROM"
3. Selecione o sistema (NES, SNES, GBA, etc.)
4. Escolha o arquivo ROM
5. Clique em "Upload"

### Jogar
1. Selecione um sistema na sidebar
2. Clique em uma ROM para jogar
3. O jogo abrirá em uma nova aba

### Gerenciar ROMs
- **Excluir**: Clique no botão "Excluir" de uma ROM
- **Atualizar**: Clique no botão "Atualizar" na barra superior

## 🔧 Configuração Avançada

### Portas
Para alterar a porta, edite o `docker-compose.yml`:
```yaml
ports:
  - "3000:80"  # Altere 3000 para a porta desejada
```

### Volumes
Os volumes são configurados para persistir dados:
- `./roms:/app/roms` - ROMs
- `./saves:/app/saves` - Saves
- `./screenshots:/app/screenshots` - Screenshots

### Recursos
Para sistemas com pouca RAM, você pode limitar os recursos:
```yaml
deploy:
  resources:
    limits:
      memory: 2G
    reservations:
      memory: 1G
```

## 🐛 Solução de Problemas

### Container não inicia
```bash
# Verificar logs
docker-compose logs emulatorjs

# Reiniciar container
docker-compose restart emulatorjs
```

### ROMs não aparecem
1. Verifique se os arquivos estão na pasta `./roms/`
2. Verifique se o formato é suportado
3. Reinicie o container

### Performance lenta
1. Aumente a RAM disponível
2. Use ROMs em formato ZIP quando possível
3. Verifique se há outros processos consumindo recursos

## 📝 Formatos Suportados

### ROMs
- **ZIP**: Recomendado para múltiplos arquivos
- **7Z**: Arquivos compactados
- **RAR**: Arquivos compactados
- **Binários**: .gba, .nes, .snes, .gb, .gbc, .n64, .iso, .cue, .bin

### Sistemas e Extensões
- **GBA**: .gba, .zip
- **NES**: .nes, .zip
- **SNES**: .snes, .smc, .zip
- **Game Boy**: .gb, .zip
- **Game Boy Color**: .gbc, .zip
- **Nintendo 64**: .n64, .v64, .z64, .zip
- **PlayStation**: .iso, .cue, .bin, .zip

## 🤝 Contribuição

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença GPL-3.0. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 🙏 Agradecimentos

- [EmulatorJS](https://github.com/EmulatorJS/EmulatorJS) - Projeto base
- [RetroArch](https://www.retroarch.com/) - Core de emulação
- Comunidade de desenvolvedores de emuladores

## 📞 Suporte

Se encontrar problemas ou tiver dúvidas:
1. Abra uma [Issue](https://github.com/seu-usuario/emulatorjs-docker-interface/issues)
2. Verifique os logs: `docker-compose logs emulatorjs`
3. Consulte a documentação do [EmulatorJS](https://emulatorjs.org/docs/)

---

**Divirta-se jogando! 🎮**
