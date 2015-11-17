using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Net;
using System.Text;
using System.Windows.Forms;

namespace CygwinPortableCS
{
    public partial class Form_Download : Form
    {

        public static void Copy(string sourceDirectory, string targetDirectory)
        {
            DirectoryInfo diSource = new DirectoryInfo(sourceDirectory);
            DirectoryInfo diTarget = new DirectoryInfo(targetDirectory);

            CopyAll(diSource, diTarget);
        }

        public static void CopyAll(DirectoryInfo source, DirectoryInfo target)
        {
            Directory.CreateDirectory(target.FullName);

            // Copy each file into the new directory.
            foreach (FileInfo fi in source.GetFiles())
            {
                Console.WriteLine(@"Copying {0}\{1}", target.FullName, fi.Name);
                fi.CopyTo(Path.Combine(target.FullName, fi.Name), true);
            }

            // Copy each subdirectory using recursion.
            foreach (DirectoryInfo diSourceSubDir in source.GetDirectories())
            {
                DirectoryInfo nextTargetSubDir =
                    target.CreateSubdirectory(diSourceSubDir.Name);
                CopyAll(diSourceSubDir, nextTargetSubDir);
            }
        }

        private void ProgressChanged(object sender, DownloadProgressChangedEventArgs e)
        {
            progressBar1.Value = e.ProgressPercentage;
            label2.Text = e.ProgressPercentage.ToString() + " %";
        }

        private void Completed(object sender, AsyncCompletedEventArgs e)
        {

            //MessageBox.Show("Download completed!");
            Close();

            File.Move(Globals.Folders["configpath"] + "\\setup-x86.exe", Globals.scriptpath + "\\Runtime\\Cygwin\\CygwinConfig.exe");

            Process sampleProcess = new Process();
            String pArgs = "-R " + Globals.scriptpath + "\\Runtime\\Cygwin\\" + " -l " + Globals.scriptpath +
                           "\\Runtime\\Cygwin\\packages -n -d -N -s " +
                           Globals.Config["Main"]["CygwinMirror"].StringValue + " -q -P " +
                           Globals.Config["Main"]["CygwinFirstInstallAdditions"].StringValue;

            ProcessStartInfo processInfo = new ProcessStartInfo
            {
                UseShellExecute = true,
                WorkingDirectory = Environment.CurrentDirectory,
                Arguments = pArgs,
                FileName = Globals.scriptpath + "\\Runtime\\Cygwin\\CygwinConfig.exe"
            };
            Process cygwinProcess = Process.Start(processInfo);
            cygwinProcess.WaitForExit();

            if (Globals.Config["Main"]["CygwinFirstInstallDeleteUnneeded"].BoolValue)
            {
                File.Delete(Globals.scriptpath + "\\Runtime\\Cygwin\\Cygwin.ico");
                File.Delete(Globals.scriptpath + "\\Runtime\\Cygwin\\Cygwin.bat");
                File.Delete(Globals.scriptpath + "\\Runtime\\Cygwin\\setup.log");
                File.Delete(Globals.scriptpath + "\\Runtime\\Cygwin\\setup.log.full'");
            }

            Copy(Globals.scriptpath + "\\DefaultData\\cygwin\\home", Globals.scriptpath + "\\Runtime\\Cygwin\\home\\" + Globals.Config["Static"]["Username"].StringValue);
            Copy(Globals.scriptpath + "\\DefaultData\\cygwin\\bin", Globals.scriptpath + "\\Runtime\\Cygwin\\bin");
            /*DirectoryInfo homeFolder = new DirectoryInfo(Globals.scriptpath + "\\DefaultData\\cygwin\\home");
            foreach (var fileName in homeFolder.GetFiles("*"))
            {
                Console.WriteLine(fileName);
                File.Copy(Globals.scriptpath + "\\DefaultData\\cygwin\\home\\" + fileName.Name, Globals.scriptpath + "\\Runtime\\Cygwin\\home\\" + Globals.Config["Static"]["Username"].StringValue + "\\" + fileName.Name);
            }

            DirectoryInfo binFolder = new DirectoryInfo(Globals.scriptpath + "\\DefaultData\\cygwin\\bin");
            foreach (var fileName in binFolder.GetFiles("*"))
            {
                Console.WriteLine(fileName);
                File.Copy(Globals.scriptpath + "\\DefaultData\\cygwin\\bin\\" + fileName.Name, Globals.scriptpath + "\\Runtime\\Cygwin\\bin\\" + fileName.Name);
            }*/
        }

        public Form_Download()
        {
            InitializeComponent();
            progressBar1.Visible = false;
            label1.Visible = false;
            label2.Visible = false;
        }

        private void button1_Click(object sender, EventArgs e)
        {
            button1.Visible = false;
            button2.Visible = false;
            progressBar1.Visible = true;
            label1.Visible = true;
            label2.Visible = true;
            WebClient webClient = new WebClient();
            label1.Text = "Downloading " + Globals.Config["Main"]["CygwinX86URL"].StringValue;
            webClient.DownloadFileCompleted += new AsyncCompletedEventHandler(Completed);
            webClient.DownloadProgressChanged += new DownloadProgressChangedEventHandler(ProgressChanged);
            webClient.DownloadFileAsync(new Uri(Globals.Config["Main"]["CygwinX86URL"].StringValue), Globals.Folders["configpath"] + "\\setup-x86.exe");

        }

        private void button2_Click(object sender, EventArgs e)
        {
            progressBar1.Visible = true;
            button2.Visible = false;
            label1.Visible = true;
            label2.Visible = true;
            WebClient webClient = new WebClient();
            label1.Text = "Downloading " + Globals.Config["Main"]["CygwinX64URL"].StringValue;
            webClient.DownloadFileCompleted += new AsyncCompletedEventHandler(Completed);
            webClient.DownloadProgressChanged += new DownloadProgressChangedEventHandler(ProgressChanged);
            webClient.DownloadFileAsync(new Uri(Globals.Config["Main"]["CygwinX64URL"].StringValue), Globals.Folders["configpath"] + "\\setup-x64.exe");
        }
    }
}
