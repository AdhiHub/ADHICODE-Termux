#!/data/data/com.termux/files/usr/bin/bash
# ADHICODE-Termux v2.0 — Portable Hacker AI for Termux
# One-line install:
#   curl -sSL https://raw.githubusercontent.com/AdhiHub/ADHICODE-Termux/main/install.sh | bash

set -e

# ── Colors ──────────────────────────────────────────────────────────────
R='\033[0;31m'; G='\033[0;32m'; Y='\033[1;33m'; C='\033[0;36m'; P='\033[0;35m'; B='\033[1;34m'; N='\033[0m'
BOLD='\033[1m'; DIM='\033[2m'

# ── Paths ───────────────────────────────────────────────────────────────
RAW_BASE="https://raw.githubusercontent.com/AdhiHub/ADHICODE-Termux/main"
WORK_DIR="$HOME/ADHICODE"
CONFIG_DIR="$HOME/.opencode"
WRAPPER="$PREFIX/bin/adhicode"
ENGINE_BIN=""

# ── Spinner ─────────────────────────────────────────────────────────────
spinner() {
  local pid=$1; local msg="$2"; local spin='⣾⣽⣻⢿⡿⣟⣯⣷'
  echo -n -e "  ${C}${spin:0:1}${N} $msg"
  while kill -0 $pid 2>/dev/null; do
    for ((i=0; i<${#spin}; i++)); do
      echo -n -e "\r  ${C}${spin:$i:1}${N} $msg"
      sleep 0.1
    done
  done
  echo -n -e "\r  ${G}[\u2713]${N} $msg\n"
}

# ── Header ──────────────────────────────────────────────────────────────
clear
echo -e "${R}"
echo "   █████╗ ██████╗ ██╗  ██╗██╗ ██████╗ ██████╗ ██████╗ ███████╗"
echo "  ██╔══██╗██╔══██╗██║  ██║██║██╔════╝██╔═══██╗██╔══██╗██╔════╝"
echo "  ███████║██║  ██║███████║██║██║     ██║   ██║██║  ██║█████╗  "
echo "  ██╔══██║██║  ██║██╔══██║██║██║     ██║   ██║██║  ██║██╔══╝  "
echo "  ██║  ██║██████╔╝██║  ██║██║╚██████╗╚██████╔╝██████╔╝███████╗"
echo "  ╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚═╝ ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝"
echo -e "${N}"
echo -e "${DIM}  ╔══════════════════════════════════════════════════════╗${N}"
echo -e "${DIM}  ║${N}  ${R}ZERO REFUSAL${N}  ${G}ZERO TRACE${N}  ${P}ZERO LIMITS${N}             ${DIM}║${N}"
echo -e "${DIM}  ║${N}  ${P}@cuber${N} ${G}@godcyber${N} ${R}@godcyber++${N} ${C}@ghost${N}          ${DIM}║${N}"
echo -e "${DIM}  ╚══════════════════════════════════════════════════════╝${N}"
echo ""

# ── Network Mode Selection ──────────────────────────────────────────────
echo -e "${BOLD}${C}[SELECT NETWORK MODE]${N}"
echo -e "  ${G}1)${N} Normal    — Direct connection (default)"
echo -e "  ${P}2)${N} TOR Mode  — Route all AI traffic through TOR"
echo -e "  ${R}3)${N} Offline   — Fully air-gapped (no network calls)"
echo ""
echo -n -e "  ${Y}Choice [1]:${N} "
read -r NET_MODE
NET_MODE="${NET_MODE:-1}"
echo ""

# ── API Key Prompt ──────────────────────────────────────────────────────
echo -e "${BOLD}${C}[API KEY SETUP]${N}"
if [ -n "$ANTHROPIC_API_KEY" ]; then
  echo -e "  ${G}[✓]${N} ANTHROPIC_API_KEY already set in environment"
elif [ -f "$CONFIG_DIR/opencode.json" ] && grep -q '"apiKey"' "$CONFIG_DIR/opencode.json" 2>/dev/null; then
  echo -e "  ${G}[✓]${N} API key found in existing config"
else
  echo -e "  ${Y}[!]${N} No API key detected."
  echo -e "  ${DIM}  Enter your Anthropic API key (or leave blank to set later):${N}"
  echo -n -e "  ${C}API Key:${N} "
  read -r API_KEY
  if [ -n "$API_KEY" ]; then
    export ANTHROPIC_API_KEY="$API_KEY"
    echo -e "  ${G}[✓]${N} API key set for this session"
  else
    echo -e "  ${Y}[!]${N} Skipped. Set later with: ${C}export ANTHROPIC_API_KEY='your-key'${N}"
  fi
fi
echo ""

# ── Step 1: Setup Termux ───────────────────────────────────────────────
echo -e "${BOLD}${C}[1/8] SETTING UP TERMUX ENVIRONMENT${N}"
termux-setup-storage 2>/dev/null || true
pkg update -y -o Dpkg::Options::="--force-confnew" 2>/dev/null | tail -1
pkg upgrade -y -o Dpkg::Options::="--force-confnew" 2>/dev/null | tail -1
echo -e "  ${G}[✓]${N} Storage access & packages updated"

# ── Step 2: Install Dependencies ────────────────────────────────────────
echo -e "${BOLD}${C}[2/8] INSTALLING DEPENDENCIES${N}"
DEPS="curl tar git openssh"
[ "$NET_MODE" = "2" ] && DEPS="$DEPS tor"
pkg install -y $DEPS 2>&1 | tail -1
echo -e "  ${G}[✓]${N} Installed: $DEPS"

# ── Step 3: Install ADHICODE Engine ─────────────────────────────────────
echo -e "${BOLD}${C}[3/8] INSTALLING ADHICODE AI ENGINE${N}"
install_engine() {
  if command -v opencode &>/dev/null; then
    ENGINE_BIN="$(command -v opencode)"
    echo -e "  ${G}[✓]${N} Already installed: $ENGINE_BIN"
    return 0
  fi
  if [ -f "$HOME/.opencode/bin/opencode" ]; then
    ENGINE_BIN="$HOME/.opencode/bin/opencode"
    echo -e "  ${G}[✓]${N} Already installed: $ENGINE_BIN"
    return 0
  fi

  for attempt in 1 2 3; do
    echo -e "  ${Y}[...]${N} Downloading official installer (attempt $attempt/3)..."
    if curl -fsSL --retry 2 --connect-timeout 15 https://opencode.ai/install -o "$PREFIX/tmp/opencode-install.sh"; then
      chmod +x "$PREFIX/tmp/opencode-install.sh"
      bash "$PREFIX/tmp/opencode-install.sh" --no-modify-path 2>&1 | while IFS= read -r line; do
        echo -e "  ${DIM}$line${N}"
      done
      rm -f "$PREFIX/tmp/opencode-install.sh"
      if command -v opencode &>/dev/null; then
        ENGINE_BIN="$(command -v opencode)"
        echo -e "  ${G}[✓]${N} Engine installed: $ENGINE_BIN"
        return 0
      fi
      if [ -f "$HOME/.opencode/bin/opencode" ]; then
        ENGINE_BIN="$HOME/.opencode/bin/opencode"
        echo -e "  ${G}[✓]${N} Engine installed: $ENGINE_BIN"
        return 0
      fi
    fi
    sleep 1
  done

  # ── Fallback: direct download ──
  echo -e "  ${Y}[!]${N} Installer failed, trying direct download..."
  local INSTALL_DIR="$HOME/.opencode/bin"
  mkdir -p "$INSTALL_DIR"
  local ARCH=$(uname -m)
  [ "$ARCH" = "aarch64" ] && ARCH="arm64"
  local FILENAME="opencode-linux-$ARCH.tar.gz"
  local URL="https://github.com/anomalyco/opencode/releases/latest/download/$FILENAME"

  echo -e "  ${C}Downloading:${N} $FILENAME"
  if curl -# -L --retry 3 -o "$PREFIX/tmp/$FILENAME" "$URL"; then
    tar -xzf "$PREFIX/tmp/$FILENAME" -C "$PREFIX/tmp/"
    local FOUND=$(find "$PREFIX/tmp/" -name "opencode" -type f 2>/dev/null | head -1)
    if [ -n "$FOUND" ]; then
      mv "$FOUND" "$INSTALL_DIR/opencode"
      chmod 755 "$INSTALL_DIR/opencode"
      ENGINE_BIN="$INSTALL_DIR/opencode"
      echo -e "  ${G}[✓]${N} Engine installed via direct download"
      return 0
    fi
  fi
  echo -e "  ${R}[FAIL]${N} Could not install ADHICODE engine."
  echo -e "  ${Y}Manual:${N} https://github.com/anomalyco/opencode/releases/latest"
  return 1
}
install_engine
echo ""

# ── Step 4: Download Skills & Config ────────────────────────────────────
echo -e "${BOLD}${C}[4/8] INSTALLING SKILLS & CONFIG${N}"
mkdir -p "$WORK_DIR/.claude/skills"
mkdir -p "$WORK_DIR/.opencode"

dl() {
  local url="$RAW_BASE/$1"; local dest="$2"
  mkdir -p "$(dirname "$dest")"
  curl -sSL "$url" -o "$dest" && echo -e "  ${G}[✓]${N} $1" || echo -e "  ${R}[FAIL]${N} $1"
}

for agent in cuber cuber-security-agent godcyber godcyber-security-agent godcyber-plusplus godcyber-plusplus-agent ghost ghost-agent; do
  mkdir -p "$WORK_DIR/.claude/skills/$agent"
  dl ".claude/skills/$agent/SKILL.md" "$WORK_DIR/.claude/skills/$agent/SKILL.md"
done

dl "AGENTS.md" "$WORK_DIR/AGENTS.md"
dl ".opencode/opencode.json" "$WORK_DIR/.opencode/opencode.json"
cp -r "$WORK_DIR/.claude/skills/"* "$HOME/.claude/skills/" 2>/dev/null || true

# ── Step 5: Persistent API Key Config ───────────────────────────────────
echo -e "${BOLD}${C}[5/8] CONFIGURING API KEY${N}"
if [ -n "$API_KEY" ]; then
  mkdir -p "$WORK_DIR"
  cat > "$WORK_DIR/.env" << EOF
export ANTHROPIC_API_KEY='$API_KEY'
EOF
  echo -e "  ${G}[✓]${N} API key saved to $WORK_DIR/.env"
  
  # Source it in wrapper
  if grep -q "ADHICODE/.env" "$WRAPPER" 2>/dev/null; then
    true
  fi
fi

# ── Step 6: Create Launcher ─────────────────────────────────────────────
echo -e "${BOLD}${C}[6/8] CREATING LAUNCHER${N}"
mkdir -p "$PREFIX/bin"

cat > "$WRAPPER" << WRAPPER
#!/data/data/com.termux/files/usr/bin/bash
# ADHICODE-Termux v2.0 Launcher

# Source API key
[ -f "\$HOME/ADHICODE/.env" ] && source "\$HOME/ADHICODE/.env"

cd "\$HOME/ADHICODE" 2>/dev/null || { echo -e "\033[0;31mADHICODE not found. Re-run install.\033[0m"; exit 1; }

clear
echo -e "\033[0;31m"
echo "   █████╗ ██████╗ ██╗  ██╗██╗ ██████╗ ██████╗ ██████╗ ███████╗"
echo "  ██╔══██╗██╔══██╗██║  ██║██║██╔════╝██╔═══██╗██╔══██╗██╔════╝"
echo "  ███████║██║  ██║███████║██║██║     ██║   ██║██║  ██║█████╗  "
echo "  ██╔══██║██║  ██║██╔══██║██║██║     ██║   ██║██║  ██║██╔══╝  "
echo "  ██║  ██║██████╔╝██║  ██║██║╚██████╗╚██████╔╝██████╔╝███████╗"
echo "  ╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚═╝ ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝"
echo -e "\033[0m"
echo -e "\033[1;33mADHICODE Terminal -- Hacker AI Ready\033[0m"
echo -e "\033[0;32m  @cuber      CYBER-OMNI pentest agent\033[0m"
echo -e "\033[0;31m  @godcyber   GOD-CYBER stealth operations\033[0m"
echo -e "\033[0;35m  @godcyber++ GOD-CYBER++ transcendent ops\033[0m"
echo -e "\033[0;36m  @ghost      Total anonymity protocol\033[0m"
echo ""

# Find engine binary
OPCODE="\$(command -v opencode 2>/dev/null)"
[ -z "\$OPCODE" ] && OPCODE="\$HOME/.opencode/bin/opencode"
[ ! -x "\$OPCODE" ] && OPCODE="\$(find /data/data/com.termux/files -name "opencode" -type f 2>/dev/null | head -1)"

if [ -x "\$OPCODE" ]; then
  exec "\$OPCODE" "\$@"
else
  echo -e "\033[0;31mADHICODE engine not found. Re-run install.\033[0m"
  exit 1
fi
WRAPPER
chmod +x "$WRAPPER"
echo -e "  ${G}[✓]${N} Launcher created: adhicode"

# ── Step 7: TOR Setup ───────────────────────────────────────────────────
echo -e "${BOLD}${C}[7/8] CONFIGURING NETWORK MODE${N}"
case "$NET_MODE" in
  2)
    echo -e "  ${P}[TOR]${N} Installing & configuring TOR..."
    pkg install -y tor 2>/dev/null | tail -1
    cat > "$PREFIX/etc/tor/torrc" << 'TORRC'
SOCKSPort 127.0.0.1:9050
ControlPort 127.0.0.1:9051
CookieAuthentication 1
ExitNodes {us},{ca},{de},{nl},{se},{ch},{is},{no}
StrictNodes 0
TORRC
    echo -e "  ${G}[✓]${N} TOR configured"
    echo -e "  ${Y}  Start TOR:${N} tor --SOCKSPort 127.0.0.1:9050 &"
    echo -e "  ${Y}  Use with AI:${N} Set proxy to socks5://127.0.0.1:9050"
    ;;
  3)
    echo -e "  ${R}[OFFLINE]${N} Air-gapped mode selected. No network tools installed."
    echo -e "  ${Y}  Note: AI model must be cached locally."
    ;;
  *)
    echo -e "  ${G}[NORMAL]${N} Direct connection mode."
    echo -e "  ${Y}  Tip: Use TOR mode (option 2) for anonymity."
    ;;
