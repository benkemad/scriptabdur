#!/bin/bash
#
# Original script by fornesia, rzengineer and fawzya 
# Mod by Abdur
# 
# ==================================================
NIC=$(ip -4 route ls | grep default | grep -Po '(?<=dev )(\S+)' | head -1)
# initializing var
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;
MYIP=$(wget -qO- ipv4.icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";

#detail nama perusahaan
country=ID
state=MALANG
locality=JAWA TIMUR
organization=www.rumahconfig.com
organizationalunit=www.rumahconfig.com
commonname=www.rumahconfig.com
email=admin@rumahconfig.com

# simple password minimal
wget -O /etc/pam.d/common-password "https://raw.githubusercontent.com/benkemad/scriptabdur/master/common-password-deb9"
chmod +x /etc/pam.d/common-password

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
# sh -c 'echo "deb http://download.webmin.com/download/repository sarge contrib" > /etc/apt/sources.list.d/webmin.list'
# wget http://www.webmin.com/jcameron-key.asc | apt-key add jcameron-key.asc

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
echo "echo by AdminRumahconfig" >> .profile

# instal php5.6 ubuntu 16.04 64bit
apt-get -y update

# install webserver
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/benkemad/scriptabdur/master/nginx.conf"
mkdir -p /home/vps/public_html
echo "<pre>Setup by Kemaddd</pre>" > /home/vps/public_html/index.html
wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/benkemad/scriptabdur/master/vps.conf"

# install badvpn
cd
wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/benkemad/scriptabdur/master/badvpn-udpgw64"
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 1000 --max-connections-for-client 10' /etc/rc.local
chmod +x /usr/bin/badvpn-udpgw
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 1000 --max-connections-for-client 10 

cd
wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/benkemad/scriptabdur/master/badvpn-udpgw64"
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 1000 --max-connections-for-client 10' /etc/rc.local
chmod +x /usr/bin/badvpn-udpgw
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 1000 --max-connections-for-client 10 

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
wget -O /etc/squid/squid.conf "https://raw.githubusercontent.com/benkemad/scriptabdur/master/squid3.conf"
sed -i $MYIP2 /etc/squid/squid.conf

source /etc/os-release
if [[ $VERSION_ID == "9" ]]; then
# install openvpn
mkdir -p /etc/iptables
apt-get install -y openvpn easy-rsa iptables openssl ca-certificates gnupg
apt-get install -y net-tools
cp -r /usr/share/easy-rsa /etc/openvpn
cd /etc/openvpn
cd easy-rsa


cp openssl-1.0.0.cnf openssl.cnf
source ./vars
./clean-all
source vars
rm -rf keys
./clean-all
./build-ca
./build-key-server server
./pkitool --initca
./pkitool --server server
./pkitool client
./build-dh
cp keys/ca.crt /etc/openvpn
cp keys/server.crt /etc/openvpn
cp keys/server.key /etc/openvpn
cp keys/dh2048.pem /etc/openvpn
cp keys/client.key /etc/openvpn
cp keys/client.crt /etc/openvpn

# Buat config server UDP 1194
cd /etc/openvpn

cat > /etc/openvpn/server-udp-25000.conf <<-END
port 25000
proto udp
dev tun
ca ca.crt
cert server.crt
key server.key
dh dh2048.pem
plugin /usr/lib/openvpn/openvpn-plugin-auth-pam.so login
client-cert-not-required
username-as-common-name
server 10.5.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
keepalive 5 30
comp-lzo
persist-key
persist-tun
status server-udp-1194.log
verb 3
END

# Buat config server TCP 1194
cat > /etc/openvpn/server-tcp-1194.conf <<-END
port 1194
proto tcp
dev tun
ca ca.crt
cert server.crt
key server.key
dh dh2048.pem
plugin /usr/lib/openvpn/openvpn-plugin-auth-pam.so login
client-cert-not-required
username-as-common-name
server 10.6.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
keepalive 5 30
comp-lzo
persist-key
persist-tun
status server-tcp-1194.log
verb 3
END

# Buat config server TCP 2200
cat > /etc/openvpn/server-tcp-2200.conf <<-END
port 2200
proto tcp
dev tun
ca ca.crt
cert server.crt
key server.key
dh dh2048.pem
plugin /usr/lib/openvpn/openvpn-plugin-auth-pam.so login
client-cert-not-required
username-as-common-name
server 10.7.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
keepalive 5 30
comp-lzo
persist-key
persist-tun
status server-tcp-2200.log
verb 3
END

cd

# nano /etc/default/openvpn
sed -i 's/#AUTOSTART="all"/AUTOSTART="all"/g' /etc/default/openvpn
# Cari pada baris #AUTOSTART=”all” hilangkan tanda pagar # didepannya sehingga menjadi AUTOSTART=”all”. Save dan keluar dari editor

# restart openvpn dan cek status openvpn
/etc/init.d/openvpn restart
/etc/init.d/openvpn status

# aktifkan ip4 forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
# edit file sysctl.conf
# nano /etc/sysctl.conf
# Uncomment hilangkan tanda pagar pada #net.ipv4.ip_forward=1

# Buat config client UDP 1194
cd /etc/openvpn

# Buat config client TCP 1194
cat > /etc/openvpn/client-tcp-1194.ovpn <<-END
##### WELCOME TO RUMAHCONFIG SERVER #####
##### www.RUMAHCONFIG.COM #####
##### DONT FORGET TO SUPPORT US #####
client
dev tun
proto tcp
remote xxxxxxxxx 1194
resolv-retry infinite
route-method exe
nobind
persist-key
persist-tun
auth-user-pass
comp-lzo
verb 3
END

sed -i $MYIP2 /etc/openvpn/client-tcp-1194.ovpn;

# Buat config client TCP 2200
cat > /etc/openvpn/client-tcp-2200.ovpn <<-END
##### WELCOME TO VPNSTORE #####
##### www.sshtunneling.tk #####
##### DONT FORGET TO SUPPORT US #####
client
dev tun
proto tcp
remote xxxxxxxxx 2200
resolv-retry infinite
route-method exe
nobind
persist-key
persist-tun
auth-user-pass
comp-lzo
verb 3
END

cd

sed -i $MYIP2 /etc/openvpn/client-tcp-2200.ovpn;

# Buat config client TCP 2200
cat > /etc/openvpn/client-udp-25000.ovpn <<-END
##### WELCOME TO VPNSTORE #####
##### www.sshtunneling.tk #####
##### DONT FORGET TO SUPPORT US #####
client
dev tun
proto udp
remote xxxxxxxxx 25000
resolv-retry infinite
route-method exe
nobind
persist-key
persist-tun
auth-user-pass
comp-lzo
verb 3
END

cd

sed -i $MYIP2 /etc/openvpn/client-udp-25000.ovpn;


# OpenVPN SSL Konfigurasi by Potato
cd /home/vps/public_html
echo "client
dev tun
proto tcp
remote xxxxxxxxx 2905
resolv-retry infinite
route-method exe
nobind
persist-key
persist-tun
auth-user-pass
comp-lzo
verb 3" > client-ssl-2905.ovpn

# change ip
sed -i $MYIP2 client-ssl-2905.ovpn

# include ca
echo '<ca>' >> client-ssl-2905.ovpn
cat /etc/openvpn/ca.crt >> client-ssl-2905.ovpn
echo '</ca>' >> client-ssl-2905.ovpn


# pada tulisan xxx ganti dengan alamat ip address VPS anda 
/etc/init.d/openvpn restart

# masukkan certificatenya ke dalam config client TCP 1194
echo '<ca>' >> /etc/openvpn/client-tcp-1194.ovpn
cat /etc/openvpn/ca.crt >> /etc/openvpn/client-tcp-1194.ovpn
echo '</ca>' >> /etc/openvpn/client-tcp-1194.ovpn

# masukkan certificatenya ke dalam config client UDP 1194
echo '<ca>' >> /etc/openvpn/client-udp-25000.ovpn
cat /etc/openvpn/ca.crt >> /etc/openvpn/client-udp-25000.ovpn
echo '</ca>' >> /etc/openvpn/client-udp-25000.ovpn

# Copy config OpenVPN client ke home directory root agar mudah didownload ( TCP 1194 )
cp /etc/openvpn/client-tcp-1194.ovpn /home/vps/public_html/client-tcp-1194.ovpn

# Copy config OpenVPN client ke home directory root agar mudah didownload ( UDP 1194 )
cp /etc/openvpn/client-udp-25000.ovpn /home/vps/public_html/client-udp-25000.ovpn

# masukkan certificatenya ke dalam config client TCP 2200
echo '<ca>' >> /etc/openvpn/client-tcp-2200.ovpn
cat /etc/openvpn/ca.crt >> /etc/openvpn/client-tcp-2200.ovpn
echo '</ca>' >> /etc/openvpn/client-tcp-2200.ovpn

# Copy config OpenVPN client ke home directory root agar mudah didownload ( TCP 2200 )
cp /etc/openvpn/client-tcp-2200.ovpn /home/vps/public_html/client-tcp-2200.ovpn

# iptables-persistent
apt install iptables-persistent -y
apt install netfilter-persistent -y
# firewall untuk memperbolehkan akses UDP dan akses jalur TCP

iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

iptables -A INPUT -i $NIC -m state --state NEW -p tcp --dport 3306 -j ACCEPT
iptables -A INPUT -i $NIC -m state --state NEW -p tcp --dport 7300 -j ACCEPT
iptables -A INPUT -i $NIC -m state --state NEW -p udp --dport 7300 -j ACCEPT

iptables -t nat -I POSTROUTING -s 10.5.0.0/24 -o $NIC -j MASQUERADE
iptables -t nat -I POSTROUTING -s 10.6.0.0/24 -o $NIC -j MASQUERADE
iptables -t nat -I POSTROUTING -s 10.7.0.0/24 -o $NIC -j MASQUERADE

iptables-save > /etc/iptables/rules.v4
chmod +x /etc/iptables/rules.v4

# Restart service openvpn
systemctl enable openvpn
systemctl start openvpn
/etc/init.d/openvpn restart
fi

source /etc/os-release
if [[ $VERSION_ID == "10" ]]; then
echo 1 > /proc/sys/net/ipv4/ip_forward
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
sysctl -p
# folder iptables
mkdir -p /etc/iptables

# install openvpn

apt-get update -y
apt-get install openvpn iptables openssl ca-certificates gnupg -y
apt-get install -y net-tools

cp -r /usr/share/easy-rsa /etc/openvpn/
cd /etc/openvpn/easy-rsa
cp vars.example vars

(echo -en "\n\n\n\n\n\n\n\n"; sleep 1; echo -en "\n"; sleep 1; echo -en "\n"; sleep 3; echo -en "yes"; echo -en "\n"; sleep 3; echo -en "yes"; echo -en "\n") | ./easyrsa init-pki

(echo -en "\n\n\n\n\n\n\n\n"; sleep 1; echo -en "\n"; sleep 1; echo -en "\n"; sleep 3; echo -en "yes"; echo -en "\n"; sleep 3; echo -en "yes"; echo -en "\n") | ./easyrsa build-ca nopass

(echo -en "\n\n\n\n\n\n\n\n"; sleep 1; echo -en "\n"; sleep 1; echo -en "\n"; sleep 3; echo -en "yes"; echo -en "\n"; sleep 3; echo -en "yes"; echo -en "\n") | ./easyrsa gen-req server nopass

(echo -en "yes") | ./easyrsa sign-req server server

(echo -en "\n\n\n\n\n\n\n\n"; sleep 1; echo -en "\n"; sleep 1; echo -en "\n"; sleep 3; echo -en "yes"; echo -en "\n"; sleep 3; echo -en "yes"; echo -en "\n") | ./easyrsa gen-dh

cp pki/ca.crt /etc/openvpn/
cp pki/private/server.key /etc/openvpn/
cp pki/issued/server.crt /etc/openvpn/
cp pki/dh.pem /etc/openvpn/

# konfigurasi

echo 'port 1194
proto tcp
dev tun
ca ca.crt
cert server.crt
key server.key
dh dh.pem
verify-client-cert none
username-as-common-name
plugin /usr/lib/x86_64-linux-gnu/openvpn/plugins/openvpn-plugin-auth-pam.so login
server 10.8.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
push "route-method exe"
push "route-delay 2"
socket-flags TCP_NODELAY
push "socket-flags TCP_NODELAY"
keepalive 10 120
comp-lzo
user nobody
group nogroup
persist-key
persist-tun
management 127.0.0.1 5555
status openvpn-status.log
log openvpn.log
verb 3
ncp-disable
cipher none
auth none' >/etc/openvpn/server-tcp-1194.conf

systemctl enable openvpn@server-tcp-1194
systemctl start openvpn@server-tcp-1194


echo 'port 25000
proto udp
dev tun
ca ca.crt
cert server.crt
key server.key
dh dh.pem
verify-client-cert none
username-as-common-name
plugin /usr/lib/x86_64-linux-gnu/openvpn/plugins/openvpn-plugin-auth-pam.so login
server 20.8.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
push "route-method exe"
push "route-delay 2"
socket-flags TCP_NODELAY
push "socket-flags TCP_NODELAY"
keepalive 10 120
comp-lzo
user nobody
group nogroup
persist-key
persist-tun
status openvpn-status.log
log openvpn.log
verb 3
ncp-disable
cipher none
auth none' >/etc/openvpn/server-udp-25000.conf

systemctl enable openvpn@server-udp-25000
systemctl start openvpn@server-udp-25000


echo 'port 2200
proto tcp
dev tun
ca ca.crt
cert server.crt
key server.key
dh dh.pem
verify-client-cert none
username-as-common-name
plugin /usr/lib/x86_64-linux-gnu/openvpn/plugins/openvpn-plugin-auth-pam.so login
server 30.8.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
push "route-method exe"
push "route-delay 2"
socket-flags TCP_NODELAY
push "socket-flags TCP_NODELAY"
keepalive 10 120
comp-lzo
user nobody
group nogroup
persist-key
persist-tun
status openvpn-status.log
log openvpn.log
verb 3
ncp-disable
cipher none
auth none' >/etc/openvpn/server-tcp-2200.conf

systemctl enable openvpn@server-tcp-2200
systemctl start openvpn@server-tcp-2200


# root
cd

# konfigurasi client
echo 'auth-user-pass
client
dev tun
proto tcp
remote xxxxxxxxx 1194
persist-key
persist-tun
pull
resolv-retry infinite
nobind
user nobody
comp-lzo
remote-cert-tls server
verb 3
mute 2
connect-retry 5 5
connect-retry-max 8080
mute-replay-warnings
redirect-gateway def1
script-security 2
cipher none
auth none' >/home/vps/public_html/client-tcp-1194.ovpn

echo 'auth-user-pass
client
dev tun
proto udp
remote xxxxxxxxx 25000
persist-key
persist-tun
pull
resolv-retry infinite
nobind
user nobody
comp-lzo
remote-cert-tls server
verb 3
mute 2
connect-retry 5 5
connect-retry-max 8080
mute-replay-warnings
redirect-gateway def1
script-security 2
cipher none
auth none' >/home/vps/public_html/client-udp-25000.ovpn

echo 'auth-user-pass
client
dev tun
proto tcp
remote xxxxxxxxx 2905
persist-key
persist-tun
pull
resolv-retry infinite
nobind
user nobody
comp-lzo
remote-cert-tls server
verb 3
mute 2
connect-retry 5 5
connect-retry-max 8080
mute-replay-warnings
redirect-gateway def1
script-security 2
cipher none
auth none' >/home/vps/public_html/client-ssl-2905.ovpn

echo 'auth-user-pass
client
dev tun
proto tcp
remote xxxxxxxxx 2200
persist-key
persist-tun
pull
resolv-retry infinite
nobind
user nobody
comp-lzo
remote-cert-tls server
verb 3
mute 2
connect-retry 5 5
connect-retry-max 8080
mute-replay-warnings
redirect-gateway def1
script-security 2
cipher none
auth none' >/home/vps/public_html/client-tcp-2200.ovpn


# input ca
sed -i $MYIP2 /home/vps/public_html/client-tcp-1194.ovpn
sed -i $MYIP2 /home/vps/public_html/client-tcp-2200.ovpn
sed -i $MYIP2 /home/vps/public_html/client-ssl-2905.ovpn
sed -i $MYIP2 /home/vps/public_html/client-udp-25000.ovpn

apt-get install -y zip unzip
cd /home/vps/public_html

# input ca
{
echo "<ca>"
cat "/etc/openvpn/ca.crt"
echo "</ca>"
} >>client-tcp-1194.ovpn

{
echo "<ca>"
cat "/etc/openvpn/ca.crt"
echo "</ca>"
} >>client-tcp-2200.ovpn

{
echo "<ca>"
cat "/etc/openvpn/ca.crt"
echo "</ca>"
} >>client-ssl-2905.ovpn

{
echo "<ca>"
cat "/etc/openvpn/ca.crt"
echo "</ca>"
} >>client-udp-25000.ovpn


apt-get install -y iptables iptables-persistent netfilter-persistent

iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o $NIC -j MASQUERADE
iptables -t nat -A POSTROUTING -s 20.8.0.0/24 -o $NIC -j MASQUERADE
iptables -t nat -A POSTROUTING -s 30.8.0.0/24 -o $NIC -j MASQUERADE
iptables-save > /etc/iptables/rules.v4

systemctl restart netfilter-persistent
service openvpn restart
systemctl restart openvpn@server-tcp-1194
systemctl restart openvpn@server-udp-25000
systemctl restart openvpn@server-tcp-2200

# done

fi
# setting vnstat
apt-get -y update;apt-get -y install vnstat;vnstat -u -i eth0;service vnstat restart 

# install webmin
cd
wget http://prdownloads.sourceforge.net/webadmin/webmin_1.910_all.deb
dpkg --install webmin_1.910_all.deb;
apt-get -y -f install;
sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf
rm -f webmin_1.910_all.deb
/etc/init.d/webmin restart

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
openssl genrsa -out key.pem 2048
openssl req -new -x509 -key key.pem -out cert.pem -days 1095 \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
cat key.pem cert.pem >> /etc/stunnel/stunnel.pem

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

# xml parser
cd
apt-get install -y libxml-parser-perl

# banner /etc/issue.net
wget -O /etc/issue.net "https://raw.githubusercontent.com/benkemad/scriptbagus/master/issue.net"
sed -i 's@#Banner@Banner@g' /etc/ssh/sshd_config
sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/issue.net"@g' /etc/default/dropbear

# download script
cd /usr/bin
wget -O perpanjang "https://raw.githubusercontent.com/benkemad/scriptabdur/master/perpanjang.sh"
wget -O menu "https://raw.githubusercontent.com/benkemad/scriptabdur/master/menu.sh"
wget -O usernew "https://raw.githubusercontent.com/benkemad/scriptabdur/master/usernew.sh"
wget -O trial "https://raw.githubusercontent.com/benkemad/scriptabdur/master/trial.sh"
wget -O hapus "https://raw.githubusercontent.com/benkemad/scriptabdur/master/hapus.sh"
wget -O member "https://raw.githubusercontent.com/benkemad/scriptabdur/master/member.sh"
wget -O delete "https://raw.githubusercontent.com/benkemad/scriptabdur/master/delete.sh"
wget -O cek "https://raw.githubusercontent.com/benkemad/scriptabdur/master/cek.sh"
wget -O restart "https://raw.githubusercontent.com/benkemad/scriptabdur/master/restart.sh"
wget -O speedtest "https://raw.githubusercontent.com/benkemad/scriptabdur/master/speedtest_cli.py"
wget -O limit "https://raw.githubusercontent.com/benkemad/scriptabdur/master/limit.sh"
wget -O userlimit "https://raw.githubusercontent.com/benkemad/scriptabdur/master/userlimit.sh"
wget -O portstat "https://raw.githubusercontent.com/benkemad/scriptabdur/master/portstat.sh"
wget -O info "https://raw.githubusercontent.com/benkemad/scriptabdur/master/info.sh"
wget -O contact "https://raw.githubusercontent.com/benkemad/scriptabdur/master/contact.sh"
wget -O about "https://raw.githubusercontent.com/benkemad/scriptabdur/master/about.sh"

echo "0 0 * * * root /sbin/reboot" > /etc/cron.d/reboot

chmod +x perpanjang
chmod +x menu
chmod +x usernew
chmod +x trial
chmod +x hapus
chmod +x member
chmod +x delete
chmod +x cek
chmod +x restart
chmod +x speedtest
chmod +x limit
chmod +x userlimit
chmod +x portstat
chmod +x info
chmod +x contact
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
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 1000 --max-connections-for-client 10 
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 1000 --max-connections-for-client 10 
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

# finihsing
clear
neofetch
netstat -ntlp
