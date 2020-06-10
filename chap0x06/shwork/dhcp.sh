#!/usr/bin/env/bash
source vars.sh

ssh root@$HOSTname<<ssh

ifconfig ${DHCP_INTERFACE} up

ifconfig ${DHCP_INTERFACE} ${INTERFACE_ADDRESS} netmask 255.255.255.0


service isc-dhcp-server restart

exit
ssh