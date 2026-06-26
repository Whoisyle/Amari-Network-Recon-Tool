#!/usr/bin/env python3
"""
Network Recon Tool — entry point.

Usage:
    python main.py discover 192.168.1.0/24
    python main.py dns example.com
    python main.py reverse 8.8.8.8
    python main.py host example.com
    python main.py ports 192.168.1.1 --ports 22,80,443

Run ``python main.py --help`` for full usage information.
"""

import logging
import sys

from recon.arguments import parse_args
from recon.output import (
    export_csv,
    export_json,
    export_xml,
    print_discovery_table,
    print_dns_result,
    print_host_result,
    print_port_table,
    print_reverse_result,
)
from recon.ports import parse_port_range
from recon.scanner import ReconEngine, ScanConfig
from recon.utils import setup_logging

logger = logging.getLogger(__name__)


def _resolve_path(value: str | None) -> str | None:
    """Return ``None`` when *value* is ``'-'`` (stdout sentinel)."""
    if value is None:
        return None
    return None if value == "-" else value


def _apply_exports(result, args) -> None:
    """Write all requested export formats.

    Args:
        result: The result object to export.
        args:   Parsed argument namespace containing ``json``, ``csv``, ``xml``
                attributes.
    """
    if args.json:
        export_json(result, _resolve_path(args.json))
    if hasattr(args, "csv") and args.csv:
        export_csv(result, _resolve_path(args.csv))
    if args.xml:
        export_xml(result, _resolve_path(args.xml))


def cmd_discover(args) -> int:
    """Execute the ``discover`` sub-command.

    Args:
        args: Parsed CLI namespace.

    Returns:
        Exit code (0 for success, 1 for error).
    """
    config = ScanConfig(
        timeout=args.timeout,
        max_workers=args.workers,
        resolve_hostnames=not args.no_resolve,
        scan_ports=args.ports,
    )
    engine = ReconEngine(config=config)

    try:
        from rich.progress import Progress, SpinnerColumn, TextColumn, BarColumn, TaskProgressColumn

        with Progress(
            SpinnerColumn(),
            TextColumn("[progress.description]{task.description}"),
            BarColumn(),
            TaskProgressColumn(),
            transient=True,
        ) as progress:
            task = progress.add_task(f"Scanning {args.network}…", total=None)

            def _cb(scanned: int, total: int) -> None:
                progress.update(task, completed=scanned, total=total)

            report = engine.discover_subnet(args.network, progress_callback=_cb)

    except ImportError:
        print(f"Scanning {args.network}…", file=sys.stderr)
        report = engine.discover_subnet(args.network)

    print_discovery_table(report)
    _apply_exports(report, args)
    return 0


def cmd_dns(args) -> int:
    """Execute the ``dns`` sub-command."""
    engine = ReconEngine(config=ScanConfig(timeout=args.timeout))
    result = engine.resolve_dns(args.hostname)
    print_dns_result(result)
    _apply_exports(result, args)
    return 0 if result.success else 1


def cmd_reverse(args) -> int:
    """Execute the ``reverse`` sub-command."""
    engine = ReconEngine(config=ScanConfig(timeout=args.timeout))
    result = engine.reverse_dns(args.ip_address)
    print_reverse_result(result)
    _apply_exports(result, args)
    return 0 if result.success else 1


def cmd_host(args) -> int:
    """Execute the ``host`` sub-command."""
    engine = ReconEngine(config=ScanConfig(timeout=args.timeout))
    result = engine.lookup_host(args.target)
    print_host_result(result)
    _apply_exports(result, args)
    return 0 if result.success else 1


def cmd_ports(args) -> int:
    """Execute the ``ports`` sub-command."""
    ports = None
    if args.ports:
        try:
            ports = parse_port_range(args.ports)
        except ValueError as exc:
            print(f"[error] Invalid port specification: {exc}", file=sys.stderr)
            return 1

    engine = ReconEngine(config=ScanConfig(timeout=args.timeout, max_workers=args.workers))
    report = engine.scan_ports(args.host, ports=ports)
    print_port_table(report)
    _apply_exports(report, args)
    return 0


_COMMANDS = {
    "discover": cmd_discover,
    "dns": cmd_dns,
    "reverse": cmd_reverse,
    "host": cmd_host,
    "ports": cmd_ports,
}


def main(argv: list[str] | None = None) -> int:
    """Main entry point for the Network Recon Tool.

    Args:
        argv: Optional argument list override (defaults to ``sys.argv[1:]``).

    Returns:
        Integer exit code.
    """
    args = parse_args(argv)

    log_level = getattr(logging, args.log_level, logging.WARNING)
    setup_logging(level=log_level, log_file=args.log_file)
    logger.debug("Args: %s", args)

    handler = _COMMANDS.get(args.subcommand)
    if handler is None:
        print(f"Unknown command: {args.subcommand}", file=sys.stderr)
        return 1

    try:
        return handler(args)
    except KeyboardInterrupt:
        print("\n[interrupted]", file=sys.stderr)
        return 130
    except Exception as exc:  # noqa: BLE001
        logger.exception("Unhandled error in command '%s'", args.subcommand)
        print(f"\n[error] {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
