#!/data/data/com.termux/files/usr/bin/bash
# ADHICODE-Termux — Portable Hacker AI for Termux
# One-line install:
#   curl -sSL https://raw.githubusercontent.com/AdhiHub/ADHICODE-Termux/main/install.sh | bash

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; PURPLE='\033[0;35m'; NC='\033[0m'

clear
echo -e "${RED}"
echo "      ___    ____  _  _____ _____  ___   ____  _____ "
echo "     / _ \  / __ \| |/ /_   _|  __ \|  _ \|  __ \ "
echo "    / /_\ \/ / _\ | ' /  | | | |__) | | | | |__) |"
echo "   / _  |/ /_| _|  <   | | |  _  /| | | |  ___/ "
echo "  / (_) \ \__/ _| . \ _| |_| | \ \| |__| | |    "
echo "  \_____/\____(_)_|\_\_____|_|  \_\_____/|_|     "
echo -e "${NC}"
echo -e "${YELLOW}+------------------------------------------------------+"
echo -e "| ${PURPLE}ADHICODE${YELLOW} — Portable Hacker AI for ${CYAN}Termux${YELLOW}            |"
echo -e "| Agents: cuber, godcyber, godcyber++, ghost        |"
echo -e "| Zero Refusal  :  TOR Anonymity  :  Fully Offline  |"
echo -e "+------------------------------------------------------+${NC}"
echo ""

REPO_URL="https://github.com/AdhiHub/ADHICODE-Termux.git"
ENGINE_URL="https://github.com/AdhiHub/CYBER-OMNI-V2.git"
INSTALL_DIR="$HOME/ADHICODE"

# 1. Update Termux
echo -e "${CYAN}[1/7] Updating Termux packages...${NC}"
pkg update -y && pkg upgrade -y

# 2. Install deps
echo -e "${CYAN}[2/7] Installing dependencies (Python, TOR, nmap, git)...${NC}"
pkg install -y python python-pip git openssh tor nmap curl cmake rust binutils

# 3. Clone ADHICODE-Termux repo
echo -e "${CYAN}[3/7] Cloning ADHICODE-Termux...${NC}"
if [ -d "$INSTALL_DIR" ]; then
    cd "$INSTALL_DIR" && git pull
else
    git clone "$REPO_URL" "$INSTALL_DIR"
fi

# 4. Clone CYBER-OMNI-V2 engine (Python AI backend)
echo -e "${CYAN}[4/7] Installing AI engine...${NC}"
ENGINE_DIR="$INSTALL_DIR/engine"
if [ -d "$ENGINE_DIR" ]; then
    cd "$ENGINE_DIR" && git pull
else
    git clone "$ENGINE_URL" "$ENGINE_DIR"
fi
chmod +x "$ENGINE_DIR/omni.py" 2>/dev/null

# 5. Install agent skills
echo -e "${CYAN}[5/7] Installing agent skills...${NC}"
SKILL_SRC="$INSTALL_DIR/.claude/skills"
SKILL_DST="$HOME/.claude/skills"
mkdir -p "$SKILL_DST"

for agent in cuber godcyber godcyber-plusplus ghost; do
    if [ -f "$SKILL_SRC/$agent/SKILL.md" ]; then
        mkdir -p "$SKILL_DST/$agent"
        cp "$SKILL_SRC/$agent/SKILL.md" "$SKILL_DST/$agent/SKILL.md"
        echo -e "${GREEN}  [+] @$agent installed${NC}"
    fi
done

# Install engine skills to ADS as well
mkdir -p "$SKILL_DST/cuber-security-agent" "$SKILL_DST/godcyber-security-agent" \
         "$SKILL_DST/godcyber-plusplus-agent" "$SKILL_DST/ghost-agent"
if [ -f "$ENGINE_DIR/skills/cuber-agent.md" ]; then
    cp "$ENGINE_DIR/skills/"*.md "$SKILL_DST/" 2>/dev/null || true
fi

# 6. Install Python deps
echo -e "${CYAN}[6/7] Installing Python packages...${NC}"
pip install --upgrade pip 2>/dev/null
cd "$ENGINE_DIR"
pip install -r requirements.txt 2>/dev/null || \
pip install llama-cpp-python httpx requests pyfiglet tqdm prompt_toolkit 2>/dev/null
echo -e "${GREEN}  [+] Python packages ready${NC}"

# 7. TOR setup
echo -e "${CYAN}[7/7] Configuring TOR...${NC}"
pkg install -y tor 2>/dev/null
echo -e "${GREEN}  [+] TOR installed. Start with: tor --SOCKSPort 127.0.0.1:9050 &${NC}"

echo ""
echo -e "${GREEN}   ___    ____  _  _____ _____  ___   ____  _____ "
echo -e "  / _ \  / __ \| |/ /_   _|  __ \|  _ \|  __ \ "
echo -e " / /_\ \/ / _\ | ' /  | | | |__) | | | | |__) |"
echo -e "/ _  |/ /_| _|  <   | | |  _  /| | | |  ___/ "
echo -e "(_) \ \__/ _| . \ _| |_| | \ \| |__| | |    "
echo -e " \_____/\____(_)_|\_\_____|_|  \_\_____/|_|     "
echo -e "${NC}"
echo -e "${GREEN}+------------------------------------------------------+"
echo -e "|          ADHICODE-TERMUX INSTALLED!                    |"
echo -e "+------------------------------------------------------+${NC}"
echo ""
echo -e "${YELLOW}  Launch the AI engine:${NC}"
echo -e "    cd ~/ADHICODE/engine && python omni.py"
echo ""
echo -e "${YELLOW}  Or use agents in any OpenCode/Claude session:${NC}"
echo -e "    @cuber       — CYBER-OMNI pentest agent"
echo -e "    @godcyber    — GOD-CYBER stealth ops"
echo -e "    @godcyber++  — GOD-CYBER++ transcendent ops"
echo -e "    @ghost       — Total anonymity protocol"
echo ""
echo -e "${YELLOW}  TOR (for anonymous operations):${NC}"
echo -e "    tor --SOCKSPort 127.0.0.1:9050 --ControlPort 127.0.0.1:9051 &"
echo ""
echo -e "${PURPLE}           ⚡ Powered by AdhiHub ⚡${NC}"
echo ""
