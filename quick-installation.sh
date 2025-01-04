#!/bin/bash

# Bersihkan layar dan tampilkan banner
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
echo -e "\033[0;32m[1/7] Updating and installing dependencies...\033[0m"
sudo apt update && sudo apt upgrade -y
echo -e "\033[0;32mDependencies updated successfully.\033[0m"

# Install Hyperspace CLI
echo -e "\033[0;32m[2/7] Installing Hyperspace CLI...\033[0m"
curl https://download.hyper.space/api/install | bash
source /root/.bashrc
echo -e "\033[0;32mHyperspace CLI installed successfully.\033[0m"

# Create .pem file
KEY_FILE="hyperspace-key.pem"
echo -e "\033[1;34m[3/7] Creating $KEY_FILE file...\033[0m"
echo "Masukkan private keys Anda:"
read -p "Private Key: " PRIVATE_KEY
echo "$PRIVATE_KEY" > "$KEY_FILE"
echo -e "\033[0;32m$KEY_FILE created successfully.\033[0m"

# Start Hyperspace in Screen Session
echo -e "\033[1;34m[4/7] Starting Hyperspace in a screen session...\033[0m"
screen -dmS hyperspace bash -c "
    source /root/.bashrc &&
    aios-cli start;
    exec bash
"
echo -e "\033[0;32mScreen session 'hyperspace' started successfully.\033[0m"

# Configure Model and Hive in Another Screen
echo -e "\033[1;34m[5/7] Configuring model and Hive in another screen session...\033[0m"
screen -dmS prompt-hyperspace bash -c "
    source /root/.bashrc &&
    aios-cli models add hf:TheBloke/phi-2-GGUF:phi-2.Q4_K_M.gguf &&
    aios-cli infer --model hf:TheBloke/phi-2-GGUF:phi-2.Q4_K_M.gguf --prompt 'Hello, can you explain about the YouTube channel Share It Hub?' &&
    aios-cli hive import-keys ./$KEY_FILE &&
    aios-cli hive login &&
    aios-cli hive select-tier 5 &&
    aios-cli hive connect &&
    aios-cli hive infer --model hf:TheBloke/phi-2-GGUF:phi-2.Q4_K_M.gguf --prompt 'Hello, can you explain about the YouTube channel Share It Hub?';
    exec bash
"
echo -e "\033[0;32mScreen session 'prompt-hyperspace' started successfully.\033[0m"

# Wait for 'prompt-hyperspace' to finish
echo -e "\033[1;34m[6/7] Waiting for 'prompt-hyperspace' to complete...\033[0m"
while screen -list | grep -q "prompt-hyperspace"; do
    echo -e "\033[0;33mWaiting for 'prompt-hyperspace' process...\033[0m"
    sleep 30  # Memeriksa setiap 60 detik
done
echo -e "\033[0;32m'prompt-hyperspace' process completed.\033[0m"

# Restart Hyperspace with --connect
echo -e "\033[1;34m[7/7] Restarting Hyperspace with --connect...\033[0m"
screen -r hyperspace -X stuff $'\003' # Send CTRL+C to terminate existing process
screen -r hyperspace -X stuff "aios-cli start --connect\n"
echo -e "\033[0;32mHyperspace restarted with --connect.\033[0m"

# Check Points
echo -e "\033[1;34m[8/7] Checking Hive points...\033[0m"
screen -dmS check-points bash -c "
    source /root/.bashrc &&
    aios-cli hive points;
    exec bash
"
echo -e "\033[0;32mHive points check complete.\033[0m"

echo -e "\033[1;32mScript execution complete. Use 'screen -ls' to view active screen sessions.\033[0m"
