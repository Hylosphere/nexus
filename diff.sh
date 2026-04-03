#!/bin/bash

# --- PARAMETERS ---
SERVER_IP="192.168.1.100"
SERVER_USER="alg"
REMOTE_DIR="/opt/nexus/"

echo "🔍 Analyzing differences (updates) between Mac and the Nexus server..."
echo "---------------------------------------------------------------------------------------"

rsync -rlptzui --dry-run --no-perms --no-owner --no-group \
  --exclude='.git' \
  --exclude='.DS_Store' \
  --exclude='pcb' \
  --exclude='deploy.sh' \
  --exclude='install.sh' \
  --exclude='diff.sh' \
  --exclude='esphome' \
  --exclude='.gitignore' \
  --exclude='homeassistant/.storage' \
  --exclude='homeassistant/deps' \
  --exclude='homeassistant/tts' \
  --exclude='homeassistant/*.db*' \
  --exclude='homeassistant/*.log*' \
  --exclude='homeassistant/zigbee.db*' \
  ./ "$SERVER_USER@$SERVER_IP:$REMOTE_DIR"

echo "---------------------------------------------------------------------------------------"
echo "💡 DETAILED LEGEND (How to read the results):"
echo ""
echo "  [1. Item Type & Direction]"
echo "  > or < : The file is being transferred (Mac to Server)."
echo "  .      : The item is NOT transferred, but its attributes changed."
echo "  f      : It's a File."
echo "  d      : It's a Directory (folder)."
echo ""
echo "  [2. Why is it listed?]"
echo "  +++++++++ : It's a brand NEW file (will be created on the server)."
echo "  s         : Size is different."
echo "  t         : Timestamp (modification date) is different."
echo ""
echo "  [3. Common Examples]"
echo "  >f+++++++++ : NEW file ready to be sent to the server."
echo "  <f.st...... : MODIFIED file ready to overwrite the server's version."
echo "  .d..t...... : A folder's timestamp changed (completely harmless, ignore it)."
echo "---------------------------------------------------------------------------------------"