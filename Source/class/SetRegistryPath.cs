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
                    if (Globals.Config["Main"]["SetContextMenu"].BoolValue)
                    {
                        SetRegistry();
                    }
                    else
                    {
                        UnSetRegistry();
                    }
                }
            }
        }

        //Seperate Method for Form -> Dont accept Bool False if registry key still exists
        public static bool RegistryKeyExists()
        {
            RegistryKey key = Registry.ClassesRoot.OpenSubKey("*\\shell\\Run in Cygwin");

            //Key exists but path is wrong
            if (key != null && Globals.Config["Main"]["SetContextMenu"].BoolValue)
            {
                return true;
            }
            return false;
        }

        public static bool ValidRegistry()
        {
            RegistryKey key = Registry.ClassesRoot.OpenSubKey("*\\shell\\Run in Cygwin");

            //Key exists but path is wrong
            if (key != null && Globals.Config["Main"]["SetContextMenu"].BoolValue)
            {

                if (key.GetValue("Icon").ToString() != Globals.AppPath + "\\AppInfo\\appicon.ico")
                {
                    return false;
                }
            }

            //Key dont exists and SetContextMenu is enabled
            if (key == null && Globals.Config["Main"]["SetContextMenu"].BoolValue)
            {
                    return false;
            }

            //Key exists but SetContextMenu is disabled
            if (key != null && !Globals.Config["Main"]["SetContextMenu"].BoolValue)
            {
                return false;
            }
            return true;
        }

        public static void SetRegistry()
        {
            //Icon Files
            RegistryKey iconFileKey = Registry.ClassesRoot.CreateSubKey("*\\shell\\Run in Cygwin");
            iconFileKey.SetValue("Icon", Globals.AppPath + "\\AppInfo\\appicon.ico", RegistryValueKind.ExpandString);
            iconFileKey.Close();

            RegistryKey commandFileKey = Registry.ClassesRoot.CreateSubKey("*\\shell\\Run in Cygwin\\command");
            commandFileKey.SetValue("", "\"" + Globals.ExeFile + "\" -path \"%1\"");
            commandFileKey.Close();

            //Icon Directory
            RegistryKey iconDirectoryKey = Registry.ClassesRoot.CreateSubKey("Directory\\shell\\OpenDirectoryInCygwin");
            iconDirectoryKey.SetValue("Icon", Globals.AppPath + "\\AppInfo\\appicon.ico", RegistryValueKind.ExpandString);
            iconDirectoryKey.Close();

            RegistryKey commandDirectoryKey = Registry.ClassesRoot.CreateSubKey("Directory\\shell\\OpenDirectoryInCygwin\\command");
            commandDirectoryKey.SetValue("", "\"" + Globals.ExeFile + "\" -path \"%L\"");
            commandDirectoryKey.Close();

            //Icon Drive
            RegistryKey iconDriveKey = Registry.ClassesRoot.CreateSubKey("Drive\\shell\\OpenDriveInCygwin");
            iconDriveKey.SetValue("Icon", Globals.AppPath + "\\AppInfo\\appicon.ico", RegistryValueKind.ExpandString);
            iconDriveKey.Close();

            RegistryKey commandDriveKey = Registry.ClassesRoot.CreateSubKey("Drive\\shell\\OpenDriveInCygwin\\command");
            commandDriveKey.SetValue("", "\"" + Globals.ExeFile + "\" -path \"%1\"");
            commandDriveKey.Close();

        }

        public static void UnSetRegistry()
        {
            Registry.ClassesRoot.DeleteSubKey("*\\shell\\Run in Cygwin\\command");
            Registry.ClassesRoot.DeleteSubKey("*\\shell\\Run in Cygwin");

            Registry.ClassesRoot.DeleteSubKey("Directory\\shell\\OpenDirectoryInCygwin\\command");
            Registry.ClassesRoot.DeleteSubKey("Directory\\shell\\OpenDirectoryInCygwin");

            Registry.ClassesRoot.DeleteSubKey("Drive\\shell\\OpenDriveInCygwin\\command");
            Registry.ClassesRoot.DeleteSubKey("Drive\\shell\\OpenDriveInCygwin");
        }

    }
}
