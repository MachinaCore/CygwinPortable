using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Reflection;
using System.Security.Principal;
using System.Windows.Forms;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json;

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

            bool configFileExists = true;
            if (!File.Exists(Globals.ConfigPath + "\\Configuration.json"))
            {
                configFileExists = false;
            }

            Globals.MainConfig["Cygwin"] = new JObject();
            Globals.MainConfig["Cygwin"]["Username"] = "cygwin";
            Globals.MainConfig["Cygwin"]["ExitAfterExec"] = false;
            Globals.MainConfig["Cygwin"]["SetContextMenu"] = true;
            Globals.MainConfig["Cygwin"]["TrayMenu"] = true;
            Globals.MainConfig["Cygwin"]["Shell"] = "ConEmu";
            Globals.MainConfig["Cygwin"]["ExecutableExtension"] = "exe,bat,sh,pl,bat,py";
            Globals.MainConfig["Cygwin"]["NoMsgBox"] = false;
            Globals.MainConfig["Cygwin"]["CygwinMirror"] = "http://mirrors.kernel.org/sourceware/cygwin/";
            Globals.MainConfig["Cygwin"]["CygwinPortsMirror"] = "ftp://ftp.cygwinports.org/pub/cygwinports";
            Globals.MainConfig["Cygwin"]["CygwinFirstInstallDeleteUnneeded"] = true;
            Globals.MainConfig["Cygwin"]["InstallUnofficial"] = true;
            Globals.MainConfig["Cygwin"]["WindowsPathToCygwin"] = true;
            Globals.MainConfig["Cygwin"]["WindowsAdditionalPath"] = "/cygdrive/c/python27;/cygdrive/c/windows;/cygdrive/c/windows/system32;/cygdrive/c/windows/SysWOW64";
            Globals.MainConfig["Cygwin"]["WindowsPythonPath"] = "/cygdrive/c/python27";
            Globals.MainConfig["Cygwin"]["CygwinX86URL"] = "https://www.cygwin.com/setup-x86.exe";
            Globals.MainConfig["Cygwin"]["CygwinX64URL"] = "https://www.cygwin.com/setup-x86_64.exe";

            Globals.MainConfig["Cygwin"]["CygwinDeleteInstallation"] = false;
            Globals.MainConfig["Cygwin"]["CygwinDeleteInstallationFolders"] = "xbin,cygdrive,dev,etc,home,lib,packages,tmp,usr,var";

            //Check if Delete Installation Flag is set
            if ((bool)Globals.MainConfig["Cygwin"]["CygwinDeleteInstallation"])
            {
                DialogResult dialogResult = MessageBox.Show("Do you REALLY want to delete and reinstall your Cygwin installation ?", "Delete/Reinstall Cygwin", MessageBoxButtons.YesNo);
                if (dialogResult == DialogResult.Yes)
                {
                    foreach (string folder in ((string)Globals.MainConfig["Cygwin"]["CygwinDeleteInstallationFolders"]).Split(','))
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
            if (!configFileExists)
            {
                System.IO.File.WriteAllText(Globals.ConfigPath + "\\Configuration.json", JsonConvert.SerializeObject(Globals.MainConfig["Cygwin"], Formatting.Indented));
                
                configFileExists = true;
            } else
            {
                Helpers.MergeCsDictionaryAndSave((JObject)Globals.MainConfig["Cygwin"], Globals.ConfigPath + "\\Configuration.json");
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

                if (Globals.RuntimeSettings["x86x64Download"].ToString() == "x64")
                {
                    File.Move(Globals.ConfigPath + "\\setup-x86_64.exe", Globals.AppPath + "\\Runtime\\Cygwin\\CygwinConfig.exe");
                }
                else
                {
                    File.Move(Globals.ConfigPath + "\\setup-x86.exe", Globals.AppPath + "\\Runtime\\Cygwin\\CygwinConfig.exe");
                }

                String cygInstallerArgs = "-R " + Globals.AppPath + "\\Runtime\\Cygwin\\" + " -l " + Globals.AppPath +
                               "\\Runtime\\Cygwin\\packages -n -d -N -s " +
                               (string)Globals.MainConfig["Cygwin"]["CygwinMirror"] + " -q -P " +
                               (string)Globals.RuntimeSettings["CygwinFirstInstallAdditions"];
                Process cygInstaller = new Process();
                cygInstaller.StartInfo.UseShellExecute = false;
                cygInstaller.StartInfo.Arguments = cygInstallerArgs;
                cygInstaller.StartInfo.FileName = Globals.AppPath + "\\Runtime\\Cygwin\\CygwinConfig.exe";
                cygInstaller.Start();
                cygInstaller.WaitForExit();

                if ((bool)Globals.MainConfig["Cygwin"]["CygwinFirstInstallDeleteUnneeded"])
                {
                    File.Delete(Globals.AppPath + "\\Runtime\\Cygwin\\Cygwin.ico");
                    File.Delete(Globals.AppPath + "\\Runtime\\Cygwin\\Cygwin.bat");
                    File.Delete(Globals.AppPath + "\\Runtime\\Cygwin\\setup.log");
                    File.Delete(Globals.AppPath + "\\Runtime\\Cygwin\\setup.log.full'");
                }

                Form_Download.Copy(Globals.AppPath + "\\DefaultData\\cygwin\\home", Globals.AppPath + "\\Runtime\\Cygwin\\home\\" + (string)Globals.MainConfig["Cygwin"]["Username"]);
                Form_Download.Copy(Globals.AppPath + "\\DefaultData\\cygwin\\bin", Globals.AppPath + "\\Runtime\\Cygwin\\bin");

                if (Globals.RuntimeSettings["x86x64Download"].ToString() == "x64")
                {
                    Form_Download.Copy(Globals.AppPath + "\\DefaultData\\cygwin_x86_x64\\bin", Globals.AppPath + "\\Runtime\\Cygwin\\bin");
                }
                else
                {
                    Form_Download.Copy(Globals.AppPath + "\\DefaultData\\cygwin_x86\\bin", Globals.AppPath + "\\Runtime\\Cygwin\\bin");
                }
            }

            //Check if ConEmu is installed
            if (!Directory.Exists(Globals.AppPath + "\\Runtime\\ConEmu") && (string)Globals.MainConfig["Cygwin"]["Shell"] == "ConEmu")
            {
                Globals.MainConfig["Cygwin"]["Shell"] = "mintty";
            }

            if ((string)Globals.MainConfig["Cygwin"]["Username"] == "")
            {
                Globals.MainConfig["Cygwin"]["Username"] = "cygwin";
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
        public static JObject MainConfig = new JObject();
        public static JObject RuntimeSettings = new JObject();

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
