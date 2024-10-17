#!/bin/sh

start_wg() {
	localip="$(nvram get wireguard_localip)"
	privatekey="$(nvram get wireguard_localkey)"
	peerkey="$(nvram get wireguard_peerkey)"
	peerip="$(nvram get wireguard_peerip)"
	
#关闭vnt的防火墙
/usr/bin/vpn --stop
#关闭vnt的防火墙
iptables -D INPUT -i vnt-tun -j ACCEPT 2>/dev/null
iptables -D FORWARD -i vnt-tun -o vnt-tun -j ACCEPT 2>/dev/null
iptables -D FORWARD -i vnt-tun -j ACCEPT 2>/dev/null
iptables -t nat -D POSTROUTING -o vnt-tun -j MASQUERADE 2>/dev/null
killall vpn
killall -9 vpn
sleep 3
#清除vnt的虚拟网卡
ifconfig vnt-tun down && ip tuntap del vnt-tun mode tun

/usr/bin/vpn -k $privatekey -d $peerkey -i $localip -o $peerip --ip 10.26.0.12 &

sleep 3
if [ ! -z "`pidof vpn`" ] ; then
logger -t "vpn" "启动成功"
#放行vnt防火墙
iptables -I INPUT -i vnt-tun -j ACCEPT
iptables -I FORWARD -i vnt-tun -o vnt-tun -j ACCEPT
iptables -I FORWARD -i vnt-tun -j ACCEPT
iptables -t nat -I POSTROUTING -o vnt-tun -j MASQUERADE
#开启arp
ifconfig vnt-tun arp
else
logger -t "vpn" "启动失败"
fi
