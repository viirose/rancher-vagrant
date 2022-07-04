#! /bin/sh

cat >> /etc/profile <<EOL
export PATH=/var/lib/rancher/rke2/bin:$PATH
export KUBECONFIG=/etc/rancher/rke2/rke2.yaml
EOL

curl -sfL  https://get.rke2.io   | sh -  &

wait

systemctl enable rke2-server
systemctl start rke2-server
