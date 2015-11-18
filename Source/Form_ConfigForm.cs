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
            textBox_executable_files.Text = Globals.Config["Main"]["ExecutableExtension"].StringValue;
            checkBox_exit_after_execution.Checked = Globals.Config["Main"]["ExitAfterExec"].BoolValue;
            checkBox_set_windows_context_menu.Checked = Globals.Config["Main"]["SetContextMenu"].BoolValue;
            comboBox_shell.Text = Globals.Config["Main"]["Shell"].StringValue;
            checkBox_disable_message_boxes.Checked = Globals.Config["Main"]["NoMsgBox"].BoolValue;
            textBox_cygwin_mirror.Text = Globals.Config["Main"]["CygwinMirror"].StringValue;
            textBox_cygwin_ports_mirror.Text = Globals.Config["Main"]["CygwinPortsMirror"].StringValue;
            checkBox_delete_unneeded_files.Checked = Globals.Config["Main"]["CygwinFirstInstallDeleteUnneeded"].BoolValue;
            checkBox_install_unofficial_cygwin_tools.Checked = Globals.Config["Main"]["InstallUnofficial"].BoolValue;
            checkBox_add_windows_path_variables_to_cygwin.Checked = Globals.Config["Main"]["WindowsPathToCygwin"].BoolValue;

            textBox_username.Text = Globals.Config["Static"]["Username"].StringValue;
            checkBox_delete_complete_installation.Checked = Globals.Config["Expert"]["CygwinDeleteInstallation"].BoolValue;
            textBox_drop_these_folders_on_reinstall.Text = Globals.Config["Expert"]["CygwinDeleteInstallationFolders"].StringValue;

        }

        private void button_save_Click(object sender, EventArgs e)
        {
            bool registryChange = Globals.Config["Main"]["SetContextMenu"].StringValue != checkBox_set_windows_context_menu.Checked.ToString();
            Globals.Config["Main"]["ExecutableExtension"].StringValue = textBox_executable_files.Text;
            Globals.Config["Main"]["ExitAfterExec"].StringValue = checkBox_exit_after_execution.Checked.ToString();
            Globals.Config["Main"]["SetContextMenu"].StringValue = checkBox_set_windows_context_menu.Checked.ToString();
            Globals.Config["Main"]["Shell"].StringValue = comboBox_shell.Text;
            Globals.Config["Main"]["NoMsgBox"].StringValue = checkBox_disable_message_boxes.Checked.ToString();
            Globals.Config["Main"]["CygwinMirror"].StringValue = textBox_cygwin_mirror.Text;
            Globals.Config["Main"]["CygwinPortsMirror"].StringValue = textBox_cygwin_ports_mirror.Text;
            Globals.Config["Main"]["CygwinFirstInstallDeleteUnneeded"].StringValue = checkBox_delete_unneeded_files.Checked.ToString();
            Globals.Config["Main"]["InstallUnofficial"].StringValue = checkBox_install_unofficial_cygwin_tools.Checked.ToString();
            Globals.Config["Main"]["WindowsPathToCygwin"].StringValue = checkBox_add_windows_path_variables_to_cygwin.Checked.ToString();

            Globals.Config["Static"]["Username"].StringValue = textBox_username.Text;
            Globals.Config["Expert"]["CygwinDeleteInstallation"].StringValue = checkBox_delete_complete_installation.Checked.ToString();
            Globals.Config["Expert"]["CygwinDeleteInstallationFolders"].StringValue = textBox_drop_these_folders_on_reinstall.Text;
            Globals.Config.SaveToFile(Globals.ConfigPath + "\\Configuration.ini");
            if (registryChange)
            {
                ChangeRegistryPath.Change();
            }
            //Check if Key really is set or deleted
            /*if (ChangeRegistryPath.RegistryKeyExists())
            {
                Globals.Config["Main"]["SetContextMenu"].BoolValue = true;
            }
            else
            {
                Globals.Config["Main"]["SetContextMenu"].BoolValue = false;
            }*/
            checkBox_set_windows_context_menu.Checked = Globals.Config["Main"]["SetContextMenu"].BoolValue;
            this.Close();
        }

        private void button_cancel_Click(object sender, EventArgs e)
        {
            this.Close();
        }
    }
}

