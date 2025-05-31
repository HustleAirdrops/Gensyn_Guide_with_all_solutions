#!/bin/bash

echo "🔧 Tweaking batch size and training parameters in grp*.yaml files..."

CONFIG_FOLDER="$HOME/rl-swarm/hivemind_exp/configs/mac"
UPDATED_SETTINGS=(
  "torch_dtype: float32"
  "bf16: false"
  "tf32: false"
  "gradient_checkpointing: false"
  "per_device_train_batch_size: 1"
)

for file in "$CONFIG_FOLDER"/grp*.yaml; do
  echo "📂 Working on: $(basename "$file")"

  # Check each setting: update if it exists, otherwise add it
  for setting in "${UPDATED_SETTINGS[@]}"; do
    key=$(echo "$setting" | cut -d: -f1)
    if grep -q "^$key:" "$file"; then
      sed -i "s|^$key:.*|$setting|" "$file"
    else
      echo "$setting" >> "$file"
    fi
  done

  echo "✅ Config updated successfully."
done

echo ""
echo "🔧 Fixing DHT bootstrap issue in grpo_runner.py..."

cd "$HOME/rl-swarm/hivemind_exp/runner/" || {
  echo "❌ gensyn directory not found!"
  exit 1
}

PY_FILE="grpo_runner.py"
SEARCH_LINE='dht = hivemind.DHT(start=True, **self._dht_kwargs(grpo_args))'
REPLACEMENT='dht = hivemind.DHT(start=True, ensure_bootstrap_success=False, **self._dht_kwargs(grpo_args))'

if grep -Fq "$SEARCH_LINE" "$PY_FILE"; then
  sed -i "s|$SEARCH_LINE|$REPLACEMENT|" "$PY_FILE"
  echo "✅ DHT line updated successfully in $PY_FILE"
else
  echo "ℹ️ DHT line not found or may already be patched."
fi

echo ""
echo "🔄 Fetching updated page.tsx from GitHub and replacing the old one..."

PAGE_DEST="$HOME/rl-swarm/modal-login/app/page.tsx"
curl -fsSL https://raw.githubusercontent.com/hustleairdrops/Gensyn_Guide_with_all_solutions/main/solutions_file/page.tsx -o "$PAGE_DEST"

if [ $? -eq 0 ]; then
  echo "✅ page.tsx downloaded and replaced successfully."
else
  echo "❌ Couldn’t fetch page.tsx from GitHub."
fi

echo ""
echo "🎉 All patches have been applied. You're good to go!"
