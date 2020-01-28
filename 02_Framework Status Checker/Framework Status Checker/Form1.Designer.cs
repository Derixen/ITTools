namespace Framework_Status_Checker
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Form1));
            this.dataGridView1 = new System.Windows.Forms.DataGridView();
            this.DisplayName = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.LastModified = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.ElapsedTime = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Elapsed = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Status = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.btnRemove = new System.Windows.Forms.Button();
            this.btnAdd = new System.Windows.Forms.Button();
            this.btnModify = new System.Windows.Forms.Button();
            this.btnExit = new System.Windows.Forms.Button();
            this.btnScan = new System.Windows.Forms.Button();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).BeginInit();
            this.SuspendLayout();
            // 
            // dataGridView1
            // 
            this.dataGridView1.AllowUserToAddRows = false;
            this.dataGridView1.AllowUserToDeleteRows = false;
            this.dataGridView1.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.DisableResizing;
            this.dataGridView1.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.DisplayName,
            this.LastModified,
            this.ElapsedTime,
            this.Elapsed,
            this.Status});
            this.dataGridView1.Location = new System.Drawing.Point(12, 12);
            this.dataGridView1.MultiSelect = false;
            this.dataGridView1.Name = "dataGridView1";
            this.dataGridView1.ReadOnly = true;
            this.dataGridView1.RowHeadersWidthSizeMode = System.Windows.Forms.DataGridViewRowHeadersWidthSizeMode.DisableResizing;
            this.dataGridView1.Size = new System.Drawing.Size(641, 291);
            this.dataGridView1.TabIndex = 0;
            this.dataGridView1.Click += new System.EventHandler(this.dataGridView1_Click);
            // 
            // DisplayName
            // 
            this.DisplayName.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.DisplayName.FillWeight = 25F;
            this.DisplayName.HeaderText = "Name";
            this.DisplayName.Name = "DisplayName";
            this.DisplayName.ReadOnly = true;
            this.DisplayName.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.NotSortable;
            this.DisplayName.ToolTipText = "Name of the Framework Tool";
            // 
            // LastModified
            // 
            this.LastModified.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.LastModified.FillWeight = 20F;
            this.LastModified.HeaderText = "Last Run Time";
            this.LastModified.Name = "LastModified";
            this.LastModified.ReadOnly = true;
            this.LastModified.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.NotSortable;
            // 
            // ElapsedTime
            // 
            this.ElapsedTime.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.ElapsedTime.FillWeight = 20F;
            this.ElapsedTime.HeaderText = "Planned Next Start";
            this.ElapsedTime.Name = "ElapsedTime";
            this.ElapsedTime.ReadOnly = true;
            this.ElapsedTime.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.NotSortable;
            // 
            // Elapsed
            // 
            this.Elapsed.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.Elapsed.FillWeight = 25F;
            this.Elapsed.HeaderText = "Elapsed Time";
            this.Elapsed.Name = "Elapsed";
            this.Elapsed.ReadOnly = true;
            this.Elapsed.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.NotSortable;
            // 
            // Status
            // 
            this.Status.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.Status.FillWeight = 10F;
            this.Status.HeaderText = "Status";
            this.Status.Name = "Status";
            this.Status.ReadOnly = true;
            this.Status.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.NotSortable;
            // 
            // btnRemove
            // 
            this.btnRemove.Enabled = false;
            this.btnRemove.Image = global::Framework_Status_Checker.Properties.Resources.Clearallrequests_8816;
            this.btnRemove.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft;
            this.btnRemove.Location = new System.Drawing.Point(659, 201);
            this.btnRemove.Name = "btnRemove";
            this.btnRemove.Size = new System.Drawing.Size(114, 28);
            this.btnRemove.TabIndex = 6;
            this.btnRemove.Text = "REMOVE";
            this.btnRemove.UseVisualStyleBackColor = true;
            this.btnRemove.Click += new System.EventHandler(this.btnRemove_Click);
            // 
            // btnAdd
            // 
            this.btnAdd.Image = global::Framework_Status_Checker.Properties.Resources.AddMark_10580;
            this.btnAdd.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft;
            this.btnAdd.Location = new System.Drawing.Point(659, 133);
            this.btnAdd.Name = "btnAdd";
            this.btnAdd.Size = new System.Drawing.Size(114, 28);
            this.btnAdd.TabIndex = 5;
            this.btnAdd.Text = "ADD";
            this.btnAdd.UseVisualStyleBackColor = true;
            this.btnAdd.Click += new System.EventHandler(this.btnAdd_Click);
            // 
            // btnModify
            // 
            this.btnModify.Enabled = false;
            this.btnModify.Image = global::Framework_Status_Checker.Properties.Resources.PencilTool_206;
            this.btnModify.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft;
            this.btnModify.Location = new System.Drawing.Point(659, 167);
            this.btnModify.Name = "btnModify";
            this.btnModify.Size = new System.Drawing.Size(114, 28);
            this.btnModify.TabIndex = 4;
            this.btnModify.Text = "MODIFY";
            this.btnModify.UseVisualStyleBackColor = true;
            this.btnModify.Click += new System.EventHandler(this.btnModify_Click);
            // 
            // btnExit
            // 
            this.btnExit.Image = global::Framework_Status_Checker.Properties.Resources.GotoNextRow_289_color;
            this.btnExit.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft;
            this.btnExit.Location = new System.Drawing.Point(659, 274);
            this.btnExit.Name = "btnExit";
            this.btnExit.Size = new System.Drawing.Size(114, 28);
            this.btnExit.TabIndex = 2;
            this.btnExit.Text = "Exit";
            this.btnExit.UseVisualStyleBackColor = true;
            this.btnExit.Click += new System.EventHandler(this.btnExit_Click);
            // 
            // btnScan
            // 
            this.btnScan.Image = global::Framework_Status_Checker.Properties.Resources.refresh_16xLG;
            this.btnScan.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft;
            this.btnScan.Location = new System.Drawing.Point(659, 12);
            this.btnScan.Name = "btnScan";
            this.btnScan.Size = new System.Drawing.Size(114, 70);
            this.btnScan.TabIndex = 3;
            this.btnScan.Text = "Refresh";
            this.btnScan.UseVisualStyleBackColor = true;
            this.btnScan.Click += new System.EventHandler(this.btnScan_Click);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(780, 314);
            this.Controls.Add(this.btnRemove);
            this.Controls.Add(this.btnAdd);
            this.Controls.Add(this.btnModify);
            this.Controls.Add(this.btnExit);
            this.Controls.Add(this.btnScan);
            this.Controls.Add(this.dataGridView1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.MaximizeBox = false;
            this.Name = "Form1";
            this.Text = "Logfile Monitoring";
            this.Load += new System.EventHandler(this.Form1_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.DataGridView dataGridView1;
        private System.Windows.Forms.Button btnExit;
        private System.Windows.Forms.Button btnScan;
        private System.Windows.Forms.Button btnModify;
        private System.Windows.Forms.Button btnAdd;
        private System.Windows.Forms.Button btnRemove;
        private System.Windows.Forms.DataGridViewTextBoxColumn DisplayName;
        private System.Windows.Forms.DataGridViewTextBoxColumn LastModified;
        private System.Windows.Forms.DataGridViewTextBoxColumn ElapsedTime;
        private System.Windows.Forms.DataGridViewTextBoxColumn Elapsed;
        private System.Windows.Forms.DataGridViewTextBoxColumn Status;
    }
}

