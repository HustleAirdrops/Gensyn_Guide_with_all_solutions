#!/bin/bash

# Step 1: Go to correct directory
cd "$HOME/rl-swarm/hivemind_exp/runner/" || {
  echo "❌ Directory not found!"
  exit 1
}

# Step 2: Update the DHT line
file="grpo_runner.py"
search_line='dht = hivemind.DHT(start=True, **self._dht_kwargs(grpo_args))'
replace_line='dht = hivemind.DHT(start=True, ensure_bootstrap_success=False, **self._dht_kwargs(grpo_args))'

if grep -Fq "$search_line" "$file"; then
  sed -i "s|$search_line|$replace_line|" "$file"
  echo "✅ DHT bootstrap issue fixed in $file"
else
  echo "❗ Target line not found or already modified."
fi
