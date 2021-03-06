## Graphite templates
Simply copy the .ini files to your graphiteweb template folder, i.e. ```/usr/share/icingaweb2/modules/graphite/templates/```. 
Add ``vars.check_command = "strom"`` to the service definition because of obscured check_nrpe commands.
Replace ``strom`` by the required value of template.
## check_feed_status
This plugin checks if Greenbone OpenVAS feeds are still up to date. If they are older than 10 days, a warning is displayed.
### Installation
Following entries in visudo are required:

        nagios ALL=(gvm:gvm) NOPASSWD: /opt/gvm/sbin/greenbone-feed-sync --feedversion --type *
        nagios ALL=(gvm:gvm) NOPASSWD: /opt/gvm/bin/greenbone-nvt-sync --feedversion

Where `gvm` is the user openVAS runs as. Adapt paths accordingly
### Usage    
Simply invoke with `./check_feed_status`
## check_postfwd_rate
This plugin checks for senders that exceeded a sending limit. A valid postfwd installation and configuration is required. Simply invoke it with the rate limits that should be verified:

        ./check_postfwd_rate -l 500,1000
## check_fail2ban
### Installation
This plugin requires fail2ban and sudo installed. Also several commands must be runnable by nagios user with sudo, so add the following to visudo:

        # Needed for check_fail2ban
        nagios  ALL=NOPASSWD: /usr/bin/fail2ban-client status
        nagios  ALL=NOPASSWD: /usr/bin/fail2ban-client status *
        nagios  ALL=NOPASSWD: /usr/bin/fail2ban-client get * bantime
### Usage    
            ./check_fail2ban -h Display this message
                             -w <warning level> defaults to 10
                             -c <crit level> defaults to 20
                             -t Time: Display until when IPs will be banned
                             -j <jaillist> i.e. comma separated string of jails, i.e. ssh,postfix
                                Only check those jails
### Examples
            ./check_fail2ban -t -w 5 -c 10 -j ssh,postfix
            ./check_fail2ban -t

### Example Output
![Fail2Ban](img/fail2ban_new.png "Fail2Ban")
## check_fail2ban_old.sh
This plugin is deprecated, please use check_fail2ban.sh
Forked from [Nagios Exchange](https://exchange.nagios.org/index.php?option=com_mtree&task=viewlink&link_id=4349&Itemid=74)
### Usage
/usr/lib/nagios/plugins/check_fail2ban.sh -l \<logfile\>  -p \<jail.conf\> -w 10 -c 20 \<-v\>
### Example output
![Fail2Ban](img/fail2ban.png "Fail2Ban")
## check_strom.sh
Tested and works with EnBW Stromzähler, Software Version WNGW000702
### Usage
```/usr/lib/nagios/plugins/check_strom ADDRESS```
### Output example
![Strom](img/strom.png "Strom")
## check_uptime.sh
### Usage
```/usr/lib/nagios/plugins/check_uptime```
## check_connections.sh
This check needs to be redone