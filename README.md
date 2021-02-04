# sbog/ipsecvpn

[![Build Status](https://travis-ci.com/sorrowless/ansible_ipsecvpn.svg?branch=master)](https://travis-ci.com/sorrowless/ansible_ipsecvpn)
[![Ansible Role](https://img.shields.io/ansible/role/52951)](https://galaxy.ansible.com/sorrowless/ipsecvpn)
[![Ansible Quality Score](https://img.shields.io/ansible/quality/52951)](https://galaxy.ansible.com/sorrowless/ipsecvpn)
[![Ansible Role](https://img.shields.io/ansible/role/d/52951)](https://galaxy.ansible.com/sorrowless/ipsecvpn)
[![GitHub](https://img.shields.io/github/license/sorrowless/ansible_ipsecvpn)](https://github.com/sorrowless/ansible_ipsecvpn/blob/master/LICENSE)

An Ansible role which installs and configures IPSec VPN on Linux

## Requirements

Ansible 2.7+

## Role Variables

You can see all vars in `defaults/main.yml` vars file.

## Dependencies

None

## Example Playbook

```yaml
- name: Ensure ipsecvpn
  hosts: ipsecvpns
  remote_user: root

  roles:
    - ipsecvpn
```

## License

Apache 2.0

## Author Information

This role was created by [Stan Bogatkin](https://sbog.ru).
