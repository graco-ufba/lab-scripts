#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

# Recria home do aluno logo após login
echo '#!/bin/bash
if [[ "$USER" == "aluno" ]]; then
        
        rm -rf /home/$USER
        cp -r /etc/skel /home/$USER
        chown -R $USER:$USER /home/$USER
        echo "aluno:vivaoic2021!" | chpasswd

 	  echo export PATH="/opt/flutter/bin:\$PATH" >> /home/aluno/.bashrc
  	echo export PATH="/opt/android-studio/bin:/opt/Android/Sdk/platform-tools:\$PATH" >> /home/aluno/.bashrc
  	rm -f /opt/flutter/bin/cache/lockfile
   	chown -R aluno:aluno /opt/flutter

   	ln -s /opt/gradle /home/$USER/.gradle
    	ln -s /opt/npm /home/$USER/.npm
        
        echo "DROP USER IF EXISTS '\''aluno'\''@'\''localhost'\''; CREATE USER '\''aluno'\''@'\''%'\'' IDENTIFIED BY '\''aluno'\''; GRANT ALL PRIVILEGES ON *.* TO '\''aluno'\''@'\''%'\'';" | mysql
        sudo -u postgres dropdb --if-exists aluno; sudo -u postgres createdb aluno
        sudo -u postgres dropuser --if-exists aluno; sudo -u postgres createuser aluno
        echo "ALTER USER aluno WITH PASSWORD '\''aluno'\''; GRANT ALL PRIVILEGES ON DATABASE aluno to aluno;" | sudo -u postgres psql
        sudo service mysqld start
        sudo -u mysql create user 'aluno'@'localhost' identified by 'aluno';
        sudo -u grant all privileges on *.* to 'aluno'@'localhost';

 	pip install podman-compose
	
fi
exit 0
' > /etc/gdm3/PostLogin/Default
chmod a+x /etc/gdm3/PostLogin/Default
echo '' > /etc/gdm3/PostSession/Default

exit 0
