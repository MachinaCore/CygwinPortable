using System;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Security.Principal;
using System.Windows.Forms;
using SharpConfig;

namespace CygwinPortableCS
{
    static class Program
    {
        /// <summary>
        /// Der Haupteinstiegspunkt für die Anwendung.
        /// </summary>
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);

            Globals.Folders["apppath"] = Globals.scriptpathParentParentParentFolder + "\\" + Globals.scriptpathParentParentFolderDirName;
            Globals.Folders["datapath"] = Globals.scriptpathParentParentParentFolder + "\\" + Globals.scriptpathParentParentFolderDirName + "\\" + Globals.scriptpathParentFolderDirName + "\\Data";
            Globals.Folders["configpath"] = Globals.scriptpathParentParentParentFolder + "\\" + Globals.scriptpathParentParentFolderDirName + "\\" + Globals.scriptpathParentFolderDirName + "\\Data";


            WindowsPrincipal pricipal = new WindowsPrincipal(WindowsIdentity.GetCurrent());
            Globals.RuntimeSettings["isAdmin"] = pricipal.IsInRole(WindowsBuiltInRole.Administrator);
            Globals.RuntimeSettings["defaultFileIconType"] = 16384;

            Globals.RuntimeSettings["fileIconType"] = 0x4000;
            Type runtimeType = Type.GetType("Mono.Runtime");
            if (runtimeType != null)
            {
                Globals.RuntimeSettings["Mono"] = true;
            }
            else
            {
                Globals.RuntimeSettings["Mono"] = false;
            }


            bool iniFileExists = true;
            if (!File.Exists(Globals.Folders["configpath"] + "\\Configuration.ini"))
            {
                Globals.Config = new Configuration();
                iniFileExists = false;
            }
            else
            {
                Globals.Config = Configuration.LoadFromFile(Globals.Folders["configpath"] + "\\Configuration.ini");
            }

            if (Globals.Config["Main"]["ExecutableExtension"].StringValue == "")
            {
                Globals.Config["Main"]["ExecutableExtension"].SetValue("exe,bat,sh,pl,bat,py");
            }
            if (Globals.Config["Main"]["ExecutableExtension"].StringValue == "")
            {
                Globals.Config["Main"]["ExecutableExtension"].SetValue("exe,bat,sh,pl,bat,py");
            }
            if (Globals.Config["Main"]["ExitAfterExec"].StringValue == "")
            {
                Globals.Config["Main"]["ExitAfterExec"].SetValue("false");
            }
            if (Globals.Config["Main"]["SetContextMenu"].StringValue == "")
            {
                Globals.Config["Main"]["SetContextMenu"].SetValue("true");
            }
            if (Globals.Config["Main"]["TrayMenu"].StringValue == "")
            {
                Globals.Config["Main"]["TrayMenu"].SetValue("true");
            }
            if (Globals.Config["Main"]["Shell"].StringValue == "")
            {
                Globals.Config["Main"]["Shell"].SetValue("ConEmu");
            }
            if (Globals.Config["Main"]["NoMsgBox"].StringValue == "")
            {
                Globals.Config["Main"]["NoMsgBox"].SetValue("false");
            }
            if (Globals.Config["Main"]["CygwinMirror"].StringValue == "")
            {
                Globals.Config["Main"]["CygwinMirror"].SetValue("http://lug.mtu.edu/cygwin");
            }
            if (Globals.Config["Main"]["CygwinPortsMirror"].StringValue == "")
            {
                Globals.Config["Main"]["CygwinPortsMirror"].SetValue("ftp://ftp.cygwinports.org/pub/cygwinports");
            }
            if (Globals.Config["Main"]["CygwinFirstInstallAdditions"].StringValue == "")
            {
                //Globals.Config["Main"]["CygwinFirstInstallAdditions"].SetValue("vim,X11,xinit,wget,tar,gawk,bzip2");
                //Mono Build
                Globals.Config["Main"]["CygwinFirstInstallAdditions"].SetValue("vim,X11,xinit,wget,tar,gawk,bzip2,autoconf,automake,bison,gcc-core,gcc-g++,mingw-runtime,mingw-binutils,mingw-gcc-core,mingw-gcc-g++,mingw-pthreads,mingw-w32api,libtool,make,python,gettext-devel,gettext,intltool,libiconv,pkg-config,git,curl,libxslt,mingw-zlib1,mingw-zlib-devel");
            }
            if (Globals.Config["Main"]["CygwinFirstInstallDeleteUnneeded"].StringValue == "")
            {
                Globals.Config["Main"]["CygwinFirstInstallDeleteUnneeded"].SetValue("true");
            }
            if (Globals.Config["Main"]["InstallUnofficial"].StringValue == "")
            {
                Globals.Config["Main"]["InstallUnofficial"].SetValue("true");
            }
            if (Globals.Config["Main"]["WindowsPathToCygwin"].StringValue == "")
            {
                Globals.Config["Main"]["WindowsPathToCygwin"].SetValue("true");
            }
            if (Globals.Config["Main"]["WindowsAdditionalPath"].StringValue == "")
            {
                Globals.Config["Main"]["WindowsAdditionalPath"].SetValue("/cygdrive/c/python27;/cygdrive/c/windows;/cygdrive/c/windows/system32;/cygdrive/c/windows/SysWOW64");
            }
            if (Globals.Config["Main"]["WindowsPythonPath"].StringValue == "")
            {
                Globals.Config["Main"]["WindowsPythonPath"].SetValue("/cygdrive/c/python27");
            }
            if (Globals.Config["Main"]["CygwinX86URL"].StringValue == "")
            {
                Globals.Config["Main"]["CygwinX86URL"].SetValue("https://www.cygwin.com/setup-x86.exe");
            }
            if (Globals.Config["Main"]["CygwinX64URL"].StringValue == "")
            {
                Globals.Config["Main"]["CygwinX64URL"].SetValue("https://www.cygwin.com/setup-x86_64.exe");
            }


