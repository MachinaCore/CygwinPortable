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

GlobalScriptPath = os.path.dirname(os.path.realpath(__file__)).replace('\\','/')
GlobalReleasePath = GlobalScriptPath + "/Release"
print (GlobalScriptPath)
print (GlobalReleasePath)

if not os.path.isdir(GlobalScriptPath):
    os.makedirs(GlobalReleasePath, exist_ok=True)

config = configparser.ConfigParser()
config.read(GlobalScriptPath + '/App/AppInfo/appinfo.ini')
fileName = config['Details']['AppId']
fileVersion = config['Version']['PackageVersion']

#Copy Files to Release Folder
copyfiles(GlobalScriptPath , GlobalReleasePath, '*.exe')
copyfiles(GlobalScriptPath, GlobalReleasePath, '*.config')
copyfiles(GlobalScriptPath, GlobalReleasePath, '*.pdb')
copyfiles(GlobalScriptPath, GlobalReleasePath, '*.dll')
shutil.copy2(GlobalScriptPath + '/help.html', GlobalReleasePath + '/help.html')
distutils.dir_util.copy_tree(GlobalScriptPath + '/App/AppInfo', GlobalReleasePath + '/App/AppInfo')
distutils.dir_util.copy_tree(GlobalScriptPath + '/App/DefaultData', GlobalReleasePath + '/App/DefaultData')
distutils.dir_util.copy_tree(GlobalScriptPath + '/Other', GlobalReleasePath + '/Other')
#Copy conemu
distutils.dir_util.copy_tree(GlobalScriptPath + '/App/RuntimeClean/ConEmu', GlobalReleasePath + '/App/RuntimeClean/ConEmu')


if not os.path.isdir(GlobalScriptPath + "/BuildHelpers"):
    os.makedirs(GlobalScriptPath + "/BuildHelpers", exist_ok=True)
    os.system('git clone https://github.com/LORDofDOOM/GathSystems.comAppInstaller.git ' + GlobalScriptPath + "/BuildHelpers/AppInstaller")

#Create Launcher
os.system(GlobalScriptPath + "/BuildHelpers/AppInstaller/App/nsis/makensis.exe " + GlobalScriptPath + "/Other/source/CygwinPortable.nsi")
shutil.copy2(GlobalScriptPath + '/Other/source/CygwinPortable.exe', GlobalReleasePath + '/CygwinPortable.exe')