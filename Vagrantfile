# -*- mode: ruby -*-

CLUSTER_NAME = "demo.local"
CLUSTER_DOMAIN = "demo.test"
CLUSTER_IP = "42.42.42.42"
BOX_IMAGE = "bento/ubuntu-20.10"


Vagrant.configure("2") do |config|

  config.vm.box = BOX_IMAGE

  config.vm.define "#{CLUSTER_NAME}" do |node|

    node.vm.hostname = "#{CLUSTER_NAME}"
    node.vm.network "private_network", ip: "#{CLUSTER_IP}"

    node.vm.synced_folder "./cluster/", "/cluster", id:"cluster", create: true
    node.vm.synced_folder "./conf", "/conf"

    node.vm.provider "virtualbox" do |vb|
      vb.memory = 2048
      vb.cpus = 1
      vb.name = "#{CLUSTER_NAME}"
    end


    node.vm.provision "add-tools", privileged: true, type: "shell" , inline: <<-SHELL
      # Add tools
      echo "👋 setup"
      apt-get update
      apt-get install unzip -y
      apt-get install zip -y
      apt-get install jq -y
      apt-get install -y curl
    SHELL


    node.vm.provision "k3s-install", privileged: true, type: "shell", inline: <<-SHELL
      curl -sfL https://get.k3s.io | sh -
    SHELL

    # vagrant provision --provision-with hosts
    node.vm.provision "hosts", privileged: true, type: "shell" , inline: <<-SHELL
      # Add entries to hosts file:
      echo "" >> /etc/hosts
      echo '#{CLUSTER_IP} #{CLUSTER_DOMAIN}' >> /etc/hosts
      echo "" >> /etc/hosts
    SHELL

    node.vm.provision "kubectl", privileged: true, type: "shell" , inline: <<-SHELL
      # Install kubectl
      sudo apt-get update && sudo apt-get install -y apt-transport-https
      curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
      echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
      sudo apt-get update
      sudo apt-get install -y kubectl
    SHELL



    node.vm.provision "dashboard", privileged: true, type: "shell" , inline: <<-SHELL
      # Install k8s dashboard
      GITHUB_URL=https://github.com/kubernetes/dashboard/releases
      VERSION_KUBE_DASHBOARD=$(curl -w '%{url_effective}' -I -L -s -S ${GITHUB_URL}/latest -o /dev/null | sed -e 's|.*/||')
      kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/${VERSION_KUBE_DASHBOARD}/aio/deploy/recommended.yaml
      kubectl apply -f /conf/dashboard.admin-user.yml -f /conf/dashboard.admin-user-role.yml -f /conf/dashboard.ingress.yml
    SHELL

    # node.vm.provision "argocd", privileged: true, type: "shell" , inline: <<-SHELL
    #   # Install argocd
    #   kubectl create namespace argocd
    #   kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/core-install.yaml
    #   kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
    # SHELL

    node.vm.provision "get-config", privileged: true, type: "shell" , inline: <<-SHELL
    cat /etc/rancher/k3s/k3s.yaml > /cluster/k3s.yaml
      sed -i "s/127.0.0.1/#{CLUSTER_IP}/" /cluster/k3s.yaml
      cat /var/lib/rancher/k3s/server/node-token > /cluster/node-token.txt
      echo 'cluster_ip="#{CLUSTER_IP}"' > /cluster/cluster.config
      kubectl -n kubernetes-dashboard describe secret admin-user-token | grep '^token' > /cluster/dashboard-token
    SHELL


  end
end
