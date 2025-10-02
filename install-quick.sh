#!/bin/bash

# EmulatorJS Docker Interface - Instalação Rápida
# Script otimizado para o repositório rmclique/emulador

set -e

echo "🎮 EmulatorJS Docker - Instalação Rápida"
echo "======================================="

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Detectar arquitetura
ARCH=$(uname -m)
print_status "Arquitetura detectada: $ARCH"

# Verificar se Docker está instalado
if ! command -v docker &> /dev/null; then
    print_error "Docker não encontrado!"
    print_status "Instalando Docker..."
    
    # Instalar Docker
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    rm get-docker.sh
    
    print_success "Docker instalado!"
    print_warning "Reinicie a sessão SSH ou execute 'newgrp docker'"
else
    print_success "Docker encontrado"
fi

# Verificar Docker Compose
if ! command -v docker-compose &> /dev/null; then
    print_status "Instalando Docker Compose..."
    
    if [[ "$ARCH" == "aarch64" || "$ARCH" == "arm64" ]]; then
        sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-linux-aarch64" -o /usr/local/bin/docker-compose
    else
        sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    fi
    
    sudo chmod +x /usr/local/bin/docker-compose
    print_success "Docker Compose instalado!"
else
    print_success "Docker Compose encontrado"
fi

# Criar diretórios
print_status "Criando diretórios..."
mkdir -p roms saves screenshots

# Parar containers existentes
print_status "Parando containers existentes..."
docker-compose down 2>/dev/null || true

# Construir e iniciar
print_status "Construindo e iniciando containers..."
docker-compose up -d --build

# Aguardar
print_status "Aguardando containers iniciarem..."
sleep 15

# Verificar status
if docker-compose ps | grep -q "Up"; then
    print_success "Instalação concluída!"
    
    echo ""
    echo "🎉 SUCESSO!"
    echo "==========="
    echo ""
    echo "📱 Acesse: http://$(hostname -I | awk '{print $1'}):3000"
    echo ""
    echo "🔧 Comandos úteis:"
    echo "   docker-compose logs     # Ver logs"
    echo "   docker-compose restart  # Reiniciar"
    echo "   docker-compose down     # Parar"
    echo ""
    
else
    print_error "Falha na instalação!"
    print_status "Verificando logs..."
    docker-compose logs
    exit 1
fi

print_success "Pronto para usar! 🎮"
