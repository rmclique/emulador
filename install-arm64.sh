#!/bin/bash

# EmulatorJS Docker Interface - Script de Instalação para ARM64
# Otimizado para VM Ubuntu ARM64

set -e

echo "🎮 EmulatorJS Docker Interface - Instalação ARM64"
echo "================================================"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para imprimir mensagens coloridas
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

if [[ "$ARCH" != "aarch64" && "$ARCH" != "arm64" ]]; then
    print_warning "Este script é otimizado para ARM64. Arquitetura atual: $ARCH"
fi

# Verificar se está rodando como root
if [ "$EUID" -eq 0 ]; then
    print_warning "Executando como root. Recomendado usar usuário normal com sudo."
fi

# Atualizar sistema
print_status "Atualizando sistema Ubuntu ARM64..."
sudo apt update -y
sudo apt upgrade -y

# Instalar dependências específicas para ARM64
print_status "Instalando dependências para ARM64..."
sudo apt install -y \
    curl \
    wget \
    git \
    build-essential \
    python3 \
    python3-pip \
    ca-certificates \
    gnupg \
    lsb-release

# Verificar se Docker está instalado
print_status "Verificando instalação do Docker..."
if ! command -v docker &> /dev/null; then
    print_error "Docker não encontrado. Instalando Docker para ARM64..."
    
    # Adicionar repositório Docker
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # Atualizar e instalar Docker
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    
    # Adicionar usuário ao grupo docker
    sudo usermod -aG docker $USER
    
    print_success "Docker instalado com sucesso para ARM64!"
    print_warning "Reinicie a sessão SSH ou execute 'newgrp docker' para aplicar as permissões"
else
    print_success "Docker já está instalado"
fi

# Verificar se Docker Compose está instalado
print_status "Verificando Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
    print_error "Docker Compose não encontrado. Instalando..."
    
    # Instalar Docker Compose para ARM64
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-linux-aarch64" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    
    print_success "Docker Compose instalado com sucesso para ARM64!"
else
    print_success "Docker Compose já está instalado"
fi

# Configurar Docker para ARM64
print_status "Configurando Docker para ARM64..."
sudo systemctl enable docker
sudo systemctl start docker

# Criar diretórios necessários
print_status "Criando diretórios..."
mkdir -p roms saves screenshots
print_success "Diretórios criados"

# Verificar se o arquivo docker-compose.yml existe
if [ ! -f "docker-compose.yml" ]; then
    print_error "docker-compose.yml não encontrado!"
    print_error "Certifique-se de estar no diretório correto do projeto"
    exit 1
fi

# Parar containers existentes (se houver)
print_status "Parando containers existentes..."
docker-compose down 2>/dev/null || true

# Construir e iniciar containers (otimizado para ARM64)
print_status "Construindo e iniciando containers para ARM64..."
docker-compose up -d --build

# Aguardar containers iniciarem
print_status "Aguardando containers iniciarem..."
sleep 15

# Verificar se containers estão rodando
if docker-compose ps | grep -q "Up"; then
    print_success "Containers iniciados com sucesso!"
    
    echo ""
    echo "🎉 INSTALAÇÃO CONCLUÍDA!"
    echo "========================"
    echo ""
    echo "📱 Acesse a interface em:"
    echo "   http://seu-ip:3000"
    echo ""
    echo "🔧 Comandos úteis:"
    echo "   docker-compose logs          # Ver logs"
    echo "   docker-compose restart       # Reiniciar"
    echo "   docker-compose down          # Parar"
    echo "   docker-compose up -d         # Iniciar"
    echo ""
    echo "📁 Diretórios criados:"
    echo "   ./roms/      - Para suas ROMs"
    echo "   ./saves/     - Saves dos jogos"
    echo "   ./screenshots/ - Screenshots"
    echo ""
    
    # Mostrar IP da máquina
    IP=$(hostname -I | awk '{print $1}')
    echo "🌐 URL de acesso: http://$IP:3000"
    echo ""
    echo "🔍 Para verificar se está funcionando:"
    echo "   curl http://localhost:3000"
    
else
    print_error "Falha ao iniciar containers!"
    print_status "Verificando logs..."
    docker-compose logs
    exit 1
fi

print_success "Instalação finalizada para ARM64! 🎮"
