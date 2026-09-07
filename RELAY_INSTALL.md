# NovaRelay Self-Hosting Guide

Official deployment guide for **NovaRelay**, the self-hosted relay used by NovaChat.

NovaRelay is a raw TCP service, not a web server. NovaChat clients connect to it with an address such as `chat.example.com:7777` — **do not** add `http://` or `https://`.

The public one-command installer does **not** hard-code a `dist` tag. It reads `bootstrap-release.txt`, downloads the NovaRelay package referenced there from GitHub Releases, and verifies its SHA-256 checksum before installation. After a new `v...-dist.N` release is published, repository automation advances the pointer to that release.

## Supported platform

The public NovaRelay package currently targets:

- Debian / Ubuntu and compatible Linux distributions
- x86_64 / amd64
- systemd
- A host that can accept inbound TCP connections

For the simplest deployment, use a small VPS with a public IPv4 address. A home server also works when the router and ISP allow inbound port forwarding.

## Install or update

Run this on the Linux machine that will host the relay:

```bash
curl -fsSL https://raw.githubusercontent.com/ufukmehmedov/NovaChat-Releases/main/install-relay.sh | sudo bash
```

The installer asks for the TCP port. Press Enter to use the default port, `7777`.

For a non-interactive installation on a specific port:

```bash
curl -fsSL https://raw.githubusercontent.com/ufukmehmedov/NovaChat-Releases/main/install-relay.sh | sudo NOVARELAY_PORT=7778 bash
```

The installer:

- downloads the currently referenced public NovaRelay release;
- verifies the ZIP package with SHA-256;
- installs the relay as an isolated systemd service;
- creates a dedicated unprivileged `novarelay` system account if needed;
- stores each relay instance in its own directory;
- enables the service at boot and starts it immediately;
- preserves an existing relay password when the same port is upgraded.

Running the same install command again updates that relay instance to the distribution referenced by `bootstrap-release.txt`.

## Uninstall a relay instance

The following removes the service and installed binary for TCP port `7777` but **preserves** the relay password and state under `/var/lib/novarelay/7777`:

```bash
PORT=7777
sudo systemctl disable --now "novarelay-$PORT.service" 2>/dev/null || true
sudo rm -f "/etc/systemd/system/novarelay-$PORT.service"
sudo rm -rf "/opt/novarelay/$PORT"
sudo systemctl daemon-reload
```

To permanently delete the preserved relay password and state as well, run this only after confirming the port number:

```bash
PORT=7777
sudo rm -rf "/var/lib/novarelay/$PORT"
```

Removing the relay service does not automatically remove router port-forwarding rules, cloud firewall rules, or host firewall rules. Remove those separately if they are no longer needed.

## Files created by the installer

For a relay on TCP port `7777`:

```text
/opt/novarelay/7777/novarelay
/var/lib/novarelay/7777/relay_password.txt
/etc/systemd/system/novarelay-7777.service
```

Each port is a separate relay instance with a separate working directory and a separate password.

## Get the relay password

After the service starts:

```bash
sudo cat /var/lib/novarelay/7777/relay_password.txt
```

Keep this password private. Do not publish it in GitHub, screenshots, shell history, tickets, or documentation.

## Check the service

```bash
sudo systemctl status novarelay-7777 --no-pager
```

Live logs:

```bash
sudo journalctl -u novarelay-7777 -f
```

The service is enabled at boot automatically.

## Network requirements

NovaRelay listens for **TCP**, not UDP.

If you install it on port `7777`, allow inbound **TCP 7777** from the Internet to the relay machine.

### VPS / cloud server

You normally do not need router port forwarding on a VPS. You do need to allow the selected TCP port in every firewall layer that applies, for example:

1. the cloud provider firewall / security group;
2. the Linux host firewall, if one is enabled.

Example for UFW:

```bash
sudo ufw allow 7777/tcp
```

Do not enable or reconfigure a firewall blindly on a remote server. Make sure SSH access remains allowed before changing firewall policy.

### Home server

For a relay behind a home router:

1. Give the relay computer a stable LAN address, preferably with a DHCP reservation in the router, for example `192.168.1.50`.
2. Configure router port forwarding: external **TCP 7777** -> `192.168.1.50:7777`.
3. Allow TCP 7777 in the Linux firewall if a host firewall is active.
4. Make sure your ISP provides a reachable public IPv4 address.

Example topology:

```text
Internet
   |
Public IPv4 / DNS name
   |
Home router
TCP 7777 port forward
   |
192.168.1.50:7777
   |
NovaRelay
```

## Static public IP, dynamic IP, and CGNAT

A **static public IPv4 address is recommended**, because NovaChat clients need a stable address for the relay.

A static public IP is not technically mandatory. A normal public dynamic IPv4 address can also work when you use a reliable Dynamic DNS (DDNS) hostname and keep it updated.

If your ISP uses **CGNAT**, normal IPv4 port forwarding usually cannot make the relay reachable from the public Internet. In that case use one of these options:

- ask the ISP for a public IPv4 / static IPv4 service;
- host NovaRelay on a VPS with a public IPv4 address.

## Optional DNS name

Instead of giving clients a numeric public IP, you can point a DNS A record to the relay's public IPv4 address, for example:

```text
chat.example.com -> 203.0.113.10
```

NovaChat would then use:

```text
chat.example.com:7777
```

Not:

```text
http://chat.example.com:7777
```

## Multiple relay instances

You can run multiple independent relays on the same Linux host. Use a different TCP port for each one, for example:

```text
R1 -> TCP 7776
R2 -> TCP 7777
R3 -> TCP 7778
```

Install another instance with the same one-command installer and a different port:

```bash
curl -fsSL https://raw.githubusercontent.com/ufukmehmedov/NovaChat-Releases/main/install-relay.sh | sudo NOVARELAY_PORT=7778 bash
```

Each instance gets its own service and password:

```text
novarelay-7776.service
novarelay-7777.service
novarelay-7778.service
```

If the machine is behind a router, forward every port that you actually use.

## What the relay can see

NovaChat message content is end-to-end encrypted. NovaRelay routes encrypted payloads and cannot decrypt the message text.

Like any network relay, it can observe operational metadata required to provide the service, including client IP addresses, device/user identifiers presented to the relay, connection and online status, and timing information.

## Important security notes

- Never expose the relay password publicly.
- Use a separate password for each relay instance.
- Keep the Linux host patched.
- Expose only the relay TCP ports you actually need.
- Do not run NovaRelay as root; the official installer uses the unprivileged `novarelay` account.
- Protect SSH separately with strong authentication.

NovaRelay is currently alpha/pre-release software. Deployment behavior may change while development continues.

Copyright © Ruen IT Services. All rights reserved.
