#!/bin/bash
num=$1'p' 
NEW_DNS=$2
SELECT=$3
DNS_PATH="/etc/resolv.conf"

#输入参数：1选项(选择某行,防止相同，查询不到该行数的内容就直接追加在后面)、2新的dns、3配置项目ipv4-->4 ipv6-->6 删除-->0

modify_dns(){
	if [ $SELECT == 4 ];then
		dns=$(sudo cat $DNS_PATH |sed -n '/nameserver/p' | awk '{print $2}' | sed -n '/\./p' | sed -n $num)

		if [ ! -n "$dns" ];then
                        echo "nameserver $NEW_DNS">>$DNS_PATH
                else
                       # sed -i "s/${dns}/${NEW_DNS}/" ${DNS_PATH}
			sed -i "0,/$dns/{s/$dns/$NEW_DNS/}" ${DNS_PATH}
                fi

	elif [ $SELECT == 6 ];then
		dns=$(sudo cat $DNS_PATH |sed -n '/nameserver/p' | awk '{print $2}' | sed -n '/:/p' | sed -n $num)

                if [ ! -n "$dns" ];then
			echo "nameserver $NEW_DNS">>$DNS_PATH
		else
                	#sed -i "s/$dns/$NEW_DNS/" ${DNS_PATH}
			sed -i "0,/$dns/{s/$dns/$NEW_DNS/}" ${DNS_PATH}
		fi

	elif [ $SELECT == 0 ];then
		sed -i "0,/$NEW_DNS/{//d}" $DNS_PATH

	else
		echo "选项错误，请输入正确选项。"
		exit 119
	fi
}


if [ $# == 3 ];then
	modify_dns
else
	echo "参数数量错误！执行失败"
	exit 119

fi
