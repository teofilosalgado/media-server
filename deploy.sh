#!/usr/bin/env bash
ANSIBLE_HOST_KEY_CHECKING=false && ansible-playbook -i ./inventory.ini ./main.ansible.yml -v