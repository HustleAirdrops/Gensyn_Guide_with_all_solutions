#!/bin/bash

cd "$HOME/rl-swarm/hivemind_exp/runner/" || {
  echo "❌ Directory not found!"
  exit 1
}

file="grpo_runner.py"

# Check if file contains DHT initialization line
if grep -q 'dht = hivemind.DHT(start=True' "$file"; then

  # Check if patch already applied
  if grep -q 'ensure_bootstrap_success=False' "$file"; then
    echo "ℹ️ Patch already applied in $file"
    exit 0
  fi

  # Perform the replacement — insert ensure_bootstrap_success=False after startup_timeout=30,
  sed -i -r 's|(dht = hivemind.DHT\(start=True,\s*startup_timeout=30,)(\s*)|\1 ensure_bootstrap_success=False, |' "$file"

  echo "✅ Patch applied successfully to $file"

else
  echo "❌ Could not find the target dht initialization line in $file"
fi
