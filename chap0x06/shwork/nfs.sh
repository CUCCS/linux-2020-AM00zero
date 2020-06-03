#!/usr/bin/env/bash

HOSTname=$1
CLTENTip=$2

#host work

ssh root@{$HOSTname}<<ssh

mkdir /var/nfs/general -p
chown nobody:nogroup /var/nfs/general

#fix the exports

sed -i "s/CLTENTip/${CLTENTip}/g" /root/transfer/conf/exports
cp /etc/exports /etc/exports.bk
cp /root/transfer/conf/exports /etc/exports


systemctl restart nfs-kernel-server

exit
ssh

#client work

echo "${passwd}" | sudo -S mkdir -p /nfs/general
if [ $? -ne 0 ] ;
then
	PRINT_ERROR "Fail to mkdir -p /nfs/general!"
fi

echo "${passwd}" | sudo -S mkdir -p /nfs/home
if [ $? -ne 0 ] ;
then
	PRINT_ERROR "Fail to mkdir -p /nfs/home!"
fi

echo "${passwd}" | sudo -S mount ${CLTENTip}:/var/nfs/general /nfs/general
if [ $? -ne 0 ] ;
then
	PRINT_ERROR "Fail to mount ${CLTENTip}:/var/nfs/general /nfs/general!"
fi

echo "${passwd}" | sudo -S mount ${CLTENTip}:/home /nfs/home
if [ $? -ne 0 ] ;
then
	PRINT_ERROR "Fail to mount ${CLTENTip}:/home /nfs/home!"
fi