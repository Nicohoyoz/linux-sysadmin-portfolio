# Linux Systems Administration — Automation & Monitoring Portfolio

**Nicolas Hoyos**
Ubuntu 20.04 · three-VM networked lab · Bash and Python automation

A set of five hands-on Linux administration projects, each built and validated on a live multi-VM lab. Every project solves a task a junior Linux administrator handles in a real production environment, and each one ships with commented code, run instructions, and screenshots taken on the running systems as proof.

## Lab environment

The work runs across three Ubuntu 20.04 virtual machines on an internal network, reached over SSH through a gateway:

- **VM1** — internal services (Apache, mail relay, DNS)
- **VM2** — router, intrusion detection, and firewall host
- **VM3** — mail server (Postfix and Dovecot), NFS, and the encrypted storage work

All addresses shown in screenshots are private internal lab addresses.

## Projects

| # | Project | Focus | Key tools |
|---|---------|-------|-----------|
| 1 | [SSH Log Parser](01-ssh-log-parser/README.md) | Detect brute-force login attempts | bash, grep, regex, sort/uniq |
| 2 | [Resource Monitor](02-resource-monitor/README.md) | Log CPU, memory, and disk on a schedule | bash, cron, systemd timers |
| 3 | [Backup Automation](03-backup-automation/README.md) | Timestamped backups with retention | bash, tar, retention logic |
| 4 | [iptables Firewall](04-iptables-firewall/README.md) | Default-deny firewall, persisted across reboots | iptables, netfilter-persistent |
| 5 | [LUKS Disk Encryption](05-luks-encryption/README.md) | Encrypt data at rest, keyfile automount | cryptsetup, LUKS2, crypttab and fstab |

## Why these projects

Each task maps directly to something a financial services or trading environment depends on. Spotting attacks against login services, keeping always-on systems healthy, protecting data with backups and retention, shrinking the attack surface with a firewall, and encrypting sensitive data so that a stolen drive is useless. The point of this repository is not just that the scripts exist, but that each one was run on real systems and the results were captured.

## A note on security

No keyfiles, passphrases, or private keys are committed to this repository. The `.gitignore` blocks them by pattern, and the generated lab disk image is excluded as well. LUKS UUIDs appear in a couple of screenshots and config examples; a UUID is an identifier, not a secret, so it is left visible on purpose.
