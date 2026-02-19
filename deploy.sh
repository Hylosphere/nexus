#!/bin/bash

# --- PARAMÈTRES ---
RPI_IP="192.168.1.69"    # L'IP fixe de votre Raspberry Pi
RPI_USER="alg"           # Votre utilisateur sur le Pi
LOCAL_DIR="./homeassistant/"
REMOTE_DIR="/home/alg/homeassistant/"

echo "🚀 Début du déploiement vers Nexus ($RPI_IP)..."

# --- 1. SYNCHRONISATION DES FICHIERS ---
# rsync va copier uniquement les fichiers modifiés.
# Les --exclude empêchent d'écraser la base de données du Pi ou ses fichiers cachés vitaux.
echo "📦 Envoi des fichiers de configuration..."
rsync -rlptzv --no-perms --no-owner --no-group \
  --exclude='.storage' \
  --exclude='*.db*' \
  --exclude='*.log' \
  "$LOCAL_DIR" "$RPI_USER@$RPI_IP:$REMOTE_DIR"

# --- 2. REDÉMARRAGE DE HOME ASSISTANT ---
echo "🔄 Redémarrage du conteneur Docker Home Assistant..."
ssh $RPI_USER@$RPI_IP "sudo docker restart homeassistant"

echo "✅ Déploiement terminé avec succès ! Home Assistant sera en ligne dans 30 secondes."