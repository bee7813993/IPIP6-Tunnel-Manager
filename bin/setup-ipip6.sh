#!/bin/bash
PREFIX="@PREFIX@"
CONFDIR="/etc"
LIBDIR="${PREFIX}/lib"

source "${CONFDIR}/ipip6.conf"
source "${LIBDIR}/ipip6-utils.sh"

generate_netplan_yaml() {
    local template="/etc/netplan-template.yaml"
    local output_yaml="/etc/netplan/80-ipip6.yaml"
    local temp_yaml="/tmp/80-ipip6.yaml.tmp"

    sed "s|INTERFACE_NAME|$INTERFACE|g; s|IPV6TOKEN|$IPV6TOKEN|g" "$template" > "$temp_yaml"
    if [ ! -f "$output_yaml" ] || ! diff -q "$temp_yaml" "$output_yaml" > /dev/null 2>&1; then
        mv "$temp_yaml" "$output_yaml"
        chmod 600 "$output_yaml"
        netplan apply
        log_message INFO "Netplan configuration updated and applied."
    else
        rm -f "$temp_yaml"
        log_message DEBUG "No changes detected in Netplan configuration."
    fi
}

generate_netplan_yaml
wait_for_ipv6

LOCAL_IP=$(ip -6 addr show dev "$INTERFACE" | grep 'scope global' | awk '{print $2}' | cut -d/ -f1 | normalize_ipv6)

if [ -n "$LOCAL_IP" ]; then
    ip tunnel add "$TUNNEL_NAME" mode ipip6 local "$LOCAL_IP" remote "$REMOTE_IP" dev "$INTERFACE"
    ip addr add "$LOCAL_V4IP/32" dev "$TUNNEL_NAME"
    ip link set "$TUNNEL_NAME" up
    ip route add default dev "$TUNNEL_NAME"
    iptables -t mangle -A POSTROUTING -p tcp --tcp-flags SYN,RST SYN -o "$TUNNEL_NAME" -j TCPMSS --clamp-mss-to-pmtu
    log_message INFO "Tunnel setup completed. Local IP: $LOCAL_IP, Remote IP: $REMOTE_IP"
else
    log_message ERROR "Failed to retrieve LOCAL_IP."
    exit 1
fi
