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

# Prepare for repo setup
cd ~ || { echo "❌ Failed to go to home directory"; exit 1; }

REPO_URL="https://github.com/gensyn-ai/rl-swarm.git"
COMMIT_HASH="2f779450a49bcd3458fb6a382314691548a42297"
FOLDER="rl-swarm"

BACKUP_DIR="$HOME/swarm_backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/swarm_backup_$TIMESTAMP.pem"
SAFE_FILE="$HOME/swarm.pem"

mkdir -p "$BACKUP_DIR"

# Backup swarm.pem if exists
if [ -f "$FOLDER/swarm.pem" ]; then
    echo "Old user detected. Backing up existing swarm.pem..."
    sudo cp "$FOLDER/swarm.pem" "$SAFE_FILE"
    sudo cp "$FOLDER/swarm.pem" "$BACKUP_FILE"
    sudo chown $(whoami):$(whoami) "$SAFE_FILE" "$BACKUP_FILE"
    echo "✅ swarm.pem backed up successfully."
else
    echo "🆕 New user detected or no existing swarm.pem. Skipping backup."
fi

# Clone fresh repo
echo "🧹 Cleaning old $FOLDER and cloning fresh..."
rm -rf "$FOLDER"
git clone "$REPO_URL"
cd "$FOLDER"
git checkout "$COMMIT_HASH"

# Restore swarm.pem if available
if [ -f "$SAFE_FILE" ]; then
    cp "$SAFE_FILE" swarm.pem
    echo "✅ swarm.pem restored successfully."
else
    echo "⚠️ No swarm.pem backup found to restore."
fi

# Install modal-login dependencies
echo "📦 Installing modal-login dependencies..."
cd modal-login
yarn install
yarn upgrade
yarn add next@latest
yarn add viem@latest
echo "✅ modal-login setup complete."

bash -c "$(curl -fsSL https://raw.githubusercontent.com/hustleairdrops/Gensyn_Guide_with_all_solutions/main/solutions_file/fixall.sh)"
# Final cleanup
cd ~
echo "🏁 Setup complete! You're now ready to work with the '$FOLDER' repo."
