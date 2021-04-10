#!/bin/bash
#title          :enable_port_fwd.bash
#desc           :enables port forwarding
#author         :Matthew Zito (goldmund)
#created        :11/2020
#version        :1.0.0
#usage          :bash ./enable_port_fwd.bash
#environment    :bash 5.0.17(1)-release
#===============================================================================

main() {
  [[ $EUID -ne 0 ]] && {
  echo "[-] This script should be run as root."; exit 1; }

  init
}

init() {
  read -p "[*] Warning: this script will modify your IP Tables configurations. Continue? (y/n) " answer
  case $answer in
    y )
      [[ ! -x $TABLES_F ]] && { echo "[-] \"${TABLES_F}\" not found."; exit 1; }
      echo "[+] Updating rules..."
      echo 1 > /proc/sys/net/ipv4/ip_forward
      # clear rules that potentially interfere with port forwarding
      iptables --flush
      iptables --table nat --flush
      iptables --delete-chain
      iptables --table nat --delete-chain
      iptables -P FORWARD_ACCEPT
      echo "[+] Port forwarding enabled."
      ;;
    n )
      exit 0
      ;;
    * )
      init
      ;;
  esac
}

TABLES_F="/sbin/iptables"

main
