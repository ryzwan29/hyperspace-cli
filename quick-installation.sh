#!/bin/bash

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

# Install aios-cli packages
echo -e "\033[1;34mProses installasi packages aios-cli...\033[0m"
curl -s https://download.hyper.space/api/install | bash
source /root/.bashrc

# Meminta pengguna untuk memasukkan nama screen
screen_name="start-hyperspace-aioscli"

# 1. Membuat sesi screen dengan nama "$screen_name"
echo -e "\033[1;34m[1/7] Membuat sesi screen dengan nama '$screen_name'...\033[0m"
screen -S "$screen_name" -dm

# 2. Menjalankan perintah 'aios-cli start' di dalam sesi screen "$screen_name"
echo -e "\033[1;34m[2/7] Menjalankan perintah 'aios-cli start' di dalam sesi screen '$screen_name'...\033[0m"
screen -S "$screen_name" -X stuff "aios-cli start\n"

# Memberikan waktu untuk aios-cli start berjalan
sleep 5

# 3. Keluar dari sesi screen "$screen_name" setelah menjalankan perintah
echo -e "\033[1;34m[3/7] Keluar dari sesi screen '$screen_name'...\033[0m"
screen -S "$screen_name" -X detach
sleep 5

# Memastikan screen berhasil dibuat
if [[ $? -eq 0 ]]; then
    echo -e "\033[0;32mScreen dengan nama '$screen_name' berhasil dibuat dan menjalankan perintah aios-cli start.\033[0m"
else
    echo -e "\033[0;31mGagal membuat screen. Skrip dihentikan.\033[0m"
    exit 1
fi

# Menunggu beberapa detik untuk memberi waktu screen memulai proses
sleep 2

# Masukkan private key
echo -e "\033[1;34m[4/7] Masukkan private key Anda (akhiri dengan CTRL+D):\033[0m"
cat > .pem

# Menjalankan perintah import-keys dengan file.pem
echo -e "\033[1;34m[5/7] Menjalankan perintah import-keys dengan file.pem...\033[0m"
aios-cli hive import-keys ./.pem

# Menunggu 5 detik sebelum menjalankan perintah model add...
sleep 5
echo -e "\033[1;34m[6/7] Menambahkan model dengan perintah aios-cli models add...\033[0m"
model="hf:TheBloke/phi-2-GGUF:phi-2.Q4_K_M.gguf"

# Mengulang jika terjadi kesalahan
until aios-cli models add "$model"; do
    echo -e "\033[0;33mTerjadi kesalahan saat menambahkan model. Mengulang...\033[0m"
    sleep 3  # Tunggu 3 detik sebelum mencoba lagi
done

echo -e "\033[0;32mModel berhasil ditambahkan dan proses download selesai!\033[0m"

# Menjalankan inferensi menggunakan model yang telah ditambahkan
echo -e "\033[1;34m[7/7] Menjalankan inferensi menggunakan model yang telah ditambahkan...\033[0m"
infer_prompt="Hello, can you explain about the YouTube channel Share It Hub?"

# Mengulang jika terjadi kesalahan
until aios-cli infer --model "$model" --prompt "$infer_prompt"; do
    echo -e "\033[0;33mTerjadi kesalahan saat menjalankan inferensi. Mengulang...\033[0m"
    sleep 3  # Tunggu 3 detik sebelum mencoba lagi
done

echo -e "\033[0;32mInferensi selesai dan berhasil dijalankan!\033[0m"

# Menjalankan login dan select-tier sebelum menghentikan proses 'aios-cli start'
echo -e "\033[1;34m[8/7] Menjalankan login dan select-tier...\033[0m"
aios-cli hive login
aios-cli hive select-tier 5
aios-cli hive connect

# Menghentikan proses 'aios-cli start' dan menjalankan perintah 'aios-cli kill'
echo -e "\033[1;34m[9/7] Menghentikan proses 'aios-cli start' dengan 'aios-cli kill'...\033[0m"
aios-cli kill

# Masuk kembali ke dalam screen dan menjalankan perintah aios-cli start --connect menggunakan nohup
echo -e "\033[1;34m[10/7] Masuk kembali ke screen '$screen_name' untuk menjalankan aios-cli start --connect...\033[0m"
screen -S "$screen_name" -X stuff "echo 'Menunggu 5 detik sebelum menjalankan perintah...'; aios-cli start --connect\n"

echo -e "\033[0;32mProses selesai. aios-cli start --connect telah dijalankan di dalam screen dan sistem telah kembali ke latar belakang.\033[0m"
