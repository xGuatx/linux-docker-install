#!/bin/bash

# Mettre à jour les paquets
sudo apt-get update
sudo apt-get install -y ca-certificates curl

# Ajouter la clé GPG de Docker
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Ajouter le dépôt Docker pour Debian (Kali basé sur Debian Bookworm)
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  bookworm stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Mettre à jour les dépôts et installer Docker
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Vérifier que Docker fonctionne
sudo systemctl enable docker --now
sudo docker --version

