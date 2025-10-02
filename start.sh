#!/bin/sh

# Iniciar servidor Node.js para API
cd /app/web-interface
node server.js &

# Iniciar nginx
nginx -g "daemon off;"
