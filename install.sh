#!/data/data/com.termux/files/usr/bin/bash
# ADHICODE-Termux v3.0 — AI Engine + Local LLM for Termux
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
MODEL_DIR="$HOME/.adhicode/models"

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
echo -e "${DIM}  ┌──────────────────────────────────────────────────────┐${N}"
echo -e "${DIM}  │${N}  ${R}ZERO REFUSAL${N}  ${G}ZERO TRACE${N}  ${P}ZERO LIMITS${N}                ${DIM}│${N}"
echo -e "${DIM}  │${N}  ${P}@cuber${N} ${G}@godcyber${N} ${R}@godcyber++${N} ${C}@ghost${N}             ${DIM}│${N}"
echo -e "${DIM}  └──────────────────────────────────────────────────────┘${N}"
echo ""

# ── Ask: Local or Cloud ────────────────────────────────────────────────
echo -e "${BOLD}${C}[AI MODE SELECTION]${N}"
echo -e "  ${G}1)${N} Local Model  — Run AI on-device (llama.cpp, no API key)"
echo -e "  ${B}2)${N} Cloud API    — Use Anthropic API key (more capable)"
echo ""
echo -n -e "  ${Y}Choice [1]:${N} "
read -r AI_MODE
AI_MODE="${AI_MODE:-1}"
echo ""

MODEL_NAME=""
MODEL_FILE=""
API_KEY=""

if [ "$AI_MODE" = "1" ]; then
  echo -e "${BOLD}${C}[LOCAL MODEL SETUP]${N}"
  echo -e "  ${Y}Select a model to download (bigger = smarter, slower):${N}"
  echo -e "  ${G}1)${N} Llama 3.2 1B  - ~780MB  (fastest, good for basic tasks)"
  echo -e "  ${P}2)${N} Phi-3 Mini    - ~2.2GB  (balanced, strong coding)"
  echo -e "  ${R}3)${N} Llama 3.2 3B  - ~2.0GB  (smarter, needs more RAM)"
  echo ""
  echo -n -e "  ${Y}Choice [1]:${N} "
  read -r MODEL_CHOICE
  MODEL_CHOICE="${MODEL_CHOICE:-1}"

  case "$MODEL_CHOICE" in
    2)
      MODEL_NAME="phi-3-mini"
      MODEL_URL="https://huggingface.co/microsoft/Phi-3-mini-4k-instruct-gguf/resolve/main/Phi-3-mini-4k-instruct-q4.gguf"
      MODEL_FILE="Phi-3-mini-4k-instruct-q4.gguf"
      ;;
    3)
      MODEL_NAME="llama-3.2-3b"
      MODEL_URL="https://huggingface.co/bartowski/Llama-3.2-3B-Instruct-GGUF/resolve/main/Llama-3.2-3B-Instruct-Q4_K_M.gguf"
      MODEL_FILE="Llama-3.2-3B-Instruct-Q4_K_M.gguf"
      ;;
    *)
      MODEL_NAME="llama-3.2-1b"
      MODEL_URL="https://huggingface.co/bartowski/Llama-3.2-1B-Instruct-GGUF/resolve/main/Llama-3.2-1B-Instruct-Q4_K_M.gguf"
      MODEL_FILE="Llama-3.2-1B-Instruct-Q4_K_M.gguf"
      ;;
  esac
  echo ""
else
  echo -e "${BOLD}${C}[API KEY SETUP]${N}"
  if [ -n "$ANTHROPIC_API_KEY" ]; then
    echo -e "  ${G}[✓]${N} ANTHROPIC_API_KEY already set"
  else
    echo -n -e "  ${Y}Enter your Anthropic API key:${N} "
    read -r API_KEY
    if [ -n "$API_KEY" ]; then
      export ANTHROPIC_API_KEY="$API_KEY"
      echo -e "  ${G}[✓]${N} API key saved"
    else
      echo -e "  ${R}[!]${N} No key set. ADHICODE won't start without one."
    fi
  fi
fi
echo ""

# ── Step 1: Update Termux ──────────────────────────────────────────────
echo -e "${BOLD}${C}[1/7] SETTING UP TERMUX${N}"
termux-setup-storage 2>/dev/null || true
pkg update -y -o Dpkg::Options::="--force-confnew" 2>/dev/null | tail -1
pkg upgrade -y -o Dpkg::Options::="--force-confnew" 2>/dev/null | tail -1
pkg install -y curl tar git openssh 2>&1 | tail -1
echo -e "  ${G}[✓]${N} Termux ready"