            if (Globals.Config["Static"]["Username"].StringValue == "")
            {
                Globals.Config["Static"]["Username"].SetValue("cygwin");
            }

            if (Globals.Config["Expert"]["CygwinDeleteInstallation"].StringValue == "")
            {
                Globals.Config["Expert"]["CygwinDeleteInstallation"].SetValue("false");
            }
            if (Globals.Config["Expert"]["CygwinDeleteInstallationFolders"].StringValue == "")
            {
                Globals.Config["Expert"]["CygwinDeleteInstallationFolders"].SetValue("xbin,cygdrive,dev,etc,home,lib,packages,tmp,usr,var");
            }




            //Check if Delete Installation Flag is set
            if (Globals.Config["Expert"]["CygwinDeleteInstallation"].BoolValue)
            {
                DialogResult dialogResult = MessageBox.Show("Do you REALLY want to delete and reinstall your Cygwin installation ?", "Delete/Reinstall Cygwin", MessageBoxButtons.YesNo);
                if (dialogResult == DialogResult.Yes)
                {
                    foreach (string folder in (Globals.Config["Expert"]["CygwinDeleteInstallationFolders"].StringValue).Split(','))
                    {
                        Directory.Delete(Globals.scriptpath + "\\Runtime\\Cygwin\\" + folder, true);
                    }
                }
                else if (dialogResult == DialogResult.No)
                {
                }
            }

            //Create Folders if not exist
            if (!Directory.Exists(Globals.scriptpathParentFolder + "\\Data"))
            {
                Directory.CreateDirectory(Globals.scriptpathParentFolder + "\\Data");
            }

            //Config.SaveConfig();
            if (!iniFileExists)
            {
                Globals.Config.SaveToFile(Globals.Folders["configpath"] + "\\Configuration.ini");
                iniFileExists = true;
            }

            //Check if Cygwin exists
            if (!File.Exists(Globals.scriptpath + "\\Runtime\\Cygwin\\CygwinConfig.exe"))
            {
                if (!Directory.Exists(Globals.scriptpath + "\\Runtime\\Cygwin"))
                {
                    Directory.CreateDirectory(Globals.scriptpath + "\\Runtime\\Cygwin");
                }
                var downloadForm = new Form_Download();
                downloadForm.Show();
            }

            //Check if ConEmu is installed
            if (!Directory.Exists(Globals.scriptpathParentFolder + "\\Data\\ShellScript") && Globals.Config["Main"]["Shell"].StringValue == "ConEmu")
            {
                Globals.Config["Main"]["Shell"].StringValue = "mintty";
            }

            if (Globals.Config["Static"]["Username"].StringValue == "")
            {
                Globals.Config["Static"]["Username"].StringValue = "cygwin";
            }