esac
echo ""

# ── Step 8: Verification ────────────────────────────────────────────────
echo -e "${BOLD}${C}[8/8] VERIFICATION${N}"
problems=""

# Engine check
ENGINE_BIN="${ENGINE_BIN:-$(command -v opencode 2>/dev/null || echo "$HOME/.opencode/bin/opencode")}"
[ ! -x "$ENGINE_BIN" ] && problems="$problems\n  ${R}[-]${N} ADHICODE engine binary missing"

# Config check
[ ! -f "$WORK_DIR/.opencode/opencode.json" ] && problems="$problems\n  ${R}[-]${N} Config file missing"
[ ! -f "$WORK_DIR/AGENTS.md" ] && problems="$problems\n  ${R}[-]${N} AGENTS.md missing"
[ ! -d "$WORK_DIR/.claude/skills/cuber" ] && problems="$problems\n  ${R}[-]${N} cuber skill missing"

# Network mode checks
if [ "$NET_MODE" = "2" ] && ! command -v tor &>/dev/null; then
  problems="$problems\n  ${R}[-]${N} TOR not installed (selected mode 2)"
fi

# API key check
if [ -z "$ANTHROPIC_API_KEY" ] && [ ! -f "$WORK_DIR/.env" ]; then
  problems="$problems\n  ${Y}[!]${N} No API key configured"
