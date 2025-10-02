let currentSystem = null;
let systems = [];
let roms = {};
let deleteTarget = null;

// Inicializar aplicação
document.addEventListener('DOMContentLoaded', function() {
    loadSystems();
    loadRoms();
});

// Carregar sistemas disponíveis
async function loadSystems() {
    try {
        const response = await fetch('/api/systems');
        systems = await response.json();
        renderSystems();
        populateSystemSelect();
    } catch (error) {
        console.error('Erro ao carregar sistemas:', error);
        showAlert('Erro ao carregar sistemas', 'danger');
    }
}

// Carregar ROMs
async function loadRoms() {
    try {
        const response = await fetch('/api/roms');
        roms = await response.json();
        if (currentSystem) {
            renderRoms(currentSystem);
        }
    } catch (error) {
        console.error('Erro ao carregar ROMs:', error);
        showAlert('Erro ao carregar ROMs', 'danger');
    }
}

// Renderizar lista de sistemas
function renderSystems() {
    const systemsList = document.getElementById('systemsList');
    systemsList.innerHTML = '';
    
    systems.forEach(system => {
        const systemItem = document.createElement('div');
        systemItem.className = 'list-group-item system-item';
        systemItem.innerHTML = `
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <strong>${system.name}</strong>
                    <br>
                    <small class="text-muted">${system.extensions.join(', ')}</small>
                </div>
                <span class="badge bg-secondary">${roms[system.id] ? roms[system.id].length : 0}</span>
            </div>
        `;
        
        systemItem.addEventListener('click', () => selectSystem(system.id));
        systemsList.appendChild(systemItem);
    });
}

// Selecionar sistema
function selectSystem(systemId) {
    currentSystem = systemId;
    
    // Atualizar UI
    document.querySelectorAll('.system-item').forEach(item => {
        item.classList.remove('active');
    });
    event.target.closest('.system-item').classList.add('active');
    
    // Atualizar cabeçalho
    const system = systems.find(s => s.id === systemId);
    document.getElementById('currentSystem').textContent = system.name;
    document.getElementById('systemActions').style.display = 'block';
    
    // Renderizar ROMs
    renderRoms(systemId);
}

// Renderizar ROMs do sistema selecionado
function renderRoms(systemId) {
    const container = document.getElementById('romsContainer');
    const systemRoms = roms[systemId] || [];
    
    if (systemRoms.length === 0) {
        container.innerHTML = `
            <div class="empty-state">
                <i class="fas fa-folder-open"></i>
                <h5>Nenhuma ROM encontrada</h5>
                <p>Faça upload de ROMs para este sistema</p>
                <button class="btn btn-primary" onclick="showUploadModal()">
                    <i class="fas fa-upload me-1"></i>Upload ROM
                </button>
            </div>
        `;
        return;
    }
    
    container.innerHTML = `
        <div class="rom-grid">
            ${systemRoms.map(rom => `
                <div class="rom-item" onclick="playRom('${systemId}', '${rom}')">
                    <div class="rom-name">
                        <i class="fas fa-gamepad me-2"></i>
                        ${rom}
                    </div>
                    <div class="rom-info">
                        <small>Sistema: ${systems.find(s => s.id === systemId)?.name}</small>
                    </div>
                    <div class="rom-actions">
                        <button class="btn btn-sm btn-primary" onclick="event.stopPropagation(); playRom('${systemId}', '${rom}')">
                            <i class="fas fa-play me-1"></i>Jogar
                        </button>
                        <button class="btn btn-sm btn-danger" onclick="event.stopPropagation(); deleteRom('${systemId}', '${rom}')">
                            <i class="fas fa-trash me-1"></i>Excluir
                        </button>
                    </div>
                </div>
            `).join('')}
        </div>
    `;
}

// Jogar ROM
function playRom(systemId, filename) {
    const system = systems.find(s => s.id === systemId);
    const romPath = `/roms/${systemId}/${filename}`;
    
    // Abrir EmulatorJS em nova aba
    const emulatorUrl = `/emulatorjs/index.html?rom=${encodeURIComponent(romPath)}&system=${systemId}`;
    window.open(emulatorUrl, '_blank');
}

// Mostrar modal de upload
function showUploadModal() {
    const modal = new bootstrap.Modal(document.getElementById('uploadModal'));
    modal.show();
}

// Preencher select de sistemas
function populateSystemSelect() {
    const select = document.getElementById('systemSelect');
    select.innerHTML = '<option value="">Selecione um sistema</option>';
    
    systems.forEach(system => {
        const option = document.createElement('option');
        option.value = system.id;
        option.textContent = system.name;
        select.appendChild(option);
    });
}

// Upload de ROM
async function uploadRom() {
    const form = document.getElementById('uploadForm');
    const formData = new FormData(form);
    
    const systemSelect = document.getElementById('systemSelect');
    const romFile = document.getElementById('romFile');
    
    if (!systemSelect.value) {
        showAlert('Selecione um sistema', 'warning');
        return;
    }
    
    if (!romFile.files[0]) {
        showAlert('Selecione um arquivo', 'warning');
        return;
    }
    
    try {
        showUploadProgress(true);
        
        const response = await fetch('/api/upload', {
            method: 'POST',
            body: formData
        });
        
        const result = await response.json();
        
        if (response.ok) {
            showAlert('ROM enviada com sucesso!', 'success');
            form.reset();
            bootstrap.Modal.getInstance(document.getElementById('uploadModal')).hide();
            loadRoms();
        } else {
            showAlert(result.error || 'Erro no upload', 'danger');
        }
    } catch (error) {
        console.error('Erro no upload:', error);
        showAlert('Erro no upload da ROM', 'danger');
    } finally {
        showUploadProgress(false);
    }
}

// Mostrar/esconder progresso de upload
function showUploadProgress(show) {
    const progress = document.querySelector('.upload-progress');
    if (progress) {
        progress.classList.toggle('show', show);
    }
}

// Excluir ROM
function deleteRom(systemId, filename) {
    deleteTarget = { systemId, filename };
    document.getElementById('deleteFileName').textContent = filename;
    
    const modal = new bootstrap.Modal(document.getElementById('deleteModal'));
    modal.show();
}

// Confirmar exclusão
async function confirmDelete() {
    if (!deleteTarget) return;
    
    try {
        const response = await fetch(`/api/roms/${deleteTarget.systemId}/${deleteTarget.filename}`, {
            method: 'DELETE'
        });
        
        const result = await response.json();
        
        if (response.ok) {
            showAlert('ROM excluída com sucesso!', 'success');
            bootstrap.Modal.getInstance(document.getElementById('deleteModal')).hide();
            loadRoms();
        } else {
            showAlert(result.error || 'Erro ao excluir ROM', 'danger');
        }
    } catch (error) {
        console.error('Erro ao excluir ROM:', error);
        showAlert('Erro ao excluir ROM', 'danger');
    }
    
    deleteTarget = null;
}

// Atualizar ROMs
function refreshRoms() {
    loadRoms();
    showAlert('ROMs atualizadas!', 'info');
}

// Mostrar alerta
function showAlert(message, type) {
    const alertContainer = document.querySelector('.container-fluid');
    const alert = document.createElement('div');
    alert.className = `alert alert-${type} alert-dismissible fade show`;
    alert.innerHTML = `
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;
    
    alertContainer.insertBefore(alert, alertContainer.firstChild);
    
    // Auto-remover após 5 segundos
    setTimeout(() => {
        if (alert.parentNode) {
            alert.remove();
        }
    }, 5000);
}
