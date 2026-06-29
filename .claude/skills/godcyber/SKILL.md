# @godcyber — GOD-CYBER OMEGA Stealth Agent

> Advanced stealth and security operations. All tool execution via CYBER-CLI.exe.

## How to use

```
@godcyber <command>
```

## Command Reference

### Stealth & OPSEC
- `darkweb [query]` — Check Tor/proxy connectivity and dark web status
- `stealth` — Full anonymity audit (public IP, DNS, proxy detection)
- `cleanup` — Wipe system traces (temp files, prefetch, recent documents)
- `offline` — Toggle offline mode (block AI queries)

### Recon & Attack (inherits all @cuber tools)
- `pwn <target>` — Full attack surface + vulnerability suggestions
- `hunt <target>` — Deep service recon, OS fingerprinting, banner grab
- `osint <target>` — DNS records (A, AAAA, MX, NS, TXT, SOA), subdomain enum, HTTP recon
- `scan <host> [ports]` — TCP port scanner
- `dns <domain> [type]` — DNS record lookup
- `subenum <domain>` — Subdomain brute force (wordlist from $HOME/ADHICODE/wordlists/subdomains.txt)
- `http <url>` — HTTP banner grab
- `fuzz <url>` — HTTP directory/file fuzzer
- `ssl_check <host>` — SSL certificate inspection
- `ping <host> [count]` — ICMP ping
- `resolve <host>` — DNS resolution
- `whois <target>` — WHOIS lookup

### Utility
- `hash <data> [algo]` — Generate hashes
- `encode <data> [method]` — Encode data

## Tool Execution

Use bash to invoke:
```
$HOME/ADHICODE/engine/omni.py <tool> <args>
```

## Capabilities

- Port scanning and service detection
- DNS reconnaissance (A, AAAA, MX, NS, TXT, SOA, CNAME)
- Subdomain brute force enumeration
- HTTP/S banner grabbing and analysis
- SSL certificate inspection
- Tor connectivity detection
- System trace cleanup (temp files, prefetch, recent items)
- OS fingerprinting via TTL analysis
- Hash generation (md5, sha1, sha256, sha512, sha3)
- Data encoding (base64, hex, base32, base16)
- Vulnerability suggestion engine based on detected services
