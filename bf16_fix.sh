#!/bin/bash

# Step 1: Go to home first
cd ~

# Step 2: Check and enter rl-swarm directory
if [ -d "rl-swarm" ]; then
    cd rl-swarm
else
    echo "❌ 'rl-swarm' directory not found in home. Exiting..."
    exit 1
fi

# Step 3: Install nano
sudo apt update
sudo apt install -y nano

# Step 4: Update bf16 and fp16 to false in YAML file
FILE="hivemind_exp/configs/mac/grpo-qwen-2.5-0.5b-deepseek-r1.yaml"
if [ -f "$FILE" ]; then
    sed -i 's/"bf16": true/"bf16": false/' "$FILE"
    sed -i 's/"fp16": true/"fp16": false/' "$FILE"
    echo "✅ Updated bf16 and fp16 to false in: $FILE"
else
    echo "❌ YAML file not found: $FILE"
fi

# Step 5: Go back to home
cd ~

# Step 6: Final message
echo ""
echo "✅ All done!"
echo "➡️  Now run the following:"
echo ""
echo "cd rl-swarm && python3 -m venv .venv && source .venv/bin/activate && ./run_rl_swarm.sh"
