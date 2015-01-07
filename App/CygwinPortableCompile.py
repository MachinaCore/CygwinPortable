###################################################################
# OdooPortable Freezer - Using cx_freeze
###################################################################

name = 'OdooPortable'
version = '1.0'

Win32ConsoleName = 'CygwinPortable-Console-X86.exe'
Win32WindowName = 'CygwinPortable-X86.exe'

copyRuntime = True
killTasks = False

###################################################################
# Import Libs, detect x86/x64
###################################################################

import re
import urllib.request, urllib.parse, urllib.error, configparser
from distutils.core import setup
import sys, os, shutil, datetime, zipfile, subprocess, fnmatch,glob

import platform
sys.path.insert(0, os.path.join(os.path.realpath(os.path.dirname(sys.argv[0])), 'lib'))

if platform.architecture()[0] == '64bit':
    sys.path.insert(0, os.path.join(os.path.realpath(os.path.dirname(sys.argv[0])), 'libX64'))
    x86x64 = 'X64'
    x86x64BuildPath = "exe.win-amd64-3.4"
else:
    sys.path.insert(0, os.path.join(os.path.realpath(os.path.dirname(sys.argv[0])), 'libX86'))
    x86x64 = 'X86'
    x86x64BuildPath = "exe.win32-3.4"

from cx_Freeze import setup, Executable
import distutils.dir_util
import win32api

scriptpath = os.path.realpath(os.path.dirname(sys.argv[0])).replace('\\','/')
scriptpathParentFolder = os.path.dirname(scriptpath)

###################################################################
# Set Version
###################################################################

config = configparser.ConfigParser()
config.optionxform=str
config.read("AppInfo/appinfo.ini")
config.set('Version', 'DisplayVersion', version)
with open("AppInfo/appinfo.ini", 'w') as configfile:
    config.write(configfile)

###################################################################
# Kill running Process before Build, delete old builds
###################################################################

sys.argv.append('build')

#Kill process if running
if killTasks == True:
    os.system("taskkill /im " + Win32ConsoleName + " /f")
    os.system("taskkill /im " + Win32WindowName + " /f")

# clear the dist dir
if os.path.isfile("dist/%s" % Win32WindowName):
    os.remove("dist/%s" % Win32WindowName)
if os.path.isfile("dist/%s" % Win32ConsoleName):
    os.remove("dist/%s" % Win32ConsoleName)
if os.path.isfile("%s" % Win32WindowName):
    os.remove("%s" % Win32WindowName)
if os.path.isfile("%s" % Win32ConsoleName):
    os.remove("%s" % Win32ConsoleName)
if os.path.isfile("python27.dll"):
    os.remove("python27.dll")

shutil.rmtree('dist',ignore_errors=True)
shutil.rmtree('librarys',ignore_errors=True)
shutil.rmtree('build',ignore_errors=True)

###################################################################
# cx_freeze
###################################################################

includefiles = []
includes = []
excludes = []
packages = []

includes.append('sip')
includes.append('winshell')
includes.append('atexit')
includes.append('psutil')
includes.append('PyQt5.QtCore')
includes.append('PyQt5.QtGui')
includes.append('PyQt5.QtNetwork')

excludes.append('Tkconstants')
excludes.append('Tkinter')
excludes.append('PyQt4')
excludes.append('PySide')

packages.append('sip')
packages.append('winshell')
packages.append('atexit')
packages.append('PyQt5.QtCore')
packages.append('PyQt5.QtGui')
packages.append('PyQt5.QtWidgets')
packages.append('PyQt5.QtNetwork')

path = []

bin_path_includes=['libs']

# Create GUI Version
Win32Exe = Executable(
    script = "CygwinPortable.py",
    initScript = None,
    base = 'Win32GUI',
    targetName = "CygwinPortable-" + x86x64 + ".exe",
    compress = True,
    copyDependentFiles = True,
    appendScriptToExe = True,
    appendScriptToLibrary = False,
    icon = "ressource/icons/icon.ico"
)

