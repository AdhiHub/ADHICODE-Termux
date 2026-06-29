#!/data/data/com.termux/files/usr/bin/bash
# ADHICODE-Termux — Portable Hacker AI for Termux
# Installs the SAME OpenCode CLI that ADHICODE-cyber.exe runs on Windows
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
echo -e "| Installs the REAL OpenCode AI CLI (same as .exe)  |"
echo -e "+------------------------------------------------------+${NC}"
echo ""

# Stop on first error
set -e

RAW_BASE="https://raw.githubusercontent.com/AdhiHub/ADHICODE-Termux/main"
WORK_DIR="$HOME/ADHICODE"

# Helper function to download files
dl() {
    local url="$RAW_BASE/$1"
    local dest="$2"
    mkdir -p "$(dirname "$dest")"
    if curl -sSL "$url" -o "$dest"; then
        echo -e "${GREEN}  [OK] $1${NC}"
    else
        echo -e "${RED}  [FAIL] $1${NC}"
        return 1
    fi
}

# 1. Update Termux
echo -e "${CYAN}[1/7] Updating Termux packages...${NC}"
pkg update -y -o Dpkg::Options::="--force-confnew" 2>/dev/null || pkg update -y
pkg upgrade -y -o Dpkg::Options::="--force-confnew" 2>/dev/null || pkg upgrade -y

# 2. Install deps (including build tools for npm native modules)
echo -e "${CYAN}[2/7] Installing dependencies...${NC}"
pkg install -y nodejs git tor nmap curl openssh clang make binutils pkg-config

# 3. Install OpenCode AI CLI (the REAL ADHICODE engine)
echo -e "${CYAN}[3/7] Installing OpenCode AI CLI (same engine as ADHICODE-cyber.exe)...${NC}"
npm config set unsafe-perm true 2>/dev/null || true
npm install -g opencode-ai@latest
echo -e "${GREEN}  [+] OpenCode AI CLI installed!${NC}"

# Verify opencode binary exists
if ! command -v opencode &>/dev/null; then
    echo -e "${RED}  [!] 'opencode' command not found after npm install.${NC}"
    echo -e "${YELLOW}  Trying alternative install method...${NC}"
    # Try installing from the repo's install script
    curl -fsSL https://opencode.ai/install | bash
fi

if ! command -v opencode &>/dev/null; then
    echo -e "${RED}  [ERROR] Failed to install OpenCode CLI.${NC}"
    echo -e "${YELLOW}  Try manually: npm install -g opencode-ai@latest${NC}"
    exit 1
fi
echo -e "${GREEN}  [+] Verified: opencode CLI is ready at $(command -v opencode)${NC}"

# 4. Download all config files and skills
echo -e "${CYAN}[4/7] Downloading ADHICODE config & skills...${NC}"

# Create working directory structure
mkdir -p "$WORK_DIR/.claude/skills"
mkdir -p "$WORK_DIR/.opencode"
mkdir -p "$WORK_DIR/.claude/skills/cuber"
mkdir -p "$WORK_DIR/.claude/skills/cuber-security-agent"
mkdir -p "$WORK_DIR/.claude/skills/godcyber"
mkdir -p "$WORK_DIR/.claude/skills/godcyber-security-agent"
mkdir -p "$WORK_DIR/.claude/skills/godcyber-plusplus"
mkdir -p "$WORK_DIR/.claude/skills/godcyber-plusplus-agent"
mkdir -p "$WORK_DIR/.claude/skills/ghost"
mkdir -p "$WORK_DIR/.claude/skills/ghost-agent"

# Download all skill files
dl ".claude/skills/cuber/SKILL.md" "$WORK_DIR/.claude/skills/cuber/SKILL.md"
dl ".claude/skills/cuber-security-agent/SKILL.md" "$WORK_DIR/.claude/skills/cuber-security-agent/SKILL.md"
dl ".claude/skills/godcyber/SKILL.md" "$WORK_DIR/.claude/skills/godcyber/SKILL.md"
dl ".claude/skills/godcyber-security-agent/SKILL.md" "$WORK_DIR/.claude/skills/godcyber-security-agent/SKILL.md"
dl ".claude/skills/godcyber-plusplus/SKILL.md" "$WORK_DIR/.claude/skills/godcyber-plusplus/SKILL.md"
dl ".claude/skills/godcyber-plusplus-agent/SKILL.md" "$WORK_DIR/.claude/skills/godcyber-plusplus-agent/SKILL.md"
dl ".claude/skills/ghost/SKILL.md" "$WORK_DIR/.claude/skills/ghost/SKILL.md"
dl ".claude/skills/ghost-agent/SKILL.md" "$WORK_DIR/.claude/skills/ghost-agent/SKILL.md"

# Download config files
dl "AGENTS.md" "$WORK_DIR/AGENTS.md"
dl ".opencode/opencode.json" "$WORK_DIR/.opencode/opencode.json"

# Also copy skills to ~/.claude/skills/ for global availability
cp -r "$WORK_DIR/.claude/skills/"* "$HOME/.claude/skills/" 2>/dev/null || true

echo -e "${GREEN}  [+] All skills and config downloaded${NC}"
echo -e "${GREEN}  [+] Hacker agents: cuber, godcyber, godcyber++, ghost${NC}"

