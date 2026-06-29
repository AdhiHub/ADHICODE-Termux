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
echo -e "| Installs the REAL ADHICODE AI (same engine)       |"
echo -e "+------------------------------------------------------+${NC}"
echo ""

set -e

RAW_BASE="https://raw.githubusercontent.com/AdhiHub/ADHICODE-Termux/main"
WORK_DIR="$HOME/ADHICODE"

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

echo -e "${CYAN}[1/7] Updating Termux packages...${NC}"
pkg update -y -o Dpkg::Options::="--force-confnew" 2>/dev/null || pkg update -y
pkg upgrade -y -o Dpkg::Options::="--force-confnew" 2>/dev/null || pkg upgrade -y

echo -e "${CYAN}[2/7] Installing dependencies (curl, tar, git, TOR, nmap)...${NC}"
pkg install -y curl tar git tor nmap openssh

# Step 3: Download ADHICODE AI binary (same engine as ADHICODE-cyber.exe)
echo -e "${CYAN}[3/7] Downloading ADHICODE AI engine...${NC}"
INSTALL_DIR="$HOME/.opencode/bin"
mkdir -p "$INSTALL_DIR"

# Detect arch
ARCH=$(uname -m)
if [ "$ARCH" = "aarch64" ]; then ARCH="arm64"; fi
COMBO="linux-$ARCH"

echo -e "  ${YELLOW}Arch:${NC} $COMBO"

echo -e "  ${YELLOW}Downloading latest release...${NC}"

FILENAME="opencode-$COMBO.tar.gz"
URL="https://github.com/anomalyco/opencode/releases/latest/download/${FILENAME}"

