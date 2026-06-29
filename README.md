# ADHICODE-Termux

**Portable Hacker AI for Android Termux** — one-line install, same AI engine as `ADHICODE-cyber.exe`.

## One-Line Install

```bash
curl -sSL https://raw.githubusercontent.com/AdhiHub/ADHICODE-Termux/main/install.sh | bash
```

## How to Test

### 1. Install

Run the one-liner above. The installer will:

1. Ask you to pick a **network mode** (Normal / TOR / Offline)
2. Ask for your **Anthropic API key** (or skip to set later)
3. Install the OpenCode AI engine
4. Download all 4 hacker agent skills
5. Configure TOR if you selected TOR mode
6. Create the `adhicode` launcher command

### 2. Launch

```bash
adhicode
```

This starts the AI with the hacker banner and agent list.

### 3. Test Each Agent

Inside the AI session, try:

```
# ── CYBER-OMNI pentest agent ──
@cuber scan 192.168.1.1
@cuber osint example.com

# ── GOD-CYBER stealth operations ──
@godcyber pwn example.com
@godcyber darkweb "ransomware gang forum"

# ── GOD-CYBER++ transcendent ops ──
@godcyber++ c2 4444
@godcyber++ botnet

# ── Total anonymity protocol ──
@ghost hide 10.0.0.5
@ghost status
```

### 4. Verify Installation

```bash
# Check all skills are installed
ls ~/ADHICODE/.claude/skills/

# Check config
cat ~/ADHICODE/.opencode/opencode.json

# Check API key
cat ~/ADHICODE/.env

# Check wrapper
which adhicode
file $(which adhicode)
```

### 5. TOR Mode Test

If you selected TOR mode during install:

```bash
# Start TOR
tor --SOCKSPort 127.0.0.1:9050 &

# Verify TOR is working
curl --socks5 127.0.0.1:9050 https://check.torproject.org/api/ip
```

### 6. Re-run (for testing script changes)

The install script is **idempotent** — it skips steps already done. Run it again to update:

```bash
curl -sSL https://raw.githubusercontent.com/AdhiHub/ADHICODE-Termux/main/install.sh | bash
```

## What's Installed

| Component | Path |
|-----------|------|
| AI Engine | `~/.opencode/bin/opencode` or `$PREFIX/bin/opencode` |
| Launcher | `$PREFIX/bin/adhicode` |
| Skills | `~/ADHICODE/.claude/skills/{cuber,godcyber,godcyber-plusplus,ghost}/*` |
| Config | `~/ADHICODE/.opencode/opencode.json` |
| API Key | `~/ADHICODE/.env` |
| Agents List | `~/ADHICODE/AGENTS.md` |

## Hacker Agents

| Agent | Command | Purpose |
|-------|---------|---------|
| `@cuber` | `pwn`, `hunt`, `osint`, `scan` | CYBER-OMNI pentest & recon |
| `@godcyber` | `pwn`, `darkweb`, `stealth`, `cleanup` | GOD-CYBER stealth ops |
| `@godcyber++` | `c2`, `offline`, `botnet`, `unleash` | GOD-CYBER++ transcendent ops |
| `@ghost` | `hide`, `trace`, `leak`, `scrape`, `dark`, `wipe` | Total anonymity protocol |

## Requirements

- Termux from **F-Droid** (not Google Play)
- **Anthropic API key** (get one at https://console.anthropic.com)
- Internet for first-time install
- ~200MB free space

## Troubleshooting

**"adhicode: command not found"**
```bash
ls $PREFIX/bin/adhicode
# If missing, re-run the install script
```

**"Engine not found"**
```bash
find /data/data/com.termux -name "opencode" -type f
# If found, manually point to it:
export PATH="$HOME/.opencode/bin:$PATH"
```

**Install script hangs**
- Press Ctrl+C, then run `pkg update && pkg install curl tar git` first
- Then run the one-liner again

## Cleanup

```bash
rm -rf ~/ADHICODE ~/.opencode ~/.claude/skills
rm $PREFIX/bin/adhicode
```
