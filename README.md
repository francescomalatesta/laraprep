# LaraPrep

A really simple script for a really lazy developer, to get a new Laravel project (and its development environment, with Docker) up and running with a single command.

## How Does it Work?

If you type `./laraprep.sh test`, Laraprep:

* **creates a new Laravel project**, using docker CLI commands;
* **configures the hosts file accordingly**, by linking localhost to the `test.dev` hostname;
* **configures Vessel** to use Docker for the development environment;
* **starts all the containers** with ./vessel start;

You're ready to rock! You can reach your project by typing `test.dev` in your browser.

## Custom Project

If you want to install another Laravel-based project and not the plain `laravel/laravel`, use the `--project` option. Here's an example with [one of my projects](https://github.com/francescomalatesta/laravel-api-boilerplate-jwt):

`./laraprep.sh --project=francescomalatesta/laravel-api-boilerplate-jwt boilerplate`

With the above command LaraPrep will install the `francescomalatesta/laravel-api-boilerplate-jwt` repository under the `boilerplate` folder, with everything set up to start.

**Important:** use the `--project` option BEFORE the folder name, not after.

## How can I use the Docker environment?

You can find all the info you need on the [Vessel Project site](https://vessel.shippingdocker.com/).

## I'm in! How can I install it?

Just **clone this repository wherever you want**, and you're good to go.

Also, you can add an alias for the `./laraprep.sh` file to use wherever you want on your system. You can also move it under the `usr/local/bin` folder.

## Feedback

Every kind of feedback is welcome. If something is not working, feel free to open a PR or an issue.
