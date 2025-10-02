@echo off
REM EmulatorJS Docker Interface - Script de Instalação para Windows
REM Para uso local no Windows

echo 🎮 EmulatorJS Docker Interface - Instalação Automática
echo ======================================================

REM Verificar se Docker está instalado
echo [INFO] Verificando instalação do Docker...
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Docker não encontrado!
    echo [INFO] Por favor, instale o Docker Desktop: https://www.docker.com/products/docker-desktop
    pause
    exit /b 1
)
echo [SUCCESS] Docker encontrado!

REM Verificar se Docker Compose está instalado
echo [INFO] Verificando Docker Compose...
docker-compose --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Docker Compose não encontrado!
    echo [INFO] Docker Compose geralmente vem com Docker Desktop
    pause
    exit /b 1
)
echo [SUCCESS] Docker Compose encontrado!

REM Criar diretórios necessários
echo [INFO] Criando diretórios...
if not exist "roms" mkdir roms
if not exist "saves" mkdir saves
if not exist "screenshots" mkdir screenshots
echo [SUCCESS] Diretórios criados

REM Verificar se o arquivo docker-compose.yml existe
if not exist "docker-compose.yml" (
    echo [ERROR] docker-compose.yml não encontrado!
    echo [ERROR] Certifique-se de estar no diretório correto do projeto
    pause
    exit /b 1
)

REM Parar containers existentes
echo [INFO] Parando containers existentes...
docker-compose down >nul 2>&1

REM Construir e iniciar containers
echo [INFO] Construindo e iniciando containers...
docker-compose up -d --build

REM Aguardar containers iniciarem
echo [INFO] Aguardando containers iniciarem...
timeout /t 10 /nobreak >nul

REM Verificar se containers estão rodando
docker-compose ps | findstr "Up" >nul
if %errorlevel% equ 0 (
    echo.
    echo 🎉 INSTALAÇÃO CONCLUÍDA!
    echo ========================
    echo.
    echo 📱 Acesse a interface em:
    echo    http://localhost:3000
    echo.
    echo 🔧 Comandos úteis:
    echo    docker-compose logs          # Ver logs
    echo    docker-compose restart       # Reiniciar
    echo    docker-compose down          # Parar
    echo    docker-compose up -d         # Iniciar
    echo.
    echo 📁 Diretórios criados:
    echo    .\roms\      - Para suas ROMs
    echo    .\saves\     - Saves dos jogos
    echo    .\screenshots\ - Screenshots
    echo.
    echo [SUCCESS] Instalação finalizada! 🎮
    echo.
    echo Pressione qualquer tecla para abrir o navegador...
    pause >nul
    start http://localhost:3000
) else (
    echo [ERROR] Falha ao iniciar containers!
    echo [INFO] Verificando logs...
    docker-compose logs
    pause
    exit /b 1
)
