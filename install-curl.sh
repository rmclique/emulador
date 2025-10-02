#!/bin/bash

# EmulatorJS Docker Interface - Instalação via Curl
# Instalação em uma linha de comando

echo "🎮 EmulatorJS Docker - Instalação via Curl"
echo "=========================================="

# Verificar se está no diretório correto
if [ ! -f "docker-compose.yml" ]; then
    echo "❌ docker-compose.yml não encontrado!"
    echo "📋 Execute este comando no diretório do projeto:"
    echo "   git clone https://github.com/rmclique/emulador.git"
    echo "   cd emulador"
    echo "   curl -fsSL https://raw.githubusercontent.com/rmclique/emulador/main/install-quick.sh | bash"
    exit 1
fi

# Executar instalação rápida
chmod +x install-quick.sh
./install-quick.sh
