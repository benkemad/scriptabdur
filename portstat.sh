echo -e ""
echo -e "==================="
echo -e "|   Status Port   |"
echo -e "-------------------"
echo -e ""
echo -e "List :"
echo -e ""
echo -e "[1] Dropbear"
echo -e "[2] OpenSSH"
echo -e "[3] Stunnel"
echo -e "[4] OpenVPN"
echo -e "[5] Squid Proxy"
echo -e "[6] Nginx"
echo -e ""
read -p "Mana yang ingin anda pilih : " Jawaban

        #Dropbear
        if [[ $Jawaban =~ ^([1])$ ]]
                then
                        echo -e ""
                        echo -e "================"
                        echo -e "|   Dropbear   |"
                        echo -e "----------------"
                        echo -e ""
                        service dropbear status
                        echo -e ""
                else
                        echo
        fi

        #OpenSSH
        if [[ $Jawaban =~ ^([2])$ ]]
                then
                        clear
                        echo -e ""
                        echo -e "==============="
                        echo -e "|   OpenSSH   |"
                        echo -e "---------------"
                        echo -e ""
                        service ssh status
                        echo -e ""
                else
                        echo
        fi

        #Stunnel
        if [[ $Jawaban =~ ^([3])$ ]]
                then
                        clear
                        echo -e ""
                        echo -e "==============="
                        echo -e "|   Stunnel   |"
                        echo -e "---------------"
                        echo -e ""
                        /etc/init.d/stunnel4 status
                        echo -e ""
                else
                        echo
        fi

        #OpenVPN
        if [[ $Jawaban =~ ^([4])$ ]]
                then
                        clear
                        echo -e ""
                        echo -e "==============="
                        echo -e "|   OpenVPN   |"
                        echo -e "---------------"
                        echo -e ""
                        service openvpn status
                        echo -e ""
                else
                        echo
        fi

        #SquidProxy
        if [[ $Jawaban =~ ^([5])$ ]]
                then
                        clear
                        echo -e ""
                        echo -e "==================="
                        echo -e "|   Squid Proxy   |"
                        echo -e "-------------------"
                        echo -e ""
                        service squid status
                        echo -e ""
                else
                        echo
        fi

        #Nginx
        if [[ $Jawaban =~ ^([6])$ ]]
                then
                        clear
                        echo -e ""
                        echo -e "============="
                        echo -e "|   Nginx   |"
                        echo -e "-------------"
                        echo -e ""
                        service nginx status
                        echo -e ""
                else
                        echo
        fi