            if (!Directory.Exists(Globals.scriptpathParentFolder + "\\Data\\ShellScript"))
            {
                Directory.CreateDirectory(Globals.scriptpathParentFolder + "\\Data\\ShellScript");
                File.Copy(Globals.scriptpath + "\\DefaultData\\ShellScript\\Testscript.sh", Globals.Folders["datapath"] + "\\ShellScript\\Testscript.sh");
            }
            if (!Directory.Exists(Globals.scriptpathParentFolder + "\\Data\\Shortcuts"))
            {
                Directory.CreateDirectory(Globals.scriptpathParentFolder + "\\Data\\Shortcuts");
                File.Copy(Globals.scriptpath + "\\DefaultData\\Shortcuts\\C_Users.lnk", Globals.Folders["datapath"] + "\\Shortcuts\\C_Users.lnk");
            }

            //Check if running in PortableApps
            /*if (Directory.Exists(Globals.scriptpathParentParentFolder + "\\PortableApps"))
            {
                Console.WriteLine("Running in PortableApps Environment");
                Environment.SetEnvironmentVariable("PORTABLEAPPS", "true");
            }
            else
            {
                Environment.SetEnvironmentVariable("PORTABLEAPPS", "false");
            }

            string pathvar = Environment.GetEnvironmentVariable("PATH");
            if (Globals.Config["Main"]["WindowsPathToCygwin"].BoolValue)
            {
                Environment.SetEnvironmentVariable("PATH", pathvar + ";" + Globals.Config["Main"]["WindowsAdditionalPath"] + ";" + Globals.scriptpath + "\\Runtime\\cygwin\\bin");
            }
            else
            {
                Environment.SetEnvironmentVariable("PATH", pathvar + ";" + Globals.scriptpath + "\\Runtime\\cygwin\\bin");
            }
            Environment.SetEnvironmentVariable("ALLUSERSPROFILE", "C:\\ProgramData");
            Environment.SetEnvironmentVariable("ProgramData", "C:\\ProgramData");
            //Environment.SetEnvironmentVariable("CYGWIN", "C:\\ProgramData");
            Environment.SetEnvironmentVariable("CYGWIN_HOME", Globals.scriptpath + "\\Runtime\\cygwin");
            Environment.SetEnvironmentVariable("USER", Globals.Config["Static"]["Username"].StringValue, EnvironmentVariableTarget.User);
            Environment.SetEnvironmentVariable("USERNAME", Globals.Config["Static"]["Username"].StringValue, EnvironmentVariableTarget.User);
            Environment.SetEnvironmentVariable("HOME", "/home/" + Globals.Config["Static"]["Username"].StringValue, EnvironmentVariableTarget.User);
            Environment.SetEnvironmentVariable("USBDRV", Path.GetPathRoot(Globals.scriptpath));
            Environment.SetEnvironmentVariable("USBDRVPATH", Path.GetPathRoot(Globals.scriptpath));
            if (Globals.Config["Main"]["WindowsPythonPath"].StringValue != "")
            {
                Environment.SetEnvironmentVariable("PYTHONPATH", Globals.Config["Main"]["WindowsPythonPath"].StringValue);
            }*/


            Form_Download.Copy(Globals.scriptpath + "\\DefaultData\\cygwin\\home", Globals.scriptpath + "\\Runtime\\Cygwin\\home\\" + Globals.Config["Static"]["Username"].StringValue);
            Form_Download.Copy(Globals.scriptpath + "\\DefaultData\\cygwin\\bin", Globals.scriptpath + "\\Runtime\\Cygwin\\bin");

            Application.Run(new Form_TrayMenu());
        }
    }


    //Define Global Variables 
    public class Globals
    {
        public static Configuration Config = new Configuration();
        public static IDictionary<string, object> RuntimeSettings = new Dictionary<string, object>();
        public static Dictionary<string, object> Folders = new Dictionary<string, object>();
        public static string scriptexe = Assembly.GetExecutingAssembly().Location;
        public static string scriptpath = System.IO.Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
        public static string scriptpathDirName = new DirectoryInfo(scriptpath).Name;
        public static string scriptpathParentFolder = Directory.GetParent(scriptpath).FullName;
        public static string scriptpathParentFolderDirName = new DirectoryInfo(scriptpathParentFolder).Name;
        public static string scriptpathParentParentFolder = Directory.GetParent(scriptpathParentFolder).FullName;
        public static string scriptpathParentParentFolderDirName = new DirectoryInfo(scriptpathParentParentFolder).Name;
        public static string scriptpathParentParentParentFolder = Directory.GetParent(scriptpathParentParentFolder).FullName;
        public static string scriptpathParentParentParentFolderDirName = new DirectoryInfo(scriptpathParentParentFolder).Name;
    }
}
