#! /bin/sh

# install docker
sudo yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
sudo yum -y install docker-ce
sudo systemctl start docker && sudo systemctl enable docker

export all_proxy=https://queen:7d09a90c@tk.storm-walker.com:443
export no_proxy=localhost,127.0.0.1,192.168.56.0/12,::1