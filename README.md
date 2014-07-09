## StackVDI: Open Software Virtual Desktop Infraestructure

[![Broker Video](https://i.vimeocdn.com/video/480446920_960.jpg)](https://vimeo.com/99310525)

### StackVDI allows you to
 * Connect to different cloud servers
 * Create machine templates
 * Manage users and groups
 * Launch and connect to virtual machines 

### StackVDI is

* powered by Ruby on Rails
* completely free and open source 

### 

# Installation


## Description

StackVDI is a web application that connects OpenStack server where are running virtual machines with users.
It's bases on Ruby on Rails and uses technologies as SQL Databses, NoSQL, Java applets ...

StackVDI can manage users, groups, virtual machines, machine templates and conection to several OpenStack servers. 

__ABOVE UNDER TRANSLATION__

## Instalación y configuración

Aquí se expone como instalar el broker en un servidor Ubuntu 14.04, pero las instrucciones son extrapolables a cualquier otra distribución

En el servidor necesitamos tener un usuario llamado openvdi con permisos de sudo. De no tenerlo, como root, tecleamos:

```
adduser openvdi
adduser openvdi adm
adduser openvdi sudo
```

Despues de esto, creamos la confianza ssh con la maquina para poder conectarnos sin clave con el usuario openvdi. A partir de aquí, nos conectamos por ssh con usuario openvdi y  todos los comandos los teclearemos como usuario openvdi.

Necesitamos tener Ruby 2.0 instalado. Lo instalamos a través de la herramienta rvm.

```
\curl -sSL https://get.rvm.io | bash -s stable
source /home/openvdi/.rvm/scripts/rvm
rvm install 2.0
```

Y obtenemos una salida parecida a esta

```
openvdi@pp:~$ rvm install 2.0
Searching for binary rubies, this might take some time.
No binary rubies available for: ubuntu/14.04/x86_64/ruby-2.0.0-p481.
Continuing with compilation. Please read 'rvm help mount' to get more information on binary rubies.
Checking requirements for ubuntu.
Installing requirements for ubuntu.
openvdi password required for 'apt-get --quiet --yes update':
....
Installing required packages: g++, gcc, make, libc6-dev, libreadline6-dev, zlib1g-dev, libssl-dev, libyaml-dev, libsqlite3-dev, sqlite3, autoconf, libgdbm-dev, libncurses5-dev, automake, libtool, bison, pkg-config, libffi-dev............................
Requirements installation successful.
Installing Ruby from source to: /home/openvdi/.rvm/rubies/ruby-2.0.0-p481, this may take a while depending on your cpu(s)...
ruby-2.0.0-p481 - #downloading ruby-2.0.0-p481, this may take a while depending on your connection...
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 10.2M  100 10.2M    0     0  3185k      0  0:00:03  0:00:03 --:--:-- 3186k
ruby-2.0.0-p481 - #extracting ruby-2.0.0-p481 to /home/openvdi/.rvm/src/ruby-2.0.0-p481...
ruby-2.0.0-p481 - #configuring.................................................
ruby-2.0.0-p481 - #post-configuration.
ruby-2.0.0-p481 - #compiling..............................................................................
ruby-2.0.0-p481 - #installing.............................
ruby-2.0.0-p481 - #making binaries executable..
ruby-2.0.0-p481 - #downloading rubygems-2.2.2
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  404k  100  404k    0     0   483k      0 --:--:-- --:--:-- --:--:--  483k
No checksum for downloaded archive, recording checksum in user configuration.
ruby-2.0.0-p481 - #extracting rubygems-2.2.2...
ruby-2.0.0-p481 - #removing old rubygems.........
ruby-2.0.0-p481 - #installing rubygems-2.2.2...............
ruby-2.0.0-p481 - #gemset created /home/openvdi/.rvm/gems/ruby-2.0.0-p481@global
ruby-2.0.0-p481 - #importing gemset /home/openvdi/.rvm/gemsets/global.gems.............................................................
ruby-2.0.0-p481 - #generating global wrappers.........
ruby-2.0.0-p481 - #gemset created /home/openvdi/.rvm/gems/ruby-2.0.0-p481
ruby-2.0.0-p481 - #importing gemsetfile /home/openvdi/.rvm/gemsets/default.gems evaluated to empty gem list
ruby-2.0.0-p481 - #generating default wrappers.........
ruby-2.0.0-p481 - #adjusting #shebangs for (gem irb erb ri rdoc testrb rake).
Install of ruby-2.0.0-p481 - #complete
Ruby was built without documentation, to build it run: rvm docs generate-ri
``` 

Para comprobar que tenemos ruby 2.0 funcionando, basta con escribir en la consola `ruby -v` y obtendremos una salida asi: `ruby 2.0.0p481 (2014-05-08 revision 45883) [x86_64-linux]`. 
Procedemos con la instalación de diversos servicios necesarios para el broker con el comando `sudo apt-get install mysql-client-5.5 mysql-server nginx-full redis-server git libmysqlclient-dev postfix git imagemagick`. 

Una vez instalados los servicios, procedemos a la creación de la base de datos de producción

```
mysql -u root -p
create database openvdi_production;
exit
```

Editamos .gitconfig para evitar que se chequee el certificado del servidor.

`vi ~/.gitconfig`

```
[http]
    sslVerify = false
```

Creamos los directorios donde alojaremos el broker `sudo mkdir -p /var/www/openvdi/ -p; `, clonamos el repositorio con `cd /var/www/ ; sudo chown openvdi.openvdi openvdi/ ; cd openvdi; git clone https://github.com/OpenMurVDI/broker.git`  y editamos la conexión a la base de datos asi: `sudo vi /var/www/openvdi/broker/config/database.yml`. El contenido será algo como que asi

```
production:
  adapter: mysql2
  database: openvdi_production
  username: root
  password: 
```

Tambiém creamos el directorio para albergar el applet, `sudo mkdir -p /var/www/openvdi/broker/public/applet` y copiamos el applet a ese directorio.

y lo dejamos todo con los permisos adecuados para que nuestro usuario sea el propietario `sudo  chown openvdi.openvdi /var/www/openvdi/ -R`

Creamos el fichero de configuración ngnix: `sudo vi /etc/nginx/sites-available/openvdi.conf` con este contenido:

```
upstream openvdi {
  server unix:///tmp/openvdi.sock;
}

server {
  listen 80;
  server_name iescierva.net; # change to match your URL
  root /var/www/openvdi/broker/public; # I assume your app is located at this location

  location / {
    proxy_pass http://openvdi; # match the name of upstream directive which is defined above
    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  }

  location /applet {
    root /var/www/openvdi/broker/public;
  }

  location ~* ^/(system|assets)/ {
    # Per RFC2616 - 1 year maximum expiry
    expires 1y;
    add_header Cache-Control public;

    # Some browsers still send conditional-GET requests if there's a
    # Last-Modified header or an ETag header even if they haven't
    # reached the expiry date sent in the Expires header.
    add_header Last-Modified "";
    add_header ETag "";
    break;
  }
}

```

y configuramos el servidor web

```
  cd /etc/nginx/sites-enabled
  sudo ln -s /etc/nginx/sites-available/openvdi.conf
  sudo rm -f default
  sudo /etc/init.d/nginx restart
```
    
Despues, creamos el servicio para manejar la aplicación con `sudo vi /etc/init.d/openvdi` con el contenido

```
#!/bin/bash

# OpenVDI
# Maintainer: raul@um.es

### BEGIN INIT INFO
# Provides:          openvdi
# Required-Start:    $local_fs $remote_fs $network $syslog redis-server
# Required-Stop:     $local_fs $remote_fs $network $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: OpenVDI management
# Description:       OpenVDI management
### END INIT INFO


APP_ROOT="/var/www/openvdi/broker"
PID_PATH="$APP_ROOT/tmp/pids"
WEB_SERVER_PID="$PID_PATH/puma.pid"
DAEMON_OPTS="-C $APP_ROOT/config/puma.rb -e production --pidfile $WEB_SERVER_PID"
SIDEKIQ_PID="$PID_PATH/sidekiq.pid"
START_SIDEKIQ="RAILS_ENV=production bundle exec sidekiq -d -L $APP_ROOT/log/sidekiq.log -P $SIDEKIQ_PID "
NAME="openvdi"
DESC="OpenVDI"

check_pid(){
 echo $WEB_SERVER_PID
  if [ -f $WEB_SERVER_PID ]; then
    PID=`cat $WEB_SERVER_PID`
    SPID=`cat $SIDEKIQ_PID`
    STATUS=`ps aux | grep $PID | grep -v grep | wc -l`
  else
    STATUS=0
    PID=0
  fi
}

start() {
  cd $APP_ROOT
  check_pid
  if [ "$PID" -ne 0 -a "$STATUS" -ne 0 ]; then
    # Program is running, exit with error code 1.
    echo "Error! $DESC $NAME is currently running!"
    exit 1
  else
    if [ `whoami` = root ]; then
      sudo -u openvdi -H bash -l -c "mkdir -p $PID_PATH && RAILS_ENV=production bundle exec puma $DAEMON_OPTS"
      sudo -u openvdi -H bash -l -c "mkdir -p $PID_PATH && $START_SIDEKIQ "
# > /dev/null  2>&1 &"
      echo "$DESC started"
    fi
  fi
}

stop() {
  cd $APP_ROOT
  check_pid
    ## Program is running, stop it.
    kill -QUIT `cat $WEB_SERVER_PID`
    kill -QUIT `cat $SIDEKIQ_PID`
    rm "$WEB_SERVER_PID" >/dev/null  2>/dev/null
    killall ruby >/dev/null 2> /dev/null
    rm "$SIDEKIQ_PID" >/dev/null  2>/dev/null
    echo "$DESC stopped"
}

restart() {
  cd $APP_ROOT
  check_pid
    echo "Restarting $DESC..."
    stop
    start

    echo "$DESC restarted."
}

status() {
  cd $APP_ROOT
  check_pid
  if [ "$PID" -ne 0 -a "$STATUS" -ne 0 ]; then
    echo "$DESC / PUMA with PID $PID is running."
    echo "$DESC / Sidekiq with PID $SPID is running."
  else
    echo "$DESC is not running."
    exit 1
  fi
}

## Check to see if we are running as root first.
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root"
    exit 1
fi

case "$1" in
  start)
        start
        ;;
  stop)
        stop
        ;;
  restart)
        restart
        ;;
  reload|force-reload)
        echo -n "Reloading $NAME configuration: "
        kill -HUP `cat $PID`
        echo "done."
        ;;
  status)
        status
        ;;
  *)
        echo "Usage: sudo service openvdi {start|stop|restart|reload}" >&2
        exit 1
        ;;
esac

exit 0

```

y lo añadimos al sudo del usuario openvdi. Tecleamos `sudo visudo` y dejamos el fichero asi

```
#
# This file MUST be edited with the 'visudo' command as root.
#
# Please consider adding local content in /etc/sudoers.d/ instead of
# directly modifying this file.
#
# See the man page for details on how to write a sudoers file.
#
Defaults  env_reset
Defaults  mail_badpass
Defaults  secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

Cmnd_Alias OPENVDI=/etc/init.d/openvdi

# Host alias specification

# User alias specification

# Cmnd alias specification

# User privilege specification
root  ALL=(ALL:ALL) ALL

# Members of the admin group may gain root privileges
%admin ALL=(ALL) ALL

# Allow members of group sudo to execute any command
%sudo ALL=(ALL:ALL) ALL

# See sudoers(5) for more information on "#include" directives:

openvdi ALL=NOPASSWD:OPENVDI

#includedir /etc/sudoers.d

```


Por último, añadimos el arranque automático del servicio:

```
cd /etc/rc2.d/
sudo ln -s /etc/init.d/openvdi S99openvdi
sudo chmod  +x /etc/init.d/openvdi
/etc/init.d/openvdi start
```

Sitúate de nuevo en el directorio de la aplicación `cd /var/www/openvdi/broker`
Teclea `bundle install; RAILS_ENV=production bundle exec rake assets:precompile; RAILS_ENV=production bundle exec rake db:migrate` para hacer la instalación de las gemas y la migración de la base de datos y si quieres crear los usuarios por defecto, `RAILS_ENV=production bundle exec rake db:seed`.

Y reiniciamos de nuevo nginx y openvdi
````
sudo /etc/init.d/openvdi restart
sudo /etc/init.d/nginx restart
````

Los usuarios seran
```
admin@openvdi.com, con clave changeme
user@openvdi.com, con clave changeme
```

Editaremos nuestro crontab con `crontab -e` y dejaremos la línea parecida a esto. Sólo tendremos que cambiar el directrio donde hacemos el cd. 

````
0 * * * * /bin/bash -l -c 'cd /var/www/openvdi/broker && bundle exec rails runner Machine.check_expired -e production 2> /dev/null'
```

## Pasos para configurar OpenVDI en el cliente

Comprueba [aquí](http://www.java.com/es/download/installed.jsp) que tienes correctamente instalado Java en tu navegador. Una vez hecho esto, añada la dirección http://www.openvdi.com (o el correspondiente donde este instalada) como sitio de confianza en el panel de control de Java. Pestaña Seguridad->Editar lista de sitios.

Si utiliza un cliente Linux, instale la aplicación freerdp-x11 (sudo apt-get install freerdp-x11).
Si utiliza Mac Os X, instale la aplicación [CoRD](http://sourceforge.net/projects/cord/files/cord/0.5.7/CoRD_0.5.7.zip/download) en su carpeta de aplicaciones.


