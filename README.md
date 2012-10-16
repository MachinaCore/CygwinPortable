CygwinPortable
==============

Configuration files to make Cygwin portable on a USB flash drive.

Setup
-----

Let's assume that your USB flash drive is on `E:`.

1. Install the PortableApps platform to your flash drive.

2. Create a folder at `E:\PortableApps\CygwinPortable`.

3. Download Cygwin and place `setup.exe` in the directory you just created. Rename it to `cygwinConfig.exe` (this allows you to run it without administrator privileges).

4. Install Cygwin.
	- Set the root directory to `E:\PortableApps\CygwinPortable`. 
	- Install for "Just me".
	- Set the local package directory to `E:\PortableApps\CygwinPortable\packages`.
	- Besides the defaults, install `git`, `vim`, `source-highlight` and the entire `X11` category.
	- Do not create shortcuts when you get to the last screen of the install.

5. Launch Cygwin-Terminal. Clone this repo into the root Cygwin directory:

		$ cd /
		$ git init
		$ git remote add origin git://github.com/ntmoe/CygwinPortable.git
		$ git pull origin master

6. Link the portable-ized configuration files (and some handy scripts that I use) to their proper locations:
			
		$ cd ~
		$ rm .bashrc .minttyrc /etc/profile
		$ ln -s /Other/bashrc ~/.bashrc
		$ ln -s /Other/dircolors ~/.dircolors
		$ ln -s /Other/minttyrc ~/.minttyrc
		$ ln -s /Other/profile /etc/profile
		$ ln -s /Other/cyg-wrapper.sh /bin/cyg-wrapper.sh
		$ ln -s /Other/startSumatra.sh /bin/startSumatra.sh

7. Now if you go to the PortableApps menu and refresh it, three Cygwin Utilities should show up, those being:
	- Cygwin Setup
	- Cygwin Terminal
	- Start XWin Server

