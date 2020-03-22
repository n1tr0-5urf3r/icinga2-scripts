## Graphite templates
Simply copy the .ini files to your graphiteweb template folder, i.e. ```/usr/share/icingaweb2/modules/graphite/templates/```. 
Add ``vars.check_command = "strom"`` to the service definition because of obscured check_nrpe commands.
Replace ``strom`` by the required value of template.
## check_connections.sh
This check needs to be redone
## check_fail2ban.sh
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