## Pré requis
- [Vagrant d'HashiCorp](https://www.vagrantup.com/)

- `vagrant plugin install vagrant-vbguest`


## install
```
make install
make start
# récupération du mdp admin de argocd
kubectl -n argocd get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d
```


## Eclipse CHE
Documentation             : https://www.eclipse.org/che/docs/
-------------------------------------------------------------------------------
Users Dashboard           : https://che-eclipse-che.che.k3d.localhost
Admin user login          : "admin:admin". NOTE: must change after first login.
-------------------------------------------------------------------------------
Plug-in Registry          : https://plugin-registry-eclipse-che.che.k3d.localhost/v3/
Devfile Registry          : https://devfile-registry-eclipse-che.che.k3d.localhost/
-------------------------------------------------------------------------------
Identity Provider URL     : https://keycloak-eclipse-che.che.k3d.localhost/auth/
Identity Provider login   : "admin:tWvISb0fR78J".
-------------------------------------------------------------------------------
[ACTION REQUIRED] Please add Che self-signed CA certificate into your browser: /tmp/cheCA.crt.
Documentation how to add a CA certificate into a browser: https://www.eclipse.org/che/docs/che-7/end-user-guide/importing-certificates-to-browsers/