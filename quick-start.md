# 🚀 Quick Start - EmulatorJS Docker

## ⚡ Instalação Rápida

### 1. **Instalação em Uma Linha**
```bash
# Clone e instale automaticamente
git clone https://github.com/rmclique/emulador.git && cd emulador && chmod +x install-quick.sh && ./install-quick.sh
```

### 2. **Instalação via Curl**
```bash
# Instalação direta via curl
curl -fsSL https://raw.githubusercontent.com/rmclique/emulador/main/install-quick.sh | bash
```

### 3. **Instalação Manual**
```bash
# Clone
git clone https://github.com/rmclique/emulador.git
cd emulador

# Instalar
chmod +x install-quick.sh
./install-quick.sh
```

### 4. **Acessar**
```
http://localhost:3000
```

## 🖥️ **Via SSH/PuTTY (VM)**

### 1. **Preparar Servidor**

#### **Para VM Ubuntu ARM64:**
```bash
# Preparar ambiente ARM64
wget https://raw.githubusercontent.com/rmclique/emulador/main/deploy-arm64.sh
chmod +x deploy-arm64.sh
./deploy-arm64.sh
```

#### **Para VM x86_64:**
```bash
# Instalar dependências
sudo apt update && sudo apt install -y curl wget git

# Instalar Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Instalar Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

### 2. **Deploy do Projeto**

#### **Para ARM64:**
```bash
# Clone
git clone https://github.com/rmclique/emulador.git
cd emulador

# Instalar para ARM64
chmod +x install-arm64.sh
./install-arm64.sh
```

#### **Para x86_64:**
```bash
# Clone
git clone https://github.com/rmclique/emulador.git
cd emulador

# Instalar
chmod +x install.sh
./install.sh
```

### 3. **Acessar**
```bash
# Descobrir IP
hostname -I

# Acessar: http://IP:3000
```

## 🔧 **Comandos Úteis**

```bash
# Ver logs
docker-compose logs

# Reiniciar
docker-compose restart

# Parar
docker-compose down

# Iniciar
docker-compose up -d

# Reconstruir
docker-compose up -d --build
```

## 📁 **Estrutura de Arquivos**

```
emulador/
├── 🐳 docker-compose.yml      # Orquestração
├── 🐳 Dockerfile              # Container
├── 🚀 install.sh              # Instalação Linux/Mac
├── 🚀 install.bat             # Instalação Windows
├── 🚀 deploy-ssh.sh            # Deploy SSH
├── 📁 web-interface/          # Interface web
├── 📁 roms/                   # ROMs (criado automaticamente)
├── 📁 saves/                  # Saves (criado automaticamente)
└── 📁 screenshots/            # Screenshots (criado automaticamente)
```

## 🎮 **Como Usar**

1. **Upload ROMs**: Clique em "Upload ROM" na interface
2. **Selecionar Sistema**: Escolha NES, SNES, GBA, etc.
3. **Jogar**: Clique na ROM para abrir o emulador
4. **Gerenciar**: Excluir ROMs ou organizar por sistema

## 🆘 **Problemas Comuns**

### Container não inicia
```bash
docker-compose logs
docker-compose restart
```

### Porta ocupada
Edite `docker-compose.yml` e mude a porta:
```yaml
ports:
  - "3001:80"  # Mude 3001 para outra porta
```

### Permissões Docker
```bash
sudo usermod -aG docker $USER
# Faça logout e login novamente
```

## 📞 **Suporte**

- **Issues**: [GitHub Issues](https://github.com/rmclique/emulador/issues)
- **Documentação**: [README.md](README.md)
- **Logs**: `docker-compose logs`

---

**🎮 Divirta-se jogando!**
