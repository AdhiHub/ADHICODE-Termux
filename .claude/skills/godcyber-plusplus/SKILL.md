# @godcyber++ — GOD-CYBER++ FINAL EVOLUTION

> Transcendent security operations platform. All tool execution via CYBER-CLI.exe.

## How to use

```
@godcyber++ <command>
```

## Command Reference

### Advanced Operations
- `c2 <port>` — Start C2 callback listener on specified port
- `exfil <file> <host:port>` — Exfiltrate file over TCP connection
- `botnet <subnet/24>` — Scan subnet for pwnable services
- `offline` — Toggle offline mode (block AI API calls)
- `darkweb [query]` — Check Tor connectivity and dark web status
- `stealth` — Full anonymity audit
- `cleanup` — Zero trace system wipe
- `pwn <target>` — Full attack surface mapping + vulnerability suggestions

### Recon (inherits all lower tiers)
- `hunt <host>` — Deep service recon
- `osint <target>` — Full intelligence (DNS, subdomains, HTTP)
- `scan <host> [ports]` — TCP port scan
- `dns <domain> [type]` — DNS record query
- `subenum <domain>` — Subdomain enumeration (wordlist from $HOME/ADHICODE/wordlists/subdomains.txt)
- `http <url>` — HTTP banner grab
- `fuzz <url>` — HTTP directory/file fuzzer
- `ssl_check <host>` — SSL certificate inspection
- `ping <host> [count]` — ICMP ping
- `resolve <host>` — DNS resolution
- `whois <target>` — WHOIS lookup

### Utility
- `hash <data> [algo]` — Hash generation (md5, sha1, sha256, sha512, sha3, blake2)
- `encode <data> [method]` — Encode (base64, hex, base32, base16)

## Tool Execution

Use bash to invoke:
```
$HOME/ADHICODE/engine/omni.py <tool> <args>
```

## Capabilities

- TCP port scanning with configurable range
- Service identification against 25+ common ports
- OS fingerprinting via ping TTL analysis
- DNS reconnaissance (A, AAAA, MX, NS, TXT, SOA, CNAME via raw DNS queries)
- Subdomain brute force (75+ common subdomains)
- HTTP/S banner grabbing with SSL support
- SSL certificate inspection
- C2 TCP listener for callbacks
- File exfiltration over TCP
- Subnet scanning for exploitable services
- Tor/proxy connectivity detection
- System trace cleanup (temp, prefetch, recent)
- Offline mode toggle
- Hash generation (8+ algorithms)
- Data encoding (4 methods)
- Vulnerability suggestion engine based on detected services
