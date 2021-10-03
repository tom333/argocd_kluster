## Pré requis
- [Vagrant d'HashiCorp](https://www.vagrantup.com/)

- `vagrant plugin install vagrant-vbguest`



## Build and run VBox
run `vagrant up`


## DNSMASQ

`sudo nano /etc/NetworkManager/NetworkManager.conf`
ajout de `dns=dnsmasq` dans la section `[main]`

sudo nano /etc/dnsmasq.d/kube.conf
address=/matrix/42.42.42.42

sudo systemctl restart NetworkManager
sudo service dnsmasq restart
