!/bin/bash
echo "🚀 DÉMARRAGE DE L'INSTALLATION (Version Lite)..."

# 1. Mise à jour du système
echo "📦 Mise à jour de Raspberry Pi OS..."
sudo apt-get update && sudo apt-get full-upgrade -y
sudo apt-get install -y curl apparmor-utils avahi-daemon jq network-manager

# 2. Installation de Docker
echo "🐳 Installation du moteur Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
rm get-docker.sh

# 3. Configuration des permissions utilisateur
# Ajoute l'utilisateur actuel au groupe docker pour gérer sans sudo plus tard
echo "👤 Configuration des droits pour $USER..."
sudo usermod -aG docker $USER

# 4. Installation de Home Assistant Core
echo "🏠 Téléchargement et lancement de Home Assistant..."
mkdir -p /home/$USER/homeassistant

# Lancement du conteneur
sudo docker run -d \
  --name homeassistant \
  --privileged \
  --restart=unless-stopped \
  -e TZ=Europe/Paris \
  -v /home/$USER/homeassistant:/config \
  --network=host \
  ghcr.io/home-assistant/home-assistant:stable

echo "✅ INSTALLATION TERMINÉE !"
echo "-----------------------------------------------------"
echo "👉 Accédez à Home Assistant ici : http://nexus.local:8123"
echo "-----------------------------------------------------"
echo "⚠️  IMPORTANT : Au retour, tapez 'sudo reboot' pour finaliser."
