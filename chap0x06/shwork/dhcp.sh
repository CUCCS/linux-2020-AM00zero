networkcard=$1

ssh root@$HOSTname<<ssh

cp /etc/default/isc-dhcp-server /etc/default/isc-dhcp-server.back
sed -i '/^INTERFACES/d' /etc/default/isc-dhcp-server
cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.back
cp /root/workspace/conf/dhcpd.conf /etc/dhcp/dhcpd.conf

echo INTERFACES=\"$networkcard\">>/etc/default/isc-dhcp-server


ifconfig $networkcard up

ifconfig $networkcard 10.0.66.1 netmask 255.255.255.0

systemctl restart isc-dhcp-server.service

exit
ssh