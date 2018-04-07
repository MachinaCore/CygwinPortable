using System;
using System.ComponentModel;
using System.Diagnostics;
using System.Reflection;
using System.Security.Principal;
using System.Windows.Forms;
using Microsoft.Win32;

namespace CygwinPortableCS
{
    class ChangeRegistryPath
    {

        public static void Change()
        {
            //Check if change is needed
            if (!ValidRegistry())
            {
                if (!Convert.ToBoolean(Globals.RuntimeSettings["isAdmin"]))
                {
                    DialogResult result = MessageBox.Show("You have setup CygwinPortable to set Explorer Context menu\r\n\r\nYour path has changed or the Registry Keys are not set\r\n\r\nClick OK to set registry keys with administrator access or disable 'Set Config Menu' in options", "Registry Change required", MessageBoxButtons.OKCancel, MessageBoxIcon.Information);
                    if (result == DialogResult.OK)
                    {
                        // relaunch the application with admin rights
                        string fileName = Assembly.GetExecutingAssembly().Location;
                        ProcessStartInfo processInfo = new ProcessStartInfo();
                        processInfo.UseShellExecute = true;
                        processInfo.WorkingDirectory = Environment.CurrentDirectory;
                        processInfo.Arguments = "-uactask";
                        processInfo.Verb = "runas";
                        processInfo.FileName = fileName;
                        try
                        {
                            Process.Start(processInfo);
                        }
                        catch (Win32Exception)
                        {
                            // This will be thrown if the user cancels the prompt
                        }
                    }
                    else if (result == DialogResult.Cancel)
                    {
                        //do something else
                    }
                    //return;
                }
                else
                {
                    if ((bool)Globals.MainConfig["Cygwin"]["SetContextMenu"])
                    {
                        SetRegistryCygwin();
                        if ((bool)Globals.MainConfig["Cygwin"]["SupportWSL"])
                        {
                            SetRegistryWSL();
                        }
                    }
                    else
                    {
                        UnSetRegistryCygwin();
                        UnSetRegistryWSL();
                    }
                }
            }
        }

        //Seperate Method for Form -> Dont accept Bool False if registry key still exists
        public static bool RegistryKeyExists()
        {
            RegistryKey key = Registry.ClassesRoot.OpenSubKey("*\\shell\\Run in Cygwin");

            //Key exists but path is wrong
            if (key != null && (bool)Globals.MainConfig["Cygwin"]["SetContextMenu"])
            {
                return true;
            }
            return false;
        }

        public static bool ValidRegistry()
        {
            RegistryKey key = Registry.ClassesRoot.OpenSubKey("*\\shell\\Run in Cygwin");

            //Key exists but path is wrong
            if (key != null && (bool)Globals.MainConfig["Cygwin"]["SetContextMenu"])
            {

                if (key.GetValue("Icon").ToString() != Globals.AppPath + "\\AppInfo\\appicon.ico")
                {
                    return false;
                }
            }

            //Key dont exists and SetContextMenu is enabled
            if (key == null && (bool)Globals.MainConfig["Cygwin"]["SetContextMenu"])
            {
                    return false;
            }

            //Key exists but SetContextMenu is disabled
            if (key != null && !(bool)Globals.MainConfig["Cygwin"]["SetContextMenu"])
            {
                return false;
            }
            return true;
        }

        public static void SetRegistryCygwin()
        {
            //Icon Files
            RegistryKey iconFileKey = Registry.ClassesRoot.CreateSubKey("*\\shell\\Run in Cygwin");
            iconFileKey.SetValue("Icon", Globals.AppPath + "\\AppInfo\\appicon.ico", RegistryValueKind.ExpandString);
            iconFileKey.Close();

            RegistryKey commandFileKey = Registry.ClassesRoot.CreateSubKey("*\\shell\\Run in Cygwin\\command");
            commandFileKey.SetValue("", "\"" + Globals.ExeFile + "\" -cygwin -path \"%1\"");
            commandFileKey.Close();

            //Icon Directory
            RegistryKey iconDirectoryKey = Registry.ClassesRoot.CreateSubKey("Directory\\shell\\OpenDirectoryInCygwin");
            iconDirectoryKey.SetValue("Icon", Globals.AppPath + "\\AppInfo\\appicon.ico", RegistryValueKind.ExpandString);
            iconDirectoryKey.Close();

            RegistryKey commandDirectoryKey = Registry.ClassesRoot.CreateSubKey("Directory\\shell\\OpenDirectoryInCygwin\\command");
            commandDirectoryKey.SetValue("", "\"" + Globals.ExeFile + "\" -cygwin -path \"%L\"");
            commandDirectoryKey.Close();

            //Icon Blank Directory
            RegistryKey iconBlankDirectoryKey = Registry.ClassesRoot.CreateSubKey("Directory\\Background\\shell\\OpenDirectoryInCygwin");
            iconBlankDirectoryKey.SetValue("Icon", Globals.AppPath + "\\AppInfo\\appicon.ico", RegistryValueKind.ExpandString);
            iconBlankDirectoryKey.Close();

            RegistryKey commandBlankDirectoryKey = Registry.ClassesRoot.CreateSubKey("Directory\\Background\\shell\\OpenDirectoryInCygwin\\command");
            commandBlankDirectoryKey.SetValue("", "\"" + Globals.ExeFile + "\" -cygwin -path \"%V\"");
            commandBlankDirectoryKey.Close();

            //Icon Drive
            RegistryKey iconDriveKey = Registry.ClassesRoot.CreateSubKey("Drive\\shell\\OpenDriveInCygwin");
            iconDriveKey.SetValue("Icon", Globals.AppPath + "\\AppInfo\\appicon.ico", RegistryValueKind.ExpandString);
            iconDriveKey.Close();

            RegistryKey commandDriveKey = Registry.ClassesRoot.CreateSubKey("Drive\\shell\\OpenDriveInCygwin\\command");
            commandDriveKey.SetValue("", "\"" + Globals.ExeFile + "\" -cygwin -path \"%1\"");
            commandDriveKey.Close();

        }

