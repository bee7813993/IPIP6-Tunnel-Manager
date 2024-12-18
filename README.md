
# IPIP6 Tunnel Manager

This project automates the setup and management of an IPv6-based IPIP6 tunnel, allowing for dynamic IPv6 prefix changes. It integrates seamlessly with `netplan` and `networkd-dispatcher` on Linux systems.

## Features
- **IPv6 Prefix Detection**: Automatically detects IPv6 prefix changes and updates the tunnel configuration.
- **Dynamic Netplan Configuration**: Generates and applies `netplan` YAML configurations dynamically.
- **TCPMSS Clamp**: Ensures proper MTU handling using iptables.
- **Prefix Change Handling**: Executes custom commands upon IPv6 prefix changes.
- **Log Levels**: Supports INFO, ERROR, and DEBUG logging for troubleshooting.

## File Structure
```
ipip6-tunnel/
├── Makefile
├── bin/
│   ├── setup-ipip6.sh          # Sets up the IPIP6 tunnel
│   └── cleanup-ipip6.sh        # Cleans up the IPIP6 tunnel
├── lib/
│   └── ipip6-utils.sh          # Common utility functions
├── dispatcher/
│   └── 50-ipip6-handler        # Detects prefix changes and triggers setup
└── etc/
    ├── ipip6.conf              # Configuration file
    └── netplan-template.yaml   # Netplan configuration template
```

## Installation
Run the following commands to install the scripts:

```bash
make install PREFIX=/usr/local
```

To uninstall:

```bash
make uninstall PREFIX=/usr/local
```

## Configuration
Edit `/etc/ipip6.conf` to match your environment:

```bash
IPV6TOKEN="0000:0000:0000:0001"   # Fixed IPv6 token
REMOTE_IP="2001:db8::1"           # Remote IPv6 address
LOCAL_V4IP="192.0.2.1"            # Local IPv4 address for the tunnel
INTERFACE="eth0"                  # Physical network interface
TUNNEL_NAME="ipip6-tunnel"        # Tunnel name
LOCAL_V6_FILE="/var/run/local_v6_ip"  # Storage for the last detected IPv6 prefix
ON_PREFIX_CHANGE_CMD=""           # Optional command to run on prefix change
```

## Usage
1. **Initial Setup**:  
   After installation, the `setup-ipip6.sh` script is automatically executed on system startup and upon prefix changes. To apply immediately, run:

   ```bash
   /usr/local/bin/setup-ipip6.sh
   ```

2. **Manual Cleanup**:  
   To remove the tunnel manually, run:

   ```bash
   /usr/local/bin/cleanup-ipip6.sh
   ```

3. **Logging**:  
   Logs are available via `journalctl`:

   ```bash
   journalctl -t ipip6-handler
   ```

## License
This project is licensed under the MIT License.  
See the [LICENSE](./LICENSE) file for details.
