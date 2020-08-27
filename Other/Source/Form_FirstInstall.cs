using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Text;
using System.Windows.Forms;

namespace CygwinPortableCS
{
    public partial class Form_FirstInstall : Form
    {
        public Form_FirstInstall()
        {
            StartPosition = FormStartPosition.CenterScreen;
            InitializeComponent();

            DirectoryInfo diSource = new DirectoryInfo(Globals.AppPath + "\\DefaultData\\Packages");
            foreach (FileInfo fi in diSource.GetFiles())
            {
                comboBox_packages.Items.Add(fi.Name.Replace(".txt",""));
            }
            comboBox_packages.SelectedIndex = 0;
            int index = comboBox_packages.FindStringExact("Default");
            comboBox_packages.SelectedIndex = index;
        }

        private void button_download_x86_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.OK;
            string line;
            string packagesList = "";

            StreamReader file = new StreamReader(Globals.AppPath + "\\DefaultData\\Packages\\" + comboBox_packages.Text + ".txt");
            while ((line = file.ReadLine()) != null)
            {
                Console.WriteLine(line);
                packagesList = packagesList + "," + line;
            }
            file.Close();

            Globals.RuntimeSettings["CygwinFirstInstallAdditions"] = packagesList;
            Globals.RuntimeSettings["x86x64Download"] = "x86";


        }

        private void button_download_x64_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.OK;
            string line;
            string packagesList = "";

            StreamReader file = new StreamReader(Globals.AppPath + "\\DefaultData\\Packages\\" + comboBox_packages.Text + ".txt");
            while ((line = file.ReadLine()) != null)
            {
                Console.WriteLine(line);
                packagesList = packagesList + "," + line;
            }
            file.Close();

            Globals.RuntimeSettings["CygwinFirstInstallAdditions"] = packagesList;
            Globals.RuntimeSettings["x86x64Download"] = "x64";

            
        }

        private void button_open_package_folder_Click(object sender, EventArgs e)
        {
            Process.Start(Globals.AppPath + "\\DefaultData\\Packages");
        }
    }
}
