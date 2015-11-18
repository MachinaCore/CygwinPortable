using System;
using System.ComponentModel;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Security.Principal;
using System.Windows.Forms;
using CygwinPortableCS.Properties;

namespace CygwinPortableCS
{
    public partial class Form_TrayMenu : Form
    {

        public Form_TrayMenu()
        {
            
            //Check Arguments First -> Dont load GUI
            string[] args = Environment.GetCommandLineArgs();

            try
            {
                if (args[1] != null)
                {
                    Console.WriteLine("CommandLine Parameter 1: " + args[1]);
                    if (!args[1].StartsWith("-"))
                    {
                        Cygwin.CygwinOpen(args[1]);
                        Environment.Exit(-1);
                    }
                    else if (args[1].StartsWith("-uactask"))
                    {
                        ChangeRegistryPath.Change();
                        Environment.Exit(-1);
                    }
                    else
                    {
                        string path = "";
                        string exitAfterExecute = "0";
                        int idx = 0;
                        foreach (string arg in args)
                        {
                            if (args[idx] == "-path")
                            {
                                path = args[idx + 1];
                            }

                            if (args[idx] == "-exit")
                            {
                                if (args[idx + 1] != null)
                                {
                                    exitAfterExecute = args[idx + 1];
                                    Console.WriteLine("exitAfterExecute set to: " + exitAfterExecute);
                                }
                            }
                            idx = idx + 1;
                        }
                        
                        if (exitAfterExecute == "1")
                        {
                            Globals.Config["Main"]["ExitAfterExec"].StringValue = "true";
                        }
                        

                        //MessageBox.Show("Test" + path, "Test", MessageBoxButtons.YesNo);
                        Cygwin.CygwinOpen(path);
                        Environment.Exit(-1);
                    }

                }
            }
            catch (IndexOutOfRangeException)
            {
                Console.WriteLine("Possible Commandline options: " + args[0] + " [-path <PATH>] [-exit <0/1>]");
                Console.WriteLine("-path 'C:\\Windows' open Windows folder");
                Console.WriteLine("-exit 0 let the cygwin window open, -exit 1 close the cygwin window after execution");
                Console.WriteLine("");
                Console.WriteLine("Sample to open C:\\Windows Folder:");
                Console.WriteLine("   " + args[0] + " -path 'C:\\Windows'");
                Console.WriteLine("Sample to open Shellscript and dont close window after execution:");
                Console.WriteLine("   " + args[0] + " -path 'C:\\shellscript.sh' -exit 0");
                Console.WriteLine("Sample to open C:\\Windows Folder WITHOUT arguemnts:");
                Console.WriteLine("   " + args[0] + " 'C:\\Windows'");
            }

            ChangeRegistryPath.Change();
            //Check Arguments Ended -> If CygwinPortable still lives -> go on
            InitializeComponent();

            WindowState = FormWindowState.Minimized;
            if ((WindowState == FormWindowState.Minimized))
            {
                contextMenuStrip1.Show();
                Hide();
                ShowInTaskbar = false;
            }
        }

        private void CybeSystemsRunCygwin_Click(object sender, EventArgs e, string fileName)
        {
            Cygwin.CygwinOpen(fileName);
        }

        private void CybeSystemsShowConfig_Click(object sender, EventArgs e)
        {
            var configForm = new Form_ConfigForm();
            configForm.Show();
        }


        [DllImport("shell32.dll", EntryPoint = "ShellExecute")]
        public static extern long ShellExecute(int hwnd, string cmd, string file, string param1, string param2, int swmode);

        private void CybeSystemsRunXServer_Click(object sender, EventArgs e)
        {
            string path = Globals.AppPath + "\\Runtime\\Cygwin\\bin\\run.exe";
            string parameter = "/bin/bash.exe -c '/bin/startxwin -- -nolock -unixkill";
            string pathname = Globals.AppPath;
            int flag = 1;
            ShellExecute(0, "open", path, parameter, pathname, flag);
        }


        private void CybeSystemsRunCygwinSetup(object sender, EventArgs e)
        {
            string path = Globals.AppPath + "\\Runtime\\Cygwin\\CygwinConfig.exe";
            string parameter = "-R " + Globals.AppPath + "\\Runtime\\cygwin\\ -l " + Globals.AppPath + "\\Runtime\\cygwin\\packages -n -d -N -s " + Globals.Config["Main"]["CygwinMirror"].StringValue;
            string pathname = Globals.AppPath;
            int flag = 1;
            ShellExecute(0, "open", path, parameter, pathname, flag);
        }

        private void CybeSystemsRunCygwinSetupWithPorts(object sender, EventArgs e)
        {
            string path = Globals.AppPath + "\\Runtime\\Cygwin\\CygwinConfig.exe";
            string parameter = " -K http://cygwinports.org/ports.gpg -R " + Globals.AppPath + "\\Runtime\\cygwin\\ -l " + Globals.AppPath + "\\Runtime\\cygwin\\packages -n -d -N -s " + Globals.Config["Main"]["CygwinPortsMirror"].StringValue;
            string pathname = Globals.AppPath;
            int flag = 1;
            ShellExecute(0, "open", path, parameter, pathname, flag);
        }

