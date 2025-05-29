# Gensyn_Guide_with_all_solutions

# 🚀 Gensyn RL-Swarm Node Setup Guide

Easily set up and run your Gensyn RL-Swarm node on **Linux/WSL** or **Mac**.  
**All commands are copy-paste ready!**

---

## 🛠️ Prerequisites

### For **Linux/WSL**:

```bash
sudo apt update && sudo apt install -y python3 python3-venv python3-pip curl wget screen git lsof
```

### For **Mac**:

```bash
brew install python
```

---

## 🔎 Check Python Version

```bash
python3 --version
```

---

## 🟩 Install Node.js

### For **Linux/WSL**:

```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt update && sudo apt install -y nodejs
```

### For **Mac**:

```bash
brew install node
corepack enable
npm install -g yarn
```

---

## 🧶 Install Yarn

### For **Linux/WSL**:

```bash
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list > /dev/null
sudo apt update && sudo apt install -y yarn
```

### For **Mac**:

```bash
npm install -g yarn
```

---

## 🔢 Check Versions

```bash
node -v
npm -v
yarn -v
```

---

## 🧬 Clone RL-Swarm Repository

```bash
git clone https://github.com/gensyn-ai/rl-swarm.git
```

---

## 🖥️ (Optional) Create a Screen Session (for VPS)

```bash
screen -S gensyn
```

---

## 📂 Navigate to RL-Swarm Directory

```bash
cd rl-swarm
```

---

## 🏗️ Create & Activate Python Virtual Environment

```bash
python3 -m venv .venv
source .venv/bin/activate
```

---

## 📦 Install Dependencies

```bash
cd modal-login
yarn install
yarn upgrade
yarn add next@latest
yarn add viem@latest
```

---

## 🚦 Run the Swarm Node

```bash
cd ..
```
```bash
./run_rl_swarm.sh
```

Follow the prompts:

1. **Would you like to connect to the Testnet?**  
    Enter: `Y`

2. **Which swarm would you like to join (Math (A) or Math Hard (B))?**  
    Enter: `a`

3. **How many parameters (in billions)?**  
    Choose: `[0.5, 1.5, 7, 32, 72]`

---

## 🌐 Login

- **Local PC:**  
  A web pop-up will appear. If not, open [http://localhost:3000/](http://localhost:3000/) in your browser.  
  Login with your email, enter the OTP, and return to your terminal.

- **VPS:**  
  Open a new terminal/tab and run:
  ```bash
  ssh -R 80:localhost:3000 serveo.net
  ```
  Open the provided link in your browser, login, then return to the node terminal.

---

## 🆔 Save Your Credentials

- When prompted:  
  **Would you like to push models you train in the RL swarm to the Hugging Face Hub?**  
  Enter: `N`
  
- After login, your **Username** and **Peer ID** will appear in the terminal.  
  **Save them!**

![Peer ID](peerid.png)

---

## 🖥️ VPS Users: Detach Screen

Press `Ctrl+A+D` to keep your node running in the background.

To reattach or view logs:

```bash
screen -r gensyn
```

---

## 🔐 Backup Credentials

```bash
[ -f backup.sh ] && rm backup.sh; curl -sSL -O https://raw.githubusercontent.com/zunxbt/gensyn-testnet/main/backup.sh && chmod +x backup.sh && ./backup.sh
```

Open and save the 3 links provided.

---

## 🔄 Next Day Start (Local PC)

```bash
cd rl-swarm
```
```bash
python3 -m venv .venv
source .venv/bin/activate
```
```bash
./run_rl_swarm.sh
```

---

## 🏆 Check Rewards

- Visit [@GensynReward_bot](https://t.me/GensynReward_bot) on Telegram.
- Send `/add` and then your **Peer ID** for updates.

---

## ❓ FAQ & Troubleshooting

### **BF16 Issue**

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/hustle-airdrops/Gensyn_Guide_with_all_solutions/main/bf16_fix.sh)"
```

### **Fix DHTNode Bootstrap**

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/hustle-airdrops/Gensyn_Guide_with_all_solutions/main/fix_dhtnode_bootstrap.sh)"
```

### **Fix Login Issue**
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/hustle-airdrops/Gensyn_Guide_with_all_solutions/main/fix_login.sh)"
```

### **If you see `Daemon And Bootstrap Error`, just run your node 3-4 times.**

---

### **Note**

- If you see `0x0000000000000000000000000000000000000000` in the Connected EOA Address section, your contribution is not being recorded.  
  **Delete the existing `swarm.pem` file and start again with a new email.**

---

## 📢 More Guides & Updates

- Join [Hustle Airdrops Telegram](https://t.me/Hustle_Airdrops) for more help!

---

**Happy Swarming! 🚀**
