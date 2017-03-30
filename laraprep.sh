# LaraPrep, a simple script for a lazy developer.
# Wrote by Francesco Malatesta - Dec 10, 2016

HOMESTEAD_REPOSITORY="https://github.com/Swader/homestead_improved"
HOSTS_PATH="/etc/hosts"

PROJECT_NAME="$1"
PROJECT_HOSTNAME="$1.dev"

if [ -z "$1" ]
  then
    echo "ERROR: Please specify a name for the project folder."
    exit
fi

git clone $HOMESTEAD_REPOSITORY $1
cd $PROJECT_NAME

DONE=0
while [ $DONE -eq 0 ]; do
  IP="192.168.$(( ( RANDOM % 200 )  + 2 )).$(( ( RANDOM % 200 )  + 2 ))"

  if ! grep -q "${IP}" $HOSTS_PATH; then
    DONE=1
  fi
done

echo "${IP}    ${PROJECT_HOSTNAME}" | sudo tee -a $HOSTS_PATH > /dev/null

sed -i.bak "s/192.168.10.10/${IP}/g" ./Homestead.yaml
sed -i.bak "s/homestead.app/${PROJECT_HOSTNAME}/g" ./Homestead.yaml

vagrant up
vagrant ssh -- -t 'composer create-project laravel/laravel Code/Project && exit; /bin/bash'

printf "\nConfigured: ${PROJECT_HOSTNAME} at ${IP}! Have fun :)\n"
