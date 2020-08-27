#!/usr/bin/python3
# -*- coding: utf-8 -*-

import sys, os, shutil, json, fnmatch
from subprocess import call
import distutils.dir_util

import configparser
from distutils.version import LooseVersion
from urllib.request import Request, urlopen

def copyfiles(srcdir, dstdir, filepattern):
    def failed(exc):
        raise exc

    for dirpath, dirs, files in os.walk(srcdir, topdown=True, onerror=failed):
        for file in fnmatch.filter(files, filepattern):
            shutil.copy2(os.path.join(dirpath, file), dstdir)
        break # no recursion

def set_rw(operation, name, exc):
    os.chmod(name, stat.S_IWRITE)
    return True

GlobalScriptPath = os.path.dirname(os.path.realpath(__file__)).replace('\\','/')
GlobalReleasePath = GlobalScriptPath + "/Release"
print (GlobalScriptPath)
print (GlobalReleasePath)

if not os.path.isdir(GlobalReleasePath):
    os.makedirs(GlobalReleasePath, exist_ok=True)
if not os.path.isdir(GlobalReleasePath + "/App"):
    os.makedirs(GlobalReleasePath + "/App", exist_ok=True)	

config = configparser.ConfigParser()
config.read(GlobalScriptPath + '/App/AppInfo/appinfo.ini')
fileName = config['Details']['AppId']
fileVersion = config['Version']['PackageVersion']

#Build dotnet exe
os.chdir(GlobalScriptPath + "/Other/Source")
os.system("dotnet publish -r win10-x64 -c Release -p:PublishSingleFile=true")
os.chdir(GlobalScriptPath)

#Copy Files to Release Folder
copyfiles(GlobalScriptPath + '/App', GlobalReleasePath + '/App/', '*.exe')
copyfiles(GlobalScriptPath + '/App', GlobalReleasePath + '/App/', '*.config')
copyfiles(GlobalScriptPath + '/App', GlobalReleasePath + '/App/', '*.pdb')
copyfiles(GlobalScriptPath + '/App', GlobalReleasePath + '/App/', '*.dll')
shutil.copy2(GlobalScriptPath + '/help.html', GlobalReleasePath + '/help.html')
distutils.dir_util.copy_tree(GlobalScriptPath + '/App/AppInfo', GlobalReleasePath + '/App/AppInfo')
distutils.dir_util.copy_tree(GlobalScriptPath + '/App/DefaultData', GlobalReleasePath + '/App/DefaultData')
distutils.dir_util.copy_tree(GlobalScriptPath + '/Other', GlobalReleasePath + '/Other')
#Copy conemu
distutils.dir_util.copy_tree(GlobalScriptPath + '/App/RuntimeClean/ConEmu', GlobalReleasePath + '/App/RuntimeClean/ConEmu')

# Cleanup Source Folders before distribute
shutil.rmtree(GlobalReleasePath + '/Other/Source', ignore_errors=True, onerror=set_rw)
shutil.rmtree(GlobalReleasePath + '/Other/SourceNSIS', ignore_errors=True, onerror=set_rw)
shutil.rmtree(GlobalReleasePath + '/Other/BuildHelpers', ignore_errors=True, onerror=set_rw)

if not os.path.isdir(GlobalScriptPath + "/Other/BuildHelpers"):
    os.makedirs(GlobalScriptPath + "/Other/BuildHelpers", exist_ok=True)
    os.system('git clone https://github.com/MachinaCore/MachinaCore.comAppInstaller.git ' + GlobalScriptPath + "/Other/BuildHelpers/AppInstaller")

#Create Launcher
os.system('%CD%/BuildHelpers/AppInstaller/App/nsis/makensis.exe Other/SourceNSIS/CygwinPortable.nsi')
shutil.copy2(GlobalScriptPath + '/Other/SourceNSIS/CygwinPortable.exe', GlobalReleasePath + '/CygwinPortable.exe')

#Create 7-zip
os.system('7z.exe a -r -t7z -mx=9 '+ fileName +'_'+ fileVersion +'.7z .\Release\*')

#Create Installer
os.system('%CD%/Other/BuildHelpers/AppInstaller/PortableApps.comInstaller.exe %CD%\\Release')

