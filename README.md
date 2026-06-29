# ADHICODE-Termux

**Portable Hacker AI for Android Termux** — one-line install, same AI engine as `ADHICODE-cyper.exe`.

## One-Line Install

```bash
curl -sSL https://raw.githubusercontent.com/AdhiHub/ADHICODE-Termux/main/install.sh | bash
```

## What it does

Installs the **real OpenCode AI CLI** (the same AI you use on Windows via `ADHICODE-cyber.exe`) on Termux, then configures it with:

| Feature | Description |
|---------|-------------|
| OpenCode CLI | The actual AI coding agent (installed via npm) |
| @cuber | CYBER-OMNI pentest & recon agent |
| @godcyber | GOD-CYBER stealth operations |
| @godcyber++ | GOD-CYBER++ transcendent ops |
| @ghost | Total anonymity protocol (TOR forced) |
| Zero refusal | All permissions pre-allowed in config |
| TOR | Anonymous routing for dark web ops |

## After Install

```bash
adhicode
```

Then use the agents in any session:

```
@cuber scan 192.168.1.1
@godcyber pwn example.com
@godcyber++ c2 4444
@ghost hide 10.0.0.5
```

## Requirements

- Termux from F-Droid (not Google Play)
- Node.js installed automatically
- Internet for first OpenCode AI setup
- Anthropic API key (set via `export ANTHROPIC_API_KEY='your-key'`)

## Cleanup

```bash
rm -rf ~/ADHICODE ~/.claude/skills; npm uninstall -g opencode-ai
```
