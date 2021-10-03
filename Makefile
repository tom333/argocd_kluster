
.PHONY: whoami argocd

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

whoami:
	KUBECONFIG=./cluster/k3s.yaml kubectl apply -f whoami/namespace.yml -f whoami/deploiement.yml -f whoami/service.yml -f whoami/ingress.yml

delete-whoami:
	KUBECONFIG=./cluster/k3s.yaml kubectl delete namespace whoami

KEY_FILE=certs/key.crt
CERT_FILE=certs/cert
HOST=matrix
CERT_NAME=matrix-cert

cert:
	# openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ${KEY_FILE} -out ${CERT_FILE} -subj "/CN=${HOST}/O=${HOST}"
	kubectl create secret tls ${CERT_NAME} --key ${KEY_FILE} --cert ${CERT_FILE} -n whoami


argocd:
	# kubectl create namespace argocd
	helm install argocd argocd/argocd-install  --namespace argocd --create-namespace
	kubectl get pods -l app.kubernetes.io/name=argocd-server -n argocd -o name | cut -d'/' -f 2
	kubectl -n argocd get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d

delete-argocd:
	helm uninstall argo-cd -n argocd

demo:
	kubectl create ns whoami
	./scripts/add_whoami_to_argocd.sh


voting:
	./scripts/add_vote_to_argocd.sh