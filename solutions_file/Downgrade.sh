#!/bin/bash
set -e

echo "🚀 Starting system setup and dependencies installation..."

# Update and install basics
sudo apt update && sudo apt install -y python3 python3-venv python3-pip curl wget screen git lsof

# Install NodeJS 20.x
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt update && sudo apt install -y nodejs

# Install Yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list > /dev/null
sudo apt update && sudo apt install -y yarn

# Setup firewall UFW, allow SSH and port 3000, enable UFW
yes | sudo apt install ufw -y
sudo ufw allow 22
sudo ufw allow 3000/tcp
yes | sudo ufw enable

# Install cloudflared latest
wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
sudo dpkg -i cloudflared-linux-amd64.deb

echo "✅ System setup complete!"

cd ~ || { echo "❌ Failed to go to home directory"; exit 1; }

REPO_URL="https://github.com/gensyn-ai/rl-swarm.git"
COMMIT_HASH="9b24b7012ad1dcab3e53aed5d5ac08be84c3d773"
FOLDER="rl-swarm"

BACKUP_DIR="$HOME/swarm_backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/swarm_backup_$TIMESTAMP.pem"
SAFE_FILE="$HOME/swarm.pem"

mkdir -p "$BACKUP_DIR"

if [ -f "$FOLDER/swarm.pem" ]; then
    echo "Old user detected. Backing up existing swarm.pem with sudo..."
    sudo cp "$FOLDER/swarm.pem" "$SAFE_FILE"
    sudo cp "$FOLDER/swarm.pem" "$BACKUP_FILE"
    sudo chown $(whoami):$(whoami) "$SAFE_FILE" "$BACKUP_FILE"  # Fix ownership
    echo "Backups created successfully."
else
    echo "New user detected or no existing swarm.pem found. No backup needed."
fi

echo "Deleting old $FOLDER folder..."
rm -rf "$FOLDER"

echo "Cloning repo and checking out commit..."
git clone "$REPO_URL"
cd "$FOLDER"
git checkout "$COMMIT_HASH"

if [ -f "$SAFE_FILE" ]; then
    echo "Restoring swarm.pem from backup to cloned folder..."
    cp "$SAFE_FILE" swarm.pem
    echo "swarm.pem restored successfully."
else
    echo "No backup swarm.pem found to restore."
fi

cd ..

echo "🎉 Setup and downgrade complete! You can now start working in the $FOLDER directory."
