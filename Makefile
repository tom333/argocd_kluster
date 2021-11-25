
.PHONY: whoami argocd

k9s:
	KUBECONFIG=./cluster/k3s.yaml k9s --all-namespaces

start:
	echo "⏳ 🗄 starting K3S cluster"
	docker run --rm -d --name registry -p 5000:5000 -v ${PWD}/k3s/local_registry_cache:/var/lib/registry -e REGISTRY_PROXY_REMOTEURL="https://registry-1.docker.io" registry:2
	k3d cluster create dev --port 80:80@loadbalancer --port 443:443@loadbalancer --volume "${PWD}/k3s/registry.yaml:/etc/rancher/k3s/registries.yaml"
	kubectl create namespace argocd
	helm install argo-cd argocd/argocd-install/ --namespace argocd

stop:
	echo "⏳ 👋 stoping K3S cluster"
	k3d cluster stop dev
	docker stop registry

whoami:
	KUBECONFIG=./cluster/k3s.yaml kubectl apply -f whoami/namespace.yml -f whoami/deploiement.yml -f whoami/service.yml -f whoami/ingress.yml

delete-whoami:
	KUBECONFIG=./cluster/k3s.yaml kubectl delete namespace whoami

KEY_FILE=certs/key.crt
CERT_FILE=certs/cert
HOST=k3d.localhost
CERT_NAME=k3d.localhost-cert

argocd:
	# kubectl create namespace argocd
	helm install argocd argocd/argocd-install  --namespace argocd --create-namespace
	# kubectl get pods -l app.kubernetes.io/name=argocd-server -n argocd -o name | cut -d'/' -f 2
	kubectl -n argocd get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d

delete-argocd:
	helm uninstall argo-cd -n argocd

demo:
	kubectl create ns whoami
	./scripts/add_whoami_to_argocd.sh


voting:
	./scripts/add_vote_to_argocd.sh


install:
	wget -q -O - https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash
	mkdir -p ~/.zsh/completions
	k3d completion zsh > .zsh_k3d
	# source .zsh_k3d
	k3d --version
	docker --version
	helm --version