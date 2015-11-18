using System;
using System.Collections.Generic;
using System.Diagnostics;
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

            //Set Path
            //ExeFile -> C:\PortableApps\CygwinPortable\App\CygwinPortable.exe
            Globals.ExeFile = Assembly.GetExecutingAssembly().Location;
            //AppPath -> C:\PortableApps\CygwinPortable\App
            Globals.AppPath = Path.GetDirectoryName(Globals.ExeFile);
            //BasePath -> C:\PortableApps\CygwinPortable
            Globals.BasePath = Directory.GetParent(Path.GetDirectoryName(Globals.ExeFile)).FullName;
            //RootPath -> C:\
            Globals.RootPath = Path.GetPathRoot(Globals.ExeFile);
            //DataPath -> C:\PortableApps\CygwinPortable\Data
            Globals.DataPath = Globals.BasePath + "\\Data";
            //ConfigPath -> C:\PortableApps\CygwinPortable\Data
            Globals.ConfigPath = Globals.BasePath + "\\Data";
            //ParentBasePath -> Get Parent Folder of CygwinPortable -> C:\
            DirectoryInfo parentBasePath = new DirectoryInfo(Globals.BasePath);
            Globals.ParentBasePath = parentBasePath.Parent.FullName;
            //ParentParentBasePath -> Check if PortableApps is installed in Subfolder e.g. C:\Programs\PortableApps
            if (Globals.ParentBasePath != Globals.RootPath)
            {
                DirectoryInfo parentParentBasePath = new DirectoryInfo(Globals.ParentBasePath);
                Globals.ParentParentBasePath = parentParentBasePath.Parent.FullName;
            }

            /*
            Console.WriteLine(Globals.ExeFile);
            Console.WriteLine(Globals.AppPath);
            Console.WriteLine(Globals.BasePath);
            Console.WriteLine(Globals.RootPath);
            Console.WriteLine(Globals.DataPath);
            Console.WriteLine(Globals.ConfigPath);
            Console.WriteLine(Globals.PortableAppsPath);
            Console.WriteLine(Globals.ParentBasePath);
            Console.WriteLine(Globals.ParentParentBasePath);
            */

            WindowsPrincipal pricipal = new WindowsPrincipal(WindowsIdentity.GetCurrent());
            Globals.RuntimeSettings["isAdmin"] = pricipal.IsInRole(WindowsBuiltInRole.Administrator);
            Globals.RuntimeSettings["defaultFileIconType"] = 16384;
            Globals.RuntimeSettings["x86x64Download"] = "x86";
            Globals.RuntimeSettings["CygwinFirstInstallAdditions"] = "vim,X11,xinit,wget,tar,gawk,bzip2";

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
            if (!File.Exists(Globals.ConfigPath + "\\Configuration.ini"))
            {
                Globals.Config = new Configuration();
                iniFileExists = false;
            }
            else
            {
                Globals.Config = Configuration.LoadFromFile(Globals.ConfigPath + "\\Configuration.ini");
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
                        Directory.Delete(Globals.AppPath + "\\Runtime\\Cygwin\\" + folder, true);
                    }
                }
                else if (dialogResult == DialogResult.No)
                {
                }
            }

            //Create Folders if not exist
            if (!Directory.Exists(Globals.BasePath + "\\Data"))
            {
                Directory.CreateDirectory(Globals.BasePath + "\\Data");
            }

            //Config.SaveConfig();
            if (!iniFileExists)
            {
                Globals.Config.SaveToFile(Globals.ConfigPath + "\\Configuration.ini");
                iniFileExists = true;
            }

            //Check if Cygwin exists
            if (!File.Exists(Globals.AppPath + "\\Runtime\\Cygwin\\CygwinConfig.exe"))
            {
                if (!Directory.Exists(Globals.AppPath + "\\Runtime\\Cygwin"))
                {
                    Directory.CreateDirectory(Globals.AppPath + "\\Runtime\\Cygwin");
                }
                var firstInstallForm = new Form_FirstInstall();
                firstInstallForm.ShowDialog();

                var downloadForm = new Form_Download();
                downloadForm.ShowDialog();

                File.Move(Globals.ConfigPath + "\\setup-x86.exe", Globals.AppPath + "\\Runtime\\Cygwin\\CygwinConfig.exe");

                String cygInstallerArgs = "-R " + Globals.AppPath + "\\Runtime\\Cygwin\\" + " -l " + Globals.AppPath +
                               "\\Runtime\\Cygwin\\packages -n -d -N -s " +
                               Globals.Config["Main"]["CygwinMirror"].StringValue + " -q -P " +
                               Globals.RuntimeSettings["CygwinFirstInstallAdditions"];
                Process cygInstaller = new Process();
                cygInstaller.StartInfo.UseShellExecute = false;
                cygInstaller.StartInfo.Arguments = cygInstallerArgs;
                cygInstaller.StartInfo.FileName = Globals.AppPath + "\\Runtime\\Cygwin\\CygwinConfig.exe";
                cygInstaller.Start();
                cygInstaller.WaitForExit();

                if (Globals.Config["Main"]["CygwinFirstInstallDeleteUnneeded"].BoolValue)
                {
                    File.Delete(Globals.AppPath + "\\Runtime\\Cygwin\\Cygwin.ico");
                    File.Delete(Globals.AppPath + "\\Runtime\\Cygwin\\Cygwin.bat");
                    File.Delete(Globals.AppPath + "\\Runtime\\Cygwin\\setup.log");
                    File.Delete(Globals.AppPath + "\\Runtime\\Cygwin\\setup.log.full'");
                }

                Form_Download.Copy(Globals.AppPath + "\\DefaultData\\cygwin\\home", Globals.AppPath + "\\Runtime\\Cygwin\\home\\" + Globals.Config["Static"]["Username"].StringValue);
                Form_Download.Copy(Globals.AppPath + "\\DefaultData\\cygwin\\bin", Globals.AppPath + "\\Runtime\\Cygwin\\bin");
            }

            //Check if ConEmu is installed
            if (!Directory.Exists(Globals.AppPath + "\\Runtime\\ConEmu") && Globals.Config["Main"]["Shell"].StringValue == "ConEmu")
            {
                Globals.Config["Main"]["Shell"].StringValue = "mintty";
            }

            if (Globals.Config["Static"]["Username"].StringValue == "")
            {
                Globals.Config["Static"]["Username"].StringValue = "cygwin";
            }



            if (!Directory.Exists(Globals.BasePath + "\\Data\\ShellScript"))
            {
                Directory.CreateDirectory(Globals.BasePath + "\\Data\\ShellScript");
                File.Copy(Globals.AppPath + "\\DefaultData\\ShellScript\\Testscript.sh", Globals.DataPath + "\\ShellScript\\Testscript.sh");
            }
            if (!Directory.Exists(Globals.BasePath + "\\Data\\Shortcuts"))
            {
                Directory.CreateDirectory(Globals.BasePath + "\\Data\\Shortcuts");
                File.Copy(Globals.AppPath + "\\DefaultData\\Shortcuts\\C_Users.lnk", Globals.DataPath + "\\Shortcuts\\C_Users.lnk");
            }

            Application.Run(new Form_TrayMenu());
        }
    }


    //Define Global Variables 
    public class Globals
    {
        public static Configuration Config = new Configuration();
        public static IDictionary<string, object> RuntimeSettings = new Dictionary<string, object>();

        public static string ExeFile = "";
        public static string AppPath = "";
        public static string BasePath = "";
        public static string RootPath = "";
        public static string DataPath = "";
        public static string ConfigPath = "";
        public static string PortableAppsPath = "";
        public static string ParentBasePath = "";
        public static string ParentParentBasePath = "";
        
    }
}
