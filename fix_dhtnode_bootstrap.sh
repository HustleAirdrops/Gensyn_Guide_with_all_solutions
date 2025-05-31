#!/bin/bash

cd "$HOME/rl-swarm/hivemind_exp/runner/" || {
  echo "❌ Directory not found!"
  exit 1
}

file="grpo_runner.py"

# Check if the line contains the DHT init and does NOT have the bootstrap fix yet
if grep -q 'dht = hivemind.DHT(start=True, startup_timeout=30' "$file"; then
  if grep -q 'ensure_bootstrap_success=False' "$file"; then
    echo "ℹ️ Patch already applied in $file"
    exit 0
  fi

  # Insert ensure_bootstrap_success=False after startup_timeout=30,
  sed -i 's|\(dht = hivemind.DHT(start=True, startup_timeout=30,\) *|\1 ensure_bootstrap_success=False, |' "$file"
  echo "✅ Patch applied successfully to $file"
else
  echo "❌ Could not find the target line to patch in $file"
fi
