#!/bin/bash
#
# Original script by fornesia, rzengineer and fawzya 
# Mod by Kemaddd
# 
# ==================================================

# initializing var
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;
MYIP=$(wget -qO- ipv4.icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";

# go to root
cd

# Edit file /etc/systemd/system/rc-local.service
cat > /etc/systemd/system/rc-local.service <<-END
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
[Install]
WantedBy=multi-user.target
END

# nano /etc/rc.local
cat > /etc/rc.local <<-END
#!/bin/sh -e
# rc.local
# By default this script does nothing.
exit 0
END

# Ubah izin akses
chmod +x /etc/rc.local

# enable rc local
systemctl enable rc-local
systemctl start rc-local.service

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

#update
apt-get update -y

# install wget and curl
apt-get -y install wget curl

# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config

# set repo
echo 'deb http://download.webmin.com/download/repository sarge contrib' >> /etc/apt/sources.list.d/webmin.list
wget "http://www.dotdeb.org/dotdeb.gpg"
cat dotdeb.gpg | apt-key add -;rm dotdeb.gpg
wget -qO - http://www.webmin.com/jcameron-key.asc | apt-key add -

# update
apt-get update

# install webserver
apt-get -y install nginx

# install neofetch
apt-get update -y
apt-get -y install gcc
apt-get -y install make
apt-get -y install cmake
apt-get -y install git
apt-get -y install screen
apt-get -y install unzip
apt-get -y install curl
git clone https://github.com/dylanaraps/neofetch
cd neofetch
make install
make PREFIX=/usr/local install
make PREFIX=/boot/home/config/non-packaged install
make -i install
apt-get -y install neofetch
cd
echo "clear" >> .profile
echo "neofetch" >> .profile
echo "echo by Horasss" >> .profile

# install webserver
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/marloxxx/install/master/nginx.conf"
mkdir -p /home/vps/public_html
echo "<pre>Setup by Horasss</pre>" > /home/vps/public_html/index.html
wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/marloxxx/install/master/vps.conf"

# install badvpn
cd
wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/marloxxx/install/master/badvpn-udpgw64"
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500' /etc/rc.local
chmod +x /usr/bin/badvpn-udpgw
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500
cd
wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/marloxxx/install/master/badvpn-udpgw64"
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500' /etc/rc.local
chmod +x /usr/bin/badvpn-udpgw
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500

# setting port ssh
sed -i 's/Port 22/Port 22/g' /etc/ssh/sshd_config

# install dropbear
apt-get -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=143/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 110 -p 109 -p 456"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
/etc/init.d/dropbear restart

# install squid
cd
apt-get -y install squid3
wget -O /etc/squid/squid.conf "https://raw.githubusercontent.com/marloxxx/install/master/squid3.conf"
sed -i $MYIP2 /etc/squid/squid.conf

# setting vnstat
apt-get -y update;apt-get -y install vnstat;vnstat -u -i eth0;service vnstat restart 

# install webmin
apt-get -y install webmin
sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf

# install stunnel
apt-get install stunnel4 -y
cat > /etc/stunnel/stunnel.conf <<-END
cert = /etc/stunnel/stunnel.pem
client = no
socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1

[dropbear]
accept = 443
connect = 127.0.0.1:109

[dropbear]
accept = 777
connect = 127.0.0.1:109

[dropbear]
accept = 222
connect = 127.0.0.1:109

[dropbear]
accept = 990
connect = 127.0.0.1:109

[openvpn]
accept = 2905
connect = 127.0.0.1:1194

END

# make a certificate
wget -O /etc/stunnel/stunnel.pem "https://raw.githubusercontent.com/marloxxx/install/master/stunnel.pem.crt"

# konfigurasi stunnel
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
/etc/init.d/stunnel4 restart

# install fail2ban
apt-get -y install fail2ban

# Instal DDOS Flate
if [ -d '/usr/local/ddos' ]; then
	echo; echo; echo "Please un-install the previous version first"
	exit 0
else
	mkdir /usr/local/ddos
fi
clear
echo; echo 'Installing DOS-Deflate 0.6'; echo
echo; echo -n 'Downloading source files...'
wget -q -O /usr/local/ddos/ddos.conf http://www.inetbase.com/scripts/ddos/ddos.conf
echo -n '.'
wget -q -O /usr/local/ddos/LICENSE http://www.inetbase.com/scripts/ddos/LICENSE
echo -n '.'
wget -q -O /usr/local/ddos/ignore.ip.list http://www.inetbase.com/scripts/ddos/ignore.ip.list
echo -n '.'
wget -q -O /usr/local/ddos/ddos.sh http://www.inetbase.com/scripts/ddos/ddos.sh
chmod 0755 /usr/local/ddos/ddos.sh
cp -s /usr/local/ddos/ddos.sh /usr/local/sbin/ddos
echo '...done'
echo; echo -n 'Creating cron to run script every minute.....(Default setting)'
/usr/local/ddos/ddos.sh --cron > /dev/null 2>&1
echo '.....done'
echo; echo 'Installation has completed.'
echo 'Config file is at /usr/local/ddos/ddos.conf'
echo 'Please send in your comments and/or suggestions to zaf@vsnl.com'

# Save & restore IPTABLES
#wget -O /etc/iptables.up.rules "https://raw.githubusercontent.com/marloxxx/centos6/master/iptables.up.rules"
#sed -i '$ i\iptables-restore < /etc/iptables.up.rules' /etc/rc.local
#sed -i '$ i\iptables-restore < /etc/iptables.up.rules' /etc/rc.d/rc.local
#MYIP=`curl icanhazip.com`;
#MYIP2="s/xxxxxxxxx/$MYIP/g";
#sed -i $MYIP2 /etc/iptables.up.rules;
#sed -i 's/venet0/eth0/g' /etc/iptables.up.rules
#iptables-restore < /etc/iptables.up.rules
#sysctl -w net.ipv4.ip_forward=1
#sed -i 's/net.ipv4.ip_forward = 0/net.ipv4.ip_forward = 1/g' /etc/sysctl.conf
#cp /etc/sysconfig/iptables /etc/iptables.up.rules
#chmod +x /etc/iptables.up.rules
#service iptables restart
#cd

#security limite login 
#wget -O /etc/security/limits.conf "https://raw.githubusercontent.com/marloxxx/centos6/master/limits.conf"
#chmod +x /etc/security/limits.conf

# limite login
#iptables -A INPUT -p tcp --syn --dport 22 -m connlimit --connlimit-above 2 -j REJECT
#iptables -A INPUT -p tcp --syn --dport 143 -m connlimit --connlimit-above 2 -j REJECT
#iptables -A INPUT -p tcp --syn --dport 109 -m connlimit --connlimit-above 2 -j REJECT
#iptables -A INPUT -p tcp --syn --dport 110 -m connlimit --connlimit-above 2 -j REJECT
#iptables -A INPUT -p tcp --syn --dport 456 -m connlimit --connlimit-above 2 -j REJECT
#iptables -A INPUT -p tcp --syn --dport 443 -m connlimit --connlimit-above 2 -j REJECT
#service iptables save
#service iptables restart

# xml parser
cd
apt-get install -y libxml-parser-perl

# blockir torrent
#iptables -A OUTPUT -p tcp --dport 6881:6889 -j DROP
#iptables -A OUTPUT -p udp --dport 1024:65534 -j DROP
#iptables -A FORWARD -m string --string "get_peers" --algo bm -j DROP
#iptables -A FORWARD -m string --string "announce_peer" --algo bm -j DROP
#iptables -A FORWARD -m string --string "find_node" --algo bm -j DROP
#iptables -A FORWARD -m string --algo bm --string "BitTorrent" -j DROP
#iptables -A FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP
#iptables -A FORWARD -m string --algo bm --string "peer_id=" -j DROP
#iptables -A FORWARD -m string --algo bm --string ".torrent" -j DROP
#iptables -A FORWARD -m string --algo bm --string "announce.php?passkey=" -j DROP
#iptables -A FORWARD -m string --algo bm --string "torrent" -j DROP
#iptables -A FORWARD -m string --algo bm --string "announce" -j DROP
#iptables -A FORWARD -m string --algo bm --string "info_hash" -j DROP

# banner /etc/issue.net
wget -O /etc/issue.net "https://raw.githubusercontent.com/marloxxx/install/master/issue.net"
sed -i 's@#Banner@Banner@g' /etc/ssh/sshd_config
sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/issue.net"@g' /etc/default/dropbear

# download script
cd /usr/bin
wget -O menu "https://raw.githubusercontent.com/marloxxx/install/master/menu.sh"
wget -O usernew "https://raw.githubusercontent.com/marloxxx/install/master/usernew.sh"
wget -O trial "https://raw.githubusercontent.com/marloxxx/install/master/trial.sh"
wget -O hapus "https://raw.githubusercontent.com/marloxxx/install/master/hapus.sh"
wget -O member "https://raw.githubusercontent.com/marloxxx/install/master/member.sh"
wget -O delete "https://raw.githubusercontent.com/marloxxx/install/master/delete.sh"
wget -O cek "https://raw.githubusercontent.com/marloxxx/install/master/cek.sh"
wget -O restart "https://raw.githubusercontent.com/marloxxx/install/master/restart.sh"
wget -O speedtest "https://raw.githubusercontent.com/marloxxx/install/master/speedtest_cli.py"
wget -O info "https://raw.githubusercontent.com/marloxxx/install/master/info.sh"
wget -O about "https://raw.githubusercontent.com/marloxxx/install/master/about.sh"

echo "0 0 * * * root /sbin/reboot" > /etc/cron.d/reboot

chmod +x menu
chmod +x usernew
chmod +x trial
chmod +x hapus
chmod +x member
chmod +x delete
chmod +x cek
chmod +x restart
chmod +x speedtest
chmod +x info
chmod +x about

# finishing
cd
chown -R www-data:www-data /home/vps/public_html
/etc/init.d/nginx restart
/etc/init.d/openvpn restart
/etc/init.d/cron restart
/etc/init.d/ssh restart
/etc/init.d/dropbear restart
/etc/init.d/fail2ban restart
/etc/init.d/webmin restart
/etc/init.d/stunnel4 restart
/etc/init.d/squid3 start
rm -rf ~/.bash_history && history -c
echo "unset HISTFILE" >> /etc/profile

# grep ports 
opensshport="$(netstat -ntlp | grep -i ssh | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
dropbearport="$(netstat -nlpt | grep -i dropbear | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
stunnel4port="$(netstat -nlpt | grep -i stunnel | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
openvpnport="$(netstat -nlpt | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
squidport="$(cat /etc/squid/squid.conf | grep -i http_port | awk '{print $2}')"
nginxport="$(netstat -nlpt | grep -i nginx| grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"

# remove unnecessary files
apt -y autoremove
apt -y autoclean
apt -y clean

# info
echo "Autoscript Include:" | tee log-install.txt
echo "===========================================" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Service"  | tee -a log-install.txt
echo "-------"  | tee -a log-install.txt
echo "OpenSSH  : 22"  | tee -a log-install.txt
echo "Dropbear : 143, 110,109,456"  | tee -a log-install.txt
echo "SSL      : 222,443,777,990"  | tee -a log-install.txt
echo "Squid3   : 80, 3128, 8080 (limit to IP SSH)"  | tee -a log-install.txt
echo "OpenVPN  : TCP 1194 (client config : http://$MYIP:81/client-tcp-1194.ovpn)"  | tee -a log-install.txt
echo "OpenVPN  : TCP 2200 (client config : http://$MYIP:81/client-tcp-2200.ovpn)"  | tee -a log-install.txt
echo "OpenVPN  : UDP 1194 (client config : http://$MYIP:81/client-udp-1194.ovpn)"  | tee -a log-install.txt
echo "OpenVPN  : UDP 2200 (client config : http://$MYIP:81/client-udp-2200.ovpn)"  | tee -a log-install.txt
echo "badvpn   : 7200/7300"  | tee -a log-install.txt
echo "nginx    : 81"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Script"  | tee -a log-install.txt
echo "------"  | tee -a log-install.txt
echo "menu (Displays a list of available commands)"  | tee -a log-install.txt
echo "usernew (Creating an SSH Account)"  | tee -a log-install.txt
echo "trial (Create a Trial Account)"  | tee -a log-install.txt
echo "hapus (Clearing SSH Account)"  | tee -a log-install.txt
echo "cek (Check User Login)"  | tee -a log-install.txt
echo "member (Check Member SSH)"  | tee -a log-install.txt
echo "restart (Restart Service dropbear, webmin, squid3, openvpn and ssh)"  | tee -a log-install.txt
echo "reboot (Reboot VPS)"  | tee -a log-install.txt
echo "speedtest (Speedtest VPS)"  | tee -a log-install.txt
echo "info (System Information)"  | tee -a log-install.txt
echo "about (Information about auto install script)"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Other features"  | tee -a log-install.txt
echo "----------"  | tee -a log-install.txt
echo "Webmin   : http://$MYIP:10000/"  | tee -a log-install.txt
echo "Timezone : Asia/Jakarta (GMT +7)"  | tee -a log-install.txt
echo "IPv6     : [off]"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Original Script by Horas"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Installation Log --> /root/log-install.txt"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "==========================================="  | tee -a log-install.txt
cd
rm -f /root/install.sh