        private void ContextMenuStrip1Opening()
        {
            contextMenuStrip1.Items.Clear();

            var scriptsMenu = new ToolStripMenuItem("Scripts");
            contextMenuStrip1.Items.Add(scriptsMenu);
            scriptsMenu.Image = Resources.appicon_16; ;
            string[] scriptsEntries = Directory.GetFiles(Globals.BasePath + "\\Data\\ShellScript");
            foreach (string fileName in scriptsEntries) {
                Icon fileIcon = IconFromFile.GetFileIcon(fileName, IconFromFile.IconSizeEnum.SmallIcon16);
                scriptsMenu.DropDownItems.Add(Path.GetFileName(fileName), fileIcon.ToBitmap(), (sender, e) => { CybeSystemsRunCygwin_Click(sender, e, fileName); });
            }


            var shortcutsMenu = new ToolStripMenuItem("Shortcuts");
            contextMenuStrip1.Items.Add(shortcutsMenu);
            shortcutsMenu.Image = Resources.shortcuts;
            string[] shortcutsEntries = Directory.GetFiles(Globals.BasePath + "\\Data\\Shortcuts");
            foreach (string fileName in shortcutsEntries)
            {
                Icon fileIcon = IconFromFile.GetFileIcon(fileName, IconFromFile.IconSizeEnum.SmallIcon16);
                shortcutsMenu.DropDownItems.Add(Path.GetFileName(fileName), fileIcon.ToBitmap(), (sender, e) => { CybeSystemsRunCygwin_Click(sender, e, fileName); });
            }

            var drivesMenu = new ToolStripMenuItem("Drives");
            contextMenuStrip1.Items.Add(drivesMenu);
            drivesMenu.Image = Resources.drive;
            DriveInfo[] allDrives = DriveInfo.GetDrives();
            foreach (DriveInfo drive in allDrives)
            {
                Icon fileIcon = IconFromFile.GetFileIcon(drive.Name, IconFromFile.IconSizeEnum.SmallIcon16);
                drivesMenu.DropDownItems.Add(drive.Name, fileIcon.ToBitmap(), (sender, e) => { CybeSystemsRunCygwin_Click(sender, e, drive.Name); });
            }

            contextMenuStrip1.Items.Add(new ToolStripSeparator());

            Icon fileIconC = IconFromFile.GetFileIcon(@"C:\", IconFromFile.IconSizeEnum.SmallIcon16);
            contextMenuStrip1.Items.Add("Open Bash (C:)", fileIconC.ToBitmap(), (sender, e) => { CybeSystemsRunCygwin_Click(sender, e, "C:\\"); });

            Icon fileIconU = IconFromFile.GetFileIcon(@"C:\", IconFromFile.IconSizeEnum.SmallIcon16);
            contextMenuStrip1.Items.Add("Open Homefolder", fileIconC.ToBitmap(), (sender, e) => { CybeSystemsRunCygwin_Click(sender, e, "~"); });

            if (File.Exists(Globals.AppPath + "\\Runtime\\Cygwin\\bin\\startxwin"))
            {
                contextMenuStrip1.Items.Add("Open XServer", Resources.xserver, CybeSystemsRunXServer_Click);
            }

            contextMenuStrip1.Items.Add("Open Cygwin Setup", Resources.wand, CybeSystemsRunCygwinSetup);

            contextMenuStrip1.Items.Add("Open Cygwin Setup (Cygwin ports)", Resources.wand, CybeSystemsRunCygwinSetupWithPorts);

            contextMenuStrip1.Items.Add("QuickConfig", Resources.cog, CybeSystemsShowConfig_Click);

            contextMenuStrip1.Items.Add(new ToolStripSeparator());

            contextMenuStrip1.Items.Add("Beenden", Resources.cancel, CybeSystemsMenuExit);
        }

        private void CybeSystemsMenuExit(object sender, EventArgs e)
        {
            notifyIcon1.Visible = false;
            Application.Exit();
            Environment.Exit(-1);
        }

        [DllImport("User32.dll", ExactSpelling = true, CharSet = CharSet.Auto)]
        public static extern bool SetForegroundWindow(HandleRef hWnd);
        private void notifyIcon1_Click(object sender, EventArgs e)
        {
            //if (e.Button == MouseButtons.Left)
            //{

                ContextMenuStrip1Opening();
                SetForegroundWindow(new HandleRef(this, this.Handle));
                int x = Control.MousePosition.X;
                int y = Control.MousePosition.Y;
                x = x - 10;
                y = y - 40;
                this.contextMenuStrip1.Show(x, y);
            //}
        }


    }
}
