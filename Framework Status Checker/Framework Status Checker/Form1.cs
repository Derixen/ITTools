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
    public partial class Form1 : Form
    {
        // Global variables
        public static int intRowNumber = 0;
        public static int intCellNumber = 0;
        public static int daysDiff;
        public static int hoursDiff;
        public static int minutesDiff; 

        //Builder
        public Form1()
        {
            InitializeComponent();
        }

        // EVENT HANDLERS
        private void btnScan_Click(object sender, EventArgs e)
        {
            startScan();
        }

        private void btnExit_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void btnAdd_Click(object sender, EventArgs e)
        {
            FormModify frm = new FormModify();
            frm.ShowDialog();

            startScan();
        }

        private void btnModify_Click(object sender, EventArgs e)
        {
            int selectedRowNr = dataGridView1.CurrentCell.RowIndex + 1;

            using (StreamReader sr = new StreamReader("Settings.ini"))
            {
                String line = sr.ReadToEnd();
                string[] lines = line.Split(new string[] { Environment.NewLine }, StringSplitOptions.None);
                int newIndex = 0;

                for (int i = 1; i < lines.Length; i++)
                {
                    string[] tabs = lines[i].Split('\t');
                    if (tabs[0] == selectedRowNr.ToString())
                    {
                        if (!File.Exists("NewEntry.tmp"))
                        {
                            using (StreamWriter sw = File.CreateText("NewEntry.tmp"))
                            {
                                sw.WriteLine(selectedRowNr.ToString() + "\t" + tabs[1] + "\t" + tabs[2] + "\t" + tabs[3] + "\t" + tabs[4] + "\t" + tabs[5]);
                            }
                        }
                        else
                        {
                            TextWriter tw = new StreamWriter("NewEntry.tmp");    
                            tw.WriteLine(newIndex.ToString() + "\t" + tabs[1] + "\t" + tabs[2] + "\t" + tabs[3] + "\t" + tabs[4] + "\t" + tabs[5]);
                            tw.Close();
                        }

                    }
                }

            }

            FormModify frm = new FormModify();
            frm.ShowDialog();
            btnModify.Enabled = false;
            btnRemove.Enabled = false;
            startScan();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            if (!File.Exists("Settings.ini"))
            {
                using (StreamWriter sw = File.CreateText("Settings.ini"))
                {
                    sw.WriteLine("Nr" + "\t" + "Name" + "\t" + "Path" + "\t" + "Day" + "\t" + "Hour" + "\t" + "Minute");
                }
            }
            startScan();
        }

        private void btnRemove_Click(object sender, EventArgs e)
        {
            int selectedRowNr = dataGridView1.CurrentCell.RowIndex + 1;
            if (!File.Exists("Settings.tmp"))
            {
                using (StreamWriter sw = File.CreateText("Settings.tmp"))
                {
                    sw.WriteLine("Nr" + "\t" + "Name" + "\t" + "Path" + "\t" + "Day" + "\t" + "Hour" + "\t" + "Minute");
                }	
            }
            else
            {
                TextWriter tw = new StreamWriter("Settings.tmp");
                tw.WriteLine("Nr" + "\t" + "Name" + "\t" + "Path" + "\t" + "Day" + "\t" + "Hour" + "\t" + "Minute");
                tw.Close();
            }

            using (StreamReader sr = new StreamReader("Settings.ini"))
            {
                String line = sr.ReadToEnd();
                string[] lines = line.Split(new string[] { Environment.NewLine }, StringSplitOptions.None);
                int newIndex = 0;

                for (int i = 1; i < lines.Length; i++)
                {
                    string[] tabs = lines[i].Split('\t');
                    if (tabs[0] != selectedRowNr.ToString() && tabs[0] != "")
                    {
                        newIndex++;
                        using (StreamWriter sw = File.AppendText("Settings.tmp"))
                        {
                            sw.WriteLine(newIndex.ToString() + "\t" + tabs[1] + "\t" + tabs[2] + "\t" + tabs[3] + "\t" + tabs[4] + "\t" + tabs[5]);
                        }
                    }
                }

            }

            File.Delete("Settings.ini");
            File.Move("Settings.tmp", "Settings.ini");

            btnModify.Enabled = false;
            btnRemove.Enabled = false;

            startScan();
        }

        // VOID FUNCTIONS
        private void dateDifference(DateTime date1)
        {
            DateTime date2 = DateTime.Now;
            daysDiff = ((TimeSpan)(date2 - date1)).Days;
            hoursDiff = ((TimeSpan)(date2 - date1)).Hours;
            minutesDiff = ((TimeSpan)(date2 - date1)).Minutes; 
        }

        private void startScan()
        {
            dataGridView1.Rows.Clear();
            dataGridView1.ClearSelection();
            try
            {
                //setting variables
                DateTime FileModificationDate;
                DateTime lastRunTime;
                DateTime nextRunTime;
                TimeSpan duration;
                string sTreshold;
                string sDateDiff;
                string sDateDiff2;
                int iDays;
                int iHours;
                int iMinutes;

                using (StreamReader sr = new StreamReader("Settings.ini"))
                {

                    String line = sr.ReadToEnd();
                    string sStatus;
                    string[] lines = line.Split(new string[] { Environment.NewLine }, StringSplitOptions.None);
                    for (int i = 1; i < lines.Length; i++)
                    {
                        string[] tabs = lines[i].Split('\t');
                        if (string.IsNullOrEmpty(tabs[0]) == false)
                        {
                            FileModificationDate = File.GetLastWriteTime(tabs[2]);
                            Boolean bFileExist = File.Exists(tabs[2]) ? true : false;

                            if (bFileExist)
                            {
                                dateDifference(FileModificationDate);
                                Int32.TryParse(tabs[3], out iDays);
                                Int32.TryParse(tabs[4], out iHours);
                                Int32.TryParse(tabs[5], out iMinutes);
                                duration = new TimeSpan(iDays, iHours, iMinutes, 0);

                                lastRunTime = FileModificationDate;
                                nextRunTime = FileModificationDate.Add(duration);

                                sTreshold = iDays.ToString() + ":" + iHours.ToString() + ":" + iMinutes.ToString();
                                sDateDiff = daysDiff.ToString() + ":" + hoursDiff.ToString() + ":" + minutesDiff.ToString();
                                sDateDiff2 = daysDiff.ToString() + " Days " + hoursDiff.ToString() + " Hours " + minutesDiff.ToString() + " Minutes";
                                Boolean bToMuch = false;
                                if (iDays >= daysDiff)
                                {
                                    if (iDays == daysDiff)
                                    {
                                        if (iHours >= hoursDiff)
                                        {
                                            if (iHours == hoursDiff)
                                            {
                                                if (iMinutes < minutesDiff)
                                                {
                                                    bToMuch = true;
                                                }
                                            }
                                        }
                                        else
                                        {
                                            bToMuch = true;
                                        }
                                    }
                                }
                                else
                                {
                                    bToMuch = true;
                                }

                                if (bToMuch)
                                {
                                    sStatus = "Warning";
                                    this.dataGridView1.Rows.Add(tabs[1], lastRunTime.ToString(), nextRunTime.ToString(), sDateDiff2, sStatus);
                                    this.dataGridView1.Rows[i - 1].DefaultCellStyle.BackColor = Color.Yellow;
                                    //this.dataGridView1.Rows[i - 1].DefaultCellStyle.ForeColor = Color.White;
                                    this.dataGridView1.Rows[i - 1].Cells[4].Style.Alignment = DataGridViewContentAlignment.MiddleCenter;
                                    dataGridView1.ClearSelection();
                                }
                                else
                                {
                                    sStatus = "OK";
                                    this.dataGridView1.Rows.Add(tabs[1], lastRunTime.ToString(), nextRunTime.ToString(), sDateDiff2, sStatus);
                                    this.dataGridView1.Rows[i - 1].Cells[4].Style.BackColor = Color.Green;
                                    this.dataGridView1.Rows[i - 1].Cells[4].Style.ForeColor = Color.White;
                                    this.dataGridView1.Rows[i - 1].Cells[4].Style.Alignment = DataGridViewContentAlignment.MiddleCenter;
                                    dataGridView1.ClearSelection();
                                }

                            }
                            else
                            {
                                this.dataGridView1.Rows.Add(tabs[1], "- File not found -", "- File not found -", "- File not found -", "Error");
                                this.dataGridView1.Rows[i - 1].DefaultCellStyle.BackColor = Color.Red;
                                this.dataGridView1.Rows[i - 1].DefaultCellStyle.ForeColor = Color.White;
                                this.dataGridView1.Rows[i - 1].Cells[1].Style.Alignment = DataGridViewContentAlignment.MiddleCenter;
                                this.dataGridView1.Rows[i - 1].Cells[2].Style.Alignment = DataGridViewContentAlignment.MiddleCenter;
                                this.dataGridView1.Rows[i - 1].Cells[3].Style.Alignment = DataGridViewContentAlignment.MiddleCenter;
                                this.dataGridView1.Rows[i - 1].Cells[4].Style.Alignment = DataGridViewContentAlignment.MiddleCenter;
                                dataGridView1.ClearSelection();
                            }
                        }
                        
                    }
                }
            }
            catch (Exception sel)
            {
                this.dataGridView1.Rows.Add(sel.Message, "Error", "Error", "Error", "Error");
                this.dataGridView1.RowsDefaultCellStyle.BackColor = Color.Red;
                this.dataGridView1.RowsDefaultCellStyle.ForeColor = Color.White;
                this.dataGridView1.RowsDefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;
            }
        }

        private void dataGridView1_Click(object sender, EventArgs e)
        {
            foreach (DataGridViewRow row in dataGridView1.Rows)
            {
                if (this.dataGridView1.SelectedRows.Count == 1)
                {
                    // get information of 1st column from the row
                    btnModify.Enabled = true;
                    btnRemove.Enabled = true;
                }
                else
                {
                    btnModify.Enabled = false;
                    btnRemove.Enabled = false;
                    dataGridView1.ClearSelection();
                }
            }
        }

        

    }
}
