#!/bin/bash

echo -e "\e[1;36m
   _____          _    _____            
  / ____|        | |  / ____|           
 | |     ___ _ __| |_| |  __  ___ _ __  
 | |    / _ \ '__| __| | |_ |/ _ \ '_ \ 
 | |___|  __/ |  | |_| |__| |  __/ | | |
  \_____\___|_|   \__|\_____|\___|_| |_|
                                        
                                        
           \e[1;35mSSL Setup Script by Lunosat\e[0m
"

echo -e "\n\e[1;33mChoose an option:\e[0m"
echo "1) Generate new certificate"
echo "2) Renew all certificates manually"

read -p $'\e[1;34mOption [1-2]: \e[0m' OPTION
case "$OPTION" in
  1)
    read -p $'\e[1;34mDomain (e.g. api.example.com): \e[0m' DOMAIN
    [ -z "$DOMAIN" ] && { echo -e "\e[1;31mError: domain cannot be empty.\e[0m"; exit 1; }

    read -p $'\e[1;34mEmail (required for Let\'s Encrypt): \e[0m' EMAIL
    [ -z "$EMAIL" ] && { echo -e "\e[1;31mError: email cannot be empty.\e[0m"; exit 1; }

    echo -e "\n\e[1;34mInstalling Certbot...\e[0m"
    sudo apt-get update -y
    sudo apt-get install -y software-properties-common
    sudo add-apt-repository universe -y
    sudo add-apt-repository ppa:certbot/certbot -y
    sudo apt-get update -y
    sudo apt-get install -y certbot

    echo -e "\n\e[1;34mRequesting certificate for $DOMAIN...\e[0m"
    sudo certbot certonly --standalone -d "$DOMAIN" --agree-tos -m "$EMAIL" --non-interactive

    if [ $? -eq 0 ]; then
      echo -e "\n\e[1;32m✅ Certificate successfully generated for $DOMAIN!\e[0m"
      echo -e "\n\e[1;33mUse in Node.js like this:\e[0m"
      echo -e "const fs = require('fs');\n\nconst SSL_OPTIONS = {\n  key: fs.readFileSync('/etc/letsencrypt/live/$DOMAIN/privkey.pem'),\n  cert: fs.readFileSync('/etc/letsencrypt/live/$DOMAIN/fullchain.pem')\n};"

      read -p $'\n\e[1;34mSet up automatic renewal? [y/N]: \e[0m' RENEW
      if [[ "$RENEW" =~ ^[Yy]$ ]]; then
        CRON_JOB="0 0,12 * * * certbot renew --standalone --quiet"
        sudo crontab -l 2>/dev/null | grep -Fq "$CRON_JOB"
        if [ $? -eq 0 ]; then
          echo -e "\n\e[1;33m⏱️  Automatic renewal already configured:\e[0m $CRON_JOB"
        else
          ( sudo crontab -l 2>/dev/null; echo "$CRON_JOB" ) | sudo crontab -
          echo -e "\n\e[1;32m✅ Automatic renewal configured:\e[0m $CRON_JOB"
        fi
      fi
    else
      echo -e "\e[1;31m❌ Certificate generation failed.\e[0m"
    fi
    ;;
  2)
    echo -e "\n\e[1;34mRenewing all certificates...\e[0m"
    sudo certbot renew --standalone --quiet
    if [ $? -eq 0 ]; then
      echo -e "\n\e[1;32m✅ Renewal completed successfully!\e[0m"
    else
      echo -e "\e[1;31m❌ Renewal failed.\e[0m"
    fi
    ;;
  *)
    echo -e "\e[1;31mInvalid option.\e[0m"
    exit 1
    ;;
esac
