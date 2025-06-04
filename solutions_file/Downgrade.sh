#!/bin/bash

# -------- STEP 0: Go to home directory --------
cd ~ || { echo "❌ Failed to go to home directory"; exit 1; }

# -------- CONFIG --------
REPO_URL="https://github.com/gensyn-ai/rl-swarm.git"
COMMIT_HASH="9b24b7012ad1dcab3e53aed5d5ac08be84c3d773"
FOLDER_NAME="rl-swarm"

SAFE_PATH="$HOME/swarm.pem"
BACKUP_FOLDER="$HOME/swarm_backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_FOLDER/swarm_backup_$TIMESTAMP.pem"

# -------- STEP 1: Create backup folder if it doesn't exist --------
mkdir -p "$BACKUP_FOLDER"

# -------- STEP 2: Backup swarm.pem if it exists --------
if [ -f "$FOLDER_NAME/swarm.pem" ]; then
    cp "$FOLDER_NAME/swarm.pem" "$SAFE_PATH"
    cp "$FOLDER_NAME/swarm.pem" "$BACKUP_FILE"
    echo "✅ swarm.pem backed up to:"
    echo "   • $SAFE_PATH"
    echo "   • $BACKUP_FILE"
else
    echo "⚠️ swarm.pem not found in old folder. Skipping backup step."
fi

# -------- STEP 3: Delete old rl-swarm folder --------
rm -rf "$FOLDER_NAME"
echo "🧹 Deleted old rl-swarm folder."

# -------- STEP 4: Clone and checkout to specific commit --------
git clone "$REPO_URL"
cd "$FOLDER_NAME" || exit 1
git checkout "$COMMIT_HASH"
echo "📥 Repo cloned and checked out to commit: $COMMIT_HASH"

# -------- STEP 5: Restore swarm.pem --------
if [ -f "$SAFE_PATH" ]; then
    cp "$SAFE_PATH" swarm.pem
    echo "✅ swarm.pem restored to new folder."
else
    echo "❌ swarm.pem not found at $SAFE_PATH. Please restore manually from backup."
fi

echo -e "\n🎉 All done! Dual backups created and repo is downgraded."