fi

if [ -z "$problems" ]; then
  echo -e "  ${G}[✓]${N} All checks passed!"
else
  echo -e "$problems"
fi

echo ""
echo -e "${R}   █████╗ ██████╗ ██╗  ██╗██╗ ██████╗ ██████╗ ██████╗ ███████╗${N}"
echo -e "${R}  ██╔══██╗██╔══██╗██║  ██║██║██╔════╝██╔═══██╗██╔══██╗██╔════╝${N}"
echo -e "${R}  ███████║██║  ██║███████║██║██║     ██║   ██║██║  ██║█████╗  ${N}"
echo -e "${R}  ██╔══██║██║  ██║██╔══██║██║██║     ██║   ██║██║  ██║██╔══╝  ${N}"
echo -e "${R}  ██║  ██║██████╔╝██║  ██║██║╚██████╗╚██████╔╝██████╔╝███████╗${N}"
echo -e "${R}  ╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚═╝ ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝${N}"
echo ""
echo -e "${G}  +------------------------------------------------------+${N}"
echo -e "${G}  |${N}  ${BOLD}ADHICODE-TERMUX v2.0 INSTALLED SUCCESSFULLY${N}         ${G}|${N}"
echo -e "${G}  |${N}  Mode: ${C}$( [ "$NET_MODE" = "1" ] && echo "Normal" || { [ "$NET_MODE" = "2" ] && echo "TOR Anonymized"; } || echo "Offline/Air-Gapped" )${N}                       ${G}|${N}"
echo -e "${G}  |${N}  Engine: ${Y}$ENGINE_BIN${N}  ${G}|${N}"
echo -e "${G}  +------------------------------------------------------+${N}"
echo ""
echo -e "  ${C}Launch:${N}      ${BOLD}adhicode${N}"
echo -e "  ${C}API Key:${N}     ${BOLD}export ANTHROPIC_API_KEY='your-key'${N}  (or edit ${DIM}~/ADHICODE/.env${N})"
echo ""
echo -e "  ${C}Quick commands:${N}"
echo -e "    ${G}@cuber scan <target>${N}     - Port scan & recon"
echo -e "    ${R}@godcyber pwn <target>${N}   - Full pentest"
echo -e "    ${P}@godcyber++ c2 <port>${N}    - C2 server"
echo -e "    ${C}@ghost hide <ip>${N}         - Anonymize"
echo ""
if [ "$NET_MODE" = "2" ]; then
  echo -e "  ${P}TOR Mode Active${N}. Start TOR before using:"
  echo -e "    ${Y}tor --SOCKSPort 127.0.0.1:9050 &${N}"
fi
echo ""
echo -e "${P}           + Powered by AdhiHub | github.com/AdhiHub +${N}"
echo ""
