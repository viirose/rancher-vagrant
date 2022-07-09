# /bin/sh

prlctl stop server1
prlctl stop server2
prlctl stop server3
# prlctl stop worker1
# prlctl stop worker2

prlctl list --all


k3s server \
  --write-kubeconfig-mode "0644"    \
  --tls-san "k3.local"             \
  --node-label "server1"  


# 创建首个主节点，k3s-m1
curl -sfL https://get.k3s.io \
    | bash -s - server --cluster-init

# 查看口令，k3s-m1
cat /var/lib/rancher/k3s/server/node-token

# 添加其他主节点，k3s-m2，k3s-m3
curl -sfL https://get.k3s.io                \
    | K3S_TOKEN="K106b3ec83860442b512b4c4e7fe901a6d0b503bcc22738f1d61024d991a51ceba7::server:f479ff5813e9205f3fecd35b1e725de0" \
      bash -s - server --server https://10.211.55.10:6443