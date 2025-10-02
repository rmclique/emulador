#!/bin/bash

# EmulatorJS Docker Interface - Deploy via SSH
# Script para instalação rápida via PuTTY/SSH

echo "🚀 EmulatorJS Docker - Deploy via SSH"
echo "====================================="

# Verificar se está rodando via SSH
if [ -z "$SSH_CLIENT" ] && [ -z "$SSH_TTY" ]; then
    echo "⚠️  Aviso: Não detectado como sessão SSH"
fi

# Atualizar sistema
echo "📦 Atualizando sistema..."
sudo apt update -y

# Instalar dependências
echo "🔧 Instalando dependências..."
sudo apt install -y curl wget git

# Verificar Docker
if ! command -v docker &> /dev/null; then
    echo "🐳 Instalando Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    rm get-docker.sh
    echo "✅ Docker instalado!"
else
    echo "✅ Docker já instalado"
fi

# Verificar Docker Compose
if ! command -v docker-compose &> /dev/null; then
    echo "🐳 Instalando Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo "✅ Docker Compose instalado!"
else
    echo "✅ Docker Compose já instalado"
fi

# Criar diretório do projeto
PROJECT_DIR="emulatorjs-docker"
if [ -d "$PROJECT_DIR" ]; then
    echo "📁 Diretório $PROJECT_DIR já existe. Removendo..."
    rm -rf "$PROJECT_DIR"
fi

echo "📁 Criando diretório do projeto..."
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"

# Criar diretórios necessários
mkdir -p roms saves screenshots

echo "🎉 Deploy preparado!"
echo ""
echo "📋 Próximos passos:"
echo "1. Clone o repositório: git clone https://github.com/rmclique/emulador.git"
echo "2. Entre no diretório: cd emulador"
echo "3. Execute: chmod +x install.sh"
echo "4. Execute: ./install.sh"
echo ""
echo "🌐 Após a instalação, acesse: http://$(hostname -I | awk '{print $1'}):3000"
