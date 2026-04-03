#!/bin/bash

# --- PARAMÈTRES ---
SERVER_IP="192.168.1.100"        # IP du PC Ubuntu
SERVER_USER="alg"                # Utilisateur sur Ubuntu
REMOTE_DIR="/opt/nexus/"         # Dossier cible sur le serveur

echo "🚀 Début du déploiement vers le serveur Nexus ($SERVER_IP)..."

# --- 1. SYNCHRONISATION DES FICHIERS ---
echo "📦 Envoi de la configuration (Home Assistant, Docker)..."
rsync -rlptzv --no-perms --no-owner --no-group \
  --exclude='.git' \
  --exclude='.DS_Store' \
  --exclude='pcb' \
  --exclude='deploy.sh' \
  --exclude='install.sh' \
  --exclude='esphome' \
  --exclude='homeassistant/.storage' \
  --exclude='homeassistant/deps' \
  --exclude='homeassistant/tts' \
  --exclude='homeassistant/*.db*' \
  --exclude='homeassistant/*.log*' \
  --exclude='homeassistant/zigbee.db*' \
  ./ "$SERVER_USER@$SERVER_IP:$REMOTE_DIR"

# --- 2. GESTION DES CONTENEURS ---
echo "🔄 Mise à jour et redémarrage des conteneurs Docker..."
ssh -t $SERVER_USER@$SERVER_IP "cd $REMOTE_DIR && sudo docker compose up -d && sudo docker compose restart homeassistant"

echo "✅ Déploiement terminé avec succès ! Home Assistant sera en ligne dans quelques secondes."