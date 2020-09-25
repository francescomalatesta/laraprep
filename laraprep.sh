#!/usr/bin/env bash

# LaraPrep, a simple script for a lazy developer.
# Wrote by Francesco Malatesta - Dec 10, 2016 - Last Update Sep 25, 2020

function docker_prep {
  # export current user id
  USER_ID=$(id -u -r)
  USER_NAME=$(whoami)

  echo "Creating Project: ${PROJECT_NAME} with laravel/laravel${PROJECT_VERSION} - PHP: ${PHP_VERSION}"
  echo "127.0.0.1    ${PROJECT_HOSTNAME}" | sudo tee -a $HOSTS_PATH > /dev/null

  docker run -u $USER_ID --rm -it \
      -v $(pwd):/opt \
      -w /opt shippingdocker/php-composer:$PHP_VERSION \
      composer create-project laravel/laravel$PROJECT_VERSION $PROJECT_NAME

  docker run -u $USER_ID --rm -it \
      -v $(pwd):/opt \
      -w /opt/$PROJECT_NAME shippingdocker/php-composer:$PHP_VERSION \
      composer require shipping-docker/vessel

  docker run -u $USER_ID --rm -it \
      -v $(pwd):/opt \
      -w /opt/$PROJECT_NAME shippingdocker/php-composer:$PHP_VERSION \
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

PHP_VERSION="$3"
if [ -z "$3" ]
  then
    PHP_VERSION="latest"
fi

PROJECT_VERSION="=$2"
if [ -z "$2" ]
  then
    PROJECT_VERSION=""
fi

PROJECT_NAME="$1"
PROJECT_HOSTNAME="$1.test"
HOSTS_PATH="/etc/hosts"

docker_prep
