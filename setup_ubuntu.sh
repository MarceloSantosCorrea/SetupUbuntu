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

InstallApache(){
	apt-get -y install apache2 2>&1 &
	echo "Instalando Apache"
    printf "Aguarde...\040\040" ; Loading
    printf "\033[1Dok\012"
}

pacotes=$(whiptail --title "Instalation Requeriments" --checklist --fb \
        "" 20 40 11 \
        1 "Git" OFF \
        2 "PHP" OFF \
        3 "Create Database MySql  " OFF \
        4 "Vnstat" OFF \
        5 "FFmpeg" OFF \
        6 "Proftpd" OFF \
        7 "mLocate" OFF \
        8 "mod Rewrite Apache" OFF \
        9 "Install Ioncube" OFF \
        10 "Enable MySql Remote" OFF \
        11 "Create htaccess" OFF \
        12 "Install Apache" OFF 3>&1 1>&2 2>&3)
    status=$?

if [ $status = 0 ] && [ -n "$pacotes" ]
then
    for pacote in $pacotes
    do
        case `echo $pacote | sed -e 's/\"//g'` in
            1)
                InstallGit
                ;;
            2)
                InstallPHP
                FixApache2Conf
                Apache2SitesAvailableDefaultConf
                ;;
            3)
                CreateDatabaseMySql
                ;;
            4)
                Vnstat
                ;;
            5)
                FFmpeg
                ;;
            6)
                Proftpd
                ;;
            7)
                mLocate
                ;;
            8)
                Apache2SitesAvailableDefaultConf
                FixApache2Conf
                ModRewriteApache
                ;;
            9)
                InstallIoncube
                ;;
            10)
                EnableRemoteMysql
                ;;
            11)
                CreateHtaccess
                ;;
            12)
                InstallApache
                ;;
        esac
    done
fi