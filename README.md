CygwinPortable
==============

A portable Cygwin environment with much options. It's very useful for "static" installations too. It can create ShellExtensions in Windows Explorer ("Open Folder in Cygwin", "Open Drive in Cygwin", "Run in Cygwin").  "Open with -> CygwinPortable.exe" is also supported (you can register e.g. .sh extensions with CygwinPortable.exe). The default installation support XServer. ShellExtensions needs admin rights!

First Start
-----
 - Start CygwinPortable.exe - The setup.exe is download automatically
 - *Optional: Enter a new username if you want (cygwin is default username and home directory. Should be OK in most cases)*
 - *Optional: Change options if you want. The default settings are OK for most users.* 
 - Let the cygwin install (defaults are cygwin defaults + vim,X11,xinit,wget,tar,gawk,bzip2 packages)
 - Enjoy Cygwin :-)

Commandline Parameters:
-----
These options overrides the options from settings.ini

 - CygwinPortable.exe -help		-> Show help screen 
 - CygwinPortable.exe -config 		-> Open Config (setup.exe) 
 - CygwinPortable.exe -exit [0/1]	-> Exit the cygwin window after execution 
 - CygwinPortable.exe -path [PATH] -> Open the folder in path or execute the file (if the file is executable)  
 - CygwinPortable.exe [PATH] 		-> Open the folder in path or execute the file (if the file is executable) All other parameters are ignored (needed for "open with" in Windows)

PortableApps
-----
PortableApps (http://portableapps.com/) Tool is supported. Copy the Cygwin Portable folder to USBSTICK:\PortableApps

Special Folders
-----
There are 2 special Folders - Samples are included: 

- CYGWINPORTABLE/Data/ShellScript: Quick access to ShellScripts (rightclick Trayicon -> ShellScripts)
- CYGWINPORTABLE/Data/Shortcuts: Quick access to Windows Shortcuts (rightclick Trayicon -> Shortcuts)

Settings
-----

There are some interesting options - Rightclick on the CygwinPortable Trayicon -> "Cygwin Portable Settings"

**Settings:**

 - Shell: You can choose between mintty (default) and ConEmu. I've already included the last stable version of ConEmu (you can replace it with beta if you want - You should only preserve my ConEmu.xml file).
 - Executable File Extensions: Define what extensions are should by executed with Cygwin. This will NOT register the files directly ! This option will tell Cygwin Portable if a "open with" under windows is a extension that can be used from bash. If you open a file with a unknown extesion CygwinPortable will open the folder and not run the file.
 - Use TrayMenu: Enable/Disable the Traymenu (NOT RECOMMEND !) - if the Traymenu is disabled you can reactivate this option in CygwinPortable.ini -> TrayMenu=True
 - Exit after execution: If you open a file in Cygwin (e.g. a Shellscript) the window is closed after successfully execution. If you want see the output leave it disabled.
 - Disable Message Boxes: If CygwinPortable failed it will show the error in a Message Box. Disable it if you are working in a non GUI environment.
 - Add Windows PATH variables to Cygwin: Disable if cygwin should not be able to access Windows programs from path (useful if you have e.g. Git installed but you want to use cygwin git)

**Installer:**

- Cygwin Mirror: The Cygwin mirror where the packages will be downloaded.
- Cygwin Ports Mirror: Cygwin Ports have much more packages than the official Cygwin mirrors. Use it if needed
- First install additions: The packages that are additional installed to the default Cygwin packages
- Delete unneeded files: Drop unneeded files  or files that are not working in portable mode (e.g. cygwin.bat)
- Install unofficial Tools: Install files from CYGWINPORTABLE/other/unofficial folder. Default package is only apt-cyg (a tool that works like apt-get from debian based distros)

**Expert:**

- Delete conmplete installation: Drop all folders from ("Drop these folders on Reinstall"). Use it if you want to complete reinstall cygwin
- Drop these folders on Reinstall: See info above
- Username: Change the username and home directory 

Compile
-----

If you want to compile CygwinPortable by yourself download and install AutoItv3 (http://www.autoitscript.com/site/autoit/downloads/) and SciTE4AutoIt3 (http://www.autoitscript.com/site/autoit-script-editor/downloads/)
open CygwinPortable.au3 with Scite and click Tools -> Compile. Ready :-)

I've choose Autoit because it don't have any dependency's and create small exe files.

*Thanks for reading*