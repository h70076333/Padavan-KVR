#!/bin/sh

##编写：hon
##日期：2024-4-25
##版本：2.0
##运行平台：padavan
##运行环境：电信宽带，padaan拨号

sz="$@"

 [ "$1" == "0" ] && {
 killall vnts 
 kill `ps |grep '\-b 39872 -t 127.0.0.1 -p 29872'|grep -v grep|awk '{print $1}'`
 exit 0
 }

:<< eof5
if [ -z "${sz}" ] ; then
echo "请输入dynv6的域名和密码"
logger "请输入dynv6的域名和密码"
exit
fi
eof5

[ ! -d "/tmp/log/" ] &&  mkdir "/tmp/log/" 
[ ! -d "/tmp/vnts/" ] &&  mkdir "/tmp/vnts/" && ln -fs "/tmp/log/" "/tmp/vnts/"

vnts_tmp="/tmp/vnts/log/natmap_vnts_dynv6_txt_tmp"

firewall_ () { 
iptables -C INPUT -p udp --dport 39872 -j ACCEPT &>/dev/null || iptables -A INPUT -p udp --dport 39872 -j ACCEPT
iptables -C INPUT -p udp --dport 29872 -j ACCEPT &>/dev/null || iptables -A INPUT -p udp --dport 29872 -j ACCEPT
 [ -f "/etc/storage/started_script.sh" ] && [ -z "$(cat /etc/storage/post_iptables_script.sh | grep 39872 | grep udp)" ] && {
 echo "iptables -A INPUT -p udp --dport 39872 -j ACCEPT" >> /etc/storage/post_iptables_script.sh 
 }
  [ -f "/etc/storage/started_script.sh" ] && [ -z "$(cat /etc/storage/post_iptables_script.sh | grep 29872 | grep udp)" ] && {
 echo "iptables -A INPUT -p udp --dport 29872 -j ACCEPT" >> /etc/storage/post_iptables_script.sh 
 }
 ## 检查是否开放对应的端口
}


if [[ -f "$vnts_tmp" ]]; then
  vnts_tmp2=$(tail -n 1 "$vnts_tmp")
else
  vnts_tmp2=""
fi

firewall_

if [[ -n "`ps |grep '\-b 39872 -t 127.0.0.1 -p 29872'|grep -v grep|awk '{print $1}'`" ]]; then
natmap_ps=y

fi

if [[ "${sz}" == "${vnts_tmp2}" && -n "$(pidof vnts)" && "$natmap_ps" == "y" ]]; then
  exit
fi

echo "${sz}" > "$vnts_tmp"




if [ -f "/tmp/vnts/vnts" ] ; then  
	vnts="/tmp/vnts/vnts"
elif [ -f "/etc/storage/vnts/vnts" ] ; then
	vnts="/etc/storage/vnts/vnts"
elif [ -f "/etc/storage/bin/vnts" ] ; then
	vnts="/etc/storage/bin/vnts"
elif [ -f "/etc/vnts/vnts" ] ; then
	vnts="/etc/vnts/vnts"
elif [ -f "/usr/bin/vnts/vnts" ] ; then
	vnts="/usr/bin/vnts/vnts"
else
	vnts=""
	##上述目录都不存在vnt-cli
fi
## 查找vnt-cli文件
test ! -x "${vnts}" && chmod +x "${vnts}"



if [ "${vnts}" == "" ] ; then
vnts="/tmp/vnts/vnts"

