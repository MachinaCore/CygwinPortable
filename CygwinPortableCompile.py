import re
import urllib.request, urllib.parse, urllib.error, configparser
from distutils.core import setup
import sys, os, shutil, datetime, zipfile, subprocess, fnmatch,glob

import platform
sys.path.insert(0, os.path.join(os.path.realpath(os.path.dirname(sys.argv[0])), 'lib'))

from cx_Freeze import setup, Executable
import distutils.dir_util
import win32api

qtVersion = 'PyQt5'
buildPath = "exe.win32-3.4"

import os, fnmatch
def find_files(directory, pattern):
    for root, dirs, files in os.walk(directory):
        for basename in files:
            if fnmatch.fnmatch(basename, pattern):
                filename = os.path.join(root, basename)
                yield filename

name = 'CybeSystem CygwinPortable'
version = '0.1'

Win32ConsoleName = 'CygwinPortable-Console.exe'
Win32WindowName = 'CygwinPortable.exe'


createPortableApp = False
compressFiles = False


config = configparser.ConfigParser()
config.optionxform=str
config.read("App/AppInfo/appinfo.ini")
config.set('Version', 'DisplayVersion', version)

sys.argv.append('build')

#Kill process if running
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

def recursive_find_data_files(root_dir, allowed_extensions=('*')):
    to_return = {}
    for (dirpath, dirnames, filenames) in os.walk(root_dir):
        if not filenames:
            continue
        for cur_filename in filenames:
            matches_pattern = False
            for cur_pattern in allowed_extensions:
                if fnmatch.fnmatch(cur_filename, '*.'+cur_pattern):
                    matches_pattern = True
            if not matches_pattern:
                continue
            cur_filepath = os.path.join(dirpath, cur_filename)
            to_return.setdefault(dirpath, []).append(cur_filepath)
    return sorted(to_return.items())

def find_all_libraries(root_dirs):
    libs = []
    for cur_root_dir in root_dirs:
        for (dirpath, dirnames, filenames) in os.walk(cur_root_dir):
            if '__init__.py' not in filenames:
                continue
            libs.append(dirpath.replace(os.sep, '.'))
    return libs


def allFiles(dir):
    files = []
    for file in os.listdir(dir):
        fullFile = os.path.join(dir, file)
        if os.path.isdir(fullFile):
            files += allFiles(fullFile)
        else:
            files.append(fullFile)

    return files

includefiles = []
includes = []
packages = []

excludes = ['Tkconstants', 'Tkinter','PyQt4','PySide']
"""includes.append('sip')
includes.append('atexit')
includes.append('PyQt5')
includes.append('PyQt5.QtCore')
includes.append('PyQt5.QtGui')
includes.append('PyQt5.QtWidgets')
includes.append('PyQt5.QtPrintSupport')
packages.append('sip')
packages.append('atexit')
packages.append('PyQt5')
packages.append('PyQt5.QtCore')
packages.append('PyQt5.QtGui')
packages.append('PyQt5.QtWidgets')
packages.append('PyQt5.QtPrintSupport')"""

"""excludes = ['Tkconstants', 'Tkinter','PyQt4','PySide']
includes.append('sip')
includes.append('atexit')
includes.append('PyQt5')
includes.append('PyQt5.QtCore')
includes.append('PyQt5.QtGui')
includes.append('PyQt5.QtWebKit')
includes.append('PyQt5.QtWebKitWidgets')
includes.append('PyQt5.QtWidgets')
includes.append('PyQt5.QtPrintSupport')
packages.append('sip')
packages.append('atexit')
packages.append('PyQt5')
packages.append('PyQt5.QtCore')
packages.append('PyQt5.QtGui')
packages.append('PyQt5.QtWebKit')
packages.append('PyQt5.QtWebKitWidgets')
packages.append('PyQt5.QtWidgets')
packages.append('PyQt5.QtPrintSupport')"""



path = []

bin_path_includes=['libs']

Win32Exe = Executable(
    script = "CygwinPortable.py",
    initScript = None,
    base = 'Win32GUI',
    targetName = "CygwinPortable.exe",
    compress = True,
    copyDependentFiles = True,
    appendScriptToExe = True,
    appendScriptToLibrary = False,
    icon = "App/AppInfo/appicon1.ico"
)

