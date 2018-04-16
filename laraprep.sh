# LaraPrep, a simple script for a lazy developer.
# Wrote by Francesco Malatesta - Dec 10, 2016 - Last Update Nov 23, 2017

function docker_prep {
  # export current user id
  USER_ID=$(id -u -r)
  USER_NAME=$(whoami)

  echo "127.0.0.1    ${PROJECT_HOSTNAME}" | sudo tee -a $HOSTS_PATH > /dev/null

  docker run -u $USER_ID --rm -it \
      -v $(pwd):/opt \
      -w /opt shippingdocker/php-composer:latest \
      composer create-project $1 $PROJECT_NAME

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

PARSED_OPTIONS=$(getopt -n "$0"  -o p: --long "project:"  -- "$@")
REPO_NAME="laravel/laravel"

if [ $? -ne 0 ];
then
  exit 1
fi

eval set -- "$PARSED_OPTIONS"

while true;
do
  case "$1" in
    -p|--project)
      if [ -n "$2" ];
      then
        REPO_NAME="$2"
      fi
      shift 2;;

    --)
      shift
      break;;
  esac
done

if [ -z "$1" ]
  then
    echo "ERROR: Please specify a name for the project folder."
    exit
fi

PROJECT_NAME="$1"
PROJECT_HOSTNAME="$1.dev"
HOSTS_PATH="/etc/hosts"

docker_prep "$REPO_NAME"