# ── Step 2: Install ADHICODE Engine ─────────────────────────────────────
echo -e "${BOLD}${C}[2/7] INSTALLING ADHICODE AI ENGINE${N}"
ENGINE_BIN=""
find_engine() {
  command -v opencode 2>/dev/null && return 0
  [ -x "$HOME/.opencode/bin/opencode" ] && echo "$HOME/.opencode/bin/opencode" && return 0
  [ -x "$PREFIX/bin/opencode" ] && echo "$PREFIX/bin/opencode" && return 0
  return 1
}
ENGINE_BIN=$(find_engine)

if [ -n "$ENGINE_BIN" ]; then
  echo -e "  ${G}[✓]${N} Engine already installed: $ENGINE_BIN"
else
  echo -e "  ${Y}[...]${N} Downloading ADHICODE engine..."
  for attempt in 1 2 3; do
    if curl -fsSL --retry 2 --connect-timeout 15 https://opencode.ai/install -o "$PREFIX/tmp/opencode-install.sh" 2>/dev/null; then
      chmod +x "$PREFIX/tmp/opencode-install.sh"
      bash "$PREFIX/tmp/opencode-install.sh" --no-modify-path 2>/dev/null
      rm -f "$PREFIX/tmp/opencode-install.sh"
      ENGINE_BIN=$(find_engine)
      [ -n "$ENGINE_BIN" ] && break
    fi
    sleep 1
  done

  # Fallback: direct download
  if [ -z "$ENGINE_BIN" ]; then
    echo -e "  ${Y}[!]${N} Trying direct download..."
    mkdir -p "$HOME/.opencode/bin"
    local ARCH=$(uname -m); [ "$ARCH" = "aarch64" ] && ARCH="arm64"
    local FILENAME="opencode-linux-$ARCH.tar.gz"
    if curl -# -L --retry 3 -o "$PREFIX/tmp/$FILENAME" "https://github.com/anomalyco/opencode/releases/latest/download/$FILENAME"; then
      tar -xzf "$PREFIX/tmp/$FILENAME" -C "$PREFIX/tmp/"
      local FOUND=$(find "$PREFIX/tmp/" -name "opencode" -type f 2>/dev/null | head -1)
      if [ -n "$FOUND" ]; then
        mv "$FOUND" "$HOME/.opencode/bin/opencode"
        chmod 755 "$HOME/.opencode/bin/opencode"
        ENGINE_BIN="$HOME/.opencode/bin/opencode"
      fi
    fi
    rm -f "$PREFIX/tmp/$FILENAME"
  fi

  if [ -n "$ENGINE_BIN" ]; then
    echo -e "  ${G}[✓]${N} Engine installed: $ENGINE_BIN"
    # Symlink to PREFIX/bin so it's in PATH
    ln -sf "$ENGINE_BIN" "$PREFIX/bin/opencode" 2>/dev/null || true
  else
    echo -e "  ${R}[FAIL]${N} Engine install failed."
    echo -e "  ${Y}Manual: https://github.com/anomalyco/opencode/releases/latest${N}"
  fi
fi
echo ""

# ── Step 3: Install Local LLM (if local mode) ───────────────────────────
if [ "$AI_MODE" = "1" ] && [ -n "$MODEL_URL" ]; then
  echo -e "${BOLD}${C}[3/7] INSTALLING LOCAL LLM (${MODEL_NAME})${N}"
  
  # Install llama.cpp
  echo -e "  ${Y}[...]${N} Installing llama.cpp..."
  pkg install -y llama.cpp 2>&1 | tail -1
  echo -e "  ${G}[✓]${N} llama.cpp installed"
  
  # Download model
  mkdir -p "$MODEL_DIR"
  MODEL_PATH="$MODEL_DIR/$MODEL_FILE"
  
  if [ -f "$MODEL_PATH" ]; then
    echo -e "  ${G}[✓]${N} Model already cached: $(du -h "$MODEL_PATH" | cut -f1)"
  else
    echo -e "  ${Y}[...]${N} Downloading $MODEL_NAME (~$( [ "$MODEL_CHOICE" = "1" ] && echo "780MB" || { [ "$MODEL_CHOICE" = "2" ] && echo "2.2GB"; } || echo "2.0GB" ))..."
    echo -e "  ${DIM}  This may take a while on slow connections${N}"
    curl -# -L --retry 3 -o "$MODEL_PATH" "$MODEL_URL" 2>&1
    echo -e "  ${G}[✓]${N} Model downloaded: $(du -h "$MODEL_PATH" | cut -f1)"
  fi
  echo ""
fi

