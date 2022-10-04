#!/bin/bash -e
if [[ $(id -u) -ne 0 ]]; then echo "Please run as root (e.g. sudo ./path/to/this/script)"; exit 1; fi

apt-get install -y strongswan libstrongswan-standard-plugins libcharon-extra-plugins
apt-get install -y libcharon-standard-plugins || true  # 17.04+ only
ln -f -s /etc/ssl/certs/ISRG_Root_X1.pem /etc/ipsec.d/cacerts/
grep -Fq 'jawj/IKEv2-setup' /etc/ipsec.conf || echo "
# https://github.com/jawj/IKEv2-setup
conn ikev2vpn
        ikelifetime=60m
        keylife=20m
        rekeymargin=3m
        keyingtries=1
        keyexchange=ikev2
        ike=aes256-sha256-modp1024,aes256-sha256-modp2048,aes256gcm16-prfsha384-ecp384
        esp=aes256gcm16-ecp384
        leftsourceip=%config
        leftauth=eap-mschapv2
        eap_identity={{ client.name }}
        right={{ ipsec_server_name }}
        rightauth=pubkey
        rightid=@{{ ipsec_server_name }}
        rightsubnet=0.0.0.0/0
        auto=add  # or auto=start to bring up automatically
" >> /etc/ipsec.conf
grep -Fq 'jawj/IKEv2-setup' /etc/ipsec.secrets || echo "
# https://github.com/jawj/IKEv2-setup
{{ client.name }} : EAP \"{{ client.secret }}\"
" >> /etc/ipsec.secrets
ipsec restart
sleep 5  # is there a better way?
echo "Bringing up VPN ..."
ipsec up ikev2vpn
ipsec statusall
echo
echo -n "Testing IP address ... "
VPNIP=$(dig -4 +short {{ ipsec_server_name }})
ACTUALIP=$(dig -4 +short myip.opendns.com @resolver1.opendns.com)
if [[ "$VPNIP" == "$ACTUALIP" ]]; then echo "PASSED (IP: ${VPNIP})"; else echo "FAILED (IP: ${ACTUALIP}, VPN IP: ${VPNIP})"; fi
echo
echo "To disconnect: ipsec down ikev2vpn"
echo "To reconnect:  ipsec up ikev2vpn"
echo "To connect automatically: change auto=add to auto=start in /etc/ipsec.conf"