        public static void SetRegistryWSL()
        {
            //Icon Files
            RegistryKey iconFileKey = Registry.ClassesRoot.CreateSubKey("*\\shell\\Run in Bash");
            iconFileKey.SetValue("Icon", Globals.AppPath + "\\AppInfo\\ubuntu.ico", RegistryValueKind.ExpandString);
            iconFileKey.Close();

            RegistryKey commandFileKey = Registry.ClassesRoot.CreateSubKey("*\\shell\\Run in Bash\\command");
            commandFileKey.SetValue("", "\"" + Globals.ExeFile + "\" -wsl -path \"%1\"");
            commandFileKey.Close();

            //Icon Directory
            RegistryKey iconDirectoryKey = Registry.ClassesRoot.CreateSubKey("Directory\\shell\\OpenDirectoryInBash");
            iconDirectoryKey.SetValue("Icon", Globals.AppPath + "\\AppInfo\\ubuntu.ico", RegistryValueKind.ExpandString);
            iconDirectoryKey.Close();

            RegistryKey commandDirectoryKey = Registry.ClassesRoot.CreateSubKey("Directory\\shell\\OpenDirectoryInBash\\command");
            commandDirectoryKey.SetValue("", "\"" + Globals.ExeFile + "\" -wsl -path \"%L\"");
            commandDirectoryKey.Close();

            //Icon Blank Directory
            RegistryKey iconBlankDirectoryKey = Registry.ClassesRoot.CreateSubKey("Directory\\Background\\shell\\OpenDirectoryInBash");
            iconBlankDirectoryKey.SetValue("Icon", Globals.AppPath + "\\AppInfo\\ubuntu.ico", RegistryValueKind.ExpandString);
            iconBlankDirectoryKey.Close();

            RegistryKey commandBlankDirectoryKey = Registry.ClassesRoot.CreateSubKey("Directory\\Background\\shell\\OpenDirectoryInBash\\command");
            commandBlankDirectoryKey.SetValue("", "\"" + Globals.ExeFile + "\" -wsl -path \"%V\"");
            commandBlankDirectoryKey.Close();

            //Icon Drive
            RegistryKey iconDriveKey = Registry.ClassesRoot.CreateSubKey("Drive\\shell\\OpenDriveInBash");
            iconDriveKey.SetValue("Icon", Globals.AppPath + "\\AppInfo\\ubuntu.ico", RegistryValueKind.ExpandString);
            iconDriveKey.Close();

            RegistryKey commandDriveKey = Registry.ClassesRoot.CreateSubKey("Drive\\shell\\OpenDriveInBash\\command");
            commandDriveKey.SetValue("", "\"" + Globals.ExeFile + "\" -wsl -path \"%1\"");
            commandDriveKey.Close();

        }


        public static void UnSetRegistryCygwin()
        {
            Registry.ClassesRoot.DeleteSubKey("*\\shell\\Run in Cygwin\\command");
            Registry.ClassesRoot.DeleteSubKey("*\\shell\\Run in Cygwin");

            Registry.ClassesRoot.DeleteSubKey("Directory\\shell\\OpenDirectoryInCygwin\\command");
            Registry.ClassesRoot.DeleteSubKey("Directory\\shell\\OpenDirectoryInCygwin");

            Registry.ClassesRoot.DeleteSubKey("Directory\\Background\\shell\\OpenDirectoryInCygwin\\command");
            Registry.ClassesRoot.DeleteSubKey("Directory\\Background\\shell\\OpenDirectoryInCygwin");

            Registry.ClassesRoot.DeleteSubKey("Drive\\shell\\OpenDriveInCygwin\\command");
            Registry.ClassesRoot.DeleteSubKey("Drive\\shell\\OpenDriveInCygwin");
        }

        public static void UnSetRegistryWSL()
        {
            Registry.ClassesRoot.DeleteSubKey("*\\shell\\Run in Bash\\command");
            Registry.ClassesRoot.DeleteSubKey("*\\shell\\Run in Bash");

            Registry.ClassesRoot.DeleteSubKey("Directory\\shell\\OpenDirectoryInBash\\command");
            Registry.ClassesRoot.DeleteSubKey("Directory\\shell\\OpenDirectoryInBash");

            Registry.ClassesRoot.DeleteSubKey("Directory\\Background\\shell\\OpenDirectoryInBash\\command");
            Registry.ClassesRoot.DeleteSubKey("Directory\\Background\\shell\\OpenDirectoryInBash");

            Registry.ClassesRoot.DeleteSubKey("Drive\\shell\\OpenDriveInBash\\command");
            Registry.ClassesRoot.DeleteSubKey("Drive\\shell\\OpenDriveInBash");
        }

    }
}
