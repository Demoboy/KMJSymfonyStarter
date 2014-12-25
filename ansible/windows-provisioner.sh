#!/bin/bash

ANSIBLE_PLAYBOOK=$1
ANSIBLE_EXTRA_VARS=$2

# Detect package management system.
YUM=$(which yum)
APT_GET=$(which apt-get)

# Make sure Ansible playbook exists.
if [ ! -f /vagrant/$ANSIBLE_PLAYBOOK ]; then
  echo "Cannot find Ansible playbook."
  exit 1
fi

# Install Ansible and its dependencies if it's not installed already.
if [ ! -f /usr/bin/ansible ]; then
  echo "Installing Ansible dependencies and Git."
  if [[ ! -z $YUM ]]; then
    yum install -y git python python-devel
  elif [[ ! -z $APT_GET ]]; then
    apt-get install -y git python python-devel
  else
    echo "Neither yum nor apt-get are available."
    exit 1;
  fi

  echo "Installing pip via easy_install."
  wget http://peak.telecommunity.com/dist/ez_setup.py
  python ez_setup.py && rm -f ez_setup.py
  easy_install pip
  # Make sure setuptools are installed crrectly.
  pip install setuptools --no-use-wheel --upgrade

  echo "Installing required python modules."
  pip install paramiko pyyaml jinja2 markupsafe

  echo "Installing Ansible."
  pip install ansible
fi

# Install Ansible roles from requirements file, if available.
if [ -f /vagrant/requirements.txt ]; then
  sudo ansible-galaxy install -r /vagrant/requirements.txt
elif [ -f /vagrant/requirements.yml ]; then
  sudo ansible-galaxy install -r /vagrant/requirements.yml
fi

# Run the playbook.
echo "Running Ansible provisioner defined in Vagrantfile."
echo "ansible-playbook -i 'localhost,' /vagrant/$1 --extra-vars '$2' --connection=local"
ansible-playbook -i 'localhost,' /vagrant/$1 --extra-vars "$2" --connection=local