setup(
    version = "0.1",
    description = "OdooPortable Win32",
    author = "CybeSystems.com",
    name = "OdooPortable",
    options = {"build_exe": {"includes": includes,
                             "excludes": excludes,
                             "packages": packages,
                             "include_msvcr": True,   #skip error msvcr100.dll missing
                             'include_files':includefiles,
                             "bin_path_includes":    bin_path_includes,
                             "path": path
    }
    },
    executables = [Win32Exe]
)

#Create Console Version
ConsoleExe = Executable(
    script = "CygwinPortable.py",
    initScript = None,
    base = 'Console',
    targetName = "CygwinPortable-Console-" + x86x64 + ".exe",
    compress = True,
    copyDependentFiles = True,
    appendScriptToExe = True,
    appendScriptToLibrary = False,
    icon = "ressource/icons/icon.ico"
)

setup(
    version = "0.1",
    description = "OdooPortable Console",
    author = "CybeSystems.com",
    name = "OdooPortable",
    options = {"build_exe": {"includes": includes,
                             "excludes": excludes,
                             "packages": packages,
                             "include_msvcr": True,   #skip error msvcr100.dll missing
                             'include_files':includefiles,
                             "bin_path_includes":    bin_path_includes,
                             "path": path
    }
    },

    executables = [ConsoleExe]
)

###################################################################
# Copy needed files for release
###################################################################

print ("########################################")
print ("Copy Files")
print ("########################################")

os.makedirs('build/' + x86x64BuildPath + '/lib' + x86x64)

listOfFiles = os.listdir('build/' + x86x64BuildPath)
for f in listOfFiles:
    if os.path.isfile('build/' + x86x64BuildPath + '/' + f):
        shutil.copy('build/' + x86x64BuildPath + '/' + f, 'build/' + x86x64BuildPath + '/lib' + x86x64 + '/' + f)
        os.remove('build/' + x86x64BuildPath + '/' + f)


shutil.copy('build/' + x86x64BuildPath + '/lib' + x86x64 + '/CygwinPortable-' + x86x64 + '.exe', 'build/' + x86x64BuildPath + '/CygwinPortable-' + x86x64 + '.exe')
shutil.copy('build/' + x86x64BuildPath + '/lib' + x86x64 + '/CygwinPortable-Console-' + x86x64 + '.exe', 'build/' + x86x64BuildPath + '/CygwinPortable-Console-' + x86x64 + '.exe')
shutil.copy('build/' + x86x64BuildPath + '/lib' + x86x64 + '/library.zip', 'build/' + x86x64BuildPath + '/library.zip')

shutil.copyfile('lib' + x86x64 + '/python34.dll', 'build/' + x86x64BuildPath + '/python34.dll')
shutil.copyfile('lib' + x86x64 + '/msvcr100.dll', 'build/' + x86x64BuildPath + '/msvcr100.dll')

os.remove('build/' + x86x64BuildPath + '/lib' + x86x64 + '/python34.dll')
os.remove('build/' + x86x64BuildPath + '/lib' + x86x64 + '/msvcr100.dll')

#Drop unneeded files
os.remove('build/' + x86x64BuildPath + '/lib' + x86x64 + '/library.zip')
os.remove('build/' + x86x64BuildPath + '/lib' + x86x64 + '/CygwinPortable-' + x86x64 + '.exe')
os.remove('build/' + x86x64BuildPath + '/lib' + x86x64 + '/CygwinPortable-Console-' + x86x64 + '.exe')

shutil.copytree('ressource', 'build/' + x86x64BuildPath + '/ressource')
shutil.copyfile('build/' + x86x64BuildPath + '/library.zip', 'build/' + x86x64BuildPath + '/lib' + x86x64 + '/libraries.zip')
os.remove('build/' + x86x64BuildPath + '/library.zip')

