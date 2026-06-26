# Contributing to Network Recon Tool

Thank you for your interest in contributing! This document outlines the process for contributing code, documentation, and bug reports.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Making Changes](#making-changes)
- [Coding Standards](#coding-standards)
- [Testing](#testing)
- [Submitting Changes](#submitting-changes)
- [Reporting Bugs](#reporting-bugs)
- [Feature Requests](#feature-requests)

---

## Code of Conduct

All contributors must adhere to our [Code of Conduct](CODE_OF_CONDUCT.md). Please read it before participating.

---

## Getting Started

1. Fork the repository on GitHub.
2. Clone your fork locally:

```bash
git clone https://github.com/<your-username>/network-recon-tool.git
cd network-recon-tool
```

3. Set the upstream remote:

```bash
git remote add upstream https://github.com/example/network-recon-tool.git
```

---

## Development Setup

```bash
# Create and activate a virtual environment
python -m venv .venv
source .venv/bin/activate          # Linux/macOS
.\.venv\Scripts\Activate.ps1       # Windows PowerShell

# Install runtime + development dependencies
pip install -e ".[dev]"
```

---

## Making Changes

1. Create a feature branch from `main`:

```bash
git checkout -b feature/short-description
```

2. Make your changes, following the [Coding Standards](#coding-standards) below.
3. Run the test suite to confirm nothing is broken:

```bash
python -m pytest
```

4. Commit with a clear, conventional message:

```
feat: add IPv6 host discovery support
fix: correct CSV export when hostname is None
docs: update installation instructions for macOS 14
test: add edge-case tests for parse_port_range
```

---

## Coding Standards

- **PEP 8** — enforced via `ruff` (run `ruff check .`)
- **Google-style docstrings** — every public class, method, and function
- **Type hints** — required for all function signatures
- **Single responsibility** — one module, one concern
- **No third-party dependencies** beyond `rich` (optional) for core functionality

---

## Testing

All changes must be covered by tests:

```bash
# Run all tests
python -m pytest

# With coverage report
python -m pytest --cov=recon --cov-report=term-missing

# Run a specific test file
python -m pytest tests/test_utils.py -v
```

Coverage must remain ≥ 80% for any PR to be accepted.

---

## Submitting Changes

1. Push your branch to your fork:

```bash
git push origin feature/short-description
```

2. Open a Pull Request against the `main` branch.
3. Fill in the PR template completely.
4. Address review feedback — we aim to review PRs within 3 business days.

---

## Reporting Bugs

Open an issue using the **Bug Report** template and include:

- OS and Python version
- Steps to reproduce
- Expected vs actual behaviour
- Full error output (use code blocks)

---

## Feature Requests

Open an issue using the **Feature Request** template. If it touches network scanning behaviour, explain the use case and why it cannot be accomplished with existing commands.

**Security-sensitive features** — please review [SECURITY.md](SECURITY.md) first. We will not accept exploit modules, evasion techniques, or capabilities that primarily serve unauthorized access.

---

Thank you for contributing! 🛡️
