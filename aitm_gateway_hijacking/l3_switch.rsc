/system/identity set name=L3-Switch

/interface/bridge
add name=br1 vlan-filtering=yes dhcp-snooping=yes

/interface/bridge/port
add bridge=br1 interface=ether1 pvid=10
add bridge=br1 interface=ether2 pvid=10
add bridge=br1 interface=ether3 pvid=20

/interface/bridge/vlan
add bridge=br1 vlan-ids=10 untagged=ether1,ether2 tagged=br1
add bridge=br1 vlan-ids=20 untagged=ether3 tagged=br1

/interface/vlan
add name=RED_NET vlan-id=10 interface=br1
add name=BLUE_NET vlan-id=20 interface=br1

/ip/address
add address=10.0.10.254/24 interface=RED_NET
add address=10.0.20.254/24 interface=BLUE_NET

/ip/dhcp-client
remove [find]

/ip/pool
add name=RED_POOL ranges=10.0.10.151-10.0.10.200
add name=BLUE_POOL ranges=10.0.20.151-10.0.20.200

/ip/dhcp-server
add name=RED_DHCP interface=RED_NET address-pool=RED_POOL
add name=BLUE_DHCP interface=BLUE_NET address-pool=BLUE_POOL

/ip/dhcp-server/network
add address=10.0.10.0/24 gateway=10.0.10.254
add address=10.0.20.0/24 gateway=10.0.20.254

/interface/bridge/settings
set use-ip-firewall=yes
set use-ip-firewall-for-vlan=yes

/ip/firewall/raw
add chain=prerouting action=accept in-interface=RED_NET protocol=udp dst-port=67 limit=1,5:packet
add chain=prerouting action=drop in-interface=RED_NET protocol=udp dst-port=67 log=yes log-prefix="POSSIBLE_DHCP_ABUSE"