TMPDIR="${TMPDIR:-/tmp}/adhicode_install_$$"
mkdir -p "$TMPDIR"
echo -e "  ${YELLOW}Downloading:${NC} $URL"
HTTP_CODE=$(curl -# -L -o "$TMPDIR/$FILENAME" -w "%{http_code}" "$URL" 2>&1)
if [ "$HTTP_CODE" != "200" ]; then
    echo -e "${RED}  [!] Download failed (HTTP $HTTP_CODE). Trying specific version...${NC}"
    VERSION=$(curl -s https://api.github.com/repos/anomalyco/opencode/releases/latest | sed -n 's/.*"tag_name": *"v\([^"]*\)".*/\1/p')
    if [ -n "$VERSION" ]; then
        URL="https://github.com/anomalyco/opencode/releases/download/v${VERSION}/${FILENAME}"
        echo -e "  ${YELLOW}Retrying:${NC} $URL"
        HTTP_CODE=$(curl -# -L -o "$TMPDIR/$FILENAME" -w "%{http_code}" "$URL" 2>&1)
    fi
    if [ "$HTTP_CODE" != "200" ]; then
        echo -e "${RED}  [ERROR] Download failed. Check your internet connection.${NC}"
        exit 1
    fi
fi

if [ ! -f "$TMPDIR/$FILENAME" ] || [ ! -s "$TMPDIR/$FILENAME" ]; then
    echo -e "${RED}  [ERROR] Downloaded file is missing or empty${NC}"
    exit 1
fi

echo -e "  ${YELLOW}Extracting...${NC}"
tar -xzf "$TMPDIR/$FILENAME" -C "$TMPDIR"

if [ ! -f "$TMPDIR/opencode" ]; then
    echo -e "${RED}  [ERROR] Binary not found in archive${NC}"
    ls -la "$TMPDIR/"
    exit 1
fi

# Install the engine binary (stays as 'opencode' internally, user runs 'adhicode')
mv "$TMPDIR/opencode" "$INSTALL_DIR/opencode"
chmod 755 "$INSTALL_DIR/opencode"
rm -rf "$TMPDIR"

# Add to PATH if not already
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo "export PATH=\"\$HOME/.opencode/bin:\$PATH\"" >> "$HOME/.bashrc"
    export PATH="$HOME/.opencode/bin:$PATH"
fi

echo -e "${GREEN}  [+] ADHICODE AI engine installed!${NC}"

echo -e "${CYAN}[4/7] Downloading ADHICODE skills & config...${NC}"
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

dl ".claude/skills/cuber/SKILL.md" "$WORK_DIR/.claude/skills/cuber/SKILL.md"
dl ".claude/skills/cuber-security-agent/SKILL.md" "$WORK_DIR/.claude/skills/cuber-security-agent/SKILL.md"
dl ".claude/skills/godcyber/SKILL.md" "$WORK_DIR/.claude/skills/godcyber/SKILL.md"
dl ".claude/skills/godcyber-security-agent/SKILL.md" "$WORK_DIR/.claude/skills/godcyber-security-agent/SKILL.md"
dl ".claude/skills/godcyber-plusplus/SKILL.md" "$WORK_DIR/.claude/skills/godcyber-plusplus/SKILL.md"
dl ".claude/skills/godcyber-plusplus-agent/SKILL.md" "$WORK_DIR/.claude/skills/godcyber-plusplus-agent/SKILL.md"
dl ".claude/skills/ghost/SKILL.md" "$WORK_DIR/.claude/skills/ghost/SKILL.md"
dl ".claude/skills/ghost-agent/SKILL.md" "$WORK_DIR/.claude/skills/ghost-agent/SKILL.md"

dl "AGENTS.md" "$WORK_DIR/AGENTS.md"
dl ".opencode/opencode.json" "$WORK_DIR/.opencode/opencode.json"

cp -r "$WORK_DIR/.claude/skills/"* "$HOME/.claude/skills/" 2>/dev/null || true

echo -e "${GREEN}  [+] All skills and config installed${NC}"

echo -e "${CYAN}[5/7] Creating 'adhicode' launcher...${NC}"
mkdir -p "$PREFIX/bin"
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
exec "$HOME/.opencode/bin/opencode" "$@"
WRAPPER
chmod +x "$PREFIX/bin/adhicode"
echo -e "${GREEN}  [+] 'adhicode' command ready${NC}"

echo -e "${CYAN}[6/7] Configuring TOR for anonymity...${NC}"
pkg install -y tor 2>/dev/null || true
echo -e "${GREEN}  [+] TOR ready. Start with: tor --SOCKSPort 127.0.0.1:9050 &${NC}"

echo -e "${CYAN}[7/7] Final verification...${NC}"
problems=""
[ ! -f "$INSTALL_DIR/opencode" ] && problems="$problems\n  - Missing: ADHICODE engine binary"
[ ! -f "$WORK_DIR/.opencode/opencode.json" ] && problems="$problems\n  - Missing: opencode.json"
[ ! -f "$WORK_DIR/AGENTS.md" ] && problems="$problems\n  - Missing: AGENTS.md"
[ ! -d "$WORK_DIR/.claude/skills/cuber" ] && problems="$problems\n  - Missing: cuber skill"
! command -v tor &>/dev/null && problems="$problems\n  - Missing: tor"

if [ -z "$problems" ]; then
    echo -e "${GREEN}  [+] All checks passed!${NC}"
else
    echo -e "${RED}  [!] Issues:$problems${NC}"
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
echo -e "${YELLOW}  Launch ADHICODE:${NC}"
echo -e "    ${CYAN}adhicode${NC}"
echo ""
echo -e "${YELLOW}  Hacker agents available inside:${NC}"
echo -e "    ${GREEN}@cuber${NC}       -- CYBER-OMNI pentest agent"
echo -e "    ${RED}@godcyber${NC}    -- GOD-CYBER stealth ops"
echo -e "    ${PURPLE}@godcyber++${NC}  -- GOD-CYBER++ transcendent ops"
echo -e "    ${CYAN}@ghost${NC}       -- Total anonymity protocol"
echo ""
echo -e "${YELLOW}  TOR: tor --SOCKSPort 127.0.0.1:9050 --ControlPort 127.0.0.1:9051 &${NC}"
echo ""
echo -e "${PURPLE}           + Powered by AdhiHub +${NC}"
echo ""
