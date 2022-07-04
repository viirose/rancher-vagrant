Vagrant.configure("2") do |config|

    config.vm.box = "generic/centos7"

    config.vm.provider "parallels" do |vb|
        vb.cpus = "2"
        vb.memory = "4096"
    end

    config.vm.synced_folder "./setup", "/vagrant"

# -------- Iint VM --------
    $init_vm = <<-SCRIPT
sed -i 's/#PermitRootLogin/PermitRootLogin/g' /etc/ssh/sshd_config
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
swapoff -a 
sed -ri 's/.*swap.*/#&/' /etc/fstab  
systemctl stop firewalld && systemctl disable firewalld
timedatectl set-timezone 'Asia/Shanghai'

cat >> /etc/profile <<EOL
export all_proxy=https://queen:7d09a90c@tk.storm-walker.com:443
export no_proxy=localhost,127.0.0.1,192.168.56.0/12,::1,server1,server2,server3,worker1,worker2
EOL

mkdir -p /etc/rancher/rke2/

SCRIPT

# ==================  VMs =====================

    # ======= Server1 ========
    config.vm.define "server1" do |vagrant|
        vagrant.vm.hostname = "server1"
        vagrant.vm.network "private_network", ip: "192.168.56.10"
        
        vagrant.vm.provision "shell", inline: <<-SHELL
            cat >> /etc/hosts <<EOL
# 192.168.56.10 server1
192.168.56.11 server2
192.168.56.12 server3
192.168.56.100 worker1
192.168.56.101 worker2
EOL
        SHELL

        vagrant.vm.provision "shell", inline: $init_vm

    end

    # ======= Server2 ========
    config.vm.define "server2" do |vagrant|
        vagrant.vm.hostname = "server2"
        vagrant.vm.network "private_network", ip: "192.168.56.11"
        
        vagrant.vm.provision "shell", inline: <<-SHELL
            cat >> /etc/hosts <<EOL
192.168.56.10 server1
# 192.168.56.11 server2
192.168.56.12 server3
192.168.56.100 worker1
192.168.56.101 worker2
EOL

        SHELL

        vagrant.vm.provision "shell", inline: $init_vm

    end

    # ======= Server3 ========
    config.vm.define "server3" do |vagrant|
        vagrant.vm.hostname = "server3"
        vagrant.vm.network "private_network", ip: "192.168.56.12"
        
        vagrant.vm.provision "shell", inline: <<-SHELL
            cat >> /etc/hosts <<EOL
192.168.56.10 server1
192.168.56.11 server2
# 192.168.56.12 server3
192.168.56.100 worker1
192.168.56.101 worker2
EOL

        SHELL

        vagrant.vm.provision "shell", inline: $init_vm

    end

    # ------ worker1 ------
    config.vm.define "worker1" do |vagrant|
        vagrant.vm.hostname = "worker1"
        vagrant.vm.network "private_network", ip: "192.168.56.100"
        
        vagrant.vm.provision "shell", inline: <<-SHELL
            cat >> /etc/hosts <<EOL
192.168.56.10 server1
192.168.56.11 server2
192.168.56.12 server3
# 192.168.56.100 worker1
192.168.56.101 worker2
EOL
        SHELL

        vagrant.vm.provision "shell", inline: $init_vm

    end

    # ------ worker2 ------
    config.vm.define "worker2" do |vagrant|
        vagrant.vm.hostname = "worker2"
        vagrant.vm.network "private_network", ip: "192.168.56.101"
        
        vagrant.vm.provision "shell", inline: <<-SHELL
            cat >> /etc/hosts <<EOL
192.168.56.10 server1
192.168.56.11 server2
192.168.56.12 server3
192.168.56.100 worker1
# 192.168.56.101 worker2
EOL
        SHELL

        vagrant.vm.provision "shell", inline: $init_vm

    end

end
