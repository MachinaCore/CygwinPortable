namespace CygwinPortableCS
{
    partial class Form_ConfigForm
    {
        /// <summary>
        /// Erforderliche Designervariable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Verwendete Ressourcen bereinigen.
        /// </summary>
        /// <param name="disposing">True, wenn verwaltete Ressourcen gelöscht werden sollen; andernfalls False.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Vom Windows Form-Designer generierter Code

        /// <summary>
        /// Erforderliche Methode für die Designerunterstützung.
        /// Der Inhalt der Methode darf nicht mit dem Code-Editor geändert werden.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Form_ConfigForm));
            this.tabControl = new System.Windows.Forms.TabControl();
            this.tabPage_settings = new System.Windows.Forms.TabPage();
            this.tableLayoutPanel1 = new System.Windows.Forms.TableLayoutPanel();
            this.comboBox_shell = new System.Windows.Forms.ComboBox();
            this.label2 = new System.Windows.Forms.Label();
            this.textBox_executable_files = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.checkBox_set_windows_context_menu = new System.Windows.Forms.CheckBox();
            this.checkBox_exit_after_execution = new System.Windows.Forms.CheckBox();
            this.tabPage_installer = new System.Windows.Forms.TabPage();
            this.tableLayoutPanel2 = new System.Windows.Forms.TableLayoutPanel();
            this.textBox_cygwin_ports_mirror = new System.Windows.Forms.TextBox();
            this.label_cygwin_ports_mirror = new System.Windows.Forms.Label();
            this.label_cygwin_mirror = new System.Windows.Forms.Label();
            this.checkBox_delete_unneeded_files = new System.Windows.Forms.CheckBox();
            this.checkBox_install_unofficial_cygwin_tools = new System.Windows.Forms.CheckBox();
            this.textBox_cygwin_mirror = new System.Windows.Forms.TextBox();
            this.tabPage_expert = new System.Windows.Forms.TabPage();
            this.label5 = new System.Windows.Forms.Label();
            this.tableLayoutPanel3 = new System.Windows.Forms.TableLayoutPanel();
            this.checkBox_delete_complete_installation = new System.Windows.Forms.CheckBox();
            this.textBox_drop_these_folders_on_reinstall = new System.Windows.Forms.TextBox();
            this.label_drop_these_folders_on_reinstall = new System.Windows.Forms.Label();
            this.textBox_username = new System.Windows.Forms.TextBox();
            this.label_username = new System.Windows.Forms.Label();
            this.button_save = new System.Windows.Forms.Button();
            this.button_cancel = new System.Windows.Forms.Button();
            this.checkBox_disable_message_boxes = new System.Windows.Forms.CheckBox();
            this.checkBox_add_windows_path_variables_to_cygwin = new System.Windows.Forms.CheckBox();
            this.checkBox_support_wsl = new System.Windows.Forms.CheckBox();
            this.tabControl.SuspendLayout();
            this.tabPage_settings.SuspendLayout();
            this.tableLayoutPanel1.SuspendLayout();
            this.tabPage_installer.SuspendLayout();
            this.tableLayoutPanel2.SuspendLayout();
            this.tabPage_expert.SuspendLayout();
            this.tableLayoutPanel3.SuspendLayout();
            this.SuspendLayout();
            // 
            // tabControl
            // 
            this.tabControl.Controls.Add(this.tabPage_settings);
            this.tabControl.Controls.Add(this.tabPage_installer);
            this.tabControl.Controls.Add(this.tabPage_expert);
            this.tabControl.Location = new System.Drawing.Point(16, 15);
            this.tabControl.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.tabControl.Name = "tabControl";
            this.tabControl.SelectedIndex = 0;
            this.tabControl.Size = new System.Drawing.Size(581, 286);
            this.tabControl.TabIndex = 1;
            // 
            // tabPage_settings
            // 
            this.tabPage_settings.Controls.Add(this.tableLayoutPanel1);
            this.tabPage_settings.Location = new System.Drawing.Point(4, 25);
            this.tabPage_settings.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.tabPage_settings.Name = "tabPage_settings";
            this.tabPage_settings.Padding = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.tabPage_settings.Size = new System.Drawing.Size(573, 257);
            this.tabPage_settings.TabIndex = 0;
            this.tabPage_settings.Text = "Settings";
            this.tabPage_settings.UseVisualStyleBackColor = true;
            // 
            // tableLayoutPanel1
            // 
            this.tableLayoutPanel1.ColumnCount = 2;
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tableLayoutPanel1.Controls.Add(this.comboBox_shell, 1, 0);
            this.tableLayoutPanel1.Controls.Add(this.label2, 0, 2);
            this.tableLayoutPanel1.Controls.Add(this.textBox_executable_files, 1, 2);
            this.tableLayoutPanel1.Controls.Add(this.label1, 0, 0);
            this.tableLayoutPanel1.Controls.Add(this.checkBox_set_windows_context_menu, 0, 3);
            this.tableLayoutPanel1.Controls.Add(this.checkBox_exit_after_execution, 0, 5);
            this.tableLayoutPanel1.Controls.Add(this.checkBox_disable_message_boxes, 0, 6);
            this.tableLayoutPanel1.Controls.Add(this.checkBox_add_windows_path_variables_to_cygwin, 0, 7);
            this.tableLayoutPanel1.Controls.Add(this.checkBox_support_wsl, 0, 8);
            this.tableLayoutPanel1.Location = new System.Drawing.Point(8, 7);
            this.tableLayoutPanel1.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.tableLayoutPanel1.Name = "tableLayoutPanel1";
            this.tableLayoutPanel1.RowCount = 10;
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.Size = new System.Drawing.Size(555, 242);
            this.tableLayoutPanel1.TabIndex = 0;
            // 
            // comboBox_shell
            // 
            this.comboBox_shell.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.comboBox_shell.FormattingEnabled = true;
            this.comboBox_shell.Items.AddRange(new object[] {
            "ConEmu",
            "mintty"});
            this.comboBox_shell.Location = new System.Drawing.Point(281, 4);
            this.comboBox_shell.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.comboBox_shell.Name = "comboBox_shell";
            this.comboBox_shell.Size = new System.Drawing.Size(268, 24);
            this.comboBox_shell.TabIndex = 1;
            // 
            // label2
            // 
            this.label2.Anchor = System.Windows.Forms.AnchorStyles.Left;
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(4, 38);
            this.label2.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(114, 17);
            this.label2.TabIndex = 2;
            this.label2.Text = "Executable Files:";
            this.label2.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // textBox_executable_files
            // 
            this.textBox_executable_files.Location = new System.Drawing.Point(281, 36);
            this.textBox_executable_files.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.textBox_executable_files.Name = "textBox_executable_files";
            this.textBox_executable_files.Size = new System.Drawing.Size(268, 22);
            this.textBox_executable_files.TabIndex = 3;
            // 
            // label1
            // 
            this.label1.Anchor = System.Windows.Forms.AnchorStyles.Left;
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(4, 7);
            this.label1.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(43, 17);
            this.label1.TabIndex = 0;
            this.label1.Text = "Shell:";
            this.label1.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // checkBox_set_windows_context_menu
            // 
            this.checkBox_set_windows_context_menu.AutoSize = true;
            this.tableLayoutPanel1.SetColumnSpan(this.checkBox_set_windows_context_menu, 2);
            this.checkBox_set_windows_context_menu.Location = new System.Drawing.Point(4, 66);
            this.checkBox_set_windows_context_menu.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.checkBox_set_windows_context_menu.Name = "checkBox_set_windows_context_menu";
            this.checkBox_set_windows_context_menu.Size = new System.Drawing.Size(262, 21);
            this.checkBox_set_windows_context_menu.TabIndex = 4;
            this.checkBox_set_windows_context_menu.Text = "Set Windows Context Menu (registry)";
            this.checkBox_set_windows_context_menu.UseVisualStyleBackColor = true;
            // 
            // checkBox_exit_after_execution
            // 
            this.checkBox_exit_after_execution.AutoSize = true;
            this.tableLayoutPanel1.SetColumnSpan(this.checkBox_exit_after_execution, 2);
            this.checkBox_exit_after_execution.Location = new System.Drawing.Point(4, 95);
            this.checkBox_exit_after_execution.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.checkBox_exit_after_execution.Name = "checkBox_exit_after_execution";
            this.checkBox_exit_after_execution.Size = new System.Drawing.Size(149, 21);
            this.checkBox_exit_after_execution.TabIndex = 5;
            this.checkBox_exit_after_execution.Text = "Exit after execution";
            this.checkBox_exit_after_execution.UseVisualStyleBackColor = true;
            // 
            // tabPage_installer
            // 
            this.tabPage_installer.Controls.Add(this.tableLayoutPanel2);
            this.tabPage_installer.Location = new System.Drawing.Point(4, 25);
            this.tabPage_installer.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.tabPage_installer.Name = "tabPage_installer";
            this.tabPage_installer.Padding = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.tabPage_installer.Size = new System.Drawing.Size(573, 206);
            this.tabPage_installer.TabIndex = 1;
            this.tabPage_installer.Text = "Installer";
            this.tabPage_installer.UseVisualStyleBackColor = true;
            // 
            // tableLayoutPanel2
            // 
            this.tableLayoutPanel2.ColumnCount = 2;
            this.tableLayoutPanel2.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tableLayoutPanel2.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tableLayoutPanel2.Controls.Add(this.textBox_cygwin_ports_mirror, 1, 1);
            this.tableLayoutPanel2.Controls.Add(this.label_cygwin_ports_mirror, 0, 1);
            this.tableLayoutPanel2.Controls.Add(this.label_cygwin_mirror, 0, 0);
            this.tableLayoutPanel2.Controls.Add(this.checkBox_delete_unneeded_files, 0, 6);
            this.tableLayoutPanel2.Controls.Add(this.checkBox_install_unofficial_cygwin_tools, 0, 7);
            this.tableLayoutPanel2.Controls.Add(this.textBox_cygwin_mirror, 1, 0);
            this.tableLayoutPanel2.Location = new System.Drawing.Point(8, 9);
            this.tableLayoutPanel2.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.tableLayoutPanel2.Name = "tableLayoutPanel2";
            this.tableLayoutPanel2.RowCount = 8;
            this.tableLayoutPanel2.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel2.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel2.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel2.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel2.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel2.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel2.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel2.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel2.Size = new System.Drawing.Size(555, 186);
            this.tableLayoutPanel2.TabIndex = 1;
            // 
            // textBox_cygwin_ports_mirror
            // 
            this.textBox_cygwin_ports_mirror.Location = new System.Drawing.Point(281, 34);
            this.textBox_cygwin_ports_mirror.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.textBox_cygwin_ports_mirror.Name = "textBox_cygwin_ports_mirror";
            this.textBox_cygwin_ports_mirror.Size = new System.Drawing.Size(268, 22);
            this.textBox_cygwin_ports_mirror.TabIndex = 10;
            // 
            // label_cygwin_ports_mirror
            // 
            this.label_cygwin_ports_mirror.Anchor = System.Windows.Forms.AnchorStyles.Left;
            this.label_cygwin_ports_mirror.AutoSize = true;
            this.label_cygwin_ports_mirror.Location = new System.Drawing.Point(4, 36);
            this.label_cygwin_ports_mirror.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label_cygwin_ports_mirror.Name = "label_cygwin_ports_mirror";
            this.label_cygwin_ports_mirror.Size = new System.Drawing.Size(134, 17);
            this.label_cygwin_ports_mirror.TabIndex = 9;
            this.label_cygwin_ports_mirror.Text = "Cygwin Ports Mirror:";
            this.label_cygwin_ports_mirror.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // label_cygwin_mirror
            // 
            this.label_cygwin_mirror.Anchor = System.Windows.Forms.AnchorStyles.Left;
            this.label_cygwin_mirror.AutoSize = true;
            this.label_cygwin_mirror.Location = new System.Drawing.Point(4, 6);
            this.label_cygwin_mirror.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label_cygwin_mirror.Name = "label_cygwin_mirror";
            this.label_cygwin_mirror.Size = new System.Drawing.Size(97, 17);
            this.label_cygwin_mirror.TabIndex = 0;
            this.label_cygwin_mirror.Text = "Cygwin Mirror:";
            this.label_cygwin_mirror.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // checkBox_delete_unneeded_files
            // 
            this.checkBox_delete_unneeded_files.AutoSize = true;
            this.tableLayoutPanel2.SetColumnSpan(this.checkBox_delete_unneeded_files, 2);
            this.checkBox_delete_unneeded_files.Location = new System.Drawing.Point(4, 64);
            this.checkBox_delete_unneeded_files.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.checkBox_delete_unneeded_files.Name = "checkBox_delete_unneeded_files";
            this.checkBox_delete_unneeded_files.Size = new System.Drawing.Size(168, 21);
            this.checkBox_delete_unneeded_files.TabIndex = 6;
            this.checkBox_delete_unneeded_files.Text = "Delete unneeded files";
            this.checkBox_delete_unneeded_files.UseVisualStyleBackColor = true;
            // 
            // checkBox_install_unofficial_cygwin_tools
            // 
            this.checkBox_install_unofficial_cygwin_tools.AutoSize = true;
            this.tableLayoutPanel2.SetColumnSpan(this.checkBox_install_unofficial_cygwin_tools, 2);
            this.checkBox_install_unofficial_cygwin_tools.Location = new System.Drawing.Point(4, 93);
            this.checkBox_install_unofficial_cygwin_tools.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.checkBox_install_unofficial_cygwin_tools.Name = "checkBox_install_unofficial_cygwin_tools";
            this.checkBox_install_unofficial_cygwin_tools.Size = new System.Drawing.Size(213, 21);
            this.checkBox_install_unofficial_cygwin_tools.TabIndex = 7;
            this.checkBox_install_unofficial_cygwin_tools.Text = "Install unofficial Cygwin Tools";
            this.checkBox_install_unofficial_cygwin_tools.UseVisualStyleBackColor = true;
            // 
            // textBox_cygwin_mirror
            // 
            this.textBox_cygwin_mirror.Location = new System.Drawing.Point(281, 4);
            this.textBox_cygwin_mirror.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.textBox_cygwin_mirror.Name = "textBox_cygwin_mirror";
            this.textBox_cygwin_mirror.Size = new System.Drawing.Size(268, 22);
            this.textBox_cygwin_mirror.TabIndex = 8;
            // 
            // tabPage_expert
            // 
            this.tabPage_expert.Controls.Add(this.label5);
            this.tabPage_expert.Controls.Add(this.tableLayoutPanel3);
            this.tabPage_expert.Location = new System.Drawing.Point(4, 25);
            this.tabPage_expert.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.tabPage_expert.Name = "tabPage_expert";
            this.tabPage_expert.Padding = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.tabPage_expert.Size = new System.Drawing.Size(573, 206);
            this.tabPage_expert.TabIndex = 2;
            this.tabPage_expert.Text = "Expert";
            this.tabPage_expert.UseVisualStyleBackColor = true;
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.ForeColor = System.Drawing.Color.Red;
            this.label5.Location = new System.Drawing.Point(12, 15);
            this.label5.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(530, 17);
            this.label5.TabIndex = 3;
            this.label5.Text = "WARNING: Dont change anything here if you not exactly know what you are doing !";
            // 
            // tableLayoutPanel3
            // 
            this.tableLayoutPanel3.ColumnCount = 2;
            this.tableLayoutPanel3.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tableLayoutPanel3.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tableLayoutPanel3.Controls.Add(this.checkBox_delete_complete_installation, 0, 0);
            this.tableLayoutPanel3.Controls.Add(this.textBox_drop_these_folders_on_reinstall, 1, 1);
            this.tableLayoutPanel3.Controls.Add(this.label_drop_these_folders_on_reinstall, 0, 1);
            this.tableLayoutPanel3.Controls.Add(this.textBox_username, 1, 2);
            this.tableLayoutPanel3.Controls.Add(this.label_username, 0, 2);
            this.tableLayoutPanel3.Location = new System.Drawing.Point(8, 48);
            this.tableLayoutPanel3.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.tableLayoutPanel3.Name = "tableLayoutPanel3";
            this.tableLayoutPanel3.RowCount = 8;
            this.tableLayoutPanel3.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel3.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel3.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel3.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel3.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel3.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel3.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel3.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel3.Size = new System.Drawing.Size(555, 94);
            this.tableLayoutPanel3.TabIndex = 2;
            // 
            // checkBox_delete_complete_installation
            // 
            this.checkBox_delete_complete_installation.AutoSize = true;
            this.tableLayoutPanel3.SetColumnSpan(this.checkBox_delete_complete_installation, 2);
            this.checkBox_delete_complete_installation.Location = new System.Drawing.Point(4, 4);
            this.checkBox_delete_complete_installation.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.checkBox_delete_complete_installation.Name = "checkBox_delete_complete_installation";
            this.checkBox_delete_complete_installation.Size = new System.Drawing.Size(268, 21);
            this.checkBox_delete_complete_installation.TabIndex = 6;
            this.checkBox_delete_complete_installation.Text = "Delete compete installation (Reinstall)";
            this.checkBox_delete_complete_installation.UseVisualStyleBackColor = true;
            // 
            // textBox_drop_these_folders_on_reinstall
            // 
            this.textBox_drop_these_folders_on_reinstall.Location = new System.Drawing.Point(281, 33);
            this.textBox_drop_these_folders_on_reinstall.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.textBox_drop_these_folders_on_reinstall.Name = "textBox_drop_these_folders_on_reinstall";
            this.textBox_drop_these_folders_on_reinstall.Size = new System.Drawing.Size(268, 22);
            this.textBox_drop_these_folders_on_reinstall.TabIndex = 8;
            // 
            // label_drop_these_folders_on_reinstall
            // 
            this.label_drop_these_folders_on_reinstall.Anchor = System.Windows.Forms.AnchorStyles.Left;
            this.label_drop_these_folders_on_reinstall.AutoSize = true;
            this.label_drop_these_folders_on_reinstall.Location = new System.Drawing.Point(4, 35);
            this.label_drop_these_folders_on_reinstall.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label_drop_these_folders_on_reinstall.Name = "label_drop_these_folders_on_reinstall";
            this.label_drop_these_folders_on_reinstall.Size = new System.Drawing.Size(206, 17);
            this.label_drop_these_folders_on_reinstall.TabIndex = 9;
            this.label_drop_these_folders_on_reinstall.Text = "Drop these Folders on reinstall:";
            this.label_drop_these_folders_on_reinstall.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // textBox_username
            // 
            this.textBox_username.Location = new System.Drawing.Point(281, 63);
            this.textBox_username.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.textBox_username.Name = "textBox_username";
            this.textBox_username.Size = new System.Drawing.Size(268, 22);
            this.textBox_username.TabIndex = 10;
            // 
            // label_username
            // 
            this.label_username.Anchor = System.Windows.Forms.AnchorStyles.Left;
            this.label_username.AutoSize = true;
            this.label_username.Location = new System.Drawing.Point(4, 65);
            this.label_username.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label_username.Name = "label_username";
            this.label_username.Size = new System.Drawing.Size(77, 17);
            this.label_username.TabIndex = 2;
            this.label_username.Text = "Username:";
            this.label_username.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // button_save
            // 
            this.button_save.Location = new System.Drawing.Point(384, 309);
            this.button_save.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.button_save.Name = "button_save";
            this.button_save.Size = new System.Drawing.Size(100, 28);
            this.button_save.TabIndex = 2;
            this.button_save.Text = "Save";
            this.button_save.UseVisualStyleBackColor = true;
            this.button_save.Click += new System.EventHandler(this.button_save_Click);
            // 
            // button_cancel
            // 
            this.button_cancel.Location = new System.Drawing.Point(492, 309);
            this.button_cancel.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.button_cancel.Name = "button_cancel";
            this.button_cancel.Size = new System.Drawing.Size(100, 28);
            this.button_cancel.TabIndex = 3;
            this.button_cancel.Text = "Cancel";
            this.button_cancel.UseVisualStyleBackColor = true;
            this.button_cancel.Click += new System.EventHandler(this.button_cancel_Click);
            // 
            // checkBox_disable_message_boxes
            // 
            this.checkBox_disable_message_boxes.AutoSize = true;
            this.tableLayoutPanel1.SetColumnSpan(this.checkBox_disable_message_boxes, 2);
            this.checkBox_disable_message_boxes.Location = new System.Drawing.Point(4, 124);
            this.checkBox_disable_message_boxes.Margin = new System.Windows.Forms.Padding(4);
            this.checkBox_disable_message_boxes.Name = "checkBox_disable_message_boxes";
            this.checkBox_disable_message_boxes.Size = new System.Drawing.Size(335, 21);
            this.checkBox_disable_message_boxes.TabIndex = 6;
            this.checkBox_disable_message_boxes.Text = "Disable Mesage Boxes (errors will not be shown)";
            this.checkBox_disable_message_boxes.UseVisualStyleBackColor = true;
            // 
            // checkBox_add_windows_path_variables_to_cygwin
            // 
            this.checkBox_add_windows_path_variables_to_cygwin.AutoSize = true;
            this.tableLayoutPanel1.SetColumnSpan(this.checkBox_add_windows_path_variables_to_cygwin, 2);
            this.checkBox_add_windows_path_variables_to_cygwin.Location = new System.Drawing.Point(4, 153);
            this.checkBox_add_windows_path_variables_to_cygwin.Margin = new System.Windows.Forms.Padding(4);
            this.checkBox_add_windows_path_variables_to_cygwin.Name = "checkBox_add_windows_path_variables_to_cygwin";
            this.checkBox_add_windows_path_variables_to_cygwin.Size = new System.Drawing.Size(281, 21);
            this.checkBox_add_windows_path_variables_to_cygwin.TabIndex = 7;
            this.checkBox_add_windows_path_variables_to_cygwin.Text = "Add Windows PATH variables to Cygwin";
            this.checkBox_add_windows_path_variables_to_cygwin.UseVisualStyleBackColor = true;
            // 
            // checkBox_support_wsl
            // 
            this.checkBox_support_wsl.AutoSize = true;
            this.tableLayoutPanel1.SetColumnSpan(this.checkBox_support_wsl, 2);
            this.checkBox_support_wsl.Location = new System.Drawing.Point(4, 182);
            this.checkBox_support_wsl.Margin = new System.Windows.Forms.Padding(4);
            this.checkBox_support_wsl.Name = "checkBox_support_wsl";
            this.checkBox_support_wsl.Size = new System.Drawing.Size(114, 21);
            this.checkBox_support_wsl.TabIndex = 8;
            this.checkBox_support_wsl.Text = "Support WSL";
            this.checkBox_support_wsl.UseVisualStyleBackColor = true;
            // 
            // Form_ConfigForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(605, 360);
            this.Controls.Add(this.button_cancel);
            this.Controls.Add(this.button_save);
            this.Controls.Add(this.tabControl);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.Name = "Form_ConfigForm";
            this.Text = "Cygwin Config";
            this.tabControl.ResumeLayout(false);
            this.tabPage_settings.ResumeLayout(false);
            this.tableLayoutPanel1.ResumeLayout(false);
            this.tableLayoutPanel1.PerformLayout();
            this.tabPage_installer.ResumeLayout(false);
            this.tableLayoutPanel2.ResumeLayout(false);
            this.tableLayoutPanel2.PerformLayout();
            this.tabPage_expert.ResumeLayout(false);
            this.tabPage_expert.PerformLayout();
            this.tableLayoutPanel3.ResumeLayout(false);
            this.tableLayoutPanel3.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion
        private System.Windows.Forms.TabControl tabControl;
        private System.Windows.Forms.TabPage tabPage_settings;
        private System.Windows.Forms.TabPage tabPage_installer;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel1;
        private System.Windows.Forms.ComboBox comboBox_shell;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox textBox_executable_files;
        private System.Windows.Forms.CheckBox checkBox_set_windows_context_menu;
        private System.Windows.Forms.CheckBox checkBox_exit_after_execution;
        private System.Windows.Forms.Button button_save;
        private System.Windows.Forms.Button button_cancel;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel2;
        private System.Windows.Forms.TextBox textBox_cygwin_ports_mirror;
        private System.Windows.Forms.Label label_cygwin_ports_mirror;
        private System.Windows.Forms.Label label_cygwin_mirror;
        private System.Windows.Forms.CheckBox checkBox_delete_unneeded_files;
        private System.Windows.Forms.CheckBox checkBox_install_unofficial_cygwin_tools;
        private System.Windows.Forms.TextBox textBox_cygwin_mirror;
        private System.Windows.Forms.TabPage tabPage_expert;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel3;
        private System.Windows.Forms.CheckBox checkBox_delete_complete_installation;
        private System.Windows.Forms.TextBox textBox_drop_these_folders_on_reinstall;
        private System.Windows.Forms.Label label_drop_these_folders_on_reinstall;
        private System.Windows.Forms.TextBox textBox_username;
        private System.Windows.Forms.Label label_username;
        private System.Windows.Forms.CheckBox checkBox_disable_message_boxes;
        private System.Windows.Forms.CheckBox checkBox_add_windows_path_variables_to_cygwin;
        private System.Windows.Forms.CheckBox checkBox_support_wsl;
    }
}