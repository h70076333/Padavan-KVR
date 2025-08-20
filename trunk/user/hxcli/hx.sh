#!/bin/sh

/usr/bin/hx-cli --stop
#关闭vnt的防火墙
iptables -D INPUT -i hxsdwan -j ACCEPT 2>/dev/null
iptables -D FORWARD -i hxsdwan -o hxsdwan -j ACCEPT 2>/dev/null
iptables -D FORWARD -i hxsdwan -j ACCEPT 2>/dev/null
iptables -t nat -D POSTROUTING -o hxsdwan -j MASQUERADE 2>/dev/null
killall hx-cli
killall -9 hx-cli
sleep 4
#清除vnt的虚拟网卡
ifconfig hxsdwan down && ip tuntap del hxsdwan mode tun
#启动命令 更多命令去官方查看

hxcli_token=$(nvram get hxcli_token)
echo $hxcli_token
hxcli_desname=$(nvram get hxcli_desname)
echo $hxcli_desname
hxcli_ip=$(nvram get hxcli_ip)
echo $hxcli_ip
hxcli_localadd=$(nvram get hxcli_localadd)
echo $hxcli_localadd
hxcli_serverw=$(nvram get hxcli_serverw)
echo $hxcli_serverw
lan_ipaddr=$(nvram get lan_ipaddr) 
echo $lan_ipaddr

hx_keep() {
	logger -t "【宏兴智能组网】" "守护进程启动"
	if [ -s /tmp/script/_opt_script_check ]; then
	sed -Ei '/【宏兴智能组网】|^$/d' /tmp/script/_opt_script_check
	if [ -z "$vntcli_tunname" ] ; then
		tunname="hxsdwan"
	else
		tunname="${hxcli_tunname}"
	fi
	cat >> "/tmp/script/_opt_script_check" <<-OSC
	[ -z "\`pidof hx-cli\`" ] && logger -t "进程守护" "宏兴智能组网 进程掉线" && eval "$scriptfilepath start &" && sed -Ei '/【宏兴智能组网】|^$/d' /tmp/script/_opt_script_check #【宏兴智能组网】
	[ -z "\$(iptables -L -n -v | grep '$tunname')" ] && logger -t "进程守护" "hx-cli 防火墙规则失效" && eval "$scriptfilepath start &" && sed -Ei '/【宏兴智能组网】|^$/d' /tmp/script/_opt_script_check #【宏兴智能组网】
	OSC
	if [ ! -z "$hx_tcp_port" ] ; then
		cat >> "/tmp/script/_opt_script_check" <<-OSC
	[ -z "\$(iptables -L -n -v | grep '$hx_tcp_port')" ] && logger -t "进程守护" "hx-cli 防火墙规则失效" && eval "$scriptfilepath start &" && sed -Ei '/【宏兴智能组网】|^$/d' /tmp/script/_opt_script_check #【宏兴智能组网】
	OSC
	fi
	fi

}

start_hxcli() {
	[ "$hxcli_enable" = "0" ] && exit 1
	logger -t "【宏兴智能组网】" "正在启动hx-cli"
  	if [ -z "$HXCLI" ] ; then
        			HXCLI=/usr/bin/hx-cli
		fi
  		nvram set hxcli_bin=$HXCLI
    	fi
   
/usr/bin/hx-cli -k $hxcli_token $hxcli_serverw -d $hxcli_desname --nic hxsdwan -i $hxcli_localadd -o $lan_ipaddr/24 --ip $hxcli_ip &
}

sleep 4
if [ ! -z "`pidof hx-cli`" ] ; then
logger -t "异地组网" "启动成功"
#放行vpn防火墙
iptables -I INPUT -i hxsdwan -j ACCEPT
iptables -I FORWARD -i hxsdwan -o hxsdwan -j ACCEPT
iptables -I FORWARD -i hxsdwan -j ACCEPT
iptables -t nat -I POSTROUTING -o hxsdwan -j MASQUERADE
#开启arp
ifconfig hxcli arp
else
logger -t "异地组网" "启动失败"
fi

hx_status() {
	if [ ! -z "$hx_process" ] ; then
		hxcpu="$(top -b -n1 | grep -E "$(pidof hx-cli)" 2>/dev/null| grep -v grep | awk '{for (i=1;i<=NF;i++) {if ($i ~ /hx-cli/) break; else cpu=i}} END {print $cpu}')"
		echo -e "\t\t hx-cli 运行状态\n" >$cmdfile
		[ ! -z "$hxcpu" ] && echo "CPU占用 ${hxcpu}% " >>$cmdfile 2>&1
		hxram="$(cat /proc/$(pidof hx-cli | awk '{print $NF}')/status|grep -w VmRSS|awk '{printf "%.2fMB\n", $2/1024}')"
		[ ! -z "$hxram" ] && echo "内存占用 ${vntram}" >>$cmdfile 2>&1
		hxtime=$(cat /tmp/hxcli_time) 
		if [ -n "$hxtime" ] ; then
			time=$(( `date +%s`-hxtime))
			day=$((time/86400))
			[ "$day" = "0" ] && day=''|| day=" $day天"
			time=`date -u -d @${time} +%H小时%M分%S秒`
		fi
		[ ! -z "$time" ] && echo "已运行 ${day}${time}" >>$cmdfile 2>&1
		cmdtart=$(cat /tmp/hx-cli.CMD)
		[ ! -z "$cmdtart" ] && echo "启动参数  $cmdtart" >>$cmdfile 2>&1
		
	else
		echo "$hx_error" >$cmdfile
	fi
	exit 1
}
