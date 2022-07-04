### Rancher RKE2 高可用

#### 自动
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
2. 修改127.0.0.1 为外部ip地址