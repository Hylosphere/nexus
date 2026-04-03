#!/bin/bash
echo "🚀 DÉMARRAGE DE L'INSTALLATION (Version Ubuntu / HP ProDesk)..."

# 1. Installation des prérequis
echo "📦 Installation des paquets utiles..."
sudo apt-get install -y curl apparmor-utils avahi-daemon jq network-manager ca-certificates

# 2. Installation de Docker
echo "🐳 Installation du moteur Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
rm get-docker.sh

# 3. Configuration des permissions utilisateur
echo "👤 Configuration des droits Docker pour $USER..."
sudo usermod -aG docker $USER

# 4. Création de l'arborescence professionnelle dans /opt
echo "📁 Création des dossiers dans /opt/nexus..."
sudo mkdir -p /opt/nexus/homeassistant
sudo chown -R $USER:$USER /opt/nexus

# 5. Création du fichier docker-compose.yml
echo "📄 Création du fichier de configuration Docker Compose..."
cat <<EOF > /opt/nexus/docker-compose.yml
services:
  homeassistant:
    container_name: homeassistant
    image: "ghcr.io/home-assistant/home-assistant:stable"
    volumes:
      - /opt/nexus/homeassistant:/config
      - /etc/localtime:/etc/localtime:ro
    restart: unless-stopped
    privileged: true
    network_mode: host
EOF

# 6. Lancement de Home Assistant
echo "🏠 Téléchargement et lancement de Home Assistant..."
cd /opt/nexus
sudo docker compose up -d

echo "✅ INSTALLATION TERMINÉE AVEC SUCCÈS !"
echo "-----------------------------------------------------"
echo "👉 Accédez à Home Assistant ici : http://$(hostname -I | awk '{print $1}'):8123"
echo "-----------------------------------------------------"
echo "⚠️ IMPORTANT : Tapez 'exit' puis reconnectez-vous en SSH pour que les droits Docker s'appliquent."
