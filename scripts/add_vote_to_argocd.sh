cat << EOF > argocd/argocd-appprojects/voting-project.yaml
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: voting-app
  namespace: argocd
spec:
  clusterResourceWhitelist:
  - group: '*'
    kind: '*'
  destinations:
  - namespace: vote
    server: https://kubernetes.default.svc
  orphanedResources:
    warn: false
  sourceRepos:
  - '*'
EOF

cat << EOF > argocd/argocd-apps/voting-app.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: voting-app
  namespace: argocd
spec:
  destination:
    namespace: vote
    server: https://kubernetes.default.svc
  project: voting-project
  source:
    path: voting-app/
    repoURL: https://github.com/tom333/argocd_kluster.git
    targetRevision: HEAD
  syncPolicy:
    syncOptions:
    - CreateNamespace=true
    automated:
      selfHeal: true
      prune: true

EOF
