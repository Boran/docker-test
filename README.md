
A quick way to setup a docker test environment. This tool
 * Creates a VM with the Ubuntu 14.04 (hashcorp/trusty box)
 * Pulls the latest docker release, fixes a few permissions and installs docker-compose. 
 * Pulls a small example container (alpine linux)

Features
 * Tested on: Mac 10.10 +Virtualbox 4.3.30 +Vagrant 1.7.4, Windows 8 +Virtual 4.3.8 + Vagrant 1.7.2
 * Works with outgoing proxies

Why
 * This pattern is small, simple and easy to duplicate into other projects.
 * Reason: docker-machine was a bit too complex and didn't work for me. Boot2docker is no longer supported.

Requirements
 * Vagrant, virtualbox
 * If proxies: vagrant plugin install vagrant-proxyconf


USAGE
-----
```
vagrant up
vagrant ssh

# play with docker:
docker images
docker run --rm -it alpine sh

# /vagrant gives accces to the host folder
ls /vagrant
```

Outgoing proxies: if you are behind a proxy firewall, enable the proxies in servers.yaml and Vagrantfile
Instal the vagrant lugin: vagrant plugin install vagrant-proxyconf
Which updates /etc/profile.d/proxy.sh /etc/environment 
Can override: VAGRANT_HTTP_PROXY="http://proxy.example.com:8080" vagrant up



TODO
----
. Use a more lightweight base image than Ubuntu 14.04
. Copy over default .bashrc from the host

