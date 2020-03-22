#!/bin/bash

if uptime -p | grep day > /dev/null; then
        DAYS=$(uptime -p | egrep -o "[0-9]+ day" | sed 's/ day//g')
else
        DAYS=0
fi
if uptime -p | grep min > /dev/null; then
        MIN=$(uptime -p | egrep -o "[0-9]+ min" | sed 's/ min//g')
else
        MIN=0
fi
if uptime -p | grep hour > /dev/null; then
        HOUR=$(uptime -p | egrep -o "[0-9]+ hour" | sed 's/ hour//g')
else
        HOUR=0
fi
if uptime -p | grep week > /dev/null; then
        WEEK=$(uptime -p | egrep -o "[0-9]+ week" | sed 's/ week//g')
else
        WEEK=0
fi
if uptime -p | grep month > /dev/null; then
        MONTH=$(uptime -p | egrep -o "[0-9]+ month" | sed 's/ month//g')
else
        MONTH=0
fi
if uptime -p | grep year > /dev/null; then
        YEAR=$(uptime -p | egrep -o "[0-9]+ year" | sed 's/ year//g')
else
        YEAR=0
fi


# for perfdata
SECONDS=$(echo $(($YEAR*365*24*60*60+$MONTH*31*24*60*60+$WEEK*7*24*60*60+$HOUR*60*60+$DAYS*24*60*60+$MIN*60)))
echo "Uptime: $(uptime -p) since $(uptime -s)|uptime=$SECONDS;0;0"
exit 0
