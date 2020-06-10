#!/usr/bin/env/bash

source vars.sh

ssh root@$HOSTname<<ssh

cp /etc/samba/smb.conf /etc/samba/smb.conf.bk
cp /root/workspace/conf/smb.conf /etc/samba/smb.conf

apt install -y samba 
useradd -M -s /sbin/nologin ${SMB_USER}

/usr/bin/expect << EOF
spawn passwd ${SMB_USER}
expect {
 "Enter new UNIX password:" {send "${SMB_PASS}\r"; exp_continue}
 "Retype new UNIX password:" {send "${SMB_PASS}\r";}
}
expect eof
EOF

/usr/bin/expect << EOF
spawn smbpasswd -a ${SMB_USER}
expect {
 "New SMB password:" {send "${SMB_PASS}\r"; exp_continue }
 "Retype new SMB password:" {send "${SMB_PASS}\r"; }
}
expect eof
EOF

smbpasswd -e ${SMB_USER}
groupadd ${SMB_GROUP}

usermod -G ${SMB_GROUP} ${SMB_USER}

if [[ ! -d "/home/samba/guest" ]] ; then

  mkdir  -p /home/samba/guest
fi


if [[ ! -d "/home/samba/demo" ]] ; then
  mkdir  -p /home/samba/demo
fi

chgrp -R ${SMB_GROUP} /home/samba/guest
chgrp -R ${SMB_GROUP} /home/samba/demo

chmod 2775 /home/samba/guest
chmod 2770 /home/samba/demo

systemctl restart smbd.service 

exit
ssh