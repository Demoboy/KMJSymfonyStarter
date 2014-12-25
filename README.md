KMJ Standard Symfony Project
========================

The goal of this project was to provide a ready-to-code installation of the Symfony2 Framework.

This Symfony project comes bundled (configs included) with

   * [**FOSUserBundle**][1]
   * [**KMJToolkitBundle**][2]
   * [**KMJCronBundle**][3]
   * [**KMJSyncBundle**][4]
   * [**Vagrant**][5] with [**Ansible**][6] configuration

The virtual machine will come with the following installed:

    Apache 2.4
    PHP 5.6
    Composer
    wkhtmltopdf
    nodejs
    lessc
    uglifiycss
    uglifiyjs


1) System Requirements
----------------------------------

This project should support all operating systems. This guide assumes you are a *nix based system.

Please make sure you have installed the following dependencies installed on your system.

   * [**Git**][9]
   * [**Vagrant**][5]
   * [**vagrant-vbguest**][7]
   * [**vagrant-hostsupdater**][10]
   * [**vagrant-winnfsd**][11] (Windows only)
   * [**Ansible**][6] (For windows installation see windows section of this document)
   * [**VirtualBox**][8]

Since we are using vagrant, PHP and Composer are not required as the Ansible configuration
will automatically install it when the vagrant box first boots


2) Installation
----------------------------------

Using Git

The best way to install the project is to clone the repository and then remove
the .git folder so that you can start with a fresh project. The following commands
will do just that.

    git clone https://github.com/Demoboy/KMJSymfonyStarter.git projectname
    cd projectname
    rm -rf .git
    git init
    git add *
    git commit -a -m "First commit"


Manual Installation

If git is not available on the system you can download the master zip file from the repository
directly. Then remove the .git folder.

3) Basic Configuration
----------------------------------

The only configuration that is required is to modify the vagrantvars.rb file.
The configuration options are described in that file.

***Please Note: The domain will automatically have your environment appended to it***
This means that setting the value of HOST_NAME to "kmj" would configure the dev machine
to be configured with a host name of "kmj.dev" and a test machine host name of "kmj.test" etc.

These domain names are written to your hosts file when you call vagrant up and removed when running vagrant halt

4) First run
----------------------------------

To begin the automated setup of the box type

    vagrant up

See the vagrant documentation to see exactly is going on while running this command.
This process will take a few minutes while it installs the necessary applications and binaries.

After the installation is complete run:

    vagrant ssh
    cd /vagrant

This will remote you into the newly created virtual machine and change the directory to the project.
From here you can run Composer and any other project configuration that might need to take place.
But after that is all completed, you will be able to visit the URL in the vagrantvars.rb and view the site.

5) Environments
----------------------------------

Vagrant has been configured to have different virtual machines based on the environment you want.
The default ones are:

    dev
    test
    prod

The dev environment is the default and therefore running vagrant up loads the dev Vagrant box.
If you want to load up the testing environment just type

    vagrant up test

There will also be an Ansible variable set called environment that will contain
the current loading environment which is handy if needing to only install certain programs in
specific environments.

6) Windows Support
----------------------------------
This project including Vagrant and Ansible can be used in a Windows environment. In order for
the project to work smoothly a few extra additions need to get made to vagrant. Be sure to install the
[**vagrant-winnfsd**][11] plugin as using vagrant without nfs is very slow. Be sure to install also install cygwin.

When running a Cygwin terminal be sure to run it as administrator otherwise the vagrant up command will
fail when it attempts to write the hostname to the hosts file.

Sometimes when running the vagrant plugin install command an error would pop up complaining that a root
certificate was invalid when installing from https://rubygems.org. A work around is to install the plugin from the
non SSL site. Just append --plugin-source http://rubygems.org to the command and it should install smoothly.

Since Ansible is not available to run on a windows host, there is a shell script to install Ansible on
your newly created virtual machine. The script will then configure the virtual machine locally using Ansible

[1]: https://github.com/FriendsOfSymfony/FOSUserBundle
[2]: https://github.com/Demoboy/ToolkitBundle
[3]: https://github.com/Demoboy/KMJCronBundle
[4]: https://github.com/Demoboy/KMJSyncBundle
[5]: https://www.vagrantup.com
[6]: http://www.ansible.com/home
[7]: https://github.com/dotless-de/vagrant-vbguest
[8]: https://www.virtualbox.org
[9]: http://git-scm.com
[10]: https://github.com/cogitatio/vagrant-hostsupdater
[11]: https://github.com/GM-Alex/vagrant-winnfsd
