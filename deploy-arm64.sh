#!/bin/bash

# EmulatorJS Docker Interface - Deploy ARM64 via SSH
# Script para instalação rápida em VM Ubuntu ARM64

echo "🚀 EmulatorJS Docker - Deploy ARM64 via SSH"
echo "==========================================="

# Verificar arquitetura
ARCH=$(uname -m)
echo "🔍 Arquitetura detectada: $ARCH"

if [[ "$ARCH" != "aarch64" && "$ARCH" != "arm64" ]]; then
    echo "⚠️  Aviso: Este script é otimizado para ARM64. Arquitetura atual: $ARCH"
fi

# Verificar se está rodando via SSH
if [ -z "$SSH_CLIENT" ] && [ -z "$SSH_TTY" ]; then
    echo "⚠️  Aviso: Não detectado como sessão SSH"
fi

# Atualizar sistema Ubuntu ARM64
echo "📦 Atualizando sistema Ubuntu ARM64..."
sudo apt update -y
sudo apt upgrade -y

# Instalar dependências específicas para ARM64
echo "🔧 Instalando dependências para ARM64..."
sudo apt install -y \
    curl \
    wget \
    git \
    build-essential \
    python3 \
    python3-pip \
    ca-certificates \
    gnupg \
    lsb-release \
    software-properties-common

# Verificar Docker
if ! command -v docker &> /dev/null; then
    echo "🐳 Instalando Docker para ARM64..."
    
    # Adicionar repositório Docker oficial
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # Atualizar e instalar Docker
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    
    # Configurar Docker
    sudo systemctl enable docker
    sudo systemctl start docker
    sudo usermod -aG docker $USER
    
    echo "✅ Docker instalado para ARM64!"
else
    echo "✅ Docker já instalado"
fi

# Verificar Docker Compose
if ! command -v docker-compose &> /dev/null; then
    echo "🐳 Instalando Docker Compose para ARM64..."
    
    # Instalar Docker Compose específico para ARM64
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-linux-aarch64" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    
    echo "✅ Docker Compose instalado para ARM64!"
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

echo "🎉 Deploy ARM64 preparado!"
echo ""
echo "📋 Próximos passos:"
echo "1. Clone o repositório: git clone https://github.com/rmclique/emulador.git"
echo "2. Entre no diretório: cd emulador"
echo "3. Execute: chmod +x install-arm64.sh"
echo "4. Execute: ./install-arm64.sh"
echo ""
echo "🌐 Após a instalação, acesse: http://$(hostname -I | awk '{print $1'}):3000"
echo ""
echo "🔍 Para testar a conectividade:"
echo "   curl -I http://localhost:3000"
