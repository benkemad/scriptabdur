#!/bin/bash

read -p "Username : " Login
read -p "Password : " Pass
read -p "Expired (hari): " masaaktif

IP=$(wget -qO- ipv4.icanhazip.com);

# Modifikasi Terminal

white='\e[1;37m'
green='\e[32m'
purple='\e[1;35m'
blue='\e[0;31m'
red='\e[1;32m'

echo ""
echo -e $white"      =====================================================" 
sleep 0.5
echo -e $purple "      #                                                   #" 
sleep 0.5
echo -e $green "      #               [ PROSES MEMBUAT AKUN ]              #" 
sleep 0.5
echo -e $blue "      #                                                   #" 
sleep 0.5
echo -e $green "      #                   Mohon menunggu                  #" 
sleep 0.5
echo -e $red "      #                                                   #" 
sleep 0.5
echo -e $blue "      #              Akun Telah Berhasil Dibuat           #" 
sleep 0.5
echo -e $red "      #                                                  #" 
sleep 0.5
echo -e $purple "      #                  Terima Kasih                   #" 
sleep 0.5
echo -e $green "      #                                                   #" 
sleep 0.5
echo -e $blue "      #        Copyright © AbdurRahman™ Premium 2020        #" 
sleep 0.5
echo -e $white "      =====================================================" 
clear
clear
useradd -e `date -d "$masaaktif days" +"%Y-%m-%d"` -s /bin/false -M $Login
exp="$(chage -l $Login | grep "Account expires" | awk -F": " '{print $2}')"
echo -e "$Pass\n$Pass\n"|passwd $Login &> /dev/null
echo -e ""
echo -e "--------------------------------------"
echo -e "     account creation successfully"
echo -e "--------------------------------------"
echo -e "         Configuration Detail"
echo -e "--------------------------------------"
echo -e ""
echo -e "Host         : $IP"
echo -e "Username     : $Login"
echo -e "Password     : $Pass"
echo -e "Exp account  : $exp"
echo -e "Port OpenSSH : 22"
echo -e "Port Dropbear: 109,110,143"
echo -e "Port SSL     : 443,777,990"
echo -e "BadVPN UDPGW : 7200,7300"
echo -e "Squid Proxy  : 80,3128,8080"
echo -e "OpenVPN TCP  : http://$IP:81/client-tcp-1194.ovpn"
echo -e "OpenVPN SSL  : http://$IP:81/client-udp-2200.ovpn"
echo -e "OpenVPN UDP  : http://$IP:81/client-ssl-2905.ovpn"
echo -e ""
echo -e "--------------------------------------"
echo -e "-)No Torrent"
echo -e "-)No Carding"
echo -e "-)No illegal activity"
echo -e "-)Max Login 2 Devices"
echo -e "-)If Not follow the Rule your account"
echo -e "  Will be banned"
echo -e "--------------------------------------"
echo -e "Script by AdminRumahConfig"
