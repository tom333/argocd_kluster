# préparation
helm repo add argo-cd https://argoproj.github.io/argo-helm
helm dep update

# install
kubectl create namespace argocd
helm install argo-cd . --namespace argocd

# mot passe par défaut = nom du pod
kubectl get pods -l app.kubernetes.io/name=argocd-server -o name -n argocd| cut -d'/' -f 2
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

helm upgrade -f values.yaml argo-cd . --version argo-cd-1.0.0 --namespace argocd