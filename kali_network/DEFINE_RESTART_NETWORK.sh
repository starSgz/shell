#!/bin/bash
DEFINE_RESTART_NETWORK (){
#目前仅支持单网卡
  INTERFACE_NAME=$(ip link show | sed -n -r '/^.: /p' | awk '{print $2}' |cut -d':' -f1 | sed -n '/lo/!p')
        echo -e "\033[32m       网卡${INTERFACE_NAME}IP修改成功,网络重启中，请使用新IP链接服务器................the end !\033[0m"
        #先清空网卡配置，再重启网卡重新加载配置
        sudo ip addr flush dev ${INTERFACE_NAME}
        sudo systemctl restart networking.service
}

DEFINE_RESTART_NETWORK

