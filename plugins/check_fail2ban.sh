#!/bin/bash
#########################################################
# Written by Andor Westphal andor.westphal@gmail.com    #
# Modified by Fabian Ihle fabi@ihlecloud.de             #
# Created: 2013-02-22   (version 1.0)                   #
# Modified:2013-03-12   (version 1.1)                   #
#       -fix wrong count for output                     #
#       -implement status check                         #
# Modified 2020-03-22   (version 1.2)                   #
#       - fix wrong process status (OldBlogger)         #
#       - Add verbose IP output (Fabian Ihle)           #
#       - Fix jail_list (svamberg)                      #
#                                                       #
#checks the count of active jails                       #
#checks for banned IP's                                 #
#integrated performance data for banned IPs             #
#shows banned IP since the last logrotate in long output#
#########################################################
STATUS_OK="0"
STATUS_WARNING="1"
STATUS_CRITICAL="2"
STATUS_UNKNOWN="3"
ps_state=$(ss -aux |grep "fail2ban.sock" |grep -v grep| wc -l)
PROGPATH=$(dirname $0)
fail2ban_client=$(which fail2ban-client)
jail_count=$($fail2ban_client status|grep "Number" |cut -f 2)




print_usage() {
echo "
Usage:

  $PROGPATH/check_fail2ban -h for help (this messeage)

                -l </path/to/logfile>
                -p </path/to/conffile>
                -w <your warnlevel>
                -c <your critlevel>
                -v Verbose Output: Display banned IPs and protocols

        example :
  $PROGPATH/check_fail2ban -l /var/log/fail2ban.log -p /etc/fail2ban/jail.conf -w 10 -c 20

"
}

wrong_cpath() {
echo "Is your path to conffile right?"
echo "There is no entry for the bantime"
echo "Normaly its in the jail.conf"
}


if [ "$ps_state" -lt "1" ]; then
        echo "   ++++ Process is not running ++++"
        exit $STATUS_CRITICAL
fi



if [ -z "$1" ];then
        echo "    ++++ No arguments found ++++"
        exit $STATUS_UNKNOWN
fi


while test -n "$1"; do
    case "$1" in
        -c)
            crit=$2
            shift
            ;;
        -h)
            print_help
            exit $STATUS_UNKNOWN
            ;;
        -l)
            lpath=$2
            shift
            ;;
        -p)
            cpath=$2
            shift
            ;;
        -w)
            warn=$2
            shift
            ;;
        -v)
            verbose=true
            ;;
        *)
            echo "Unknown argument: $1"
            print_usage
            exit $STATUS_UNKNOWN
            ;;
    esac
  shift
done


if [ -z ${crit} ] ||  [ -z ${lpath} ] || [ -z ${cpath} ] || [ -z ${warn} ]; then
        echo "    ++++ Missing arguments ++++"
        print_usage
        exit $STATUS_UNKNOWN
fi

ban=$(grep "Ban " ${lpath} | grep -v Fail | sed -E 's/[ ]{2,}/ /g' | awk -F[\ \:] '{print $11, $9}')
bcount=$(echo "$ban"|grep -v ^\#  | grep -v ^$|wc -l)



if [ "$bcount" -ge ${warn} ] && [ "$bcount" -lt ${crit} ]; then
        State="Warning"
elif [ "$bcount" -ge ${warn} ];then
        State="Critical"
else
        State="Ok"
fi


ban_time=$(cat ${cpath} |grep "bantime" |cut -d " "  -f4)

long_out=$(cat /var/log/fail2ban.log |grep "Ban "|cut -d " " -f 7,5,2|sed  -e 's/$/\\n/g'|grep -v Fail)

if [ "$verbose" = true ]; then
        ban=$(echo "$ban" | sed 's/]/]\\n/g')
        OUTPUT=$(echo "${jail_count} active jails --- ${State}: ${bcount} banned IP(s) \n The bantime are ${ban_time} seconds \n "$long_out" \n Banned IPs: \n $ban |banned_IP=${bcount};${warn};${crit};;")
else
        OUTPUT=$(echo "${jail_count} active jails --- ${State}: ${bcount} banned IP(s) \n The bantime are ${ban_time} seconds \n "$long_out" |banned_IP=${bcount};${warn};${crit};;")
fi

echo $OUTPUT

if [ ${State} == "Warning" ];then
        exit ${STATUS_WARNING}
elif [ ${State} == "Critical" ];then
        exit ${STATUS_CRITICAL}
elif [ ${State} == "Unknown" ];then
        exit ${STATUS_UNKNOWN}
else
        exit ${STATUS_OK}
fi
