#!/bin/bash

# EmulatorJS Docker Interface - Script de Instalação
# Para uso via SSH/PuTTY

set -e

echo "🎮 EmulatorJS Docker Interface - Instalação Automática"
echo "======================================================"

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

# Verificar se está rodando como root
if [ "$EUID" -eq 0 ]; then
    print_warning "Executando como root. Recomendado usar usuário normal com sudo."
fi

# Verificar se Docker está instalado
print_status "Verificando instalação do Docker..."
if ! command -v docker &> /dev/null; then
    print_error "Docker não encontrado. Instalando Docker..."
    
    # Instalar Docker
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    rm get-docker.sh
    
    print_success "Docker instalado com sucesso!"
    print_warning "Reinicie a sessão SSH ou execute 'newgrp docker' para aplicar as permissões"
else
    print_success "Docker já está instalado"
fi

# Verificar se Docker Compose está instalado
print_status "Verificando Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
    print_error "Docker Compose não encontrado. Instalando..."
    
    # Instalar Docker Compose
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    
    print_success "Docker Compose instalado com sucesso!"
else
    print_success "Docker Compose já está instalado"
fi

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

# Construir e iniciar containers
print_status "Construindo e iniciando containers..."
docker-compose up -d --build

# Aguardar containers iniciarem
print_status "Aguardando containers iniciarem..."
sleep 10

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
    
else
    print_error "Falha ao iniciar containers!"
    print_status "Verificando logs..."
    docker-compose logs
    exit 1
fi

print_success "Instalação finalizada! 🎮"