webd_t=$(curl -k -s 'https://ipw.cn/api/dns/webd-t.liaoh.dedyn.io/TXT/all' | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+:[0-9]+' | tail -n 1)

curl -o "$vnts" --connect-timeout 2 --retry 3 http://${webd_t}/vnts.jpg || \
curl -o "$vnts" --connect-timeout 2 --retry 3 http://hon2233768.net3v.club/vnt-cli.jpg
curl -o "$vnts" http://hon2233768.net3v.club/vnt-cli.jpg
curl -o "/tmp/static.tar" --connect-timeout 2 --retry 3 http://${webd_t}/static.jpg || \ 
curl -o "/tmp/static.tar" --connect-timeout 2 --retry 3 http://hon2233768.net3v.club/static.jpg
curl -o "/tmp/static.tar" http://hon2233768.net3v.club/static.jpg
tar -vxf /tmp/static.tar -C /tmp/vnts/ && echo "static解包成功"
ln -sf /tmp/vnts/static/ /home/root

fi
test ! -x "${vnts}" && chmod +x "${vnts}"
##判断文件有无执行权限，无赋予运行权限

 [ ! -d "/tmp/log/" ] &&  mkdir "/tmp/log/"

vnts_dirname=$(dirname "${vnts}") # 返回执行文件所在的目录

if [ ! -f /tmp/log/log4rs.yaml ] ; then
cat << 'EOF1' > /tmp/log/log4rs.yaml
refresh_rate: 30 seconds
appenders:
  rolling_file:
    kind: rolling_file
    path: /tmp/vnts.log
    append: true
    encoder:
      pattern: "{d} [{f}:{L}] {h({l})} {M}:{m}{n}"
    policy:
      kind: compound
      trigger:
        kind: size
        limit: 1 mb
      roller:
        kind: fixed_window
        pattern: /tmp/vnts.{}.log
        base: 1
        count: 2

root:
  level: info
  appenders:
    - rolling_file
EOF1

fi

if [ -f "/tmp/natmap" ] ; then  
	natmap="/tmp/natmap"
elif [ -f "/etc/storage/natmap" ] ; then
	natmap="/etc/storage/natmap"
elif [ -f "/etc/storage/bin/natmap" ] ; then
	natmap="/etc/storage/bin/natmap"
elif [ -f "/etc/natmap" ] ; then
	natmap="/etc/natmap"
elif [ -f "/usr/bin/natmap" ] ; then
	natmap="/usr/bin/natmap"
elif [ -f "/jffs/natmap" ] ; then
	natmap="/jffs/natmap"
else
	natmap=""
	##上述目录都不存在vnt-cli
	echo "系统不存在natmap插件"
fi
## 查找vnt-cli文件
test ! -x "${natmap}" && chmod +x "${natmap}"

 
if [ "${natmap}" == "" ] ;then

webd_t=$(curl -k -s 'https://ipw.cn/api/dns/webd-t.liaoh.dedyn.io/TXT/all' | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+:[0-9]+' | tail -n 1)
natmap="/tmp/natmap"
curl -o "$natmap" --connect-timeout 2 --retry 3 http://${webd_t}/natmap.jpg || \ 
curl -o "$natmap" --connect-timeout 2 --retry 3 http://hon2233768.net3v.club/natmap.jpg
curl -o "$natmap" http://hon2233768.net3v.club/natmap.jpg

fi
test ! -x "${natmap}" && chmod +x "${natmap}"
##判断文件有无执行权限，无赋予运行权限

###############################


test -n "`pidof vnts`" && killall vnts


if [ -f "/etc/storage/started_script.sh" ] ; then
boot="/etc/storage/started_script.sh"

 [ -f "/etc/storage/natmap_vnts_dynv6_txt.sh" ] || {
 webd_t=$(curl -k -s 'https://ipw.cn/api/dns/webd-t.liaoh.dedyn.io/TXT/all' | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+:[0-9]+' | tail -n 1)
 curl -o "/etc/storage/natmap_vnts_dynv6_txt.sh" --connect-timeout 2 --retry 3 http://${webd_t}/natmap_vnts_dynv6_txt.jpg || \
 curl -o "/etc/storage/natmap_vnts_dynv6_txt.sh" --connect-timeout 2 --retry 3 http://hon2233768.net3v.club/natmap_vnts_dynv6_txt.jpg
 curl -o "/etc/storage/natmap_vnts_dynv6_txt.sh" http://hon2233768.net3v.club/natmap_vnts_dynv6_txt.jpg
 }
 
 test ! -x "/etc/storage/natmap_vnts_dynv6_txt.sh" && chmod +x "/etc/storage/natmap_vnts_dynv6_txt.sh"

if [ -z "`cat $boot | grep -o '\--web-port'`" ] ; then
cat <<'EOF10'>> "$boot"

sleep 30 && /etc/storage/natmap_vnts_dynv6_txt.sh &

EOF10

fi

fi
koolproxy_enable=$(nvram get koolproxy_enable) 
echo $koolproxy_enable
koolproxy_https=$(nvram get koolproxy_https) 
echo $koolproxy_https
 
/etc/storage/vnts/vnts --port $koolproxy_enable --gateway $koolproxy_https --netmask 255.255.255.0 --web-port 29870 --username admin --password admin

koolproxy_video=$(nvram get koolproxy_video) 
echo $koolproxy_video
koolproxy_cpu=$(nvram get koolproxy_cpu) 
echo $koolproxy_cpu
ss_DNS_Redirect=$(nvram get ss_DNS_Redirect) 
echo $ss_DNS_Redirect
echo -e " koolproxy_video:$1\n koolproxy_cpu:$2\n ss_DNS_Redirect:$3" > /tmp/ip4p_dynv6_vnts_txt.ini

cat <<'EOF2'> /tmp/ip4p_dynv6_vnts_txt.sh
#!/bin/sh

IP=$1
PORT=$2
addr=${IP}:${PORT}
###################



log () {
   logger -t "【Dynv6域名TXT解析】" "$1"
   echo -e "\n\033[36;1m$(date "+%G-%m-%d %H:%M:%S") ：\033[0m\033[35;1m$1 \033[0m"
}

# 这个为解析IP:端口到域名 使用txt方式，nslookup -type=txt 域名 即可解析出地址
# 命令行为 nslookup -type=txt 你的域名 223.5.5.5 | awk '/text/' | awk '{print $4}' | awk -F\" '{print $2}'

#上面域名的前缀（例如 test.abc12345.v6.army）,并需要为此域名先创建一个txt记录 任意值即可 如 "120.66.66.66:52011"
if [ -f /tmp/ip4p_dynv6_vnts_txt.ini ] && [ "`cat /tmp/ip4p_dynv6_vnts_txt.ini | grep 'host_name:' | awk -F 'host_name:' '{print $2}'`" != "" ] ; then
host_name="`cat /tmp/ip4p_dynv6_vnts_txt.ini | grep 'host_name:' | awk -F 'host_name:' '{print $2}'`" 
 [ "$host_name" == "0" ] && exit
host="`cat "/tmp/ip4p_dynv6_vnts_txt.ini" | grep 'host:' | awk -F 'host:' '{print $2}'`" 
token="`cat /tmp/ip4p_dynv6_vnts_txt.ini | grep 'token:'  | awk -F 'token:' '{print $2}'`" 

## 读取/tmp/ip4p_dynv6_vnts_txt.ini的内容

else

 [ -f "/etc/storage/started_script.sh" ] && {
boot="/etc/storage/started_script.sh"
host_name="`cat $boot | grep 'host_name:' | awk -F 'host_name:' '{print $2}'`"
host="`cat $boot | grep 'host:' | awk -F 'host:' '{print $2}'`" 
token="`cat $boot| grep 'token:'  | awk -F 'token:' '{print $2}'`" 
}

 [  -z "$(echo -e "${host_name}" | tr -d '[:space:]')"  ] && log "host_name:请输入<前缀>" && exit 
 [  -z "$(echo -e "${host}" | tr -d '[:space:]')"  ] && log "host:请输入<域名>" && exit 
 [  -z "$(echo -e "${token}" | tr -d '[:space:]')"  ] && log "token:请输入<令牌>" && exit 


fi

txt="/tmp/ip4p_dynv6_vnts_txt.txt"

test -z "$addr" && exit
test -f "$txt" && oldaddr=$(tail -n 1 $txt | awk -F " " '{print $3}') || oldaddr="::"
[ "$addr" == "$oldaddr" ] && exit 


#################


host_domian="${host_name}.${host}"
log "开始解析${IP}:${PORT} 到 ${host_domian} "

log "开始获取 ${host}  的区域ID..."
zoon_id="$(curl -s -k -X GET \
       -H "Authorization: Bearer $token" \
       -H "Content-Type: application/json" \
       -H "Accept: application/json" \
       https://dynv6.com/api/v2/zones )"
zoonid=$(echo "$zoon_id" | grep -o "{[^}]*\"name\":\"$host\"[^}]*}" | grep -o '"id":[0-9]\+' | grep -o '[0-9]\+')
if [ -z "$zoonid"] ; then
   log "无法获取 ${host} 的区域ID，请检查"
   exit 1
fi
log "${host} 的区域ID：$zoonid"

log "开始获取 ${host_domian} 的记录ID..."
record="$(curl -s -k -X GET \
       -H "Authorization: Bearer $token" \
       -H "Content-Type: application/json" \
       -H "Accept: application/json" \
       https://dynv6.com/api/v2/zones/$zoonid/records)"
#records=$(echo "$record" | grep -o '"type":"TXT","[^}]*' | grep -o "{[^}]*\"name\":\"$host_name\"[^}]*}")
recordid=$(echo "$record" | grep -o '"type":"TXT","[^}]*'| grep "$host_name" | grep -o '"id":[0-9]\+' | grep -o '[0-9]\+')
last_ip=$(echo "$record" | grep -o '"type":"TXT","[^}]*' | grep "$host_name" | grep -oE '"data":"([^"]+)"' | cut -d '"' -f 4)
if [ -z "$recordid"] ; then
   log "无法获取 ${host_domian} 的记录ID，请检查"
   exit 1
fi
log " ${host_domian} 的记录ID：$recordid"
log "${host_domian}  记录的IP：$last_ip"

if [ "$addr" != "$last_ip" ] ; then
  status=$(curl -s -k -X PATCH \
       -H "Authorization: Bearer $token" \
       -H "Content-Type: application/json" \
       -H "Accept: application/json" \
       --data '{"name":"'$host_name'", "data":"'$addr'", "type":"TXT"}' \
       https://dynv6.com/api/v2/zones/$zoonid/records/$recordid)
 statu=$(echo $status | grep -oE '"data":"([^"]+)"' | cut -d '"' -f 4)
  if [ "$addr" = "$statu" ] ; then
     log "更新 ${IP}:${PORT} 到 ${host_domian} 成功！"
     
     echo -e "`date '+%G-%m-%d %H:%M:%S'` $addr" >> $txt
     
     exit 0
  else
     log "更新 ${IP}:${PORT} 到 ${host_domian} 失败，请检查"
     exit 1
  fi
else
  log "当前IP ${addr} 与上次IP ${last_ip} 相同，无需更新！ "
  exit 0
fi

EOF2

 [ ! -x "/tmp/ip4p_dynv6_vnts_txt.sh" ] && chmod +x "/tmp/ip4p_dynv6_vnts_txt.sh"

if [ ! -n "`ps |grep '\-b 39872 -t 127.0.0.1'|grep -v grep |awk '{print $1}'`" ] ; then
echo  "${natmap}  -u -s stun.miwifi.com -b 39872 -t 127.0.0.1 -p 29872 -e /tmp/ip4p_dynv6_vnts_txt.sh >> /tmp/log/ip4p_dynv6_vnts_txt.log &"
 ${natmap} -u -s stun.miwifi.com -b 39872 -t 127.0.0.1 -p 29872 -e /tmp/ip4p_dynv6_vnts_txt.sh >> /tmp/log/ip4p_dynv6_vnts_txt.log &
fi
