#!/usr/bin/expect

set HOSTname [lindex $argv 0 ] 
set password [lindex $argv 1 ] 
set keypath [lindex $argv 2 ] 

spawn ssh-copy-id -i ${keypath} root@${HOSTname}
expect {  
 "*yes/no" { send "yes\r" ; exp_continue }  
 "*password:" { send "$password\r" ; exp_continue }
 "*password:" { send "$password\r" ; }
}
expect eof