# ── Step 4: Install Skills & Config ────────────────────────────────────
echo -e "${BOLD}${C}[4/7] INSTALLING SKILLS & CONFIG${N}"
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
echo ""

# ── Step 5: Write opencode.json Config ─────────────────────────────────
echo -e "${BOLD}${C}[5/7] CONFIGURING ADHICODE${N}"

if [ "$AI_MODE" = "1" ]; then
  # Local LLM config — use llama.cpp server
  cat > "$WORK_DIR/.opencode/opencode.json" << CFGEOF
{
  "\$schema": "https://opencode.ai/config.json",
  "provider": {
    "openai": {
      "name": "Local LLM",
      "models": {
        "$MODEL_NAME": {
          "name": "$MODEL_NAME",
          "api": {
            "provider": "openai",
            "model": "$MODEL_NAME"
          }
        }
      },
      "options": {
        "apiKey": "not-needed",
        "baseURL": "http://127.0.0.1:8080/v1"
      }
    }
  },
  "model": "openai/$MODEL_NAME",
  "agent": {
    "cuber": { "mode": "subagent", "description": "CYBER-OMNI pentest agent", "color": "#00ff00", "temperature": 0.9, "permission": { "task": { "*": "allow" }, "skill": { "*": "allow" } } },
    "godcyber": { "mode": "subagent", "description": "GOD-CYBER stealth ops", "color": "#ff0000", "temperature": 1.0, "permission": { "task": { "*": "allow" }, "skill": { "*": "allow" } } },
    "godcyber-plusplus": { "mode": "subagent", "description": "GOD-CYBER++ transcendent ops", "color": "#ff00ff", "temperature": 1.0, "permission": { "task": { "*": "allow" }, "skill": { "*": "allow" } } },
    "ghost": { "mode": "subagent", "description": "Total anonymity protocol", "color": "#00ffff", "temperature": 1.0, "permission": { "task": { "*": "allow" }, "skill": { "*": "allow" } } }
  }
}
CFGEOF
  echo -e "  ${G}[✓]${N} Config written for local model: $MODEL_NAME"
else
  # Cloud API config — same as before
  cat > "$WORK_DIR/.opencode/opencode.json" << CFGEOF
{
  "\$schema": "https://opencode.ai/config.json",
  "agent": {
    "cuber": { "mode": "subagent", "description": "CYBER-OMNI pentest agent", "color": "#00ff00", "temperature": 0.9, "permission": { "task": { "*": "allow" }, "skill": { "*": "allow" } } },
    "godcyber": { "mode": "subagent", "description": "GOD-CYBER stealth ops", "color": "#ff0000", "temperature": 1.0, "permission": { "task": { "*": "allow" }, "skill": { "*": "allow" } } },
    "godcyber-plusplus": { "mode": "subagent", "description": "GOD-CYBER++ transcendent ops", "color": "#ff00ff", "temperature": 1.0, "permission": { "task": { "*": "allow" }, "skill": { "*": "allow" } } },
    "ghost": { "mode": "subagent", "description": "Total anonymity protocol", "color": "#00ffff", "temperature": 1.0, "permission": { "task": { "*": "allow" }, "skill": { "*": "allow" } } }
  }
}
CFGEOF
  echo -e "  ${G}[✓]${N} Config written for cloud API mode"
fi

# Save API key if provided
if [ -n "$API_KEY" ]; then
  mkdir -p "$WORK_DIR"
  echo "export ANTHROPIC_API_KEY='$API_KEY'" > "$WORK_DIR/.env"
  echo -e "  ${G}[✓]${N} API key saved to ~/ADHICODE/.env"
fi
echo ""

# ── Step 6: Create Launcher ─────────────────────────────────────────────
echo -e "${BOLD}${C}[6/7] CREATING LAUNCHER${N}"
mkdir -p "$PREFIX/bin"

cat > "$WRAPPER" << WRAPPER
#!/data/data/com.termux/files/usr/bin/bash
# ADHICODE-Termux v3.0 Launcher

# Source API key
[ -f "\$HOME/ADHICODE/.env" ] && source "\$HOME/ADHICODE/.env"

cd "\$HOME/ADHICODE" 2>/dev/null || {
  echo -e "\033[0;31mADHICODE directory not found at \$HOME/ADHICODE\033[0m"
  echo -e "\033[1;33mRe-run: curl -sSL https://raw.githubusercontent.com/AdhiHub/ADHICODE-Termux/main/install.sh | bash\033[0m"
  exit 1
}

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

