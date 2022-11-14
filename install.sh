#!/usr/bin/env bash

set +e

if [[ $(id -u) != 0 ]]; then
  echo -e "Please run this script as root or sudoer."
  exit 1
fi

ERROR="1;31m"
SUCCESS="1;32m"
WARNING="1;33m"
INFO="1;36m"
LINK="1;92m"

color_echo(){
  COLOR=$1
  echo -e "\033[${COLOR}${@:2}\033[0m"
}

install_base() {
    color_echo ${INFO} "Installing all necessary software..."
    apt-get update -q &>/dev/null
    apt-get install sudo git curl xz-utils wget apt-transport-https gnupg lsb-release unzip resolvconf ntpdate \
      systemd dbus ca-certificates locales iptables software-properties-common cron e2fsprogs less neofetch \
      whiptail dnsutils jq -q -y &>/dev/null
    apt-get install bc -q -y &>/dev/null
    sh -c 'echo "y\n\ny\ny\n" | DEBIAN_FRONTEND=noninteractive apt-get install ntp -q -y' &>/dev/null
    color_echo ${SUCCESS} "Requirements installed."
    echo ""
}

export DEBIAN_FRONTEND=noninteractive
install_base

color_echo ${INFO} "Getting system info..."
mkdir /root/auto-trojan/ &>/dev/null
if [[ ! -f /root/auto-trojan/ip.json ]]; the
  curl --ipv4 --retry 3 -s https://ipinfo.io?token=56c375418c62c9 --connect-timeout 5 &> /root/auto-trojan/ip.json
fi
local_ip=$(ip -4 a | grep inet | grep "scope global" | awk '{print $2}' | cut -d'/' -f1 | head -n 1)
my_ipv6=$(ip -6 a | grep inet6 | grep "scope global" | awk '{print $2}' | cut -d'/' -f1 | head -n 1)
my_ip="$( jq -r '.ip' "/root/auto-trojan/ip.json" )"
my_country="$( jq -r '.country' "/root/auto-trojan/ip.json" )"
my_city="$( jq -r '.city' "/root/auto-trojan/ip.json" )"
echo "IP: $my_ip   Local: $local_ip"
echo "IPv6: $my_ipv6"
echo "Country: $my_country"
echo "City: $my_city"