setup(
    version = "0.1",
    description = "CybeSystems Win32",
    author = "CybeSystems.com",
    name = "CybeSystems",
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


"""ConsoleExe = Executable(
    script = "CygwinPortable.py",
    initScript = None,
    base = 'Console',
    targetName = "CybeSystems-Console.exe",
    compress = True,
    copyDependentFiles = True,
    appendScriptToExe = True,
    appendScriptToLibrary = False,
    icon = "App/AppInfo/appicon1.ico"
)

setup(
    version = "0.1",
    description = "CybeSystems Console",
    author = "CybeSystems.com",
    name = "CybeSystems",
    options = {"build_exe": {"includes": includes,
                             "excludes": excludes,
                             "packages": packages,
                             #Set next line to embedd libs into exe
                             #"create_shared_zip": False,
                             "include_msvcr": True,   #skip error msvcr100.dll missing
                             'include_files':includefiles,
                             "bin_path_includes":    bin_path_includes,
                             "path": path
                            }
    },
    executables = [ConsoleExe]
)"""

print ("########################################")
print ("Copy Files")
print ("########################################")
shutil.copytree('App', 'build/' + buildPath + '/App')
os.makedirs('build/' + buildPath + '/App/PythonLib')

listOfFiles = os.listdir('build/' + buildPath)
for f in listOfFiles:
    if os.path.isfile('build/' + buildPath + '/' + f):
        shutil.copy('build/' + buildPath + '/' + f, 'build/' + buildPath + '/App/PythonLib/' + f)
        os.remove('build/' + buildPath + '/' + f)

shutil.copy('build/' + buildPath + '/App/PythonLib/CygwinPortable.exe', 'build/' + buildPath + '/CygwinPortable.exe')
shutil.copy('CygwinPortable.ini', 'build/' + buildPath + '/CygwinPortable.ini')

shutil.copytree('Other', 'build/' + buildPath + '/Other')
shutil.copytree('Lib/ui', 'build/' + buildPath + '/App/PythonLib/ui')

#Copy PyQt5 plugins
shutil.copytree('build/' + buildPath + '/platforms', 'build/' + buildPath + '/App/PythonLib/plugins/platforms')

print ("########################################")
print ("Drop unneeded PyQt5 Libraries")
print ("########################################")

shutil.rmtree('build/' + buildPath + '/imageformats',ignore_errors=True)
shutil.rmtree('build/' + buildPath + '/platforms',ignore_errors=True)
shutil.rmtree('build/' + buildPath + '/PyQt5.uic.widget-plugins',ignore_errors=True)

os.remove('build/' + buildPath + '/App/PythonLib/CygwinPortable.exe')

os.remove('build/' + buildPath + '/App/PythonLib/icudt49.dll')
os.remove('build/' + buildPath + '/App/PythonLib/icuin49.dll')
os.remove('build/' + buildPath + '/App/PythonLib/icuuc49.dll')
os.remove('build/' + buildPath + '/App/PythonLib/LIBEAY32.dll')
os.remove('build/' + buildPath + '/App/PythonLib/libEGL.dll')
os.remove('build/' + buildPath + '/App/PythonLib/libGLESv2.dll')
os.remove('build/' + buildPath + '/App/PythonLib/SSLEAY32.dll')

os.remove('build/' + buildPath + '/App/PythonLib/Qt5Multimedia.dll')
os.remove('build/' + buildPath + '/App/PythonLib/Qt5Qml.dll')
os.remove('build/' + buildPath + '/App/PythonLib/Qt5Quick.dll')
os.remove('build/' + buildPath + '/App/PythonLib/Qt5Sql.dll')
os.remove('build/' + buildPath + '/App/PythonLib/Qt5Sensors.dll')
os.remove('build/' + buildPath + '/App/PythonLib/Qt5Positioning.dll')
os.remove('build/' + buildPath + '/App/PythonLib/Qt5WebKit.dll')
os.remove('build/' + buildPath + '/App/PythonLib/Qt5Widgets.dll')

os.remove('build/' + buildPath + '/App/PythonLib/PyQt5.QtWebKit.pyd')





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
