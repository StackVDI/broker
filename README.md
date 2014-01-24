## OpenVDI: Open Software Virtual Desktop Infraestructure

![screenshot](https://gitlom/gitlab-org/gitlab-ce/raw/master/public/gitlab_logo.png)


### OpenVDI allows you to
 * Connect to different cloud servers
 * Create machine templates
 * Manage users and groups
 * Launch and connect to virtual machines 

### OpenVDI is

* powered by Ruby on Rails
* completely free and open source 

### Installation

#### Production machine
* Install redis server, mysql, nginx ...

    apt-get install mysql mysql-server ngnix redis-server git libmysqlclient-dev postfix

* Create some directories and files

    adduser openvdi
    adduser openvdi adm
    adduser openvdi sudo
    mkdir -p /var/www/openvdi/shared/config -p
    vi /var/www/openvdi/shared/config/database.yml (make it your own)
    chown openvdi.openvdi /var/www/openvdi/ -R
    cp openvdi_nginx.conf /etc/nginx/sites-available/openvdi.conf
    cd /etc/nginx/sites-enabled
    ln -s /etc/nginx/sites-available/openvdi.conf
    rm -f /etc/ngnix/sites-available/default
    /etc/init.d/nginx restart
    visudo 
    Cmnd_Alias OPENVDI = /etc/init.d/openvdi
    openvdi ALL=NOPASSWD: OPENVDI
    mysql -u root 
    create database openvdi_production


* Install ruby
    As openvdi user

    \curl -sSL https://get.rvm.io | bash -s stable
    rvm install 2.0.0
    
#### Developer machine

    git clone https://git.inf.um.es/root/broker.git
    vi config/deploy/production.rb
    bundle exec cap production deploy
   
