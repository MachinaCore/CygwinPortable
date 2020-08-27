using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace CygwinPortableCS
{
    public partial class Form_ConfigForm : Form
    {
        public Form_ConfigForm()
        {
            InitializeComponent();
            textBox_executable_files.Text = (string)Globals.MainConfig["Cygwin"]["ExecutableExtension"];
            checkBox_exit_after_execution.Checked = (bool)Globals.MainConfig["Cygwin"]["ExitAfterExec"];
            checkBox_set_windows_context_menu.Checked = (bool)Globals.MainConfig["Cygwin"]["SetContextMenu"];
            comboBox_shell.Text = (string)Globals.MainConfig["Cygwin"]["Shell"];
            checkBox_disable_message_boxes.Checked = (bool)Globals.MainConfig["Cygwin"]["NoMsgBox"];
            textBox_cygwin_mirror.Text = (string)Globals.MainConfig["Cygwin"]["CygwinMirror"];
            textBox_cygwin_ports_mirror.Text = (string)Globals.MainConfig["Cygwin"]["CygwinPortsMirror"];
            checkBox_delete_unneeded_files.Checked = (bool)Globals.MainConfig["Cygwin"]["CygwinFirstInstallDeleteUnneeded"];
            checkBox_install_unofficial_cygwin_tools.Checked = (bool)Globals.MainConfig["Cygwin"]["InstallUnofficial"];
            checkBox_add_windows_path_variables_to_cygwin.Checked = (bool)Globals.MainConfig["Cygwin"]["WindowsPathToCygwin"];
            checkBox_support_wsl.Checked = (bool)Globals.MainConfig["Cygwin"]["SupportWSL"];
            comboBox_default_environment.Text = (string)Globals.MainConfig["Cygwin"]["DefaultEnvironment"];

            textBox_username.Text = (string)Globals.MainConfig["Cygwin"]["Username"];
            checkBox_delete_complete_installation.Checked = (bool)Globals.MainConfig["Cygwin"]["CygwinDeleteInstallation"];
            textBox_drop_these_folders_on_reinstall.Text = (string)Globals.MainConfig["Cygwin"]["CygwinDeleteInstallationFolders"];

        }

        private void button_save_Click(object sender, EventArgs e)
        {
            bool registryChange = (bool)Globals.MainConfig["Cygwin"]["SetContextMenu"] != checkBox_set_windows_context_menu.Checked;
            Globals.MainConfig["Cygwin"]["ExecutableExtension"] = textBox_executable_files.Text;
            Globals.MainConfig["Cygwin"]["ExitAfterExec"] = checkBox_exit_after_execution.Checked;
            Globals.MainConfig["Cygwin"]["SetContextMenu"] = checkBox_set_windows_context_menu.Checked;
            Globals.MainConfig["Cygwin"]["Shell"] = comboBox_shell.Text;
            Globals.MainConfig["Cygwin"]["NoMsgBox"] = checkBox_disable_message_boxes.Checked;
            Globals.MainConfig["Cygwin"]["CygwinMirror"] = textBox_cygwin_mirror.Text;
            Globals.MainConfig["Cygwin"]["CygwinPortsMirror"] = textBox_cygwin_ports_mirror.Text;
            Globals.MainConfig["Cygwin"]["CygwinFirstInstallDeleteUnneeded"] = checkBox_delete_unneeded_files.Checked;
            Globals.MainConfig["Cygwin"]["InstallUnofficial"] = checkBox_install_unofficial_cygwin_tools.Checked;
            Globals.MainConfig["Cygwin"]["WindowsPathToCygwin"] = checkBox_add_windows_path_variables_to_cygwin.Checked;
            Globals.MainConfig["Cygwin"]["SupportWSL"] = checkBox_support_wsl.Checked;
            Globals.MainConfig["Cygwin"]["DefaultEnvironment"] = comboBox_default_environment.Text;

            Globals.MainConfig["Cygwin"]["Username"] = textBox_username.Text;
            Globals.MainConfig["Cygwin"]["CygwinDeleteInstallation"] = checkBox_delete_complete_installation.Checked;
            Globals.MainConfig["Cygwin"]["CygwinDeleteInstallationFolders"] = textBox_drop_these_folders_on_reinstall.Text;
            System.IO.File.WriteAllText(Globals.ConfigPath + "\\Configuration.json", JsonConvert.SerializeObject(Globals.MainConfig["Cygwin"], Formatting.Indented));
            if (registryChange)
            {
                ChangeRegistryPath.Change();
            }
            //Check if Key really is set or deleted
            /*if (ChangeRegistryPath.RegistryKeyExists())
            {
                Globals.MainConfig["Cygwin"]["SetContextMenu"].BoolValue = true;
            }
            else
            {
                Globals.MainConfig["Cygwin"]["SetContextMenu"].BoolValue = false;
            }*/
            checkBox_set_windows_context_menu.Checked = (bool)Globals.MainConfig["Cygwin"]["SetContextMenu"];
            this.Close();
        }

        private void button_cancel_Click(object sender, EventArgs e)
        {
            this.Close();
        }
    }
}

