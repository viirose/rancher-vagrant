### Rancher RKE2 安装高可用

---- server ----
第一个server：
1. 安装 `curl -sfL  https://get.rke2.io   | sh -`
2. `systemctl enable rke2-server`
3. `systemctl start rke2-server`
4. 配置本地kubectl
```shell
vim /etc/profile
export PATH=/var/lib/rancher/rke2/bin:$PATH
export KUBECONFIG=/etc/rancher/rke2/rke2.yaml

source /etc/profile
```
4. 显示token `cat /var/lib/rancher/rke2/server/node-token`
5. 配置文件 `/etc/rancher/rke2/config.yaml`
```yaml
token: TOKEN
tls-san:
  - server1
```

其他server
1. 配置文件 `/etc/rancher/rke2/config.yaml`
```yaml
server: https://server1:9345
token: TOKEN
tls-san:
  - server1
```
重复执行第一个server: 1-4

---- workers ----
1. 配置文件 `/etc/rancher/rke2/config.yaml`
```yaml
server: https://server1:9345
token: TOKEN
```
2. 安装 agent `curl -sfL https://get.rke2.io | INSTALL_RKE2_TYPE="agent" sh -`
3. `systemctl enable rke2-agent`
4. `systemctl start rke2-agent`


---- kubectl外部连接 ----
1. 复制配置文件 `/etc/rancher/rke2/rke2.yaml` 为 `~/.kube/config`
2. 修改127.0.0.1 为外部ip地址