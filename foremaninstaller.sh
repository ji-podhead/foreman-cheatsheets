#!/bin/bash

# Überprüfen, ob das Skript als root ausgeführt wird
if [ "$(id -u)"!= "0" ]; then
   echo "Dieses Skript muss als root ausgeführt werden." >&2
   exit 1
fi

# Aktualisieren Sie die Paketliste
yum update -y

# Installieren Sie das Katello Discovery Plugin
yum install -y foreman-discovery-plugin

# Konfigurieren Sie den DHCP-Server
cat <<EOF > /etc/dhcp/dhcpd.conf
subnet 192.168.1.0 netmask 255.255.255.0 {
  range 192.168.1.10 192.168.1.100;
  option domain-name-servers 8.8.8.8, 8.8.4.4;
  option routers 192.168.1.1;
  option broadcast-address 192.168.1.255;
  default-lease-time 600;
  max-lease-time 7200;
}
EOF

# Starten Sie den DHCP-Server neu
systemctl restart dhcpd

# Konfigurieren Sie den DNS-Server
cat <<EOF > /etc/resolv.conf
nameserver 8.8.8.8
nameserver 8.8.4.4
search example.com
domain example.com
EOF

# Setzen Sie die NIC auf enp2s0
ip link set dev enp2s0 up
ip addr add 192.168.1.1/24 dev enp2s0
ip route add default via 192.168.1.1

echo "Foreman mit Katello Discovery Plugin installiert und DHCP/DNS konfiguriert."

