# 📚 Informações do Repositório

## 🎮 EmulatorJS Docker Interface

**Repositório**: [https://github.com/rmclique/emulador](https://github.com/rmclique/emulador)

### 🚀 Instalação Rápida

```bash
# Instalação em uma linha
git clone https://github.com/rmclique/emulador.git && cd emulador && chmod +x install-quick.sh && ./install-quick.sh

# OU via curl
curl -fsSL https://raw.githubusercontent.com/rmclique/emulador/main/install-quick.sh | bash
```

### 🖥️ Para VM Ubuntu ARM64

```bash
# 1. Preparar ambiente
wget https://raw.githubusercontent.com/rmclique/emulador/main/deploy-arm64.sh
chmod +x deploy-arm64.sh
./deploy-arm64.sh

# 2. Clone e instalar
git clone https://github.com/rmclique/emulador.git
cd emulador
chmod +x install-arm64.sh
./install-arm64.sh
```

### 🔧 Comandos Úteis

```bash
# Ver logs
docker-compose logs

# Reiniciar
docker-compose restart

# Parar
docker-compose down

# Iniciar
docker-compose up -d
```

### 🌐 Acesso

- **Local**: http://localhost:3000
- **VM**: http://IP-DA-VM:3000

### 📁 Estrutura

```
emulador/
├── 🐳 docker-compose.yml      # Orquestração
├── 🐳 Dockerfile              # Container
├── 🚀 install-quick.sh        # Instalação rápida
├── 🚀 install-arm64.sh        # ARM64 específico
├── 🚀 deploy-arm64.sh         # Deploy ARM64
├── 📁 web-interface/          # Interface web
├── 📚 README.md               # Documentação
└── 📚 quick-start.md          # Guia rápido
```

### 🎯 Características

- ✅ Interface web moderna
- ✅ Upload de ROMs
- ✅ Múltiplos sistemas (NES, SNES, GBA, etc.)
- ✅ Persistência de dados
- ✅ API REST
- ✅ Docker Compose
- ✅ Suporte ARM64
- ✅ Instalação automática

### 📞 Suporte

- **Issues**: [GitHub Issues](https://github.com/rmclique/emulador/issues)
- **Documentação**: [README.md](README.md)
- **Logs**: `docker-compose logs`
