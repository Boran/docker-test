#!/bin/bash

# What does this do?
# Configure Ubuntu 14.04 VM to host docker containers
# Note:
# - expects to run as root/sudo

#TODO echo "-- speed up login --
#https://gist.github.com/jedi4ever/5657094
#echo -e "\nUseDNS no  # Disable DNS lookups" >> /etc/ssh/sshd_config  && sudo /etc/init.d/ssh restart

echo "------------ Install docker + tools ------------"

echo "---- docker group -----"
groupadd docker
usermod -aG docker vagrant
usermod -aG docker www-data

echo "---- install curl, extras for aufs  -----"
apt-get update -yq
apt-get -yqq install apt-transport-https linux-image-extra-`uname -r` curl

echo "---- install docker-compose -----"
curl -sSL https://github.com/docker/compose/releases/download/1.4.0/docker-compose-`uname -s`-`uname -m` > /tmp/docker-compose
mv /tmp/docker-compose /usr/local/bin/docker-compose
chmod 755 /usr/local/bin/docker-compose

echo "---- install docker -----"
if [ ! -z "http_proxy" ]; then
  # Some parts of the docker install don't work with proxies
  echo "Proxies enabled: for keyserver "
  apt-key adv --keyserver-options http-proxy=$http_proxy --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
fi
curl -sSL https://get.docker.com/ | sh
if [ ! -z "http_proxy" ]; then
  echo "Proxies enabled: for docker daemon "
  echo "export https_proxy=$https_proxy" >> /etc/default/docker
fi
restart docker
docker --version

echo "---- permissions -----"
chown -R www-data /var/run/docker.sock


echo "---- environment -----"
echo "---- Timezone/local for Switzerland"
echo -e "\nLC_ALL=en_US.UTF-8" >> /etc/default/locale
locale-gen UTF-8 en_US en_US.UTF-8 de_CH de_CH.UTF-8
dpkg-reconfigure locales
timedatectl set-timezone Europe/Zurich

git config --global push.default matching
echo "---- Set VM name to webfact-vm "
sudo hostname docker-test
echo docker-test > /etc/hostname

echo "---- download alpine linux image to test docker -----"
docker pull alpine

#echo "---- Install container via docker-compose  -----"
#cd /vagrant/somedir
#docker-compose up -d somecontainer

echo "---- provisioning done `date +%Y%m%d` ----- "