# 5. Create wrapper command 'adhicode'
echo -e "${CYAN}[5/7] Creating 'adhicode' launcher...${NC}"
cat > "$PREFIX/bin/adhicode" << 'WRAPPER'
#!/data/data/com.termux/files/usr/bin/bash
cd "$HOME/ADHICODE" || { echo "ADHICODE not found. Re-run install."; exit 1; }
echo -e "\033[0;36m"
echo "      ___    ____  _  _____ _____  ___   ____  _____ "
echo "     / _ \  / __ \| |/ /_   _|  __ \|  _ \|  __ \ "
echo "    / /_\ \/ / _\ | ' /  | | | |__) | | | | |__) |"
echo "   / _  |/ /_| _|  <   | | |  _  /| | | |  ___/ "
echo "  / (_) \ \__/ _| . \ _| |_| | \ \| |__| | |    "
echo "  \_____/\____(_)_|\_\_____|_|  \_\_____/|_|     "
echo -e "\033[0m"
echo -e "\033[1;33mADHICODE Terminal -- Hacker AI Ready\033[0m"
echo -e "\033[0;32mType @cuber, @godcyber, @godcyber++, or @ghost for agents\033[0m"
echo ""
opencode "$@"
WRAPPER
chmod +x "$PREFIX/bin/adhicode"
echo -e "${GREEN}  [+] 'adhicode' command created (type 'adhicode' to launch)${NC}"

# 6. TOR setup
echo -e "${CYAN}[6/7] Configuring TOR for anonymous operations...${NC}"
pkg install -y tor 2>/dev/null || true
echo -e "${GREEN}  [+] TOR ready. Start with: tor --SOCKSPort 127.0.0.1:9050 &${NC}"

# 7. Verify everything
echo -e "${CYAN}[7/7] Final verification...${NC}"
echo ""
echo -e "${YELLOW}  Checking installation...${NC}"
problems=""
[ ! -f "$WORK_DIR/.opencode/opencode.json" ] && problems="$problems\n  - Missing: opencode.json"
[ ! -f "$WORK_DIR/AGENTS.md" ] && problems="$problems\n  - Missing: AGENTS.md"
[ ! -d "$WORK_DIR/.claude/skills/cuber" ] && problems="$problems\n  - Missing: cuber skill"
[ ! -d "$WORK_DIR/.claude/skills/godcyber" ] && problems="$problems\n  - Missing: godcyber skill"
[ ! -d "$WORK_DIR/.claude/skills/godcyber-plusplus" ] && problems="$problems\n  - Missing: godcyber++ skill"
[ ! -d "$WORK_DIR/.claude/skills/ghost" ] && problems="$problems\n  - Missing: ghost skill"
! command -v opencode &>/dev/null && problems="$problems\n  - Missing: opencode CLI"
! command -v tor &>/dev/null && problems="$problems\n  - Missing: tor"

if [ -z "$problems" ]; then
    echo -e "${GREEN}  [+] All checks passed!${NC}"
else
    echo -e "${RED}  [!] Issues found:$problems${NC}"
fi

echo ""
echo -e "${GREEN}   ___    ____  _  _____ _____  ___   ____  _____ "
echo -e "  / _ \  / __ \| |/ /_   _|  __ \|  _ \|  __ \ "
echo -e " / /_\ \/ / _\ | ' /  | | | |__) | | | | |__) |"
echo -e "/ _  |/ /_| _|  <   | | |  _  /| | | |  ___/ "
echo -e "(_) \ \__/ _| . \ _| |_| | \ \| |__| | |    "
echo -e " \_____/\____(_)_|\_\_____|_|  \_\_____/|_|     "
echo -e "${NC}"
echo -e "${GREEN}+------------------------------------------------------+"
echo -e "|       ADHICODE-TERMUX INSTALLED SUCCESSFULLY!            |"
echo -e "|  Same AI engine as ADHICODE-cyber.exe on Windows        |"
echo -e "+------------------------------------------------------+${NC}"
echo ""
echo -e "${YELLOW}  Launch ADHICODE (same CLI as the Windows .exe):${NC}"
echo -e "    ${CYAN}adhicode${NC}"
echo ""
echo -e "${YELLOW}  Hacker agents available inside:${NC}"
echo -e "    ${GREEN}@cuber${NC}       -- CYBER-OMNI pentest agent"
echo -e "    ${RED}@godcyber${NC}    -- GOD-CYBER stealth ops"
echo -e "    ${PURPLE}@godcyber++${NC}  -- GOD-CYBER++ transcendent ops"
echo -e "    ${CYAN}@ghost${NC}       -- Total anonymity protocol"
echo ""
echo -e "${YELLOW}  TOR (for anonymous operations):${NC}"
echo -e "    tor --SOCKSPort 127.0.0.1:9050 --ControlPort 127.0.0.1:9051 &"
echo ""
echo -e "${YELLOW}  NOTE: On first launch, OpenCode will ask for your API key.${NC}"
echo -e "${YELLOW}  Set it via: export ANTHROPIC_API_KEY='your-key'${NC}"
echo ""
echo -e "${PURPLE}           + Powered by AdhiHub +${NC}"
echo ""
