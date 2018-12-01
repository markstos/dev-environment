#!/usr/bin/env bash

# Usage: ansible-mac.sh [task-name-to-start-at]
#
# Run all tasks or give a task name to start at

# Install Ansible, if not already installed
if ! which ansible-playbook > /dev/null; then
  sudo apt update
  sudo apt install software-properties-common
  sudo apt-add-repository --yes --update ppa:ansible/ansible
  sudo apt install ansible
fi

# Install the role files we depend on.
ansible-galaxy install --roles-path ./roles geerlingguy.nodejs \
                                            gantsign.hub \
                                            Oefenweb.yarn \
                                            geerlingguy.pip \
                                            dotstrap.fzf

# Provision machine with ansible
if [ -z "$1" ];
then
    : # $1 was not given
    ansible-playbook -i "localhost," -c local --become-method=sudo --ask-become-pass playbook.yml
else
    : # $1 was given
    ansible-playbook -i "localhost," -c local --become-method=sudo --ask-become-pass playbook.yml --start-at-task "$1"
fi
