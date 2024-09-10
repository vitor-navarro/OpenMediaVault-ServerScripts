#!/bin/bash

# Diretório onde está o arquivo de configuração
config_dir="Config"

# Arquivo de configuração
config_file="$config_dir/MonitoringConfig.txt"

# Diretório inicial (raiz do sistema)
start_dir="/"

# Diretório onde o arquivo será salvo
output_dir="ArquivosGerados"

# Cria a pasta ArquivosGerados se não existir
mkdir -p "$output_dir"

# Arquivo onde serão salvos os resultados, dentro da pasta ArquivosGerados
output_file="$output_dir/pastas_encontradas.txt"

# Limpa o conteúdo do arquivo de saída (caso exista)
> "$output_file"

# Verifica se o arquivo de configuração existe
if [[ ! -f "$config_file" ]]; then
    echo "Arquivo de configuração '$config_file' não encontrado."
    exit 1
fi

# Lê a lista de pastas do arquivo de configuração
folders_line=$(cat "$config_file")
IFS=',' read -r -a folders <<< "$folders_line"

# Função para buscar as pastas
find_folders() {
    for folder in "${folders[@]}"; do
        # Remove espaços em branco ao redor do nome da pasta
        folder=$(echo "$folder" | xargs)
        
        # Procurar por pastas com o nome específico
        found_folders=$(find "$start_dir" -type d -name "$folder" 2>/dev/null)
        if [[ -n "$found_folders" ]]; then
            # Para cada pasta encontrada, registrar a pasta e o caminho
            while IFS= read -r folder_path; do
                echo "$folder : $folder_path" | tee -a "$output_file"
            done <<< "$found_folders"
        else
            echo "$folder : Não encontrada" | tee -a "$output_file"
        fi
    done
}

# Executar a função de busca
find_folders
