#!/usr/bin/env bash

Loading() {
   tput civis
   while [ -d /proc/$! ]
   do
      for i in / - \\ \|
      do
         printf "\033[1D$i"
         sleep .1
      done
   done
   tput cnorm
}

ChangePasswdRoot(){
    newPassword=$(whiptail --title "Alterar Senha do Root" --inputbox "Informe a nova senha para o Root" --fb 10 60 3>&1 1>&2 2>&3)
    STATUS=$?
    if [ $STATUS = 1 ] || [ $STATUS = 255 ]; then exit; fi
    echo "root:$newPassword" | chpasswd
}

InstallOpenssh(){
    apt-get -y install openssh-server > /dev/null 2>&1 &
    echo "Instalando Open SSH"
    printf "Aguarde...\040\040" ; Loading
    printf "\033[1Dok\012"

    sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config;
    sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config; 
    /etc/init.d/ssh stop > /dev/null 2>&1 &
    /etc/init.d/ssh start > /dev/null 2>&1 &
    echo "Configurando Open SSH"
    printf "Aguarde...\040\040" ; Loading
    printf "\033[1Dok\012"
}

InstallGit(){
    apt-get -y install git > /dev/null 2>&1 &
    echo "Instalando Git"
    printf "Aguarde...\040\040" ; Loading
    printf "\033[1Dok\012"
}

InstallMySql(){
    rootPassword=$(whiptail --title "Senha Root" --inputbox "Informe a nova senha para o Root" --fb 10 60 3>&1 1>&2 2>&3)
    debconf-set-selections <<< "mysql-server mysql-server/root_password password $rootPassword" 
    debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $rootPassword" 
    apt-get -y install mysql-server mysql-client > /dev/null 2>&1 &
    echo "Instalando MySql"
    printf "Aguarde...\040\040" ; Loading
    printf "\033[1Dok\012"
}

EnableRemoteMysql(){
    rootPassword=$(whiptail --title "Senha Root" --inputbox "Informe a senha do Root" --fb 10 60 3>&1 1>&2 2>&3)
    sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/my.cnf > /dev/null 2>&1 &

mysql --host=localhost --user=root --password=$rootPassword  << EOF
    GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY "$rootPassword" WITH GRANT OPTION;
    FLUSH PRIVILEGES;
EOF

    echo "Habilitando Root"
    printf "Aguarde...\040\040" ; Loading
    printf "\033[1Dok\012"
}

CreateDatabaseMySql(){
    MYSQL_ROOT_PASSWORD=$(whiptail --title "Criar Banco de Dados MySql" --inputbox "Senha do Root Mysql:" --fb 10 60 3>&1 1>&2 2>&3)
    STATUS=$?
    if [ $STATUS = 1 ] || [ $STATUS = 255 ]; then exit; fi

    MYSQL_DATABASE=$(whiptail --title "Criar Banco de Dados MySql" --inputbox "Nome do Banco de Dados:" --fb 10 60 3>&1 1>&2 2>&3)
    STATUS=$?
    if [ $STATUS = 1 ] || [ $STATUS = 255 ]; then exit; fi

    MYSQL_UERNAME=$(whiptail --title "Criar Banco de Dados MySql" --inputbox "Usuário para o Banco de Dados "$MYSQL_DATABASE":" --fb 10 60 3>&1 1>&2 2>&3)
    STATUS=$?
    if [ $STATUS = 1 ] || [ $STATUS = 255 ]; then exit; fi

    MYSQL_PASSWORD=$(whiptail --title "Criar Banco de Dados MySql" --inputbox "Senha para o Usuário "$MYSQL_UERNAME":" --fb 10 60 3>&1 1>&2 2>&3)
    STATUS=$?
    if [ $STATUS = 1 ] || [ $STATUS = 255 ]; then exit; fi


mysql --host=localhost --user=root --password=$MYSQL_ROOT_PASSWORD  << EOF
    CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
    CREATE USER $MYSQL_UERNAME@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
    GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO $MYSQL_UERNAME@localhost IDENTIFIED BY '$MYSQL_PASSWORD';
    GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO $MYSQL_UERNAME@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
EOF
}

# ResetPasswordRootMySql(){
    # /etc/init.d/mysql stop
    # mysqld_safe --skip-grant-tables &
    # mysql -u root
    # use mysql;
    # update user set password=PASSWORD("nova_senha") where User='root';
    # flush privileges;
    # quit
    # /etc/init.d/mysql start
# }

InstallApache(){
    apt-get -y install apache2 > /dev/null 2>&1 &
    echo "Instalando Apache"
    printf "Aguarde...\040\040" ; Loading
    printf "\033[1Dok\012"
}

ModRewriteApache(){
    echo "Habilitando Mod Rewrite"
}

InstallPHP(){
    sudo add-apt-repository ppa:ondrej/php
    apt-get update;

    apt-get install curl;
    apt-get install php;
    apt-get install php-mysql;
    apt-get install php-cli;
    apt-get install php-pear;
    apt-get install php-intl;
    apt-get install php-mcrypt;
    apt-get install libapache2-mod-php;
    apt-get install php-gd;
    apt-get install php-xmlrpc;
    apt-get install libapache2-mod-auth-mysql;
    apt-get install php-curl;
    apt-get install php-mbstring
}

