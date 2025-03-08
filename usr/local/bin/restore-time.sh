#!/bin/sh

TIME_FILE="/media/root-ro/var/lib/time-lastboot"

if [ -f "$TIME_FILE" ]; then
    SAVED_TIME=$(cat "$TIME_FILE")

    # Validate the saved timestamp
    if [ "$SAVED_TIME" -ge 1000000000 ] 2>/dev/null; then
        echo "Restoring time: $(date -d "@$SAVED_TIME")"
        date -s "@$SAVED_TIME"
    else
        echo "Error: Invalid saved time!"
    fi
else
    echo "No saved time found! Setting fallback time..."
    date -s "2025-01-01 00:00:00"  # Set an approximate time to avoid certificate issues
fi
