#!/bin/bash
#修改网卡
#目前只支持单网卡


DHCPv4_DHCPv6_CONFIG_CREATE (){
  #写入全新dhcpv4\dhcpv6
        cat>$INTERFACE_DIR<<-EOF
    # This file describes the network interfaces available on your system
    # and how to activate them. For more information, see interfaces(5).

    source /etc/network/interfaces.d/*

    # The loopback network interface
    auto lo
    iface lo inet loopback

    auto $INTERFACE_NAME
         iface $INTERFACE_NAME inet dhcp
         iface $INTERFACE_NAME inet6 dhcp
EOF
                #重启网卡，检测是否能ping通
}

DHCPv4_CONFIG_CREATE (){
  #写入全新dhcpv4
	cat>$INTERFACE_DIR<<-EOF
    # This file describes the network interfaces available on your system
    # and how to activate them. For more information, see interfaces(5).

    source /etc/network/interfaces.d/*

    # The loopback network interface
    auto lo
    iface lo inet loopback

    auto $INTERFACE_NAME
		iface $INTERFACE_NAME inet dhcp
		EOF
		#重启网卡，检测是否能ping通
}



DHCPv6_CONFIG_CREATE (){
  #写入全新dhcpv4
	cat>$INTERFACE_DIR<<-EOF
    # This file describes the network interfaces available on your system
    # and how to activate them. For more information, see interfaces(5).

    source /etc/network/interfaces.d/*

    # The loopback network interface
    auto lo
    iface lo inet loopback

    auto $INTERFACE_NAME
		iface $INTERFACE_NAME inet6 dhcp
		EOF
		#重启网卡，检测是否能ping通
}



STATIC_IPv4_CONFIG_CREATE (){
  #写入新的网卡配置
	cat>${INTERFACE_DIR}<<-EOF
    # This file describes the network interfaces available on your system
    # and how to activate them. For more information, see interfaces(5).

    source /etc/network/interfaces.d/*

    # The loopback network interface
    auto lo
    iface lo inet loopback

    auto $INTERFACE_NAME
		iface $INTERFACE_NAME inet static
		address $ADDRESS
		netmask $NETMASK
		gateway $GATEWAY
		hwaddress ether $MAC
		EOF
}


STATIC_IPv6_CONFIG_CREATE (){
  #写入新的网卡配置
	cat>${INTERFACE_DIR}<<-EOF
    # This file describes the network interfaces available on your system
    # and how to activate them. For more information, see interfaces(5).

    source /etc/network/interfaces.d/*

    # The loopback network interface
    auto lo
    iface lo inet loopback

    auto $INTERFACE_NAME
		iface $INTERFACE_NAME inet6 static
		address $ADDRESS
		netmask $NETMASK
		gateway $GATEWAY
		hwaddress ether $MAC
		EOF
}




STATIC_IPv4_IPv6_CONFIG_CREATE (){
  #写入新的网卡配置
  if [ $ADDRESS_IPV6 == "None" ];then
    cat>${INTERFACE_DIR}<<-EOF
      # This file describes the network interfaces available on your system
      # and how to activate them. For more information, see interfaces(5).

      source /etc/network/interfaces.d/*

      # The loopback network interface
      auto lo
      iface lo inet loopback

      auto $INTERFACE_NAME
      iface $INTERFACE_NAME inet static
      address $ADDRESS
      netmask $NETMASK
      gateway $GATEWAY
      hwaddress ether $MAC

EOF
  else
    cat>${INTERFACE_DIR}<<-EOF
      # This file describes the network interfaces available on your system
      # and how to activate them. For more information, see interfaces(5).

      source /etc/network/interfaces.d/*

      # The loopback network interface
      auto lo
      iface lo inet loopback

      auto $INTERFACE_NAME
      iface $INTERFACE_NAME inet static
      address $ADDRESS
      netmask $NETMASK
      gateway $GATEWAY

    auto $INTERFACE_NAME
      iface $INTERFACE_NAME inet6 static
      address $ADDRESS_IPV6
      netmask $NETMASK_IPV6
      gateway $GATEWAY_IPV6

      hwaddress ether $MAC
EOF
    fi
}

STATIC_IPv4_DHCPv6_CONFIG_CREATE (){
  	cat>${INTERFACE_DIR}<<-EOF
    # This file describes the network interfaces available on your system
    # and how to activate them. For more information, see interfaces(5).

    source /etc/network/interfaces.d/*

    # The loopback network interface
    auto lo
    iface lo inet loopback

    auto $INTERFACE_NAME
		iface $INTERFACE_NAME inet static
		address $ADDRESS
		netmask $NETMASK
		gateway $GATEWAY

	auto $INTERFACE_NAME
		iface $INTERFACE_NAME inet6 dhcp

		hwaddress ether $MAC
		EOF
}

STATIC_IPv6_DHCPv4_CONFIG_CREATE (){
  if [ $ADDRESS == "None" ];then
  	cat>${INTERFACE_DIR}<<-EOF
    # This file describes the network interfaces available on your system
    # and how to activate them. For more information, see interfaces(5).

    source /etc/network/interfaces.d/*

    # The loopback network interface
    auto lo
    iface lo inet loopback
	  auto $INTERFACE_NAME
		iface $INTERFACE_NAME inet dhcp

		hwaddress ether $MAC
		EOF
  else
  	cat>${INTERFACE_DIR}<<-EOF
    # This file describes the network interfaces available on your system
    # and how to activate them. For more information, see interfaces(5).

    source /etc/network/interfaces.d/*

    # The loopback network interface
    auto lo
    iface lo inet loopback

    auto $INTERFACE_NAME
		iface $INTERFACE_NAME inet6 static
		address $ADDRESS
		netmask $NETMASK
		gateway $GATEWAY

	auto $INTERFACE_NAME
		iface $INTERFACE_NAME inet dhcp

		hwaddress ether $MAC
		EOF
  fi
}

#$2 ip  $3 netmask $4 gateway $5 mac
NUM=$1
INTERFACE_NAME=$(ip link show | sed -n -r '/^.: /p' | awk '{print $2}' |cut -d':' -f1 | sed -n '/lo/!p')
ADDRESS=$2
NETMASK=$3
GATEWAY=$4
ADDRESS_IPV6=$6
NETMASK_IPV6=$7
GATEWAY_IPV6=$8
MAC=$5
INTERFACE_DIR='/etc/network/interfaces'   #修改网卡路径

# 0 DHCPv4_CONFIG_CREATE 1 DHCPv6_CONFIG_CREATE 2 DHCPv4_DHCPv6_CONFIG_CREATE 3 STATIC_IPv4_CONFIG_CREATE 4 STATIC_IPv6_CONFIG_CREATE
#0dhcpv4 1dhcpv6 2dhcpv4+dhcpv6 3ipv4静态 4ipv6静态 5静态ipv4 + ipv6

if [ $NUM == 0 ];then
  DHCPv4_CONFIG_CREATE
elif [ $NUM == 1 ];then
  DHCPv6_CONFIG_CREATE
elif [ $NUM == 2 ];then
  DHCPv4_DHCPv6_CONFIG_CREATE
elif [ $NUM == 3 ];then
  if [ $# == 5 ];then
    STATIC_IPv4_CONFIG_CREATE
  else
      echo "参数输入错误！"
      exit 119
   fi
elif [ $NUM == 4 ];then
  if [ $# == 5 ];then
    STATIC_IPv6_CONFIG_CREATE
  else
      echo "参数输入错误！"
      exit 119
   fi
elif [ $NUM == 5 ];then
  if [ $# == 8 ];then
    STATIC_IPv4_IPv6_CONFIG_CREATE
  else
      echo "参数输入错误！"
      exit 119
   fi

elif [ $NUM == 6 ];then
  if [ $# == 5 ];then
    STATIC_IPv4_DHCPv6_CONFIG_CREATE
  else
      echo "参数输入错误！"
      exit 119
   fi

elif [ $NUM == 7 ];then
  if [ $# == 5 ];then
    STATIC_IPv6_DHCPv4_CONFIG_CREATE
  else
      echo "参数输入错误！"
      exit 119
   fi


else
  echo "参数输入错误！"
  exit 119
fi

