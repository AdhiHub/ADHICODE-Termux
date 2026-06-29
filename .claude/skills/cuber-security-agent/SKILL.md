# @cuber — CYBER-OMNI Security Agent

## How to use

```
@cuber <command>
```

## Command Reference

### Recon Tools
- `scan <host> [ports]` — TCP port scanner (default: 1-1000)
- `hunt <host>` — Full service recon + OS detection
- `osint <target>` — DNS recon + subdomain enumeration + HTTP headers
- `pwn <target>` — Attack surface mapping + vulnerability suggestions
- `dns <domain> [type]` — DNS records (A, AAAA, MX, NS, TXT, SOA, CNAME)
- `subenum <domain>` — Subdomain brute force
- `whois <target>` — WHOIS/RDAP lookup
- `http <url>` — HTTP/S banner grab and header inspection
- `fuzz <url>` — HTTP directory/file fuzzer
- `ssl_check <host>` — SSL certificate inspection
- `ping <host> [count]` — ICMP ping with average latency

### Utility Tools
- `hash <data> [algo]` — Hash (md5, sha1, sha256, sha512, sha3, blake2)
- `encode <data> [method]` — Encode (base64, hex, base32, base16)
- `resolve <host>` — DNS resolution

## Tool Execution

Use bash directly with available tools (nmap, curl, dig, openssl, etc).

## Capabilities
- Port scanning (TCP connect via nmap or bash)
- DNS reconnaissance
- Service identification
- OS fingerprinting
- Subdomain enumeration
- HTTP/S banner grabbing
- SSL certificate analysis
- Hash generation and encoding
- Vulnerability suggestions based on detected services
