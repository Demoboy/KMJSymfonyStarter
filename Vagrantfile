require_relative 'vagrantvars.rb'
require "ipaddr"
include VagrantVars

unless Vagrant.has_plugin?("vagrant-vbguest")
  raise 'VBGuest plugin is not installed'
end

if Vagrant::Util::Platform.windows?
  unless Vagrant.has_plugin?("vagrant-winnfsd")
    raise 'Winnfsd plugin not installed and is required for a windows install'
  end
end

unless Vagrant.has_plugin?("vagrant-hostsupdater")
  raise 'hostsupdater plugin not installed and is required'
end

Vagrant.configure("2") do |config|
  config.vm.box = "helderco/trusty64"

  config.ssh.forward_agent = true
  config.vm.synced_folder '.', '/vagrant', nfs: true

  if !Vagrant::Util::Platform.windows?
    config.vm.provision "lamp", type: "ansible" do |lamp|
      lamp.playbook = "ansible/lamp/playbook.yml"
      lamp.limit = 'all'
    end

    config.vm.provision "setup", type: "ansible", run: "always" do |setup|
      setup.playbook = "ansible/setup/playbook.yml"
      setup.limit = 'all'
    end
  else
    config.vm.provision "lamp", type: "shell" do |lamp|
      lamp.path="ansible/windows-provisioner.sh"
    end
    config.vm.provision "setup", type: "shell" do |setup|
      setup.path="ansible/windows-provisioner.sh"
    end
  end

  config.vm.provider :virtualbox do |v|
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

    v.customize ["modifyvm", :id, "--memory", mem]
    v.customize ["modifyvm", :id, "--cpus", cpus]
    v.customize ["modifyvm", :id, "--cpuexecutioncap", "100"]
    v.customize ["modifyvm", :id, "--hwvirtex", "on"]
  end

    config.vm.provider "vmware_fusion" do |v|
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

        v.vmx["memsize"]  = mem
        v.vmx["numvcpus"] = cpus
    end


  #################################################
  ####                Machines                 ####
  #################################################

  config.vm.define "dev", primary: true do |dev|
    dev.vm.network :private_network, ip: DEV_IP_ADDRESS
    dev.vm.hostname = HOST_NAME + ".dev"

    dev.vm.provider :virtualbox do |v|
      v.name = HOST_NAME + " - Dev"
    end

    if !Vagrant::Util::Platform.windows?
      dev.vm.provision "lamp", type: "ansible" do |lamp|
        ipArray = DEV_IP_ADDRESS.split(".");
        ipArray[-1] = "1";

        lamp.extra_vars = {
          enviroment: "dev",
          servername: HOST_NAME + ".dev",
          database_name: DATABASE_NAME,
          database_user: DATABASE_USER,
          database_password: DATABASE_PASSWORD,
          xdebug_ip: ipArray.join("."),
        }
      end

      dev.vm.provision "setup", type: "ansible" do |setup|
        setup.extra_vars = {
          enviroment: "dev",
        }
      end
    else
      dev.vm.provision "lamp", type: "shell" do |lamp|
        lamp.args="ansible/lamp/playbook.yml  \"enviroment=dev servername="+HOST_NAME+".dev database_name="+DATABASE_NAME+" database_user=" + DATABASE_USER + " database_password="+DATABASE_PASSWORD+"\""
      end
      dev.vm.provision "setup", type: "shell" do |setup|
        setup.args="ansible/setup/playbook.yml  \"enviroment=dev\""
      end
    end

  end

  config.vm.define "test", autostart: false do |test|
    test.vm.network :private_network, ip: TEST_IP_ADDRESS
    test.vm.hostname = HOST_NAME + ".test"

    test.vm.provider :virtualbox do |v|
      v.name = HOST_NAME + " - Test"
    end

    if !Vagrant::Util::Platform.windows?
      test.vm.provision "lamp", type: "ansible" do |lamp|
       ipArray = DEV_IP_ADDRESS.split(".");
        ipArray[-1] = "1";

        lamp.extra_vars = {
          enviroment: "test",
          servername: HOST_NAME + ".test",
          database_name: DATABASE_NAME,
          database_user: DATABASE_USER,
          database_password: DATABASE_PASSWORD,
          xdebug_ip: ipArray.join("."),
        }
      end

      test.vm.provision "setup", type: "ansible" do |setup|
        setup.extra_vars = {
          enviroment: "test",
        }
      end
    else
      test.vm.provision "lamp", type: "shell" do |lamp|
        lamp.args="ansible/lamp/playbook.yml  \"enviroment=test servername="+HOST_NAME+".test database_name="+DATABASE_NAME+" database_user=" + DATABASE_USER + " database_password="+DATABASE_PASSWORD+"\""
      end
      test.vm.provision "setup", type: "shell" do |setup|
        setup.args="ansible/setup/playbook.yml  \"enviroment=test\""
      end
    end
  end

  config.vm.define "prod", autostart: false do |prod|
    prod.vm.network :private_network, ip: PROD_IP_ADDRESS
    prod.vm.hostname = HOST_NAME + ".prod"

    prod.vm.synced_folder '.', '/vagrant', type: "rsync",
    rsync__exclude: [
      ".git/",
      "vendors"
    ]

    prod.vm.provider :virtualbox do |v|
      v.name = HOST_NAME + " - Prod"
    end

    if !Vagrant::Util::Platform.windows?
      prod.vm.provision "lamp", type: "ansible" do |lamp|
        ipArray = DEV_IP_ADDRESS.split(".");
        ipArray[-1] = "1";

        lamp.extra_vars = {
          enviroment: "prod",
          servername: HOST_NAME + ".prod",
          database_name: DATABASE_NAME,
          database_user: DATABASE_USER,
          database_password: DATABASE_PASSWORD,
          xdebug_ip: ipArray.join("."),
        }
      end

      prod.vm.provision "setup", type: "ansible" do |setup|
        setup.extra_vars = {
          enviroment: "prod",
        }
      end
    else
      prod.vm.provision "lamp", type: "shell" do |lamp|
        lamp.args="ansible/lamp/playbook.yml  \"enviroment=prod servername="+HOST_NAME+".prod database_name="+DATABASE_NAME+" database_user=" + DATABASE_USER + " database_password="+DATABASE_PASSWORD+"\""
      end
      prod.vm.provision "setup", type: "shell" do |setup|
        setup.args="ansible/setup/playbook.yml  \"enviroment=prod\""
      end
    end
  end
end
