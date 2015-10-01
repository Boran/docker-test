# -*- mode: ruby -*-
# vi: set ft=ruby :
#
# Automate installation of a Ubuntu VM, with docker+tools
# USAGE: see vagrant.md
# See also https://docs.vagrantup.com.
########

Vagrant.require_version ">= 1.6.0"
VAGRANTFILE_API_VERSION = "2"

require 'yaml'
servers = YAML.load_file('servers.yaml')

# The "2" in Vagrant.configure configures the configuration version 
Vagrant.configure(2) do |config|

  config.vm.box = "ubuntu/trusty64"
  #config.vm.box_check_update = false

  # Iterate through entries in YAML file
  servers.each do |servers|
    #config.vm.define no-proxy["name"] do |srv|
    config.vm.define servers["name"] do |srv|
      srv.vm.box = servers["box"]
      if servers["proxy"] == 1
        # Proxies: if you network requires outgoing access via a proxy
        if Vagrant.has_plugin?("vagrant-proxyconf")
          config.proxy.http     = "http://proxy.example.ch:80"
          config.proxy.https    = "http://proxy.example.ch:80"
          config.proxy.ftp      = "http://proxy.example.ch:80"
          config.proxy.no_proxy = "localhost,127.0.0.1,.example.ch"
        end
      end

      srv.vm.provision :shell, path: "vagrant.sh"
      srv.vm.hostname = servers["name"]
      # Option: enable a private network between Servers
      #srv.vm.network "private_network", ip: servers["ip"]

      srv.vm.provider :virtualbox do |vb|
        vb.name = servers["name"]
        vb.memory = servers["ram"]
        # Display the VirtualBox GUI when booting the machine
        #vb.gui = true
        #vb.cpus = 2
        # Limit cpu load
        #vb.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
      end

      # Create a forwarded port mapping which allows access to a specific port
      # within the machine from a port on the host machine. 
      # E.g. for port 8001 inside the VM to 8001 on the mac host
      #config.vm.network "forwarded_port", guest: 8001, host: 8001

      # Share an additional folder to the guest VM. The first argument is
      # the path on the host to the actual folder. The second argument is
      # the path on the guest to mount the folder. And the optional third
      # argument is a set of non-required options.
      # config.vm.synced_folder "../data", "/vagrant_data"
    end
  end

end

