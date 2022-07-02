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
token: K10d521e958d2ad65c1cf15f12ad8e40d561a39d2c29955c737976dcbd4bac6a6d5::server:2eed359e1e2714b37745478cb7a03596
tls-san:
  - server1
```

其他server
1. 配置文件 `/etc/rancher/rke2/config.yaml`
```yaml
server: https://server1:9345
token: K10d521e958d2ad65c1cf15f12ad8e40d561a39d2c29955c737976dcbd4bac6a6d5::server:2eed359e1e2714b37745478cb7a03596
tls-san:
  - server1
```
重复执行第一个server: 1-4

---- workers ----
1. 配置文件 `/etc/rancher/rke2/config.yaml`
```yaml
server: https://server1:9345
token: K10d521e958d2ad65c1cf15f12ad8e40d561a39d2c29955c737976dcbd4bac6a6d5::server:2eed359e1e2714b37745478cb7a03596
```
2. 安装 agent `curl -sfL https://get.rke2.io | INSTALL_RKE2_TYPE="agent" sh -`
3. `systemctl enable rke2-agent`
4. `systemctl start rke2-agent`


---- kubectl外部连接 ----
1. 复制配置文件 `/etc/rancher/rke2/rke2.yaml` 为 `~/.kube/config`
2. 修改127.0.0.1 为外部ip地址