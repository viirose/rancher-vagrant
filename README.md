### Rancher RKE2 kubernetes 集群

* 第一个server节点
1. `vagrant up server1`
2. `vagrant ssh server1`

```shell
  sudo -s
  cd /vagrant && sh server1.sh

  cat /var/lib/rancher/rke2/server/node-token
```
3. 修改`./setup/.env` (不存在则新建)，设置 `TOKEN=$token`

* 所有其他server和worker节点
1. `vagrant up`
2. 其他server节点执行 `servers.sh`
3. worker节点节点执行 `workers.sh`

* kubectl外部连接
1. 复制配置文件 `/etc/rancher/rke2/rke2.yaml` 为 `~/.kube/config`
2. 修改127.0.0.1 为server节点ip地址

### Rancher 高可用安装
1. `https://rancher.com/docs/rancher/v2.6/en/installation/install-rancher-on-k8s`

```
WARNING: Kubernetes configuration file is group-readable. This is insecure. Location: /Users/kris/.kube/config
WARNING: Kubernetes configuration file is world-readable. This is insecure. Location: /Users/kris/.kube/config
```
chmod go-r ~/.kube/config

helm 安装 certmanager

```bash
helm install rancher rancher-stable/rancher \
  --namespace cattle-system \
  --set hostname=rc.local \
  --set bootstrapPassword=admin
```

### haproxy 4层负载均衡
1. `brew install haproxy`
2. `vi /usr/local/etc/haproxy.cfg`
```bash
global
    daemon
 
defaults
    mode tcp #默认的模式mode { tcp|http|health }，tcp是4层，http是7层，health只会返回OK
    retries 3 #两次连接失败就认为是服务器不可用，也可以通过后面设置
    option redispatch #当serverId对应的服务器挂掉后，强制定向到其他健康的服务器
    option abortonclose #当服务器负载很高的时候，自动结束掉当前队列处理比较久的链接
    maxconn 65535 #默认的最大连接数
    timeout connect 5000ms #连接超时
    timeout client 30000ms #客户端超时
    timeout server 30000ms #服务器超时
    #timeout check 2000 #心跳检测超时
    log 127.0.0.1 local0 err #[err warning info debug]

listen rc.local
    bind 0.0.0.0:443
    mode tcp # 4层代理
    balance roundrobin
    server  server1 10.211.55.10:443 check
    server  server2 10.211.55.11:443 check
    server  server3 10.211.55.12:443 check
```
3. `/usr/local/opt/haproxy/bin/haproxy -f /usr/local/etc/haproxy.cfg`
4. 配置hosts `127.0.0.1     rc.local` 
5. `sudo killall -HUP mDNSResponder`
6. 设置证书信任


apt -y install chrony
/etc/chrony/chrony.conf

sudo vi /etc/netplan/01-network-manager-all.yaml

export all_proxy=http://127.0.0.1:7890


deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free


wget -N --no-check-certificate -q https://cdn.jsdelivr.net/gh/h31105/trojan_v2_docker_onekey/deploy.sh && chmod +x deploy.sh && bash deploy.sh


/etc/rancher/rke2/config.yaml

tls-san:
  - 139.224.54.86
  - rancher.viirose.com

helm install rancher rancher-stable/rancher \
  --namespace cattle-system \
  --set hostname=r.local \
  --set bootstrapPassword=admin

helm install rancher rancher-stable/rancher \
  --namespace cattle-system \
  --set hostname=rancher.viirose.com \
  --set bootstrapPassword=admin \
  --set ingress.tls.source=letsEncrypt \
  --set letsEncrypt.email=krisnieh@163.com \
  --set letsEncrypt.ingress.class=traefik


apt install open-iscsi -y


curl -sfL https://get.k3s.io | sh -s - server --cluster-init

curl -sfL https://get.k3s.io | sh - 

K3S_TOKEN=K10994e832211520375038b5b58eeac8febc49570074e7e2b48e97ea482d8356c41::server:5644c1c59f5ee2a8f47e5e49c36af2c2 k3s server --server https://server1:6443


K3S_TOKEN=K1018cfe0ce82326e7a1adcc59bf8722b15d7b2c6ada9f37eaaff10cce2a23a12e1::server:05c62df19c6da2938ef2fe5fdc53f939 k3s server --cluster-init

K3S_TOKEN=K1018cfe0ce82326e7a1adcc59bf8722b15d7b2c6ada9f37eaaff10cce2a23a12e1::server:05c62df19c6da2938ef2fe5fdc53f939 k3s server --server https://server1:6443

curl -sfL https://get.k3s.io | K3S_URL=https://server1:6443 K3S_TOKEN=K1018cfe0ce82326e7a1adcc59bf8722b15d7b2c6ada9f37eaaff10cce2a23a12e1::server:05c62df19c6da2938ef2fe5fdc53f939 sh -

curl -sfL https://get.k3s.io | sh -s - server --datastore-endpoint='mysql://admin:Rancher2019k3s@tcp(k3s-mysql.csrskwupj33i.ca-central-1.rds.amazonaws.com:3306)/k3sdb'

curl -sfL https://get.k3s.io  \
    | K3S_TOKEN=K1018cfe0ce82326e7a1adcc59bf8722b15d7b2c6ada9f37eaaff10cce2a23a12e1::server:05c62df19c6da2938ef2fe5fdc53f939 \
      bash -s - server --server https://server1:6443


