#!/bin/bash

cd "$HOME/rl-swarm/hivemind_exp/runner/" || {
  echo "❌ Directory not found!"
  exit 1
}

file="grpo_runner.py"

search='dht = hivemind.DHT(start=True, startup_timeout=30, **self._dht_kwargs(grpo_args))'
replace='dht = hivemind.DHT(start=True, startup_timeout=30, ensure_bootstrap_success=False, **self._dht_kwargs(grpo_args))'

if grep -Fq "$search" "$file"; then
  sed -i "s|$search|$replace|" "$file"
  echo "✅ DHT bootstrap line updated successfully in $file"
else
  echo "❗ Exact target line not found or already updated."
fi
