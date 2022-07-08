# /bin/sh

cat >> /etc/hosts <<EOL

192.168.8.10 server1
192.168.8.11 server2
192.168.8.12 server3
192.168.8.100 worker1
192.168.8.101 worker2

EOL

mkdir -p /etc/rancher/rke2/

cat > /etc/rancher/rke2/config.yaml  <<EOL
server: https://server1:9345
token: 
tls-san:
    - server1
EOL

# Longhorn
apt install open-iscsi -y

# Chrony
apt install chrony -y


# --- server ---
# server ntp1.aliyun.com 

# allow 10.211.0.0/24
# local stratum 10

# --- client ---
# server 192.168.8.10