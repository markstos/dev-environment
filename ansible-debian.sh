#!/usr/bin/env bash

# Usage: ansible-debian.sh [tag]
#
# Run all tasks or give tasks with a given tag

# Should work on Debian and Ubuntu.

# Install Ansible, if not already installed
if ! which ansible-playbook > /dev/null; then

   # Debian can use the Ubuntu repos, too.
   echo 'deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main' | sudo tee -a /etc/apt/sources.list.d/ansible.list>/dev/null

   sudo apt adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
   sudo apt update
   sudo apt install ansible
fi

# Install the role files we depend on.
ansible-galaxy install --roles-path ./roles geerlingguy.nodejs \
                                            gantsign.hub \
                                            Oefenweb.yarn \
                                            geerlingguy.pip \
                                            mjanser.powerline \
                                            suzuki-shunsuke.tmux-tpm \
                                            nickjj.docker \
  git+https://github.com/sicruse/ansible-powerline-fonts.git,33596d76e475ebb99f2b65de7d6e1cc3cc7e26b9

# Provision machine with ansible
if [ -z "$1" ];
then
    : # $1 was not given
    ansible-playbook -i "localhost," -c local --become-method=sudo --ask-become-pass playbook.yml
else
    : # $1 was given
    ansible-playbook -i "localhost," -c local --become-method=sudo --ask-become-pass playbook.yml --tags "$1"
fi
