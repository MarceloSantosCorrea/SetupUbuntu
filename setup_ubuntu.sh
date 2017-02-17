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
        12 "Create config.php" OFF 3>&1 1>&2 2>&3)
    status=$?