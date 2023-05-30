#cloud-config
package_upgrade: true
packages:
    - nginx
runcmd:
    - chmod 400 linuxkey.pem
    - cd /var/www
    - sudo chmod 0757 html