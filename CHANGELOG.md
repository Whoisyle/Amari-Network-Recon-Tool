# Changelog

All notable changes to Network Recon Tool are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.0] — 2024-12-01

### Added

- **`discover` command** — live host discovery on IPv4 subnets using concurrent TCP probing (no root required)
- **`dns` command** — forward DNS lookup with CNAME resolution
- **`reverse` command** — reverse PTR record lookup
- **`host` command** — combined hostname/IP resolution
- **`ports` command** — multi-threaded TCP port scanner with 21 common port definitions
- **JSON export** (`--json`) for all commands
- **CSV export** (`--csv`) for `discover` and `ports` commands
- **XML export** (`--xml`) for all commands
- **Rich console tables** — colour-coded output using the `rich` library (optional; falls back to plain text)
- **Progress indicator** — animated progress bar during subnet discovery
- **Configurable timeout** (`--timeout`) and **worker count** (`--workers`) for all commands
- **Logging** with configurable verbosity (`--log-level`) and optional file output (`--log-file`)
- **Cross-platform support** — Kali Linux, Ubuntu, Debian, macOS, Windows 10/11 (Terminal, PowerShell, CMD)
- `install.sh` — automated installer for Linux and macOS
- `install.ps1` — automated installer for Windows PowerShell
- Comprehensive unit test suite (6 modules, 70+ test cases)
- Full documentation: `README.md`, `docs/architecture.md`, `docs/usage.md`, `docs/installation.md`, `docs/development.md`
- `pyproject.toml` with editable install support (`pip install -e .`)

### Architecture

- `recon/exceptions.py` — typed exception hierarchy (`ReconError` base)
- `recon/utils.py` — IP validation, CIDR parsing, TCP probing utilities
- `recon/dns.py` — `DNSResolver` with forward and reverse lookup
- `recon/hostname.py` — hostname / IP resolution wrappers
- `recon/ports.py` — `PortScanner` with service name mapping
- `recon/discovery.py` — `SubnetDiscovery` with concurrent TCP probing
- `recon/scanner.py` — `ReconEngine` high-level facade
- `recon/output.py` — console, JSON, CSV, XML formatters
- `recon/arguments.py` — `argparse`-based CLI parser
- `main.py` — CLI entry point

---

## [Unreleased]

### Planned

- IPv6 subnet discovery support
- AsyncIO-based discovery engine for improved throughput
- SNMP community string probing (v1/v2c)
- mDNS/Bonjour device discovery
- LLDP neighbour enumeration
- Network topology graph export (Graphviz DOT format)
- Docker image on Docker Hub
- GitHub Actions CI/CD pipeline
- PyPI package publication
- Plugin system for custom discovery modules
- Optional web dashboard (Flask/FastAPI)

---

[1.0.0]: https://github.com/example/network-recon-tool/releases/tag/v1.0.0
[Unreleased]: https://github.com/example/network-recon-tool/compare/v1.0.0...HEAD
