require_relative 'vagrantvars.rb'
require "ipaddr"
require 'openssl'
include VagrantVars

unless Vagrant.has_plugin?("vagrant-vbguest")
  raise 'vagrant-vbguest plugin is not installed'
end

unless Vagrant.has_plugin?("vagrant-hostsupdater")
  raise 'vagrant-hostsupdater plugin not installed and is required'
end

Vagrant.configure("2") do |config|

  if ARGV[1] and \
      (ARGV[1].split('=')[0] == "--provider" or ARGV[2])
    provider = (ARGV[1].split('=')[1] || ARGV[2])
  else
    provider = (ENV['VAGRANT_DEFAULT_PROVIDER'] || :virtualbox).to_sym
  end

  config.vm.provision "lamp", type: "ansible" do |lamp|
    lamp.playbook = "ansible/lamp/playbook.yml"
    lamp.limit = 'all'
  end

  config.vm.provision "setup", type: "ansible", run: "always" do |setup|
    setup.playbook = "ansible/setup/playbook.yml"
    setup.limit = 'all'
  end

  if provider == "aws"  
    config.vm.box = "dimroc/awsdummy"

    config.vm.provider :aws do |aws, override|    
      aws.access_key_id = AWS_ACCESS_KEY_ID
      aws.secret_access_key = AWS_ACCESS_KEY_SECRET
      aws.keypair_name = AWS_KEYPAIR_NAME
      aws.region = AWS_REGION
      aws.instance_type = AWS_INSTANCE_TYPE
      aws.associate_public_ip = true
      aws.subnet_id = AWS_SUBNET_ID
      aws.ami = "ami-5189a661"

      aws.tags = AWS_TAGS

      aws.block_device_mapping = [
        { 
          'DeviceName' => '/dev/sda1', 'Ebs.VolumeSize' => 8
        }
      ]

      override.ssh.username = "ubuntu"
      override.ssh.private_key_path = "./" + AWS_KEYPAIR_NAME + ".pem"       
    end
  else
  
    config.vm.provider :virtualbox or config.vm.provider :vmware_fusion do |v|
      config.vm.box = "helderco/trusty64"

      config.ssh.forward_agent = true
      config.vm.synced_folder '.', '/vagrant', nfs: true
      config.vm.synced_folder '~/.ssh', '/home/vagrant/host_ssh', nfs: true
        
      config.vm.provider :virtualbox do |virtualbox|
        host = RbConfig::CONFIG['host_os']

        # Give VM 1/4 system memory & access to all cpu cores on the host
        if host =~ /darwin/
          cpus = `sysctl -n hw.ncpu`.to_i
          # sysctl returns Bytes and we need to convert to MB
          mem = `sysctl -n hw.memsize`.to_i / 1024 / 1024 / 4
        elsif host =~ /linux/ 
          cpus = `nproc`.to_i
          # meminfo shows KB and we need to convert to MB
          mem = `grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i / 1024 / 4
        else
          cpus = 8
          mem = 1024
        end

        virtualbox.customize ["modifyvm", :id, "--memory", mem]
        virtualbox.customize ["modifyvm", :id, "--cpus", cpus]
        virtualbox.customize ["modifyvm", :id, "--cpuexecutioncap", "100"]
        virtualbox.customize ["modifyvm", :id, "--hwvirtex", "on"]
      end

      config.vm.provider "vmware_fusion" do |vmware|
        host = RbConfig::CONFIG['host_os']

        # Give VM 1/4 system memory & access to all cpu cores on the host
        if host =~ /darwin/
          cpus = `sysctl -n hw.ncpu`.to_i
          # sysctl returns Bytes and we need to convert to MB
          mem = `sysctl -n hw.memsize`.to_i / 1024 / 1024 / 4
        elsif host =~ /linux/ 
          cpus = `nproc`.to_i
          # meminfo shows KB and we need to convert to MB
          mem = `grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i / 1024 / 4
        else
          cpus = 8
          mem = 1024
        end

        vmware.vmx["memsize"]  = mem
        vmware.vmx["numvcpus"] = cpus
      end
    end
  end
  
  #################################################
  ####                Machines                 ####
  #################################################

  config.vm.define "dev", primary: true do |dev|
    dev.vm.network :private_network, ip: IP_ADDRESS
    dev.vm.hostname = DEV_HOST_NAME

    dev.vm.provider :virtualbox do |v|
      v.name = DEV_HOST_NAME + " - Dev"
    end

    dev.vm.provision "lamp", type: "ansible" do |lamp|
      ipArray = IP_ADDRESS.split(".");
      ipArray[-1] = "1";

      lamp.extra_vars = {
        enviroment: "dev",
        servername: DEV_HOST_NAME,
        provider: "local",
        doc_root: "/vagrant/web",
        database_name: DATABASE_NAME,
        database_user: DATABASE_USER,
        database_password: DATABASE_PASSWORD,
        xdebug_ip: ipArray.join("."),
      }
    end

    config.vm.provision :shell, run: "always",
        :inline => "sudo -i -u vagrant cp -R /home/vagrant/host_ssh/* /home/vagrant/.ssh/ && chmod 700 /home/vagrant/.ssh/*"

    dev.vm.provision "setup", type: "ansible" do |setup|
      setup.extra_vars = {
        enviroment: "dev",
      }
    end
  end
  
end
