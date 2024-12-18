#!/bin/bash
PREFIX="@PREFIX@"
CONFDIR="/etc"
LIBDIR="${PREFIX}/lib"

source "${CONFDIR}/ipip6.conf"
source "${LIBDIR}/ipip6-utils.sh"

if ip link show "$TUNNEL_NAME" > /dev/null 2>&1; then
    ip link set "$TUNNEL_NAME" down
    ip tunnel del "$TUNNEL_NAME"
    log_message INFO "Tunnel $TUNNEL_NAME cleaned up."
else
    log_message DEBUG "No tunnel to clean up."
fi
