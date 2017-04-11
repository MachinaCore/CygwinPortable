namespace CygwinPortableCS
{
    partial class Form_FirstInstall
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Form_FirstInstall));
            this.tableLayoutPanel1 = new System.Windows.Forms.TableLayoutPanel();
            this.comboBox_packages = new System.Windows.Forms.ComboBox();
            this.label1 = new System.Windows.Forms.Label();
            this.button_download_x86 = new System.Windows.Forms.Button();
            this.button_download_x64 = new System.Windows.Forms.Button();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.button_open_package_folder = new System.Windows.Forms.Button();
            this.tableLayoutPanel1.SuspendLayout();
            this.SuspendLayout();
            // 
            // tableLayoutPanel1
            // 
            this.tableLayoutPanel1.ColumnCount = 3;
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 29.76191F));
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 70.2381F));
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 55F));
            this.tableLayoutPanel1.Controls.Add(this.comboBox_packages, 1, 0);
            this.tableLayoutPanel1.Controls.Add(this.label1, 0, 0);
            this.tableLayoutPanel1.Controls.Add(this.button_open_package_folder, 2, 0);
            this.tableLayoutPanel1.Location = new System.Drawing.Point(12, 59);
            this.tableLayoutPanel1.Name = "tableLayoutPanel1";
            this.tableLayoutPanel1.RowCount = 8;
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.Size = new System.Drawing.Size(308, 29);
            this.tableLayoutPanel1.TabIndex = 1;
            // 
            // comboBox_packages
            // 
            this.comboBox_packages.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.comboBox_packages.FormattingEnabled = true;
            this.comboBox_packages.Location = new System.Drawing.Point(78, 3);
            this.comboBox_packages.Name = "comboBox_packages";
            this.comboBox_packages.Size = new System.Drawing.Size(171, 21);
            this.comboBox_packages.TabIndex = 1;
            // 
            // label1
            // 
            this.label1.Anchor = System.Windows.Forms.AnchorStyles.Left;
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(3, 7);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(55, 13);
            this.label1.TabIndex = 0;
            this.label1.Text = "Packages";
            this.label1.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // button_download_x86
            // 
            this.button_download_x86.Location = new System.Drawing.Point(18, 94);
            this.button_download_x86.Name = "button_download_x86";
            this.button_download_x86.Size = new System.Drawing.Size(148, 23);
            this.button_download_x86.TabIndex = 4;
            this.button_download_x86.Text = "Download Cygwin X86";
            this.button_download_x86.UseVisualStyleBackColor = true;
            this.button_download_x86.Click += new System.EventHandler(this.button_download_x86_Click);
            // 
            // button_download_x64
            // 
            this.button_download_x64.Location = new System.Drawing.Point(172, 94);
            this.button_download_x64.Name = "button_download_x64";
            this.button_download_x64.Size = new System.Drawing.Size(148, 23);
            this.button_download_x64.TabIndex = 5;
            this.button_download_x64.Text = "Download Cygwin X64";
            this.button_download_x64.UseVisualStyleBackColor = true;
            this.button_download_x64.Click += new System.EventHandler(this.button_download_x64_Click);
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label2.Location = new System.Drawing.Point(15, 9);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(89, 13);
            this.label2.TabIndex = 6;
            this.label2.Text = "Install Cygwin:";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(15, 35);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(196, 13);
            this.label3.TabIndex = 7;
            this.label3.Text = "Please choose start packages and version";
            // 
            // button_open_package_folder
            // 
            this.button_open_package_folder.Location = new System.Drawing.Point(255, 3);
            this.button_open_package_folder.Name = "button_open_package_folder";
            this.button_open_package_folder.Size = new System.Drawing.Size(50, 21);
            this.button_open_package_folder.TabIndex = 8;
            this.button_open_package_folder.Text = "Folder";
            this.button_open_package_folder.UseVisualStyleBackColor = true;
            this.button_open_package_folder.Click += new System.EventHandler(this.button_open_package_folder_Click);
            // 
            // Form_FirstInstall
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(331, 123);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.button_download_x64);
            this.Controls.Add(this.button_download_x86);
            this.Controls.Add(this.tableLayoutPanel1);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Name = "Form_FirstInstall";
            this.Text = "Cygwin Installation";
            this.tableLayoutPanel1.ResumeLayout(false);
            this.tableLayoutPanel1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel1;
        private System.Windows.Forms.ComboBox comboBox_packages;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Button button_download_x86;
        private System.Windows.Forms.Button button_download_x64;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Button button_open_package_folder;
    }
}
