# Media Server

![Ansible](https://img.shields.io/badge/-ansible-%231A1918?style=for-the-badge&logo=ansible&logoColor=white)
![FreeBSD](https://img.shields.io/badge/-FreeBSD-%23870000?style=for-the-badge&logo=freebsd&logoColor=white)

An opinionated Ansible-based media server deployment.

## Requirements

All requirements will be installed during execution. This role assumes a fresh FreeBSD 13 installation as a deployment target.

## Role Variables

It is opinionated, remember? No variables.

## Example Playbook

```
- hosts: localhost
  remote_user: root
  roles:
    - role: media_server

```

## To Do

- [ ] Use Jails
- [ ] Documentation

## License

MIT