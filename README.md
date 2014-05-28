Quick Setup
===========

Testing the roles
-----------------

1.  Install Ansible with instructions from [Ansible Doc](http://docs.ansible.com/intro_installation.html#installing-the-control-machine)

2.  Create an EC2 Instance and launch it. From the Web UI, note the public ip, public dns and a part of the private dns (before .ec2.internal)

3.  Create/Update /etc/ansible/hosts with the host information. Example

        [ec2]
        <PUBLIC IP>

4. cd to the repository and create a file called deploy.yml. The contents would be similar to

        ---
        - hosts: <PUBLIC IP>
          remote_user: admin # if using debian ami
          sudo: yes

          vars:
            hostname: '<PART OF PRIVATE DNS>'
            password: '<DB PW>'
            domain: '<PUBLIC DNS>'
            sitename: '<PUBLIC DNS>' # usually hostname.domain
            template: 'default'


          roles:
            - common
            - cherokee
            - uwsgi
            - postgresql
            - configure

5. Finally, run ansible-playbook. `ansible-playbook --private-key=<path_to_key> deploy.yml`
