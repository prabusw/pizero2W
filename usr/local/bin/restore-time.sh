#!/bin/sh

if grep -q "overlaytmpfs=yes" /proc/cmdline; then
    CURRENT_MODE="overlay"
    TIME_FILE="/media/root-ro/var/lib/time-lastboot"

    # Ensure /media/root-ro exists before checking time file
    if [ ! -d "/media/root-ro" ]; then
        echo "Error: /media/root-ro not found, cannot restore time!" >&2
        exit 1
    fi
else
    CURRENT_MODE="default"
    TIME_FILE="/var/lib/time-lastboot"
fi

if [ -f "$TIME_FILE" ]; then
    SAVED_TIME=$(cat "$TIME_FILE")

    # Validate the saved timestamp
    if [ -n "$SAVED_TIME" ] && [ "$SAVED_TIME" -ge 1000000000 ] 2>/dev/null; then
        CURRENT_TIME=$(date +%s)

        if [ "$SAVED_TIME" -gt "$CURRENT_TIME" ]; then
            echo "Restoring time: $(date -d "@$SAVED_TIME")"
            date -s "@$SAVED_TIME" || echo "Error: Failed to set system time!" >&2
        else
            echo "System time is already ahead of saved time. No changes made."
        fi
    else
        echo "Error: Invalid or corrupt saved time file!" >&2
    fi
else
    echo "No saved time found! Setting fallback time..."
    date -s "2025-01-01 00:00:00" || echo "Error: Failed to set fallback time!" >&2
fi
