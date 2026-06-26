# Security Policy

## Supported Versions

| Version | Supported          |
|---------|--------------------|
| 1.0.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Ethical Use

Network Recon Tool is designed **exclusively** for:

- Scanning networks you own or administer
- Authorized penetration testing engagements (written permission required)
- Educational purposes in controlled lab environments
- Network inventory and asset discovery within your own organisation

**Do not** use this tool against networks, systems, or devices you do not have explicit written permission to test. Unauthorized network scanning may violate local, national, and international laws including the Computer Fraud and Abuse Act (CFAA), the Computer Misuse Act (CMA), and equivalent legislation in your jurisdiction.

## Reporting a Vulnerability

If you discover a security vulnerability in this project, please report it responsibly:

1. **Do not** open a public GitHub issue for security vulnerabilities.
2. Email the maintainers at: `security@example.com` (replace with real address)
3. Include:
   - A description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if you have one)

We will acknowledge your report within **48 hours** and aim to release a patch within **14 days** for critical issues.

## Scope

In-scope security reports:
- Dependency vulnerabilities that could affect users
- Input validation bypasses
- Path traversal in file export functions
- Denial-of-service vectors in the scanning engine

Out-of-scope:
- Social engineering
- Physical security issues
- Issues in optional third-party dependencies not exploitable in normal usage

Thank you for helping keep Network Recon Tool safe and ethical.
