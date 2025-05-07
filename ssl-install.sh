#!/bin/bash

echo -e "\e[1;36m
  ____      _ _      _____      _ _           _   
 / ___|__ _| (_)_ __| ____|_  _| (_)_ __   __| |  
| |   / _\` | | | '__|  _| \ \/ / | | '_ \ / _\` |  
| |__| (_| | | | |  | |___ >  <| | | | | | (_| |_ 
 \____\__,_|_|_|_|  |_____/_/\_\_|_|_| |_|\__,_(_)
           \e[1;35mSSL Setup Script by Lunosat\e[0m
"

# Solicita domínio
read -p $'\e[1;34mEnter your domain (e.g. api.example.com): \e[0m' DOMAIN
if [ -z "$DOMAIN" ]; then
    echo -e "\e[1;31mError: Domain cannot be empty.\e[0m"
    exit 1
fi

# Solicita e-mail
read -p $'\e[1;34mEnter your email (required for Let\'s Encrypt): \e[0m' EMAIL
if [ -z "$EMAIL" ]; then
    echo -e "\e[1;31mError: Email cannot be empty.\e[0m"
    exit 1
fi

echo -e "\n\e[1;34mInstalling Certbot...\e[0m"
sudo apt-get update -y
sudo apt-get install -y software-properties-common
sudo add-apt-repository universe -y
sudo add-apt-repository ppa:certbot/certbot -y
sudo apt-get update -y
sudo apt-get install -y certbot

# Gera certificado com Certbot standalone
echo -e "\n\e[1;34mRequesting SSL certificate for $DOMAIN...\e[0m"
sudo certbot certonly --standalone -d $DOMAIN --agree-tos -m $EMAIL --non-interactive

# Verifica sucesso
if [ $? -eq 0 ]; then
    echo -e "\n\e[1;32m✅ SSL certificate successfully generated for $DOMAIN!\e[0m"
    echo -e "\n\e[1;33mYou can use it in Node.js like this:\e[0m"
    echo -e "\n\`\`\`js
const fs = require('fs');

const SSL_OPTIONS = {
    key: fs.readFileSync(\"/etc/letsencrypt/live/$DOMAIN/privkey.pem\"),
    cert: fs.readFileSync(\"/etc/letsencrypt/live/$DOMAIN/fullchain.pem\")
};
\`\`\`"
else
    echo -e "\e[1;31m❌ Failed to generate SSL certificate. Please check the output above.\e[0m"
fi
