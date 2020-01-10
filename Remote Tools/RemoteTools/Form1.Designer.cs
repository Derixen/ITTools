namespace RemoteTools
{
    partial class Form1
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
            this.components = new System.ComponentModel.Container();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Form1));
            this.txtSearch = new System.Windows.Forms.TextBox();
            this.button1 = new System.Windows.Forms.Button();
            this.txtActionLog = new System.Windows.Forms.TextBox();
            this.lblDomain = new System.Windows.Forms.Label();
            this.lblUser = new System.Windows.Forms.Label();
            this.lblUserAccess = new System.Windows.Forms.Label();
            this.lblPC = new System.Windows.Forms.Label();
            this.txtDomain = new System.Windows.Forms.TextBox();
            this.txtUser = new System.Windows.Forms.TextBox();
            this.txtPC = new System.Windows.Forms.TextBox();
            this.txtUserAccess = new System.Windows.Forms.TextBox();
            this.txtLogServer = new System.Windows.Forms.TextBox();
            this.lblLog = new System.Windows.Forms.Label();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.btnExit = new System.Windows.Forms.Button();
            this.btnSettings = new System.Windows.Forms.Button();
            this.btnReCheck = new System.Windows.Forms.Button();
            this.lblActionLog = new System.Windows.Forms.Label();
            this.timer1 = new System.Windows.Forms.Timer(this.components);
            this.rbtnIP = new System.Windows.Forms.RadioButton();
            this.rbtnPC = new System.Windows.Forms.RadioButton();
            this.groupBox1.SuspendLayout();
            this.SuspendLayout();
            // 
            // txtSearch
            // 
            this.txtSearch.Enabled = false;
            this.txtSearch.Location = new System.Drawing.Point(12, 12);
            this.txtSearch.Name = "txtSearch";
            this.txtSearch.ReadOnly = true;
            this.txtSearch.Size = new System.Drawing.Size(228, 20);
            this.txtSearch.TabIndex = 0;
            // 
            // button1
            // 
            this.button1.Enabled = false;
            this.button1.Location = new System.Drawing.Point(246, 11);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(91, 21);
            this.button1.TabIndex = 1;
            this.button1.Text = "Connect";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // txtActionLog
            // 
            this.txtActionLog.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Italic, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.txtActionLog.Location = new System.Drawing.Point(11, 247);
            this.txtActionLog.Multiline = true;
            this.txtActionLog.Name = "txtActionLog";
            this.txtActionLog.ReadOnly = true;
            this.txtActionLog.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.txtActionLog.Size = new System.Drawing.Size(325, 132);
            this.txtActionLog.TabIndex = 2;
            // 
            // lblDomain
            // 
            this.lblDomain.AutoSize = true;
            this.lblDomain.Location = new System.Drawing.Point(6, 22);
            this.lblDomain.Name = "lblDomain";
            this.lblDomain.Size = new System.Drawing.Size(46, 13);
            this.lblDomain.TabIndex = 3;
            this.lblDomain.Text = "Domain:";
            // 
            // lblUser
            // 
            this.lblUser.AutoSize = true;
            this.lblUser.Location = new System.Drawing.Point(6, 47);
            this.lblUser.Name = "lblUser";
            this.lblUser.Size = new System.Drawing.Size(32, 13);
            this.lblUser.TabIndex = 4;
            this.lblUser.Text = "User:";
            // 
            // lblUserAccess
            // 
            this.lblUserAccess.AutoSize = true;
            this.lblUserAccess.Location = new System.Drawing.Point(6, 99);
            this.lblUserAccess.Name = "lblUserAccess";
            this.lblUserAccess.Size = new System.Drawing.Size(70, 13);
            this.lblUserAccess.TabIndex = 5;
            this.lblUserAccess.Text = "User Access:";
            // 
            // lblPC
            // 
            this.lblPC.AutoSize = true;
            this.lblPC.Location = new System.Drawing.Point(6, 73);
            this.lblPC.Name = "lblPC";
            this.lblPC.Size = new System.Drawing.Size(32, 13);
            this.lblPC.TabIndex = 6;
            this.lblPC.Text = "Host:";
            // 
            // txtDomain
            // 
            this.txtDomain.Location = new System.Drawing.Point(85, 19);
            this.txtDomain.Name = "txtDomain";
            this.txtDomain.ReadOnly = true;
            this.txtDomain.Size = new System.Drawing.Size(143, 20);
            this.txtDomain.TabIndex = 7;
            // 
            // txtUser
            // 
            this.txtUser.Location = new System.Drawing.Point(85, 44);
            this.txtUser.Name = "txtUser";
            this.txtUser.ReadOnly = true;
            this.txtUser.Size = new System.Drawing.Size(143, 20);
            this.txtUser.TabIndex = 8;
            // 
            // txtPC
            // 
            this.txtPC.Location = new System.Drawing.Point(85, 70);
            this.txtPC.Name = "txtPC";
            this.txtPC.ReadOnly = true;
            this.txtPC.Size = new System.Drawing.Size(143, 20);
            this.txtPC.TabIndex = 9;
            // 
            // txtUserAccess
            // 
            this.txtUserAccess.Location = new System.Drawing.Point(85, 96);
            this.txtUserAccess.Name = "txtUserAccess";
            this.txtUserAccess.ReadOnly = true;
            this.txtUserAccess.Size = new System.Drawing.Size(143, 20);
            this.txtUserAccess.TabIndex = 10;
            // 
            // txtLogServer
            // 
            this.txtLogServer.Location = new System.Drawing.Point(85, 122);
            this.txtLogServer.Name = "txtLogServer";
            this.txtLogServer.ReadOnly = true;
            this.txtLogServer.Size = new System.Drawing.Size(143, 20);
            this.txtLogServer.TabIndex = 11;
            // 
            // lblLog
            // 
            this.lblLog.AutoSize = true;
            this.lblLog.Location = new System.Drawing.Point(6, 125);
            this.lblLog.Name = "lblLog";
            this.lblLog.Size = new System.Drawing.Size(62, 13);
            this.lblLog.TabIndex = 12;
            this.lblLog.Text = "Log Server:";
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.btnExit);
            this.groupBox1.Controls.Add(this.btnSettings);
            this.groupBox1.Controls.Add(this.btnReCheck);
            this.groupBox1.Controls.Add(this.lblDomain);
            this.groupBox1.Controls.Add(this.lblUser);
            this.groupBox1.Controls.Add(this.txtLogServer);
            this.groupBox1.Controls.Add(this.txtUserAccess);
            this.groupBox1.Controls.Add(this.lblUserAccess);
            this.groupBox1.Controls.Add(this.txtPC);
            this.groupBox1.Controls.Add(this.lblLog);
            this.groupBox1.Controls.Add(this.txtUser);
            this.groupBox1.Controls.Add(this.lblPC);
            this.groupBox1.Controls.Add(this.txtDomain);
            this.groupBox1.Location = new System.Drawing.Point(11, 67);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(325, 161);
            this.groupBox1.TabIndex = 15;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "Information Panel";
            // 
            // btnExit
            // 
            this.btnExit.Location = new System.Drawing.Point(234, 122);
            this.btnExit.Name = "btnExit";
            this.btnExit.Size = new System.Drawing.Size(85, 20);
            this.btnExit.TabIndex = 18;
            this.btnExit.Text = "Exit";
            this.btnExit.UseVisualStyleBackColor = true;
            this.btnExit.Click += new System.EventHandler(this.btnExit_Click);
            // 
            // btnSettings
            // 
            this.btnSettings.Enabled = false;
            this.btnSettings.Location = new System.Drawing.Point(234, 70);
            this.btnSettings.Name = "btnSettings";
            this.btnSettings.Size = new System.Drawing.Size(85, 46);
            this.btnSettings.TabIndex = 17;
            this.btnSettings.Text = "Settings";
            this.btnSettings.UseVisualStyleBackColor = true;
            this.btnSettings.Click += new System.EventHandler(this.btnSettings_Click);
            // 
            // btnReCheck
            // 
            this.btnReCheck.Location = new System.Drawing.Point(234, 19);
            this.btnReCheck.Name = "btnReCheck";
            this.btnReCheck.Size = new System.Drawing.Size(85, 45);
            this.btnReCheck.TabIndex = 16;
            this.btnReCheck.Text = "Check Again!";
            this.btnReCheck.UseVisualStyleBackColor = true;
            this.btnReCheck.Click += new System.EventHandler(this.btnReCheck_Click);
            // 
            // lblActionLog
            // 
            this.lblActionLog.AutoSize = true;
            this.lblActionLog.Location = new System.Drawing.Point(8, 231);
            this.lblActionLog.Name = "lblActionLog";
            this.lblActionLog.Size = new System.Drawing.Size(61, 13);
            this.lblActionLog.TabIndex = 15;
            this.lblActionLog.Text = "Action Log:";
            // 
            // timer1
            // 
            this.timer1.Interval = 1000;
            // 
            // rbtnIP
            // 
            this.rbtnIP.AutoSize = true;
            this.rbtnIP.Location = new System.Drawing.Point(13, 39);
            this.rbtnIP.Name = "rbtnIP";
            this.rbtnIP.Size = new System.Drawing.Size(133, 17);
            this.rbtnIP.TabIndex = 16;
            this.rbtnIP.Text = "Connect by IP Address";
            this.rbtnIP.UseVisualStyleBackColor = true;
            // 
            // rbtnPC
            // 
            this.rbtnPC.AutoSize = true;
            this.rbtnPC.Checked = true;
            this.rbtnPC.Location = new System.Drawing.Point(185, 39);
            this.rbtnPC.Name = "rbtnPC";
            this.rbtnPC.Size = new System.Drawing.Size(158, 17);
            this.rbtnPC.TabIndex = 17;
            this.rbtnPC.TabStop = true;
            this.rbtnPC.Text = "Connect by Computer Name";
            this.rbtnPC.UseVisualStyleBackColor = true;
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(348, 390);
            this.ControlBox = false;
            this.Controls.Add(this.rbtnPC);
            this.Controls.Add(this.rbtnIP);
            this.Controls.Add(this.lblActionLog);
            this.Controls.Add(this.groupBox1);
            this.Controls.Add(this.txtActionLog);
            this.Controls.Add(this.button1);
            this.Controls.Add(this.txtSearch);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.MaximizeBox = false;
            this.Name = "Form1";
            this.Text = "Remote Tools";
            this.Load += new System.EventHandler(this.Form1_Load);
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox txtSearch;
        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.TextBox txtActionLog;
        private System.Windows.Forms.Label lblDomain;
        private System.Windows.Forms.Label lblUser;
        private System.Windows.Forms.Label lblUserAccess;
        private System.Windows.Forms.Label lblPC;
        private System.Windows.Forms.TextBox txtDomain;
        private System.Windows.Forms.TextBox txtUser;
        private System.Windows.Forms.TextBox txtPC;
        private System.Windows.Forms.TextBox txtUserAccess;
        private System.Windows.Forms.TextBox txtLogServer;
        private System.Windows.Forms.Label lblLog;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.Label lblActionLog;
        private System.Windows.Forms.Button btnExit;
        private System.Windows.Forms.Button btnSettings;
        private System.Windows.Forms.Button btnReCheck;
        private System.Windows.Forms.Timer timer1;
        private System.Windows.Forms.RadioButton rbtnIP;
        private System.Windows.Forms.RadioButton rbtnPC;
    }
}

