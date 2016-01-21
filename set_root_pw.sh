#!/bin/bash

if [ -f /.root_pw_set ]; then
	echo "Root password already set!"
	exit 0
fi

PASS=${ROOT_PASS:-$(pwgen -s 12 1)}
_word=$( [ ${ROOT_PASS} ] && echo "preset" || echo "random" )
echo "=> Setting a ${_word} password to the root user"
echo "root:$PASS" | chpasswd
echo "=> Setting a password to the docker user"

adduser --disabled-password --gecos "" $1
adduser $1 x2gouser
sudo -u $1 echo LANG=C.UTF-8 >> /home/$1/.profile
sudo -u $1 echo PATH="/opt/conda/bin:$PATH" >> /home/$1/.profile

echo "Change password for $1"
if [[ $2 ]]; then
	DPASS="$2"
else
	DPASS=$(pwgen -s 12 1)
fi

echo "$1:$DPASS" | chpasswd
echo "=> Done!"
touch /.root_pw_set

echo "========================================================================"
echo "You can now connect to this Ubuntu container via SSH using:"
echo ""
echo "    ssh -p <port> root@<host>"
echo "and enter the root password '$PASS' when prompted"
echo -e "\n $1 password : $DPASS "
echo "use this to connect to the x2go server from your x2go client!"
echo "Please remember to change the above password as soon as possible!"
echo "========================================================================"
