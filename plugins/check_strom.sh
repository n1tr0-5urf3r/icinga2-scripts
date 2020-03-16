#!/bin/bash
# Checks for current load on EnBW Stromzaehler 
# 16.03.2020 Fabian Ihle, v1.0
ADDRESS=$1
TMPFILE=/tmp/strom.html

function print_help {
        echo "Usage: ./check_strom ADDRESS"
        exit 3
}

function print_error {
        echo "Connection Failed. $1"
        exit 3
}

if [ -z "$ADDRESS" ]; then
        print_help
fi

if /usr/bin/wget "$ADDRESS" -q -O $TMPFILE; then
        CURRENT=$(grep "class=\"whats\">" $TMPFILE | sed 's/<\/div>//g' | sed 's/<div class="whats">//g')
        AVG=$(grep "class=\"small-whats\">" $TMPFILE | sed 's/<\/div>//g' | sed 's/<div class="small-whats">//g')
        CURRENT_NO_UNIT=$(echo $CURRENT | sed 's/ W//g')
        AVG_NO_UNIT=$(echo $AVG | sed 's/ W//g')
        # String not found, not ENBW device
        if [ -z "$CURRENT" ]; then
                print_error "Device not compatible"
        fi
        # Data available
        echo "Current: $CURRENT, Average 15 minutes: $AVG|current=$CURRENT_NO_UNIT average=$AVG_NO_UNIT"
        exit 0
else
        print_error "Host not reachable"
fi
