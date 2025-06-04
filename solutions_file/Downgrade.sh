#!/bin/bash
set -e

cd ~ || exit 1

REPO_URL="https://github.com/gensyn-ai/rl-swarm.git"
COMMIT_HASH="9b24b7012ad1dcab3e53aed5d5ac08be84c3d773"
FOLDER="rl-swarm"

BACKUP_DIR="$HOME/swarm_backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/swarm_backup_$TIMESTAMP.pem"
SAFE_FILE="$HOME/swarm.pem"

mkdir -p "$BACKUP_DIR"

if [ -f "$FOLDER/swarm.pem" ]; then
    echo "Backing up existing swarm.pem..."
    cp "$FOLDER/swarm.pem" "$SAFE_FILE"
    cp "$FOLDER/swarm.pem" "$BACKUP_FILE"
    echo "Backups saved:"
    ls -la "$SAFE_FILE" "$BACKUP_FILE"
else
    echo "No existing swarm.pem found to backup."
fi

echo "Deleting old $FOLDER folder..."
rm -rf "$FOLDER"

echo "Cloning repo..."
git clone "$REPO_URL"
cd "$FOLDER"
git checkout "$COMMIT_HASH"

echo "Current directory and files after clone & checkout:"
pwd
ls -la

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

echo "Done."
