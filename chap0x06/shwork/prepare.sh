#!/usr/bin/env/bash

function PRINT_ERROR(){
	>&2 echo -e "\033[31m[ERROR]: $1 \033[0m\n" # >&2 same as 1>&2, 
	exit 255
}


#clien apt work

echo "${passwd}" | sudo -S apt update
if [ $? -ne 0 ] ;
then
	PRINT_ERROR "Fail to update!"
fi

echo "${passwd}" | sudo -S apt install nfs-common 
if [ $? -ne 0 ] ;
then
	PRINT_ERROR "Fail install the nfs-common package!"
fi

#ssh->host apt work
ssh root@${HOSTname}<<ssh

mkdir transfer

apt update
if [ $? -ne 0 ] ;
then
	PRINT_ERROR "Fail to update!"
fi

apt install debconf-utils
if [ $? -ne 0 ] ;
then
	PRINT_ERROR "Fail to install the debconf package!"
fi

debconf-set-selections <<EOF
vsftpd-basic shared/vsftpd/inetd_or_standalone select standalone 
EOF
apt install -y  vsftpd nfs-kernel-server samba isc-dhcp-server bind9 expect
if [ $? -ne 0 ] ;
then
	PRINT_ERROR "Fail to install the packages!"
fi

cp /etc/proftpd/proftpd.conf  /etc/proftpd/proftpd.conf.bk
cp /etc/exports  /etc/exports.bk
cp /etc/samba/smb.conf  /etc/samba/smb.conf.bk
cp /etc/network/interfaces /etc/network/interfaces.bk
cp /etc/default/isc-dhcp-server /etc/default/isc-dhcp-server.bk
cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.bk
cp /etc/bind/named.conf.local /etc/bind/named.conf.local.bk

exit
ssh

sed -i "s/WHITE_IP/${WHITE_IP}/g" /home/am/chap6work/conf/hosts.allow

sed -i "s/CLIENT_IP/${CLTENTip}/g" /home/am/chap6work/conf/exports

sed -i "s/SMB_USER/${SMB_USER}/g" /home/am/chap6work/conf/smb.conf
sed -i "s/SMB_GROUP/${SMB_GROUP}/g" /home/am/chap6work/conf/smb.conf

sed -i "s/DHCP_INTERFACE/${DHCP_INTERFACE}/g" /home/am/chap6work/conf/isc-dhcp-server

sed -i "s/SUBNET/${SUBNET}/g" /home/am/chap6work/conf/dhcpd.conf
sed -i "s/SUB_DOWN/${SUB_DOWN}/g" /home/am/chap6work/conf/dhcpd.conf
sed -i "s/SUB_TOP/${SUB_TOP}/g" /home/am/chap6work/conf/dhcpd.conf
sed -i "s/SUB_BROADCAST/${SUB_BROADCAST}/g" /home/am/chap6work/conf/dhcpd.conf

sed -i "s/INTERFACE_ADDRESS/${INTERFACE_ADDRESS}/g" /home/am/chap6work/conf/db.cuc.edu.cn

scp /home/am/chap6work/conf/proftpd.conf $username@$ip:/etc/proftpd/
scp /home/am/chap6work/conf/exports  $username@$ip:/etc/
scp /home/am/chap6work/conf/smb.conf $username@$ip:/etc/samba/
scp /home/am/chap6work/conf/isc-dhcp-server $username@$ip:/etc/default/
scp /home/am/chap6work/conf/dhcpd.conf $username@$ip:/etc/dhcp/
scp /home/am/chap6work/conf/db.cuc.edu.cn $username@$ip:/etc/bind/
scp /home/am/chap6work/shwork/vars.sh $username@$ip:
