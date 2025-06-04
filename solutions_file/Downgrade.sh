#!/bin/bash
set -e

# Step 0: Go to home directory
cd ~ || { echo "❌ Failed to go to home directory"; exit 1; }

# Configs
REPO_URL="https://github.com/gensyn-ai/rl-swarm.git"
COMMIT_HASH="9b24b7012ad1dcab3e53aed5d5ac08be84c3d773"
FOLDER="rl-swarm"

BACKUP_DIR="$HOME/swarm_backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/swarm_backup_$TIMESTAMP.pem"
SAFE_FILE="$HOME/swarm.pem"

mkdir -p "$BACKUP_DIR"

# Backup swarm.pem if exists
if [ -f "$FOLDER/swarm.pem" ]; then
    echo "Backing up existing swarm.pem..."
    cp "$FOLDER/swarm.pem" "$SAFE_FILE"
    cp "$FOLDER/swarm.pem" "$BACKUP_FILE"
    echo "Backups saved:"
    ls -la "$SAFE_FILE" "$BACKUP_FILE"
else
    echo "No existing swarm.pem found to backup."
fi

# Delete old rl-swarm folder
echo "Deleting old $FOLDER folder..."
rm -rf "$FOLDER"

# Clone repo and checkout commit
echo "Cloning repo..."
git clone "$REPO_URL"
cd "$FOLDER"
git checkout "$COMMIT_HASH"

echo "Current directory and files after clone & checkout:"
pwd
ls -la

# Restore swarm.pem backup if available
if [ -f "$SAFE_FILE" ]; then
    echo "Restoring swarm.pem..."
    cp "$SAFE_FILE" swarm.pem
    echo "swarm.pem restored. Check details:"
    ls -la swarm.pem
else
    echo "Backup swarm.pem not found at $SAFE_FILE"
fi

echo "Final folder contents:"
ls -la

# Refresh folder view: cd out and cd back in
cd ..
cd rl-swarm

echo "Refreshed directory contents:"
pwd
ls -la

echo "🎉 Done! Repo downgraded and swarm.pem restored."
