#! /bin/sh

source ./.env

mkdir -p /etc/rancher/rke2/
cat > /etc/rancher/rke2/config.yaml <<EOL
server: https://server1:9345
token: ${TOKEN}
tls-san:
    - server1
EOL

cat >> /etc/profile <<EOL
export PATH=/var/lib/rancher/rke2/bin:$PATH
export KUBECONFIG=/etc/rancher/rke2/rke2.yaml
EOL

curl -sfL  https://get.rke2.io   | sh -  &

wait

systemctl enable rke2-server
systemctl start rke2-server
