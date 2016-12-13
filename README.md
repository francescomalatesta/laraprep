# LaraPrep

A really simple script for a really lazy developer, to get a new Laravel project (and its development environment, with Vagrant) up and running with a single command.

## How Does it Work?

Here's what happens if you type `./laraprep.sh test`:

* **creates a new vagrant machine**, using Laravel Homestead Improved;
* **configures the Homestead.yml and your hosts file accordingly**, with a random IP and the `test.dev` as hostname;
* **starts the VM** after its creation;
* **installs a fresh new Laravel project**, using `composer create-project`;

And you're ready to rock! You can reach your project by typing `test.dev` in your browser.

## I'm in! How can I install it?

Just **clone this repository wherever you want**, and you're good to go.

Also, you can add an alias for the `./laraprep.sh` file to use wherever you want on your system.
