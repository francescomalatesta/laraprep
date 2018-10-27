#!/usr/bin/env bash

# LaraPrep, a simple script for a lazy developer.
# Wrote by Francesco Malatesta - Dec 10, 2016 - Last Update Oct 27, 2018

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

if [ $? -ne 0 ];
then
  exit 1
fi

if [ -z "$1" ]
  then
    echo "ERROR: Please specify a name for the project folder."
    exit
fi

PROJECT_NAME="$1"
PROJECT_HOSTNAME="$1.test"
HOSTS_PATH="/etc/hosts"

docker_prep
