# Network Recon Tool

> A professional, cross-platform network reconnaissance tool for authorized network discovery, asset inventory, and educational purposes.

[![Python 3.12+](https://img.shields.io/badge/python-3.12%2B-blue.svg)](https://python.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20Windows-lightgrey.svg)]()
[![Tests](https://img.shields.io/badge/tests-70%2B-brightgreen.svg)]()

---

## ⚠️ Ethical Use Disclaimer

**This tool is designed exclusively for:**
- Networks you own or administer
- Authorized penetration testing (written permission required)
- Educational use in controlled lab environments
- Network inventory within your own organisation

Unauthorized network scanning may violate laws including the CFAA, CMA, and equivalent legislation in your jurisdiction. Always obtain explicit written permission before scanning any network you do not own.

---

## Features

| Feature | Description |
|---------|-------------|
| 🔍 **Subnet Discovery** | Discover live hosts on any IPv4 CIDR block |
| 🌐 **DNS Resolution** | Forward and reverse DNS lookups |
| 🔌 **Port Scanning** | Multi-threaded TCP port scanner (21 common ports + custom ranges) |
| 🖥️ **Hostname Lookup** | Resolve hostnames to IPs and vice versa |
| 📊 **Rich Console** | Colour-coded tables with progress indicators |
| 📁 **JSON Export** | Structured JSON output for all commands |
| 📄 **CSV Export** | Spreadsheet-ready CSV for discovery and port scans |
| 🗂️ **XML Export** | XML output for pipeline integration |
| ⚡ **Multi-threaded** | Configurable thread pool for fast scanning |
| 🔒 **No Root Required** | TCP-based discovery works without elevated privileges |
| 🌍 **Cross-Platform** | Kali Linux, Ubuntu, Debian, macOS, Windows 10/11 |
| 📋 **Logging** | Configurable verbosity + optional log file |

---

## Screenshots

> _Screenshots go in the `screenshots/` directory. See the docs for CLI output examples._

---

## Quick Start

### Linux / macOS

```bash
git clone https://github.com/example/network-recon-tool.git
cd network-recon-tool
bash install.sh
source .venv/bin/activate
python main.py discover 192.168.1.0/24
```

### Windows PowerShell

```powershell
git clone https://github.com/example/network-recon-tool.git
cd network-recon-tool
.\install.ps1
.\.venv\Scripts\Activate.ps1
python main.py discover 192.168.1.0/24
```

---

## Installation

### Standard

```bash
git clone https://github.com/example/network-recon-tool.git
cd network-recon-tool
python -m venv .venv

# Linux/macOS
source .venv/bin/activate

# Windows PowerShell
.\.venv\Scripts\Activate.ps1

# Windows CMD
.venv\Scripts\activate.bat

pip install -r requirements.txt
```

### Editable (development)

```bash
pip install -e ".[dev]"
```

### Package

```bash
pip install .
```

See [docs/installation.md](docs/installation.md) for platform-specific notes.

---

## Usage

```
python main.py <command> [options]
```

### Commands

| Command | Description |
|---------|-------------|
| `discover` | Discover live hosts on an IPv4 subnet |
| `dns` | Forward DNS lookup |
| `reverse` | Reverse DNS (PTR) lookup |
| `host` | Full host information lookup |
| `ports` | TCP port scan |

### Common Options

```
--timeout SECS     Per-probe timeout in seconds (default: 1.0)
--workers N        Concurrent probe threads (default: 100)
--log-level LEVEL  DEBUG / INFO / WARNING / ERROR (default: WARNING)
--log-file FILE    Write logs to file
--json FILE        Export to JSON
--csv FILE         Export to CSV
--xml FILE         Export to XML
```

---

## CLI Examples

### Discover live hosts on a subnet

```bash
python main.py discover 192.168.1.0/24
python main.py discover 10.0.0.0/24 --workers 200 --timeout 0.5
python main.py discover 192.168.1.0/24 --json results.json
python main.py discover 192.168.1.0/24 --csv results.csv
python main.py discover 192.168.1.0/24 --xml results.xml
python main.py discover 192.168.1.0/24 --ports --no-resolve
```

### DNS lookups

```bash
python main.py dns example.com
python main.py dns google.com --json dns.json
```

### Reverse DNS

```bash
python main.py reverse 8.8.8.8
python main.py reverse 1.1.1.1 --json reverse.json
```

### Host information

```bash
python main.py host example.com
python main.py host 192.168.1.1
```

### Port scanning

```bash
python main.py ports 192.168.1.1
python main.py ports 192.168.1.1 --ports 22,80,443
python main.py ports 192.168.1.1 --ports 1-1024 --workers 100
python main.py ports 192.168.1.1 --json ports.json --csv ports.csv
```

### Help

```bash
python main.py --help
python main.py discover --help
python main.py ports --help
```

---

## Example Output

### Subnet Discovery

```
╭───────────────────────────────────────────────────────────────────────╮
│              Network Discovery: 192.168.1.0/24                       │
├──────────────────┬────────────────────────────────┬────────────┬──────┤
│ IP Address       │ Hostname                       │ RTT (ms)   │ …   │
├──────────────────┼────────────────────────────────┼────────────┼──────┤
│ 192.168.1.1      │ router.local                   │ 1.2        │ …   │
│ 192.168.1.10     │ laptop.local                   │ 3.5        │ …   │
│ 192.168.1.100    │ –                              │ 0.8        │ …   │
╰──────────────────┴────────────────────────────────┴────────────┴──────╯
Summary: 3 host(s) live / 254 scanned in 4.23s
```

### JSON output

```json
{
  "network": "192.168.1.0/24",
  "live_hosts": [
    {
      "ip_address": "192.168.1.1",
      "hostname": "router.local",
      "response_time_ms": 1.2,
      "open_ports": [80, 443],
      "is_alive": true
    }
  ],
  "total_scanned": 254,
  "live_count": 3,
  "duration_seconds": 4.23
}
```

---

## Project Structure

```
network-recon-tool/
├── recon/
│   ├── __init__.py       # Version and public API
│   ├── scanner.py        # ReconEngine — high-level facade
│   ├── discovery.py      # Subnet host discovery
│   ├── dns.py            # DNS resolution
│   ├── hostname.py       # Hostname/IP lookups
│   ├── ports.py          # TCP port scanner
│   ├── output.py         # Console, JSON, CSV, XML output
│   ├── arguments.py      # CLI argument parser
│   ├── utils.py          # Shared utilities
│   └── exceptions.py     # Custom exception hierarchy
├── tests/
│   ├── test_utils.py
│   ├── test_exceptions.py
│   ├── test_dns.py
│   ├── test_ports.py
│   ├── test_output.py
│   └── test_arguments.py
├── docs/
│   ├── architecture.md
│   ├── installation.md
│   ├── usage.md
│   └── development.md
├── examples/
│   ├── discover_subnet.py
│   ├── port_scan.py
│   └── dns_lookup.py
├── screenshots/           # Placeholder for tool screenshots
├── install.sh             # Linux/macOS installer
├── install.ps1            # Windows PowerShell installer
├── main.py                # CLI entry point
├── pyproject.toml
├── requirements.txt
├── README.md
├── CHANGELOG.md
├── CONTRIBUTING.md
├── SECURITY.md
├── CODE_OF_CONDUCT.md
└── LICENSE
```

---

## Architecture

```
CLI (main.py)
     │
Argument Parser (recon/arguments.py)
     │
ReconEngine (recon/scanner.py)
     │
     ├── SubnetDiscovery (recon/discovery.py)
     ├── DNSResolver (recon/dns.py)
     ├── hostname lookups (recon/hostname.py)
     └── PortScanner (recon/ports.py)
              │
         is_port_open (recon/utils.py)
              │
Output Layer (recon/output.py)
     │
     ├── Console (rich table / plain text)
     ├── JSON
     ├── CSV
     └── XML
```

See [docs/architecture.md](docs/architecture.md) for full details.

---

## Testing

```bash
# Run all tests
python -m pytest

# Verbose output
python -m pytest -v

# With coverage report
python -m pytest --cov=recon --cov-report=term-missing

# Single module
python -m pytest tests/test_utils.py -v
```

The test suite includes 70+ test cases covering:
- IP and CIDR validation
- DNS resolution (mocked)
- Port scanning logic
- Output formatting (JSON, CSV, XML)
- CLI argument parsing
- Custom exception types

---

## Roadmap

Future enhancements planned for v2.0:

- [ ] IPv6 subnet discovery
- [ ] AsyncIO-based scanning engine
- [ ] SNMP community discovery
- [ ] mDNS/Bonjour device discovery
- [ ] Network topology graph export
- [ ] Docker image
- [ ] GitHub Actions CI/CD
- [ ] PyPI package
- [ ] Plugin system
- [ ] Web dashboard (optional)

---

## FAQ

**Q: Does this need root/administrator privileges?**
A: No. TCP-based discovery works without elevated privileges on all supported platforms.

**Q: How fast is the subnet scanner?**
A: A /24 (254 hosts) typically completes in 3–8 seconds with default settings. Use `--workers 200 --timeout 0.5` for faster scanning on reliable networks.

**Q: Can I use this on Windows?**
A: Yes. The tool runs on Windows 10/11 via Terminal, PowerShell, or CMD without modification.

**Q: Why TCP probing instead of ICMP ping?**
A: ICMP requires raw socket access (root/admin). TCP probing works unprivileged and is more reliable through firewalls that block ICMP.

**Q: Can I import the library in my own scripts?**
A: Yes. See the `examples/` directory for programmatic usage patterns.

---

## Troubleshooting

**No hosts found on my subnet**
- Check that your CIDR is correct: `python main.py discover 192.168.1.0/24` (not `192.168.1.0/255.255.255.0`)
- Hosts may only respond on non-standard ports. Try `--timeout 2.0`
- Firewalls may block all TCP probes from your machine

**DNS resolution slow or failing**
- Increase timeout: `--timeout 3.0`
- Check system DNS configuration

**PermissionError on Windows**
- Run from a standard user account (no admin needed)
- Ensure antivirus is not blocking Python socket operations

**`rich` module not found**
- Install it: `pip install rich`
- Or ignore — the tool falls back to plain-text output automatically

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for development setup, coding standards, and the PR process.

---

## License

This project is licensed under the [MIT License](LICENSE).

---

## Security

Please review [SECURITY.md](SECURITY.md) before reporting vulnerabilities or requesting security-sensitive features.