#Drop unneeded PyQt Files -> cx_freeze will not resolve correct
#os.remove('build/' + x86x64BuildPath + '/lib' + x86x64 + '/LIBEAY32.dll')
#os.remove('build/' + x86x64BuildPath + '/lib' + x86x64 + '/PyQt5.QtNetwork.pyd')
os.remove('build/' + x86x64BuildPath + '/lib' + x86x64 + '/PyQt5.QtWebKit.pyd')
os.remove('build/' + x86x64BuildPath + '/lib' + x86x64 + '/Qt5Multimedia.dll')
#os.remove('build/' + x86x64BuildPath + '/lib' + x86x64 + '/Qt5Network.dll')
os.remove('build/' + x86x64BuildPath + '/lib' + x86x64 + '/Qt5Positioning.dll')
os.remove('build/' + x86x64BuildPath + '/lib' + x86x64 + '/Qt5Qml.dll')
os.remove('build/' + x86x64BuildPath + '/lib' + x86x64 + '/Qt5Quick.dll')
os.remove('build/' + x86x64BuildPath + '/lib' + x86x64 + '/Qt5Sensors.dll')
os.remove('build/' + x86x64BuildPath + '/lib' + x86x64 + '/Qt5Sql.dll')
os.remove('build/' + x86x64BuildPath + '/lib' + x86x64 + '/Qt5WebKit.dll')
#os.remove('build/' + x86x64BuildPath + '/lib' + x86x64 + '/SSLEAY32.dll')

#Workaround for PyQt error platform files not found -> No longer needed in PyQt 5.4
#shutil.copyfile('build/' + x86x64BuildPath + '/lib' + x86x64 + '/libEGL.dll', 'build/' + x86x64BuildPath + '/libEGL.dll')

shutil.copytree('build/' + x86x64BuildPath + '/platforms', 'build/' + x86x64BuildPath + '/lib' + x86x64 + '/plugins/platforms')
shutil.copytree('build/' + x86x64BuildPath + '/PyQt5.uic.widget-plugins', 'build/' + x86x64BuildPath + '/lib' + x86x64 + '/plugins/PyQt5.uic.widget-plugins')
#ImageFormats are not needed in this case
#shutil.copytree('build/' + x86x64BuildPath + '/imageformats', 'build/' + x86x64BuildPath + '/lib' + x86x64 + '/plugins/imageformats')
shutil.rmtree('build/' + x86x64BuildPath + '/platforms',ignore_errors=True)
shutil.rmtree('build/' + x86x64BuildPath + '/PyQt5.uic.widget-plugins',ignore_errors=True)
shutil.rmtree('build/' + x86x64BuildPath + '/imageformats',ignore_errors=True)

#Prepare Portable Version
shutil.rmtree('!RELEASE_' + x86x64 ,ignore_errors=True)
distutils.dir_util.copy_tree('build/' + x86x64BuildPath, '!RELEASE_' + x86x64 + '/App')
shutil.copytree('AppInfo', '!RELEASE_' + x86x64 + '/App/AppInfo')
shutil.copytree('DefaultData', '!RELEASE_' + x86x64 + '/App/DefaultData')

if copyRuntime == True:
    if not os.path.isdir('RuntimeClean'):
        print("RuntimeClean Folder not found - Fallback to Runtime")
        shutil.copytree('Runtime/ConEmu', '!RELEASE_' + x86x64 + '/App/Runtime/ConEmu')
    else:
        shutil.copytree('RuntimeClean', '!RELEASE_' + x86x64 + '/App/Runtime')

shutil.copytree(scriptpathParentFolder + '/Other', '!RELEASE_' + x86x64 + '/Other')
shutil.copyfile(scriptpathParentFolder + '/Other/Source/CygwinPortable.exe', '!RELEASE_' + x86x64 + '/CygwinPortable.exe')
os.remove('!RELEASE_' + x86x64 + '/Other/Source/CygwinPortable.exe')
shutil.copyfile(scriptpathParentFolder + '/help.html', '!RELEASE_' + x86x64 + '/help.html')


def fancyLogoWin():
    return r"""
   ____      _          ____            _
  / ___|   _| |__   ___/ ___| _   _ ___| |_ ___ _ __ ___  ___
 | |  | | | | '_ \ / _ \___ \| | | / __| __/ _ \ '_ ` _ \/ __|
 | |___ |_| | |_) |  __/___) | |_| \__ \ |_  __/ | | | | \__ \
  \____\__, |_.__/ \___|____/ \__, |___/\__\___|_| |_| |_|___/
       |___/                  |___/
"""
curFancyLogo = fancyLogoWin()
print (curFancyLogo)
print ("")
print ("########################################")
print ("Build SUCCESSFUL !!")
print ("########################################")
print ("")
