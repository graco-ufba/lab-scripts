#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

# Sublime Text
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

#neofetch
sudo apt install neofetch -y

# Visual Studio Code
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg

# OBS Studio
sudo add-apt-repository -y ppa:obsproject/obs-studio

### Apt-get
DEBIAN_FRONTEND=noninteractive dpkg --configure -a
apt-get update -y
apt-get install -y  \
  python3-pip default-jre default-jdk maven swi-prolog racket elixir clisp nasm gcc-multilib \
  python3.11-full \
  git \
  flex bison \
  sublime-text code vim sasm \
  obs-studio v4l2loopback-dkms \
  mysql-server postgresql postgresql-contrib \
  arp-scan net-tools mtr dnsutils traceroute curl \
  gnupg ca-certificates \
  podman

# PostgreSQL 17
sudo apt-get update
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y postgresql-17 postgresql-contrib
sudo systemctl start postgresql
sudo systemctl enable postgresql

# PGAdmin
sudo apt install curl -y
curl -fsS https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo gpg --dearmor -o /usr/share/keyrings/packages-pgadmin-org.gpg
sudo sh -c 'echo "deb [signed-by=/usr/share/keyrings/packages-pgadmin-org.gpg] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list && apt update'
sudo apt install -y pgadmin4-web
sudo apt install -y pgadmin4-desktop

#mysql workbench
wget http://cdn.mysql.com/Downloads/MySQLGUITools/mysql-workbench-community_8.0.34-1ubuntu22.04_amd64.deb -O mysql-workbench-community.deb
sudo dpkg -i mysql-workbench-community.deb
sudo apt-get -f install -y
sudo rm mysql-workbench-community.deb

#netbeans
sudo apt update
sudo apt install snapd
sudo apt install -y openjdk-17-jdk
sudo snap install netbeans --classic


#Megatools
sudo apt install megatools -y

#SimulIDE
megadl "https://mega.nz/file/8akRDCYJ#8Fvn6U9RIJ-sX_f49fCsn05YTUr5ySNycoFlxVFX-iE"
tar -xzvf SimulIDE_1.1.0-SR1_Lin64.tar.gz && rm SimulIDE_1.1.0-SR1_Lin64.tar.gz
sudo apt update
sudo apt install fuse libfuse2 -y
sudo apt install libqt5core5a libqt5gui5 libqt5widgets5 libqt5network5 libqt5svg5 qtbase5-dev qttools5-dev-tools libqt5serialport5 libqt5serialport5-dev -y

#Atmel AVRA
sudo apt-get install avrdude avra -y
cd $HOME
git clone https://github.com/lpodkalicki/blog.git
cd $HOME/blog/avr/attiny13/043_blinky_with_delay_function_asm
make
cd $HOME/blog/avr/attiny13/043_blinky_with_delay_function_asm
make flash
sudo wget https://raw.githubusercontent.com/DarkSector/AVR/master/asm/include/m16def.inc -y

#Arduino IDE
sudo snap install arduino
sudo usermod -a -G dialout aluno

#wine
sudo apt install wine64 -y

#mongodb
if ! [ -f /etc/mongod.conf ]; then
  sudo apt-get install gnupg curl -y
  curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
    sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
    --dearmor
  echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
  sudo apt-get update -y
  sudo apt-get install -y mongodb-org -y
fi

#R
if [[ -f /usr/lib/R/site-library/done.txt || -f /usr/local/lib/R/site-library/done.txt ]]; then
echo "R já instalado"
else
sudo dpkg -r rstudio -y
sudo apt remove r-base -y
sudo apt update -qqy
sudo apt autoremove -y
sudo apt install --no-install-recommends software-properties-common dirmngr -y
wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
sudo apt install --no-install-recommends r-base -y
sudo apt install --no-install-recommends r-base-dev -y
sudo apt -y install gdebi-core-
wget https://download1.rstudio.org/electron/jammy/amd64/rstudio-2024.04.2-764-amd64.deb -O /tmp/rstudio.deb && sudo gdebi -n /tmp/rstudio.deb
fi


