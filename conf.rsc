# by RouterOS 6.48.6
# model = RB941-2nD
# Author : Eki Guistian

/interface bridge
add name=bridge1
/interface wireless
set [ find default-name=wlan1 ] ampdu-priorities=0,1 band=2ghz-b/g/n \
    channel-width=20/40mhz-Ce country=no_country_set disabled=no frequency=\
    2442 guard-interval=long installation=outdoor mode=ap-bridge ssid=\
    "ALLNETWORK WIFI" wireless-protocol=802.11 wps-mode=disabled
/interface pwr-line
set [ find default-name=pwr-line1 ] disabled=yes
/interface list
add name=LAN
/interface wireless security-profiles
set [ find default=yes ] authentication-types=wpa-psk,wpa2-psk mode=\
    dynamic-keys supplicant-identity=MikroTik wpa-pre-shared-key=pasangallnet \
    wpa2-pre-shared-key=pasangallnet
/ip pool
add name=pool1 ranges=192.168.100.2-192.168.100.254
/ip dhcp-server
add add-arp=yes address-pool=pool1 disabled=no interface=wlan1 \
    lease-script=":local queueName \"Client- \$leaseActMAC\";\r\
    \n:if (\$leaseBound = \"1\") do={\r\
    \n /queue simple add name=\$queueName target=(\$leaseActIP . \"/32\") max-\
    limit=10M/10M comment=[/ip dhcp-server lease get [find where active-mac-ad\
    dress=\$leaseActMAC && active-address=\$leaseActIP] host-name];\r\
    \n} else={\r\
    \n    /queue simple remove \$queueName\r\
    \n} " lease-time=5m name=dhcp1
/interface pppoe-client
add add-default-route=yes dial-on-demand=yes disabled=no interface=bridge1 \
    max-mtu=1480 name=WAN-PPPOE password="--isi-dengan--pppo-dari-isp" profile=\
    default-encryption service-name=allnetwork use-peer-dns=yes user=\
    --isi-dengan--pppo-dari-isp
/queue simple
add comment=Redmi-Note-10-Pro max-limit=10M/10M name=\
    "Client- CA:8F:A1:C6:F6:F0" target=192.168.100.178/32
add comment=V2105 max-limit=10M/10M name="Client- CA:61:49:5A:11:39" target=\
    192.168.100.176/32
/interface bridge port
add bridge=bridge1 interface=ether4
add bridge=bridge1 interface=ether3
add bridge=bridge1 interface=ether1
add bridge=bridge1 interface=ether2
/ip neighbor discovery-settings
set discover-interface-list=all
/interface list member
add interface=WAN-PPPOE
add list=LAN
/ip address
add address=192.168.100.1/24 interface=wlan1 network=192.168.100.0
/ip dhcp-client
add disabled=no
/ip dhcp-server network
add address=192.168.100.0/24 dns-server=192.168.100.1,1.1.1.1 gateway=\
    192.168.100.1
/ip dns
set servers=8.8.8.8,1.1.1.1
/ip firewall filter
add action=drop chain=forward src-mac-address=F6:15:22:0F:BB:7A
/ip firewall nat
add action=masquerade chain=srcnat out-interface=WAN-PPPOE
# no interface
add action=masquerade chain=srcnat out-interface=*A
/ip firewall raw
add action=drop chain=prerouting src-mac-address=F6:15:22:0F:BB:7A
/ip route
add check-gateway=ping distance=1 gateway=172.13.0.1
/ip service
set www-ssl disabled=no
/system clock
set time-zone-name=Asia/Jakarta
/system identity
set name=Router-Os