#!/bin/bash
set -e

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

    sudo chown $(whoami):$(whoami) "$SAFE_FILE" "$BACKUP_FILE"  # Fix ownership after sudo

    echo "Backups created:"
    ls -la "$SAFE_FILE" "$BACKUP_FILE"
else
    echo "New user detected or no existing swarm.pem found. No backup needed."
fi

echo "Deleting old $FOLDER folder..."
rm -rf "$FOLDER"

echo "Cloning repo..."
git clone "$REPO_URL"
cd "$FOLDER"
git checkout "$COMMIT_HASH"

echo "After clone & checkout:"
pwd
ls -la

if [ -f "$SAFE_FILE" ]; then
    echo "Restoring swarm.pem from backup to cloned folder..."
    cp "$SAFE_FILE" swarm.pem
    echo "swarm.pem restored:"
    ls -la swarm.pem
else
    echo "No backup swarm.pem found to restore."
fi

echo "Final contents of $FOLDER:"
ls -la

cd ..
cd rl-swarm

echo "Refreshed directory contents:"
pwd
ls -la

echo "🎉 Done! Repo downgraded and swarm.pem backup & restore completed."
