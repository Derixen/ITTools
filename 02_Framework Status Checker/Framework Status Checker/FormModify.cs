using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.IO;

namespace Framework_Status_Checker
{
    public partial class FormModify : Form
    {
        public static Boolean bModify = false;
        public static int rowNumber;
        public FormModify()
        {
            InitializeComponent();
        }

        private void FormModify_Load(object sender, EventArgs e)
        {
            lWarningName.Text = "";
            lWarningPath.Text = "";
            bModify = false;

            if (File.Exists("NewEntry.tmp"))
            {
                using (StreamReader sr = new StreamReader("NewEntry.tmp"))
                {
                    String line = sr.ReadToEnd();
                    string[] lines = line.Split(new string[] { Environment.NewLine }, StringSplitOptions.None);
                    string[] tabs = lines[0].Split('\t');
                    decimal szamok;

                    int.TryParse(tabs[0], out rowNumber);
                    tbName.Text = tabs[1];
                    tbPath.Text = tabs[2];
                    Decimal.TryParse(tabs[3], out szamok);
                    nudDays.Value = szamok;
                    Decimal.TryParse(tabs[4], out szamok);
                    nudHours.Value = szamok;
                    Decimal.TryParse(tabs[5], out szamok);
                    nudMinutes.Value = szamok;
                    sr.Close();
                }
                File.Delete("NewEntry.tmp");
                bModify = true;
            }

            if (File.Exists("newRow.tmp"))
            {
                File.Delete("newRow.tmp");
            }

        }

        private void AddNewEntry()
        {
            if (tbName.Text != "" && tbPath.Text != "")
            {
                int iRowNumber = 0;
                Boolean bUniqueName = true;
                Boolean bEmptyLine = false;
                using (StreamReader sr = new StreamReader("Data.dat"))
                {
                    String line = sr.ReadToEnd();
                    string[] lines = line.Split(new string[] { Environment.NewLine }, StringSplitOptions.None);

                    for (int i = 1; i < lines.Length; i++)
                    {
                        string[] tabs2 = lines[i].Split('\t');
                        if (tabs2[0] != "")
                        {
                            if (tabs2[1] == tbName.Text)
                            {
                                lWarningName.Text = "* Please enter a different name!";
                                MessageBox.Show("A Framework with this Name already exists! Please choose a different name.", "Warning", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                                bUniqueName = false;
                            }
                        }

                    }

                    string[] tabs = lines[lines.Length - 1].Split('\t');
                    if (string.IsNullOrEmpty(tabs[0]) == false)
                    {
                        iRowNumber = lines.Length;
                        bEmptyLine = false;
                    }
                    else
                    {
                        iRowNumber = lines.Length - 1;
                        bEmptyLine = true;
                    }
                }

                if (bUniqueName)
                {
                    using (StreamWriter sw = File.AppendText("Data.dat"))
                    {
                        if (bEmptyLine)
                        {
                            sw.WriteLine(iRowNumber.ToString() + "\t" + tbName.Text + "\t" + tbPath.Text + "\t" + nudDays.Value + "\t" + nudHours.Value + "\t" + nudMinutes.Value);
                        }
                        else
                        {
                            sw.WriteLine(Environment.NewLine + iRowNumber.ToString() + "\t" + tbName.Text + "\t" + tbPath.Text + "\t" + nudDays.Value + "\t" + nudHours.Value + "\t" + nudMinutes.Value);
                        }
                    }
                    this.Close();
                }

            }
            else
            {

                if (tbName.Text == "")
                {
                    lWarningName.Text = "* Please enter a name!";
                }

                if (tbPath.Text == "")
                {
                    lWarningPath.Text = "* Please enter a Path!";
                }

                MessageBox.Show("You have not provided enough data!", "Warning", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }
        private void ModifyEntry()
        {

            if (tbName.Text != "" && tbPath.Text != "")
            {

                //File.Create("newRow.tmp");

                using (StreamReader sr = new StreamReader("data.dat"))
                {
                    String line = sr.ReadToEnd();
                    string[] lines = line.Split(new string[] { Environment.NewLine }, StringSplitOptions.None);

                    using (StreamWriter sw = File.AppendText("newRow.tmp"))
                    {
                        for (int i = 0; i < lines.Length; i++)
                        {
                            string[] tabs = lines[i].Split('\t');
                            if (tabs.Length == 6)
                            {
                                if (tabs[0] != rowNumber.ToString())
                                {
                                    sw.WriteLine(tabs[0] + "\t" + tabs[1] + "\t" + tabs[2] + "\t" + tabs[3] + "\t" + tabs[4] + "\t" + tabs[5]);
                                }
                                else
                                {
                                    sw.WriteLine(tabs[0] + "\t" + tbName.Text + "\t" + tbPath.Text + "\t" + nudDays.Value.ToString() + "\t" + nudHours.Value.ToString() + "\t" + nudMinutes.Value.ToString());
                                }
                            }
                        }
                        sw.Close();
                    }
                    sr.Close();
                    
                }

                File.Delete("Data.dat");
                File.Move("newRow.tmp", "Data.dat");

                this.Close();

            }
            else
            {
                if (tbName.Text == "")
                {
                    lWarningName.Text = "* Please enter a name!";
                }

                if (tbPath.Text == "")
                {
                    lWarningPath.Text = "* Please enter a Path!";
                }

                MessageBox.Show("You have not provided enough data!", "Warning", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void btnCancel_Click(object sender, EventArgs e)
        {
            this.Close();
        }
        private void btnOK_Click(object sender, EventArgs e)
        {
            lWarningName.Text = "";
            lWarningPath.Text = "";

            if (bModify)
            {
                ModifyEntry();
            }
            else
            {
                AddNewEntry();
            }
        }
        private void btnBrowse_Click(object sender, EventArgs e)
        {
            OpenFileDialog openFileDialog1 = new OpenFileDialog();

            // Set filter options and filter index.
            openFileDialog1.Filter = "Text Files (.txt)|*.txt|All Files (*.*)|*.*";
            openFileDialog1.FilterIndex = 1;

            openFileDialog1.Multiselect = true;

            // Call the ShowDialog method to show the dialog box.bool? userClickedOK = openFileDialog1.ShowDialog();

            // Process input if the user clicked OK.

            openFileDialog1.ShowDialog();

            //if (userClickedOK == true)
            //{
            // Open the selected file to read.
            string sFilePath = openFileDialog1.FileName.ToString();
            tbPath.Text = sFilePath;
        }
    }
}