InstallVnstat(){
    apt-get -y install vnstat > /dev/null 2>&1 &
    echo "Instalando Vnstat"
    printf "Aguarde...\040\040" ; Loading
    printf "\033[1Dok\012"

    vnstat -u -i eth0 > /dev/null 2>&1 &
    echo "Configurando Vnstat"
    printf "Aguarde...\040\040" ; Loading
    printf "\033[1Dok\012"
}

InstallFFmpeg(){
    FFMPEG=`type -p ffmpeg`;
    sudo add-apt-repository ppa:kirillshkrogalev/ffmpeg-next > /dev/null 2>&1 &
    echo "Adicionando Repositório Repository"
    printf "Aguarde...\040\040" ; Loading
    printf "\033[1Dok\012"

    sudo apt-get update > /dev/null 2>&1 &
    echo "Atualizando Sistema"
    printf "Aguarde...\040\040" ; Loading
    printf "\033[1Dok\012"

    sudo apt-get -y install ffmpeg > /dev/null 2>&1 &
    echo "Instalando FFmpeg"
    printf "Aguarde...\040\040" ; Loading
    printf "\033[1Dok\012"
}

InstallProftpd(){
    echo "Instalando ProfFtpd"
}

InstallmLocate(){
    echo "Instalando mLocate"
}

InstallIoncube(){
    echo "Instalando Ioncube"
}

InstallWowzaStreamingEngine(){

    apt-get -y install unzip

    rm -rf WowzaStreamingEngine-4.6.0-linux-x64-installer.run
    wget http://www.wowza.com/downloads/WowzaStreamingEngine-4-6-0/WowzaStreamingEngine-4.6.0-linux-x64-installer.run

    sudo chmod +x WowzaStreamingEngine-4.6.0-linux-x64-installer.run
    sudo ./WowzaStreamingEngine-4.6.0-linux-x64-installer.run

    chmod 775 -R /usr/local/WowzaStreamingEngine-4.6.0;
    chmod 777 -R /usr/local/WowzaStreamingEngine-4.6.0/applications;
    chmod 777 -R /usr/local/WowzaStreamingEngine-4.6.0/conf;
    chmod 777 -R /usr/local/WowzaStreamingEngine-4.6.0/content;
    chmod 777 -R /usr/local/WowzaStreamingEngine-4.6.0/logs;
    chmod 777 -R /usr/local/WowzaStreamingEngine-4.6.0/lib;

    cd /usr/local/WowzaStreamingEngine/lib;
    wget http://ciclano.live/releases/wowza/libs_wowza.zip -nv;
    unzip -o libs_wowza.zip >/dev/null
    rm -rf libs_wowza.zip

    cd /usr/local/WowzaStreamingEngine;
    wget http://ciclano.live/releases/wowza/wseplugins.zip -nv;
    unzip -o wseplugins.zip;
    cd /usr/local/WowzaStreamingEngine/wseplugins;
    apt-get -y install openjdk-7-jre-headless;
    apt-get -y install openjdk-7-jdk;

    javac JMXCommandLine.java
    rm -rf wseplugins.zip

    service WowzaStreamingEngine stop
    sleep 7;
    service WowzaStreamingEngine start
}

pacotes=$(whiptail --title "Instalation Requeriments" --checklist --fb \
        "" 25 40 16 \
        1 "Change Password Root" OFF \
        2 "Install Openssh" OFF \
        3 "Git" OFF \
        4 "Install MySql" OFF \
        5 "Enable MySql Remote" OFF \
        6 "Create Database MySql" OFF \
        7 "Reset Password Root MySql" OFF \
        8 "Install Apache" OFF \
        9 "mod Rewrite Apache" OFF \
        10 "PHP" OFF \
        11 "Vnstat" OFF \
        12 "FFmpeg" OFF \
        13 "Proftpd" OFF \
        14 "mLocate" OFF \
        15 "Install Ioncube" OFF \
        16 "Install WowzaStreamingEngine" OFF  3>&1 1>&2 2>&3)
    status=$?

if [ $status = 0 ] && [ -n "$pacotes" ]
then
    for pacote in $pacotes
    do
        case `echo $pacote | sed -e 's/\"//g'` in
            1)
                ChangePasswdRoot
                ;;
            2)
                InstallOpenssh
                ;;
            3)
                InstallGit
                ;;
            4)
                InstallMySql
                ;;
            5)
                EnableRemoteMysql
                ;;
            6)
                CreateDatabaseMySql
                ;;
            7)
                ResetPasswordRootMySql
                ;;
            8)
                InstallApache
                ;;
            9)
                ModRewriteApache
                ;;
            10)
                InstallPHP
                ;;
            11)
                InstallVnstat
                ;;
            12)
                InstallFFmpeg
                ;;
            13)
                InstallProftpd
                ;;
            14)
                InstallmLocate
                ;;
            15)
                InstallIoncube
                ;;
            16)
                InstallWowzaStreamingEngine
                ;;
        esac
    done
fi