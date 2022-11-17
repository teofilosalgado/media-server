#!/usr/bin/env bash
ansible-playbook -i ./inventories/localhost.ini ./main.playbook.yml -v