#!/bin/bash
USER="User"
while getopts ":u:p:h" opt; do
  case $opt in
    u)
      echo "User was pre-defined: $OPTARG" >&2
      USER=$OPTARG
      ;;   
    p)
      echo "Password was pre-defined use password: $OPTARG" >&2
      PASSWORD=$OPTARG
      ;;
    h)
      echo -e "Password is automatically generated, User is default \"User\". If you want to use pre-defined password, you need to run container with -p {password} command.\nExample: docker run -p 2223:22 -t -d cleverdata.docker -p qwe123" >&2
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

if [ ! -f /.root_pw_set ]; then
	if [[ $PASSWORD ]]; then
		/set_root_pw.sh "$USER" "$PASSWORD"
	else
	/set_root_pw.sh
	fi
fi

chmod 1777 /dev/shm

exec /usr/sbin/sshd -D
