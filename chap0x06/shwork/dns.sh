#!/usr/bin/env/bash

source vars.sh

ssh root@$HOSTname<<ssh

sudo mkdir /etc/bind/zones
service bind9 restart

exit
ssh