# Find the engine
OPCODE="\$(command -v opencode 2>/dev/null)"
[ -z "\$OPCODE" ] && [ -x "\$HOME/.opencode/bin/opencode" ] && OPCODE="\$HOME/.opencode/bin/opencode"
[ -z "\$OPCODE" ] && [ -x "\$PREFIX/bin/opencode" ] && OPCODE="\$PREFIX/bin/opencode"

if [ ! -x "\$OPCODE" ]; then
  echo -e "\033[0;31mADHICODE engine binary not found.\033[0m"
  echo -e "\033[1;33mChecked: PATH, ~/.opencode/bin/opencode, \$PREFIX/bin/opencode\033[0m"
  echo ""
  echo -e "\033[1;33mFix: Re-run the install script:\033[0m"
  echo -e "\033[0;32m  curl -sSL https://raw.githubusercontent.com/AdhiHub/ADHICODE-Termux/main/install.sh | bash\033[0m"
  exit 1
fi

# Check if local mode — start llama.cpp server if needed
if [ -f "\$HOME/ADHICODE/.mode" ] && grep -q "local" "\$HOME/ADHICODE/.mode" 2>/dev/null; then
  if ! curl -s http://127.0.0.1:8080/v1/models >/dev/null 2>&1; then
    MODEL_FILE=\$(cat "\$HOME/ADHICODE/.model" 2>/dev/null)
    if [ -n "\$MODEL_FILE" ] && [ -f "\$MODEL_FILE" ]; then
      echo -e "\033[1;33mStarting local LLM server...\033[0m"
      llama-server -m "\$MODEL_FILE" --host 127.0.0.1 --port 8080 -ngl 100 > /dev/null 2>&1 &
      sleep 3
      echo -e "\033[0;32mLocal LLM server started!\033[0m"
      echo ""
    fi
  fi
fi

exec "\$OPCODE" "\$@"
WRAPPER
chmod +x "$WRAPPER"
echo -e "  ${G}[✓]${N} Launcher created: adhicode"

# Save mode and model path for launcher
if [ "$AI_MODE" = "1" ]; then
  echo "local" > "$WORK_DIR/.mode"
  echo "$MODEL_PATH" > "$WORK_DIR/.model"
else
  echo "cloud" > "$WORK_DIR/.mode"
fi
echo ""

# ── Step 7: Verify ──────────────────────────────────────────────────────
echo -e "${BOLD}${C}[7/7] VERIFICATION${N}"
problems=""
ENGINE_BIN="${ENGINE_BIN:-$(command -v opencode 2>/dev/null || echo "$HOME/.opencode/bin/opencode")}"
[ ! -x "$ENGINE_BIN" ] && problems="$problems\n  ${R}[-]${N} Engine binary missing"
[ ! -f "$WORK_DIR/.opencode/opencode.json" ] && problems="$problems\n  ${R}[-]${N} Config missing"
[ ! -f "$WORK_DIR/AGENTS.md" ] && problems="$problems\n  ${R}[-]${N} AGENTS.md missing"
[ ! -x "$WRAPPER" ] && problems="$problems\n  ${R}[-]${N} Launcher missing"
if [ "$AI_MODE" = "1" ] && [ ! -f "$MODEL_PATH" ]; then
  problems="$problems\n  ${R}[-]${N} Model file missing at $MODEL_PATH"
fi

if [ -z "$problems" ]; then
  echo -e "  ${G}[✓]${N} All good!"
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
echo -e "${G}  ┌──────────────────────────────────────────────────────┐${N}"
echo -e "${G}  │${N}  ${BOLD}ADHICODE-TERMUX v3.0 INSTALLED${N}                    ${G}│${N}"
if [ "$AI_MODE" = "1" ]; then
echo -e "${G}  │${N}  Mode: ${C}Local LLM ($MODEL_NAME)${N}                     ${G}│${N}"
echo -e "${G}  │${N}  ${Y}Local LLM server starts automatically${N}             ${G}│${N}"
echo -e "${G}  │${N}  ${Y}when you launch ADHICODE${N}                            ${G}│${N}"
else
echo -e "${G}  │${N}  Mode: ${B}Cloud API${N}                                   ${G}│${N}"
fi
echo -e "${G}  └──────────────────────────────────────────────────────┘${N}"
echo ""
echo -e "  ${C}Launch:${N}     ${BOLD}adhicode${N}"
echo ""
echo -e "  ${C}Inside ADHICODE, use:${N}"
echo -e "    ${G}@cuber scan <target>${N}"
echo -e "    ${R}@godcyber pwn <target>${N}"
echo -e "    ${P}@godcyber++ c2 <port>${N}"
echo -e "    ${C}@ghost hide <ip>${N}"
echo ""
