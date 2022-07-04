#! /bin/sh

source ./.env

cat > /etc/rancher/rke2/config.yaml <<EOL
server: https://server1:9345
token: ${TOKEN}
EOL

curl -sfL  curl -sfL https://get.rke2.io | INSTALL_RKE2_TYPE="agent" sh -  &

wait

systemctl enable rke2-agent
systemctl start rke2-agent