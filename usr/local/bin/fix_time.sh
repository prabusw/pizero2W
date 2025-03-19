#!/bin/sh
echo nameserver 192.168.1.1 > /etc/resolv.conf
sleep 20
/sbin/rc-service chronyd restart
sleep 60
/usr/sbin/resolvconf -u
