#!/bin/bash

#输入1是备份 0是还原 其他错误119

DEFINE_CONFIG_BACKUP(){
	#备份网卡文件
	sudo \rm -f ${INTERFACE_DIR}*.bak
	sudo \cp ${INTERFACE_DIR}{,.bak}
	#备份DNS配置文件
	sudo \cp /etc/resolv.conf /opt/resolv.conf.bak
}

DEFINE_CONFIG_RESTORE(){
	#还原网卡文件
	sudo \cp {,.bak}${INTERFACE_DIR}

	#还原DNS配置文件
	sudo \cp /etc/resolv.conf.bak /etc/resolv.conf
}


INTERFACE_DIR="/etc/network/interfaces"
NUM=$1
if [ $NUM == 1 ];then
  DEFINE_CONFIG_BACKUP
elif [ $NUM == 0 ]; then
  #检测备份文件是否存在
  if [  ! -f "$INTERFACE_DIR.bak" ];then
    echo "网卡备份文件不存在！"
    exit 119
  elif [ ! -f "/etc/resolv.conf.bak" ];then
    echo "DNS备份文件不存在！"
    exit 119
  else
    DEFINE_CONFIG_RESTORE
  fi

else
  echo "参数输入错误！"
  exit 119
fi