if ! [ -f /usr/bin/rstudio ]; then
sudo apt -y install gdebi-core-
wget https://download1.rstudio.org/electron/jammy/amd64/rstudio-2024.04.2-764-amd64.deb -O /tmp/rstudio.deb && sudo gdebi -n /tmp/rstudio.deb
fi

# Node
mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --batch --yes --dearmor -o /etc/apt/keyrings/nodesource.gpg
NODE_MAJOR=20
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
apt-get update
apt-get install nodejs -y

mkdir -p /opt/npm
chown -R aluno:aluno /opt/npm
rm -f /etc/skel/.npm
ln -s /opt/npm /etc/skel/.npm

# Pacotes Node
npm install -g @angular/cli

# Python
update-alternatives --install /usr/bin/python3 python3  /usr/bin/python3.11 1
update-alternatives --install /usr/bin/python3 python3  /usr/bin/python3.10 2

### Snaps
sudo snap install eclipse --classic
sudo snap install intellij-idea-community --classic
sudo snap install mongo33
sudo snap install bluej

# Flutter
# sudo snap install flutter --classic
snap remove flutter
if [ ! -d "/opt/flutter" ]; then
  cd /opt
  wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.10.5-stable.tar.xz -O /tmp/flutter.tar.xz
  tar xf /tmp/flutter.tar.xz
  chown -R aluno:aluno flutter
  cd -
fi

#Nand2Tetris
if [ ! -d "/opt/nand2tetris" ]; then
sudo apt-get install unzip
wget --no-check-certificate https://nuvem.ufba.br/s/ykUB6F81M5z2Ef1/download -O /opt/nand2tetris.zip
cd /opt
unzip nand2tetris.zip
rm nand2tetris.zip
fi

# Google Chrome
if ! command -v google-chrome &> /dev/null; then
	cd /tmp
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	dpkg -i google-chrome-stable_current_amd64.deb
	cd -
fi

##################################

# Instala o Android SDK e Android Studio
if [[ ! -d /opt/Android ]]; then
  wget https://nuvem.ufba.br/s/FjNaDukULOwHhs4/download --no-check-certificate -O /tmp/Android.tar.bz2
  cd /opt
  tar xjf /tmp/Android.tar.bz2
  rm /tmp/Android.tar.bz2
  cd /etc/skel
  unlink Android
  ln -s /opt/Android .
fi
if [[ ! -d /opt/android-studio ]]; then
  wget https://nuvem.ufba.br/s/6BUVDGWKKMxR6Fj/download --no-check-certificate -O /tmp/android-studio.tar.bz2
  cd /opt
  tar xjf /tmp/android-studio.tar.bz2
  rm /tmp/android-studio.tar.bz2
fi

if [[ ! -d /opt/gradle ]]; then
  wget https://nuvem.ufba.br/s/U5anBL3tRpN2xhT/download --no-check-certificate -O /tmp/gradle.tar.bz2
  cd /opt
  tar xjf /tmp/gradle.tar.bz2
  mv .gradle gradle
  chown -R aluno:aluno gradle
  rm /tmp/gradle.tar.bz2
fi

if [ -f /etc/init.d/aluno.sh ]; then
  rm /etc/init.d/aluno.sh
  echo "aluno.sh removido"
fi

#unityhub
wget -qO - https://hub.unity3d.com/linux/keys/public | gpg --dearmor | sudo tee /usr/share/keyrings/Unity_Technologies_ApS.gpg > /dev/null
sudo sh -c 'echo "deb [signed-by=/usr/share/keyrings/Unity_Technologies_ApS.gpg] https://hub.unity3d.com/linux/repos/deb stable main" > /etc/apt/sources.list.d/unityhub.list'
sudo apt update
sudo apt-get install unityhub

# Frame0
if ! dpkg -l | grep -q frame0; then
  wget https://files.frame0.app/releases/linux/x64/frame0_1.0.0~beta.8_amd64.deb -O /tmp/frame0.deb
  sudo dpkg -i /tmp/frame0.deb
  sudo apt-get -f install -y
  sudo dpkg -i /tmp/frame0.deb
  rm /tmp/frame0.deb
fi

exit 0
