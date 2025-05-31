#!/bin/bash

cd "$HOME/rl-swarm/hivemind_exp/runner/" || {
  echo "❌ Directory not found!"
  exit 1
}

file="grpo_runner.py"

# Check if the file contains a line starting with dht = hivemind.DHT(start=True
if grep -q 'dht = hivemind.DHT(start=True' "$file"; then
  # Check if the patch is already applied
  if grep -q 'ensure_bootstrap_success=False' "$file"; then
    echo "ℹ️ Patch already applied in $file"
  else
    # Add ensure_bootstrap_success=False inside the DHT call parameters
    sed -i 's|\(dht = hivemind.DHT(start=True[^)]*\)|\1, ensure_bootstrap_success=False|' "$file"
    echo "✅ Patch applied successfully to $file"
  fi
else
  echo "❌ Could not find the DHT initialization line in $file"
fi
