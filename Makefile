


k9s:
	KUBECONFIG=./cluster/k3s.yaml k9s --all-namespaces

start:
	echo "⏳ 🗄 starting K3S cluster"
	vagrant up

stop:
	echo "⏳ 👋 stoping K3S cluster"
	vagrant halt

ssh:
	echo "⏳ 🗄 connecting to K3S cluster"
	vagrant ssh