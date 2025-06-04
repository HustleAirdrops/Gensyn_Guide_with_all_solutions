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

# -------- STEP 1: Check if we have write permission to home --------
if [ ! -w "$HOME" ]; then
    echo "❌ No write permission in $HOME"
    echo "Run script with proper permissions or check directory ownership."
    exit 1
fi

# -------- STEP 2: Create backup folder if it doesn't exist --------
mkdir -p "$BACKUP_FOLDER" || { echo "❌ Could not create backup folder"; exit 1; }

# -------- STEP 3: Backup swarm.pem if it exists --------
if [ -f "$FOLDER_NAME/swarm.pem" ]; then
    # Try copying working swarm.pem
    if cp "$FOLDER_NAME/swarm.pem" "$SAFE_PATH"; then
        echo "✅ Working swarm.pem backed up to $SAFE_PATH"
    else
        echo "⚠️ Failed to copy swarm.pem to $SAFE_PATH"
        # Try alternative backup location
        ALT_BACKUP="$BACKUP_FOLDER/swarm_backup_working_$TIMESTAMP.pem"
        if cp "$FOLDER_NAME/swarm.pem" "$ALT_BACKUP"; then
            echo "✅ Working swarm.pem backed up to alternative: $ALT_BACKUP"
        else
            echo "❌ Failed to backup working swarm.pem anywhere! Abort."
            exit 1
        fi
    fi

    # Timestamped backup (always try)
    if cp "$FOLDER_NAME/swarm.pem" "$BACKUP_FILE"; then
        echo "✅ Timestamped backup created: $BACKUP_FILE"
    else
        echo "⚠️ Failed to create timestamped backup at $BACKUP_FILE"
    fi
else
    echo "⚠️ swarm.pem not found in $FOLDER_NAME. Skipping backup step."
fi

# -------- STEP 4: Delete old rl-swarm folder --------
rm -rf "$FOLDER_NAME"
echo "🧹 Deleted old rl-swarm folder."

# -------- STEP 5: Clone and checkout to specific commit --------
if git clone "$REPO_URL"; then
    cd "$FOLDER_NAME" || { echo "❌ Failed to cd into cloned folder"; exit 1; }
    if git checkout "$COMMIT_HASH"; then
        echo "📥 Repo cloned and checked out to commit: $COMMIT_HASH"
    else
        echo "❌ Failed to checkout commit $COMMIT_HASH"
        exit 1
    fi
else
    echo "❌ Git clone failed!"
    exit 1
fi

# -------- STEP 6: Restore swarm.pem --------
if [ -f "$SAFE_PATH" ]; then
    if cp "$SAFE_PATH" swarm.pem; then
        echo "✅ swarm.pem restored to new folder."
    else
        echo "❌ Failed to restore swarm.pem from $SAFE_PATH"
        echo "Try manual restore from backups in $BACKUP_FOLDER"
    fi
else
    echo "❌ swarm.pem not found at $SAFE_PATH."
    echo "Please restore manually from backups in $BACKUP_FOLDER"
fi

echo -e "\n🎉 All done! Dual backups created and repo is downgraded."
