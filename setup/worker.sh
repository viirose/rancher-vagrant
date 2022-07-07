#! /bin/sh

# curl -sfL https://get.rke2.io | INSTALL_RKE2_TYPE="agent" sh -  

systemctl enable rke2-agent
systemctl start rke2-agent
