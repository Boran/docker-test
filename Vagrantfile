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

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "ubuntu/trusty64"
  # Enable now and again for check for new boxes:
  config.vm.box_check_update = false

  # Iterate through entries in YAML file
  servers.each do |servers|
    config.vm.define servers["name"] do |srv|
      srv.vm.box = servers["box"]

      if ENV["http_proxy"]
        # Detect proxies and configure
        if Vagrant.has_plugin?("vagrant-proxyconf")
          config.proxy.http     = ENV.fetch('http_proxy')
          if ENV["https_proxy"]
            config.proxy.https    = ENV.fetch('https_proxy')
          end
          if ENV["no_proxy"]
             config.proxy.no_proxy = ENV.fetch('no_proxy')
          end
        end
      end

      srv.vm.hostname = servers["name"]
      # Option: enable a private network between Servers
      #srv.vm.network "private_network", ip: servers["ip"]

      srv.vm.provider :virtualbox do |vb|
        vb.name = servers["name"]
        # resources:
        vb.memory = servers["ram"]
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

      # Provision the VM with docker + tools
      srv.vm.provision :shell, path: "vagrant.sh"
      # optional: after vagrant.sh when proxies are set, do 
      #           additional provisioning
      #srv.vm.provision :shell, inline: "docker pull alpine"
      #srv.vm.provision :shell, inline: "docker images"
    end
  end

end

