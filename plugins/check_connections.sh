#!/bin/bash
# Checks for active connection on default https port
connections=$(netstat | grep https | sed 's/^.*https     //g' | sed 's/:https/https/g' | grep -v CLOSING | sed 's/:.*//g' | sed 's/    TIME_WAIT//g' |  perl -pe 's/ \n//'| sort -u | wc -l)


if [ "$connections" -gt "200" ]
then
        echo "Warning $connections Verbindungen aktiv|a[connections]=$connections;200;500"
exit 1

elif [ "$connections" -gt "500" ]
then
        echo "Critical! $connections Verbindungen aktiv|a[connections]=$connections;200;500"
exit 2

elif [ "$connections" -lt "199" ]
then
        echo "Ok. $connections Verbindungen aktiv|c[connections]=$connections;200;500"
        exit 0
fi