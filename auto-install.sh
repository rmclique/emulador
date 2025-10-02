#!/bin/bash

# EmulatorJS Docker Interface - Instalação Automática
# Detecta automaticamente a arquitetura e instala a versão correta

set -e

echo "🎮 EmulatorJS Docker Interface - Instalação Automática"
echo "======================================================"

# Detectar arquitetura
ARCH=$(uname -m)
echo "🔍 Arquitetura detectada: $ARCH"

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

# Detectar e executar script apropriado
if [[ "$ARCH" == "aarch64" || "$ARCH" == "arm64" ]]; then
    print_status "Detectada arquitetura ARM64 - Usando script otimizado"
    
    if [ -f "install-arm64.sh" ]; then
        chmod +x install-arm64.sh
        ./install-arm64.sh
    else
        print_error "Script install-arm64.sh não encontrado!"
        print_status "Tentando instalação genérica..."
        chmod +x install.sh
        ./install.sh
    fi
    
elif [[ "$ARCH" == "x86_64" || "$ARCH" == "amd64" ]]; then
    print_status "Detectada arquitetura x86_64 - Usando script padrão"
    
    if [ -f "install.sh" ]; then
        chmod +x install.sh
        ./install.sh
    else
        print_error "Script install.sh não encontrado!"
        exit 1
    fi
    
else
    print_warning "Arquitetura não reconhecida: $ARCH"
    print_status "Tentando instalação genérica..."
    
    if [ -f "install.sh" ]; then
        chmod +x install.sh
        ./install.sh
    else
        print_error "Nenhum script de instalação encontrado!"
        exit 1
    fi
fi

print_success "Instalação automática concluída! 🎮"
