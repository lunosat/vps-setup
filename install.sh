#!/bin/bash

# Fancy banner
echo -e "\e[1;35m"
echo " _   _           _        _____           _        _ _       "
echo "| \ | |         | |      |_   _|         | |      (_) |      "
echo "|  \| | ___   __| | ___    | |  _ __  ___| |_ __ _ _| |_ ___ "
echo "| . \` |/ _ \ / _\` |/ _ \   | | | '_ \/ __| __/ _\` | | __/ _ \\"
echo "| |\  | (_) | (_| |  __/  _| |_| | | \__ \ || (_| | | ||  __/"
echo "\_| \_/\___/ \__,_|\___| |_____|_| |_|___/\__\__,_|_|\__\___|"
echo -e "               \e[1;36mNode Install By Lunosat\e[0m"
echo

# Update packages
echo -e "\e[1;34mUpdating package list...\e[0m"
sudo apt-get update -y

# Install curl
echo -e "\e[1;34mInstalling curl...\e[0m"
sudo apt-get install -y curl

# Install Node.js 23.x
echo -e "\e[1;34mInstalling Node.js 23.x...\e[0m"
curl -fsSL https://deb.nodesource.com/setup_23.x -o nodesource_setup.sh
sudo -E bash nodesource_setup.sh
sudo apt-get install -y nodejs

# Verify Node.js
echo -e "\n\e[1;32mNode.js installed: $(node -v)\e[0m"

# Install Yarn using npm
echo -e "\e[1;34mInstalling Yarn via npm...\e[0m"
sudo npm install -g yarn

# Verify Yarn
echo -e "\e[1;32mYarn installed: $(yarn -v)\e[0m"

# Install PM2 globally
echo -e "\e[1;34mInstalling PM2...\e[0m"
sudo npm install -g pm2

# Verify PM2
echo -e "\e[1;32mPM2 installed: $(pm2 -v)\e[0m"

# Done
echo -e "\n\e[1;33mInstallation completed successfully!\e[0m"
