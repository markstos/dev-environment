#!/usr/bin/env bash

# Usage: ansible-debian.sh [task-name-to-start-at]
#
# Run all tasks or give a task name to start at.

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
ansible-galaxy install --roles-path ./roles geerlingguy.nodejs \        # Install Node.js
                                            gantsign.hub \	        # Install "hub" Git extension 		
                                            Oefenweb.yarn \	        # Install "Yarn" package manager
                                            geerlingguy.pip \		# Install "pip"	
                                            sicruse.powerline-fonts \	# Install Powerline Fonts
                                            dotstrap.fzf		# Install and configure FZF			

# Provision machine with ansible
if [ -z "$1" ];
then
    : # $1 was not given
    ansible-playbook -i "localhost," -c local --become-method=sudo --ask-become-pass playbook.yml
else
    : # $1 was given
    ansible-playbook -i "localhost," -c local --become-method=sudo --ask-become-pass playbook.yml --start-at-task "$1"
fi
