#!bin/bash

clear
echo -e "\033[1;32m
██████╗ ██╗   ██  ███████╗  ███████╗  ███████╗  
██╔══██╗ ██╗ ██║  ██║   ██║ ██║   ██║ ██║   ██║
██████╔╝  ████║   ██║   ██║ ██║   ██║ ██║   ██║
██╔══██╗   ██╔╝   ██║   ██║ ██║   ██║ ██║   ██║
██║  ██║   ██║    ███████║  ███████║  ███████║
╚═╝  ╚═╝   ╚═╝    ╚══════╝  ╚══════╝  ╚══════╝
\033[0m"
echo -e "\033[1;34m==================================================\033[1;34m"
echo -e "\033[1;34m@Ryddd | Testnet, Node Runer, Developer, Retrodrop\033[1;34m"

sleep 4

# Update & Install dependencies
echo -e "\033[0;32mUpdating and Installing dependencies...\033[0m"
sudo apt update && sudo apt upgrade -y

# Install packages
echo -e "\033[0;32mDownload $ Activate Packages...\033[0m"
curl https://download.hyper.space/api/install | bash
source ~/.bashrc

#!/bin/bash

# Membuat file hyperspace-key.pem
KEY_FILE="hyperspace-key.pem"

echo "Masukkan private keys Anda (tekan Enter untuk selesai):"
read -p "Private Key: " PRIVATE_KEY

# Menulis private key ke dalam file
echo "$PRIVATE_KEY" > "$KEY_FILE"

# Memastikan file telah dibuat
if [ -f "$KEY_FILE" ]; then
    echo "File $KEY_FILE berhasil dibuat."
else
    echo "Gagal membuat file $KEY_FILE. Script dihentikan."
    exit 1
fi

# Membuat screen session a
echo "Membuat screen session 'a'..."
screen -dmS activate-aioscli bash -c "source ~/.bashrc && aios-cli start; exec bash"

# Membuat screen session b dengan tambahan perintah
echo "Membuat screen session 'activate-aioscli-wallet'..."
screen -dmS start-aioscli-config bash -c "
    source ~/.bashrc &&
    aios-cli hive import-keys ./hyperspace-key.pem &&
    aios-cli models add hf:afrideva/Tiny-Vicuna-1B-GGUF &&
    aios-cli models check hf:afrideva/Tiny-Vicuna-1B-GGUF &&
    aios-cli infer --model add hf:afrideva/Tiny-Vicuna-1B-GGUF --prompt 'Hello, can you explain the concept of blockchain technology in simple terms?' &&
    aios-cli hive login &&
    aios-cli hive select-tier 5 &&
    aios-cli hive connect;
    exec bash
"

echo "Script selesai. Screen sessions 'ctivate-aioscli' dan 'start-aioscli-config' telah dibuat."
