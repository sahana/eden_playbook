#!/bin/bash

password=`date +%s | sha256sum | base64 | head -c 32 ; echo`
privDNS=`curl -s  http://169.254.169.254/latest/meta-data/hostname | sed "s/.ec2.internal//"`
pubDNS=`curl http://169.254.169.254/latest/meta-data/public-hostname`
template="default"


cat << EOF > "deploy.yml"
---
- hosts: 127.0.0.1
  connection: local
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

ansible-playbook deploy.yml