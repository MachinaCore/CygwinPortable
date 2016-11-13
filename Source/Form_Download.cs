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


            /*DirectoryInfo homeFolder = new DirectoryInfo(Globals.AppPath + "\\DefaultData\\cygwin\\home");
            foreach (var fileName in homeFolder.GetFiles("*"))
            {
                Console.WriteLine(fileName);
                File.Copy(Globals.AppPath + "\\DefaultData\\cygwin\\home\\" + fileName.Name, Globals.AppPath + "\\Runtime\\Cygwin\\home\\" + Globals.Config["Static"]["Username"].StringValue + "\\" + fileName.Name);
            }

            DirectoryInfo binFolder = new DirectoryInfo(Globals.AppPath + "\\DefaultData\\cygwin\\bin");
            foreach (var fileName in binFolder.GetFiles("*"))
            {
                Console.WriteLine(fileName);
                File.Copy(Globals.AppPath + "\\DefaultData\\cygwin\\bin\\" + fileName.Name, Globals.AppPath + "\\Runtime\\Cygwin\\bin\\" + fileName.Name);
            }*/
        }

        public Form_Download()
        {
            StartPosition = FormStartPosition.CenterScreen;
            InitializeComponent();

            WebClient webClient = new WebClient();
            webClient.DownloadFileCompleted += new AsyncCompletedEventHandler(Completed);
            webClient.DownloadProgressChanged += new DownloadProgressChangedEventHandler(ProgressChanged);
            if (Globals.RuntimeSettings["x86x64Download"].ToString() == "x64")
            {
                label1.Text = "Downloading " + (string)Globals.MainConfig["Cygwin"]["CygwinX64URL"];
                webClient.DownloadFileAsync(new Uri((string)Globals.MainConfig["Cygwin"]["CygwinX64URL"]), Globals.ConfigPath + "\\setup-x86_64.exe");
            }
            else
            {
                label1.Text = "Downloading " + (string)Globals.MainConfig["Cygwin"]["CygwinX86URL"];
                webClient.DownloadFileAsync(new Uri((string)Globals.MainConfig["Cygwin"]["CygwinX86URL"]), Globals.ConfigPath + "\\setup-x86.exe");
            }
        }

    }
}
