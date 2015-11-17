#!/bin/bash

###############################################################################################
# Variables
###############################################################################################

# Icon for the application
ICON_FILE='"/cygdrive/d/Development/CygwinPortable/App/AppInfo/appicon.ico"'

# Set the files that mkbundle should include
# MONO_BUNDLE='Xilium.CefGlue.Demo.WinForms.exe Xilium.CefGlue.Demo.dll Xilium.CefGlue.dll'
MONO_BUNDLE='D:\\Development\\CygwinPortable\\App\\CygwinPortable.exe'

#Output Folder
OUTPUT_FOLDER="MonoBuild"

# Output.exe name
OUTPUT_EXE_NAME="CygwinPortableCS.exe"

# Mono Path -> progra~2 is Program Files (x86) on Windows x64, except without spaces in it,
export MONO=/cygdrive/c/progra~2/Mono
export MONOPATH=$MONO/bin
export MSBUILD=$MONOPATH/xbuild

#mono's machine config file
MACHINECONFIG=$PROGRAMFILES\\Mono\\etc\\mono\\4.5\\machine.config

# Required to find mkbundle
export PATH=$PATH:$MONO/bin

# Required for the pkg-config call that mkbundle causes to work
export PKG_CONFIG_PATH=$MONO/lib/pkgconfig

###############################################################################################
# Build Project
###############################################################################################

export mkbundle=/cygdrive/c/progra~2/Mono/lib/mono/4.5/mkbundle
export project='CygwinPortable.sln'
export nuget='..\\.nuget\\nuget.exe'
export EnableNuGetPackageRestore='true'

$MSBUILD $project /t:clean
$MSBUILD $project /p:TargetFrameworkProfile="" /p:Platform="Any CPU" /p:Configuration=Release /nologo /v:m

###############################################################################################
# Make sure that exports are in ~/.bashrc too !!!!!
# export MONO=/home/cygwin/Mono
# export PATH=$PATH:$MONO/bin
# export PKG_CONFIG_PATH=$MONO/lib/pkgconfig
###############################################################################################
#
#Usage:
#1.) Install cygwin and make sure you select the following packages:
#- autoconf
#- automake
#- bison
#- gcc-core
#- gcc-g++
#- mingw-runtime
#- mingw-binutils
#- mingw-gcc-core
#- mingw-gcc-g++
#- mingw-pthreads
#- mingw-w32api
#- libtool
#- make
#- python
#- gettext-devel
#- gettext
#- intltool
#- libiconv
#- pkg-config
#- git
#- curl
#- libxslt
#- mingw-zlib1
#- mingw-zlib-devel
#
#2.) Install the following Mono release package: "Mono for Windows, Gtk#, and XSP"
#
#3.) Download this script place it besides your Application and modify it to fit your environment 
# (read the comments in this file carefully).
#
#4.) Open cygwin and navigate to the output folder of your application where the executable and the
# scipt lies, e.g. YourProject/bin/Release
#
#5.) Execute the script with the command: ./mkbundle_cygwin.sh
#
#Troubleshooting:
#If your bundled executable does not work make sure the original .NET application works on mono.
# You can test that by calling mono.exe and pass your .NET app to it or by installing XamarinStudio 
# and running your project from there (make you set mono as runtime).
#
#Big credits to the following sources on which this script is based on:
#http://www.joebest.org/2011/09/mono-and-mkbundle-on-windows.html
#http://blog.shilbert.com/2012/06/using-mono-to-avoid-depending-on-net-framework/
#http://stackoverflow.com/questions/4474613/can-not-compile-simple-c-sharp-application-with-mkbundle
#http://2oj.com/2012/03/compiling-mono-executable-into-aot-exe-file-on-windows/
#
# If this doesn't work, ensure you have UNIX line endings in this file
# (\n, not \r\n.) You can use Notepad++ to switch them.

# Cygwin package requirements: gcc-mingw, pkg-config, binutils
# If you want to pass -z to mkbundle: mingw-zlib1, mingw-zlib-devel

# crash immediately if anything bad happens
#set -o errexit
#set -o nounset

rm -rf $OUTPUT_FOLDER
mkdir $OUTPUT_FOLDER

#Create icon.rc file
echo "1 ICON $ICON_FILE" > icon.rc

#Compile icon to object file
windres icon.rc icon.o

# On Cygwin you used to be able to use gcc -mno-cygwin to make binaries
# that didn't depend on cygwin. That doesn't work with the current gcc 4.x,
# so I'm explicitly using the compiler installed by the gcc-mingw package,
# in case the user has normal, non-mingw gcc installed too.
#
# Another alternative would be to use an older version of GCC, e.g:
#
# export CC="gcc-3 -mno-cygwin -U _WIN32"
#
# The -U _WIN32 undefines the _WIN32 symbol. The source code mkbundle executes
# is totally broken on Win32 but actually works if you don't let it know
# that it is on Win32.
# Also add the icon.o file so that it gets compiled into the exe.
export CC="i686-pc-mingw32-gcc -U _WIN32"
export AS="i686-pc-mingw32-as"

# Call Mono's mkbundle with your assemblies.
# --deps tells it to gather dependencies.
# -o specifies the output file name.
# YourGame.exe and OpenTK.dll can be replaced with whatever assemblies you need to include.
# You don't need to specify system assemblies, mkbundle will pick them up because of --deps.

# mkbundle
mkbundle -c -o host.c -oo bundle.o --machine-config "$MACHINECONFIG" --deps $MONO_BUNDLE

# gcc
$CC -g -Os -o $OUTPUT_FOLDER/$OUTPUT_EXE_NAME -Wall host.c `pkg-config --cflags --libs mono-2` icon.o bundle.o

#Cleanup icon.rc and icon.o
rm icon.rc 
rm icon.o
rm host.c
rm bundle.o


# Copy mono-2.0.dll and zlib1.dll here since Output.exe depends on it.
cp $MONO/bin/mono-2.0.dll $OUTPUT_FOLDER
cp $MONO/bin/zlib1.dll $OUTPUT_FOLDER

# Test output file
#./$OUTPUT_EXE_NAME