# @cuber — CYBER-OMNI Security Agent

> Real pentest/security agent. Delegates all tool execution to CYBER-CLI.exe.

## How to use

```
@cuber <command>
```

## Command Reference

Run any command by asking me directly.

### Recon Tools
- `scan <host> [ports]` — TCP port scanner (default: 1-1000)
- `hunt <host>` — Full service recon + OS detection
- `osint <target>` — DNS recon + subdomain enumeration + HTTP headers
- `pwn <target>` — Attack surface mapping + vulnerability suggestions
- `dns <domain> [type]` — DNS records (A, AAAA, MX, NS, TXT, SOA, CNAME)
- `subenum <domain>` — Subdomain brute force (uses $HOME/ADHICODE/wordlists/subdomains.txt if available)
- `whois <target>` — WHOIS/RDAP lookup via public RDAP servers
- `http <url>` — HTTP/S banner grab and header inspection
- `fuzz <url>` — HTTP directory/file fuzzer (uses $HOME/ADHICODE/wordlists/directories.txt)
- `ssl_check <host>` — SSL certificate inspection
- `ping <host> [count]` — ICMP ping with average latency

### Utility Tools
- `hash <data> [algo]` — Hash (md5, sha1, sha256, sha512, sha3, blake2)
- `encode <data> [method]` — Encode (base64, hex, base32, base16)
- `resolve <host>` — DNS resolution

## Tool Execution

Use bash to invoke:
```
$HOME/ADHICODE/engine/omni.py <tool> <args>
# Or: python $HOME/ADHICODE/engine/omni.py <tool> <args>
```

The output will be returned directly.

## Wordlist Integration

Wordlists in `$HOME/ADHICODE/wordlists/` are auto-detected:
- `subdomains.txt` -> `subenum`, `osint` (DNS brute force)
- `directories.txt` -> `fuzz` (HTTP fuzzer)
- Add your own entries (one per line, `#` for comments)

## Capabilities

- Port scanning (TCP connect)
- DNS reconnaissance
- Service identification
- OS fingerprinting (via TTL)
- Subdomain enumeration
- HTTP/S banner grabbing
- SSL certificate analysis
- Hash generation and encoding
- Vulnerability suggestions based on detected services
