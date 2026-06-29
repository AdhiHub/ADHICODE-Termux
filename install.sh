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

# Step 3: Install ADHICODE AI engine (using official opencode install script)
echo -e "${CYAN}[3/7] Installing ADHICODE AI engine...${NC}"

# Use the official install script which handles platform detection, download, extraction
if command -v opencode &>/dev/null; then
    echo -e "  ${YELLOW}ADHICODE engine already installed, skipping...${NC}"
else
    echo -e "  ${YELLOW}Downloading via official installer...${NC}"
    # Download installer to a temp file, then execute it
    curl -fsSL https://opencode.ai/install -o "$PREFIX/tmp/opencode-install.sh"
    chmod +x "$PREFIX/tmp/opencode-install.sh"
    
    # Run installer silently (no-modify-path to avoid shell config changes)
    bash "$PREFIX/tmp/opencode-install.sh" --no-modify-path 2>&1 | while IFS= read -r line; do
        echo -e "  ${CYAN}$line${NC}"
    done
    
    rm -f "$PREFIX/tmp/opencode-install.sh"
    
    # Verify installation
    if command -v opencode &>/dev/null; then
        echo -e "${GREEN}  [+] ADHICODE AI engine installed! ($(command -v opencode))${NC}"
    elif [ -f "$HOME/.opencode/bin/opencode" ]; then
        echo -e "${GREEN}  [+] ADHICODE AI engine installed! ($HOME/.opencode/bin/opencode)${NC}"
        export PATH="$HOME/.opencode/bin:$PATH"
    else
        echo -e "${RED}  [ERROR] Install script finished but 'opencode' not found.${NC}"
        echo -e "${YELLOW}  Attempting direct download fallback...${NC}"
        
        # Fallback: direct download
        INSTALL_DIR="$HOME/.opencode/bin"
        mkdir -p "$INSTALL_DIR"
        ARCH=$(uname -m)
        [ "$ARCH" = "aarch64" ] && ARCH="arm64"
        COMBO="linux-$ARCH"
        FILENAME="opencode-$COMBO.tar.gz"
        
        echo -e "  ${YELLOW}Downloading:${NC} opencode-$COMBO.tar.gz"
        echo -e "  ${YELLOW}URL:${NC} https://github.com/anomalyco/opencode/releases/latest/download/$FILENAME"
        
        TMP_DIR="$HOME/.adhicode-tmp"
        mkdir -p "$TMP_DIR"
        
        if curl -# -L --retry 3 -o "$TMP_DIR/$FILENAME" "https://github.com/anomalyco/opencode/releases/latest/download/$FILENAME"; then
            echo -e "  ${YELLOW}Extracting...${NC}"
            tar -xzf "$TMP_DIR/$FILENAME" -C "$TMP_DIR"
            if [ -f "$TMP_DIR/opencode" ]; then
                mv "$TMP_DIR/opencode" "$INSTALL_DIR/opencode"
                chmod 755 "$INSTALL_DIR/opencode"
                echo -e "${GREEN}  [+] Installed via direct download${NC}"
            else
                echo -e "${RED}  [ERROR] Binary not found in archive${NC}"
                ls -la "$TMP_DIR/"
                exit 1
            fi
        else
            echo -e "${RED}  [ERROR] Download failed.${NC}"
            echo -e "${YELLOW}  Please check your internet connection and try again.${NC}"
            echo -e "${YELLOW}  If the issue persists, download manually from:${NC}"
            echo -e "  https://github.com/anomalyco/opencode/releases/latest"
            exit 1
        fi
        rm -rf "$TMP_DIR"
    fi
fi

echo -e "${CYAN}[4/7] Downloading ADHICODE skills & config...${NC}"
mkdir -p "$WORK_DIR/.claude/skills"
mkdir -p "$WORK_DIR/.opencode"

for agent in cuber cuber-security-agent godcyber godcyber-security-agent godcyber-plusplus godcyber-plusplus-agent ghost ghost-agent; do
    mkdir -p "$WORK_DIR/.claude/skills/$agent"
    dl ".claude/skills/$agent/SKILL.md" "$WORK_DIR/.claude/skills/$agent/SKILL.md"
done

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
OPCODE=$(command -v opencode 2>/dev/null || echo "$HOME/.opencode/bin/opencode")
if [ -x "$OPCODE" ]; then
    exec "$OPCODE" "$@"
else
    echo -e "\033[0;31mADHICODE engine not found. Re-run the install script.\033[0m"
    exit 1
fi
WRAPPER
chmod +x "$PREFIX/bin/adhicode"
echo -e "${GREEN}  [+] 'adhicode' command ready${NC}"

echo -e "${CYAN}[6/7] Configuring TOR for anonymity...${NC}"
pkg install -y tor 2>/dev/null || true
echo -e "${GREEN}  [+] TOR ready. Start with: tor --SOCKSPort 127.0.0.1:9050 &${NC}"

echo -e "${CYAN}[7/7] Final verification...${NC}"
problems=""
OC=$(command -v opencode 2>/dev/null || echo "$HOME/.opencode/bin/opencode")
[ ! -x "$OC" ] && problems="$problems\n  - Missing: ADHICODE engine binary"
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
