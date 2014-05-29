#!/bin/bash

echo "Enter the Public IP"
read pubIP

cat << EOF >> inventory
$pubIP
EOF

echo "Enter the domain name"
read pubDNS

echo "Enter the Hostname"
read privDNS

echo "Enter username"
read username

echo "Enter absolute path to private key"
read keyPath

echo "Enter template name"
read template

echo "Enter Database Password"
read password

cat << EOF > "deploy.yml"
---
- hosts: 54.200.167.252
  remote_user: $username # if using debian ami
  sudo: yes

  vars:
    hostname: '$privDNS'
    password: '$password'
    domain: '$pubDNS'
    sitename: '$pubDNS' # usually hostname.domain
    template: '$template'

  roles:
    - common
    - cherokee
    - uwsgi
    - postgresql
    - configure
EOF

echo "Now running ansible-playbook"

ansible-playbook -i inventory --private-key=$keyPath -u $username deploy.yml