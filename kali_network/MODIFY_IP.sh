#!/bin/bash
# 从/iface ens33/ 开始 address 行匹配修改 一行
#sed -i '/iface ens33/,/address/s/'192.168.171.1'/'192.168.101.101'/g' interface
#sed -i '/iface '$INTERFACE_NAME' inet/,/address/s/'192.168.101.104'/'192.168.101.105'/g' interface
# 参数1-->IP 2-->netmask 3-->gateway


MODIFY_IPV4(){
IP_OLD=$(grep 'address' $eth1|sed -n '1p'|awk '{print $2}')
NETMASK_OLD=$(grep 'netmask' $eth1|sed -n '1p'|awk '{print $2}')
GATEWAY_OLD=$(grep 'gateway' $eth1|sed -n '1p'|awk '{print $2}')
sed -i '/iface '$INTERFACE_NAME' inet static/,/address/s/'$IP_OLD'/'$IP_NEW'/g' $eth1
sed -i '/iface '$INTERFACE_NAME' inet static/,/netmask/s/'$NETMASK_OLD'/'$NETMASK_NEW'/g' $eth1
sed -i '/iface '$INTERFACE_NAME' inet static/,/gateway/s/'$GATEWAY_OLD'/'$GATEWAY_NEW'/g' $eth1
}

MODIFY_IPV6(){
IP_OLD=$(grep 'address' $eth1|sed -n '1p'|awk '{print $2}')
NETMASK_OLD=$(grep 'netmask' $eth1|sed -n '1p'|awk '{print $2}')
GATEWAY_OLD=$(grep 'gateway' $eth1|sed -n '1p'|awk '{print $2}')
sed -i '/iface '$INTERFACE_NAME' inet6 static/,/address/s/'$IP_OLD'/'$IP_NEW'/g' $eth1
sed -i '/iface '$INTERFACE_NAME' inet6 static/,/netmask/s/'$NETMASK_OLD'/'$NETMASK_NEW'/g' $eth1
sed -i '/iface '$INTERFACE_NAME' inet6 static/,/gateway/s/'$GATEWAY_OLD'/'$GATEWAY_NEW'/g' $eth1
}



IP_NEW=$1
NETMASK_NEW=$2
GATEWAY_NEW=$3
INTERFACE_NAME=$(ip link show | sed -n -r '/^.: /p' | awk '{print $2}' |cut -d':' -f1 | sed -n '/lo/!p')
eth1=interface

MODIFY_IPV4

#ifconfig eth1 $ipb netmask $maskb
#ip route add default via $gwb dev eth1




