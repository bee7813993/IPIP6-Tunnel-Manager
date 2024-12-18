log_message() {
    local level="$1"
    local message="$2"
    logger -p "user.$(echo "$level" | tr '[:upper:]' '[:lower:]')" -t ipip6-handler "[$level] $message"
}

normalize_ipv6() {
    local input="$1"
    if [ -z "$input" ]; then
        read -r input
    fi
    echo "$input" | awk -F: '{
        for (i=1; i<=NF; i++) {
            if ($i == "") $i="0";
            else while (length($i) < 4) $i="0"$i;
        }
        printf "%s\n", $1":"$2":"$3":"$4":"$5":"$6":"$7":"$8;
    }'
}

wait_for_ipv6() {
    local timeout=30
    for ((i=0; i<timeout; i++)); do
        if ip -6 addr show dev "$INTERFACE" | grep 'scope global' > /dev/null 2>&1; then
            return 0
        fi
        sleep 1
    done
    log_message ERROR "Timeout: No IPv6 address assigned to $INTERFACE after $timeout seconds."
    exit 1
}
