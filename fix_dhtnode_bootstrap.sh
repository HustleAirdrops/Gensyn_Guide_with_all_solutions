#!/bin/bash

cd "$HOME/rl-swarm/hivemind_exp/runner/" || {
  echo "❌ Directory not found!"
  exit 1
}

file="grpo_runner.py"

if grep -q 'dht = hivemind.DHT(start=True, startup_timeout=30,' "$file"; then

  if grep -q 'ensure_bootstrap_success=False' "$file"; then
    echo "ℹ️ Patch already applied in $file"
    exit 0
  fi

  sed -i -r 's|(dht = hivemind.DHT\(start=True, startup_timeout=30, *)(.*)|\1ensure_bootstrap_success=False, \2|' "$file"

  echo "✅ Patch applied successfully to $file"

else
  echo "❌ Could not find target line in $file"
fi
