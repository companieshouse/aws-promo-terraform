#!/bin/bash
# Redirect the user-data output to the console logs
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

#Update Nagios registration script with relevant template
cp /usr/local/bin/nagios-host-add.sh /usr/local/bin/nagios-host-add.j2
REPLACE=Promo_Proxy_Server /usr/local/bin/j2 /usr/local/bin/nagios-host-add.j2 > /usr/local/bin/nagios-host-add.sh
#Remove unnecessary files
rm /etc/httpd/conf.d/welcome.conf
#Run Ansible playbook for Frontend deployment using provided inputs
/usr/local/bin/ansible-playbook /root/frontend_deployment.yml -e '${ANSIBLE_INPUTS}'