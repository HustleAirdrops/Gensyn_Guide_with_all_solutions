#!/bin/bash

# Step 1: Navigate to the correct directory
cd "$HOME/rl-swarm/hivemind_exp/runner/" || {
  echo "❌ Directory not found!"
  exit 1
}

# Step 2: Target file
file="grpo_runner.py"

# Step 3: Use sed to insert 'ensure_bootstrap_success=False' only if it's not already present
if grep -q 'hivemind.DHT(start=True' "$file" && ! grep -q 'ensure_bootstrap_success=False' "$file"; then
  sed -i 's|\(hivemind.DHT(start=True[^)]*\)|\1, ensure_bootstrap_success=False|' "$file"
  echo "✅ DHT bootstrap setting injected successfully in $file"
else
  echo "ℹ️ Line already modified or DHT init not found."
fi
