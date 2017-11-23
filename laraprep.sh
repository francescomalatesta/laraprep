# LaraPrep, a simple script for a lazy developer.
# Wrote by Francesco Malatesta - Dec 10, 2016 - Last Update Nov 23, 2017

PROJECT_NAME="$1"
PROJECT_HOSTNAME="$1.dev"
HOSTS_PATH="/etc/hosts"

function docker_prep {
  # export current user id
  USER_ID=$(id -u -r)
  USER_NAME=$(whoami)

  echo "127.0.0.1    ${PROJECT_HOSTNAME}" | sudo tee -a $HOSTS_PATH > /dev/null

  docker run -u $USER_ID --rm -it \
      -v $(pwd):/opt \
      -w /opt shippingdocker/php-composer:latest \
      composer create-project laravel/laravel $PROJECT_NAME

  docker run -u $USER_ID --rm -it \
      -v $(pwd):/opt \
      -w /opt/$PROJECT_NAME shippingdocker/php-composer:latest \
      composer require shipping-docker/vessel

  docker run -u $USER_ID --rm -it \
      -v $(pwd):/opt \
      -w /opt/$PROJECT_NAME shippingdocker/php-composer:latest \
      php artisan vendor:publish --provider="Vessel\VesselServiceProvider"

  cd $PROJECT_NAME

  bash vessel init
  ./vessel start

  printf "\nConfigured ${PROJECT_HOSTNAME}! Have fun :)\n"
}

function vagrant_prep {
  HOMESTEAD_REPOSITORY="https://github.com/Swader/homestead_improved"
  HOSTS_PATH="/etc/hosts"

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
}

if [ -z "$1" ]
  then
    echo "ERROR: Please specify a name for the project folder."
    exit
fi

if [ -z "$2" ]
  then
    vagrant_prep
  else
    if [ "$2" == "--docker" ]
      then
        docker_prep
      else
        echo "ERROR: unrecognizable option."
    fi
fi
