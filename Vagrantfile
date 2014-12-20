require_relative 'vagrantvars.rb'
include VagrantVars

Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/trusty64"
    config.vm.box_url = "https://vagrantcloud.com/ubuntu/boxes/trusty64/versions/14.04/providers/virtualbox.box"
    config.vm.hostname = HOST_NAME
    config.ssh.forward_agent = true
    config.vm.synced_folder '.', '/vagrant', nfs: true

    config.vm.provision "lamp", type: "ansible" do |lamp|
        lamp.playbook = "ansible/lamp/playbook.yml"
        lamp.limit = 'all'
    end

    config.vm.provision "setup", type: "ansible", run: "always" do |setup|
        setup.playbook = "ansible/setup/playbook.yml"
        setup.limit = 'all'
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
        else # sorry Windows folks, I can't help you
          cpus = 2
          mem = 1024
        end

        v.customize ["modifyvm", :id, "--memory", mem]
        v.customize ["modifyvm", :id, "--cpus", cpus]
        v.customize ["modifyvm", :id, "--cpuexecutioncap", "100"]
        v.customize ["modifyvm", :id, "--hwvirtex", "on"]
    end


    #################################################
    ####                Machines                 ####
    #################################################

    config.vm.define "dev", primary: true do |dev|
        dev.vm.network :private_network, ip: DEV_IP_ADDRESS
        dev.vm.provider :virtualbox do |v|
            v.name = HOST_NAME + " - Dev"
        end

        config.vm.provision "lamp", type: "ansible" do |lamp|
          lamp.extra_vars = {
            enviroment: "dev",
            servername: HOST_NAME + ".dev",
            database_name: DATABASE_NAME,
            database_user: DATABASE_USER,
            database_password: DATABASE_PASSWORD,
          }
        end

        dev.vm.provision "setup", type: "ansible" do |setup|
          setup.extra_vars = {
            enviroment: "dev",
          }
        end
    end

    config.vm.define "test", autostart: false do |test|
        test.vm.network :private_network, ip: TEST_IP_ADDRESS

        test.vm.provider :virtualbox do |v|
            v.name = HOST_NAME + " - Test"
        end

        config.vm.provision "lamp", type: "ansible" do |lamp|
          lamp.extra_vars = {
            enviroment: "test",
            servername: HOST_NAME + ".test",
            database_name: DATABASE_NAME,
            database_user: DATABASE_USER,
            database_password: DATABASE_PASSWORD,
          }
        end

        test.vm.provision "setup", type: "ansible" do |setup|
            setup.extra_vars = {
                enviroment: "test",
            }
        end
    end

    config.vm.define "prod", autostart: false do |prod|
        prod.vm.network :private_network, ip: PROD_IP_ADDRESS
        prod.vm.synced_folder '.', '/vagrant', type: "rsync",
            rsync__exclude: [
                ".git/",
                "vendors"
            ]

        prod.vm.provider :virtualbox do |v|
            v.name = HOST_NAME + " - Prod"
        end

        config.vm.provision "lamp", type: "ansible" do |lamp|
          lamp.extra_vars = {
            enviroment: "prod",
            servername: HOST_NAME + ".prod",
            database_name: DATABASE_NAME,
            database_user: DATABASE_USER,
            database_password: DATABASE_PASSWORD,
          }
        end

        prod.vm.provision "setup", type: "ansible" do |setup|
            setup.extra_vars = {
                enviroment: "prod",
            }
        end
    end
end
