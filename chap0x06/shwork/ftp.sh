#!/usr/bin/env/bash

FUSERname=$1
HOSTname=$2
FUSERpasswd=$3

ssh root@${HOSTname}<<ssh

#move the file

cp /etc/vsftpd.conf /etc/vsftpd.conf.bk
cp /root/transfer/conf/vsftpd.conf /etc/vsftpd.conf

cp /etc/vsftpd.userlist /etc/vsftpd.userlist.bk
cp /root/transfer/conf/vsftpd.userlist /etc/vsftpd.userlist

cp /etc/hosts.allow /etc/hosts.allow.bk
cp /root/transfer/conf/hosts.allow /etc/hosts.allow

cp /etc/hosts.deny /etc/hosts.deny.bk
cp /root/transfer/conf/hosts.deny /etc/hosts.deny

#create use
#该账号仅可用于FTP服务访问，不能用于系统shell登录
/usr/bin/expect << EOF  
spawn adduser --shell /usr/sbin/nologin "${FUSERname}"
expect {
"password:" { send "${FUSERpasswd}\r"; exp_continue }
"password:" { send "${FUSERpasswd}\r"; exp_continue }
"Name" { send "\r"; exp_continue }
"Number" { send "\r"; exp_continue }
"Work" { send "\r"; exp_continue }
"Home" { send "\r"; exp_continue }
"Other" { send "\r"; exp_continue }
"correct?" { send "Y\r"; }
}
expect eof
EOF

mkdir /home/${FUSERname}/ftp
chown nobody:nogroup /home/${FUSERname}/ftp
#chmod a-w /home/${FUSERname}/ftp #根据无需删除其写权限

#创建文件上传目录，将所有权分配给用户
mkdir /home/${FUSERname}/ftp/files
chown ${FUSERname}:${FUSERname} /home/${FUSERname}/ftp/files

#ssl
#创建自签名SSL证书
/usr/bin/expect << EOF  
spawn openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/vsftpd.pem -out /etc/ssl/private/vsftpd.pem
expect {
"AU" { send "CN\r"; exp_continue }
"State or Province Name" { send "Beijing\r"; exp_continue }
"Locality Name" { send "Chaoyang\r"; exp_continue }
"Organization Name" { send "CUC\r"; exp_continue }
"Organizational Unit Name" { send "SEC\r"; exp_continue }
"Common Name" { send "amftp\r"; exp_continue }
"Email" { send "1585801268@qq.com\r"; }
}
expect eof
EOF

systemctl restart vsftpd
exit
ssh
