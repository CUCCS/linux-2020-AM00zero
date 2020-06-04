#!/usr/bin/env/bash

source vars.sh

source prepare.sh

source ftp.sh
source nfs.sh
source samba.sh
source dhcp.sh
source dns.sh

ssh root@${HOSTname}<<ssh
rm /root/vars.sh
exit
ssh

