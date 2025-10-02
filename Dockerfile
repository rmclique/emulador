# Use Node.js como base (compatível com ARM64)
FROM node:18-alpine

# Instalar dependências do sistema
RUN apk add --no-cache \
    nginx \
    python3 \
    make \
    g++ \
    git

# Criar diretórios
WORKDIR /app
RUN mkdir -p /app/emulatorjs /app/roms /app/saves /app/screenshots

# Clonar e configurar EmulatorJS
RUN git clone https://github.com/EmulatorJS/EmulatorJS.git /app/emulatorjs
WORKDIR /app/emulatorjs

# Instalar dependências
RUN npm install

# Baixar cores e dados necessários
RUN node update.js

# Configurar nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Copiar interface personalizada
COPY web-interface/ /app/web-interface/

# Expor portas
EXPOSE 80

# Script de inicialização
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
