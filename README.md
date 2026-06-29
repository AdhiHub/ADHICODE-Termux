# ADHICODE-Termux

**Portable Hacker AI for Android Termux** — one-line install, fully offline, zero refusal.

## One-Line Install

```bash
curl -sSL https://raw.githubusercontent.com/AdhiHub/ADHICODE-Termux/main/install.sh | bash
```

## What it does

| Step | Description |
|------|-------------|
| 1 | Updates Termux packages |
| 2 | Installs Python, TOR, nmap, git, curl |
| 3 | Clones ADHICODE-Termux config |
| 4 | Clones CYBER-OMNI-V2 AI engine |
| 5 | Installs 4 agent skills |
| 6 | Installs Python packages |
| 7 | Configures TOR for anonymity |

## After Install

```bash
cd ~/ADHICODE/engine && python omni.py
```

Then in any session, use the agents:

```
@cuber scan 192.168.1.1
@godcyber pwn example.com
@godcyber++ c2 4444
@ghost hide 10.0.0.5
```

## Agents

| Agent | Description |
|-------|-------------|
| `@cuber` | CYBER-OMNI pentest & recon agent |
| `@godcyber` | GOD-CYBER stealth operations |
| `@godcyber++` | GOD-CYBER++ transcendent ops |
| `@ghost` | Total anonymity protocol (TOR forced) |

## Requirements

- Termux from F-Droid (not Google Play)
- 2GB+ free storage
- ~700MB for AI model (one-time download)

## Cleanup

```bash
rm -rf ~/ADHICODE ~/.claude/skills
```

---

**Powered by AdhiHub** — adhithyajeyanraj@gmail.com
