CygwinPortable
==============

Configuration files to make Cygwin portable on a USB flash drive.

Setup
-----

Let's assume that your USB flash drive is on `E:`.

1. Create a folder at `E:\PortableApps\CygwinPortable`.

2. Download Cygwin and place `setup.exe` in the directory you just created. Rename it to `cygwinConfig.exe` (this allows you to run it without administrator privileges.)

3. Install Cygwin.
	- Set the root directory to `E:\PortableApps\CygwinPortable`. 
	- Install for "Just me".
	- Set the local package directory to `E:\PortableApps\CygwinPortable\packages`.
	- Install `git`, `vim`, and the entire `X11` category.
	- Do not create shortcuts when you get to the last screen of the install.

4. Launch Cygwin-Terminal. Clone this repo into the root Cygwin directory:

`$ cd /
$ git init
$ git remote add origin git://github.com/ntmoe/CygwinPortable.git
$ git pull origin master
`
