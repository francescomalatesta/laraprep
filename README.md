# LaraPrep

A really simple script for a really lazy developer, to get a new Laravel project (and its development environment, with Docker) up and running with a single command.

## How Does it Work?

If you type `./laraprep.sh myapp`, Laraprep:

* **creates a new Laravel project**, using docker CLI commands;
* **configures the hosts file accordingly**, by linking localhost to the `myapp.test` hostname;
* **configures Vessel** to use Docker for the development environment;
* **starts all the containers** with ./vessel start;

You're ready to rock! You can reach your project by typing `myapp.test` in your browser.

## How can I use the Docker environment?

You can find all the info you need on the [Vessel Project site](https://vessel.shippingdocker.com/).

## I'm in! How can I install it?

Just **clone this repository wherever you want**, and you're good to go.

Also, you can add an alias for the `./laraprep.sh` file to use wherever you want on your system. You can also move it under the `usr/local/bin` folder.

## Feedback

Every kind of feedback is welcome. If something is not working, feel free to open a PR or an issue.
