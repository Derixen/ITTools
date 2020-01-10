using Microsoft.Win32;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Diagnostics;
using System.IO;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace Evosoft_Notification_Window
{
    // Modifiable
    public partial class MainWindow : Window
    {
        public static string buttonAction = "Output.txt";
        public static string strRegQuit = string.Empty;
        public MainWindow()
        {
            InitializeComponent();
        }

        private void Form1_Loaded(object sender, RoutedEventArgs e)
        {
            string str = string.Empty;

            ReadIni();

            try
            {
                using (RegistryKey key = Registry.CurrentUser.OpenSubKey(@"SOFTWARE\Evosoft\Notifications"))
                {
                    if (key != null)
                    {
                        str = key.GetValue(strRegQuit).ToString();
                        key.Close();
                    }
                }
            }
            catch (Exception)
            {
                //System.Windows.Application.Current.Shutdown();
            }

            if (str == "1")
            {
                System.Windows.Application.Current.Shutdown();
            }

        }

        public void SetImage(string PictureFile)
        {
            string PicturePath = Directory.GetCurrentDirectory() + "\\" + PictureFile;
            string absolutePicturePath = System.IO.Path.GetFullPath(PicturePath);

            if (File.Exists(PicturePath))
            {
                myImage.Stretch = Stretch.Fill;
                myImage.StretchDirection = StretchDirection.Both;
                BitmapImage myBitmapImage = new BitmapImage();
                myBitmapImage.BeginInit();
                myBitmapImage.UriSource = new Uri(absolutePicturePath);
                myBitmapImage.EndInit();

                myImage.Source = myBitmapImage;
            }
            else
            {
                lblPicture.Content = "- ERROR: Picture file could not be loaded! -";
            }

        }
        public void ReadIni()
        {
            string filePath = Directory.GetCurrentDirectory() + "\\Settings.ini";
            string IniVariable = "";
            string IniValue = "";

            if (File.Exists(filePath))
            {
                foreach (string line in File.ReadLines(filePath, Encoding.UTF8))
                {
                    //MessageBox.Show(line);
                    if (line.Length > 0)
                    {
                        if (line[0] == '[')
                        {
                            IniVariable = line.Substring(line.IndexOf("[") + 1, line.IndexOf("]") - line.IndexOf("[") - 1);
                            IniValue = line.Substring(line.IndexOf("=") + 1, line.Length - line.IndexOf("=") - 1);
                            switch (IniVariable)
                            {
                                case "NotificationTitle":
                                    tbTitle.Text = IniValue.Trim();
                                    strRegQuit = IniValue.Trim().Replace(" ", string.Empty);
                                    break;
                                case "NotificationTitleFontSize":
                                    try
                                    {
                                        tbTitle.FontSize = Int32.Parse(IniValue.Trim());
                                    }
                                    catch (Exception ex)
                                    {
                                        MessageBox.Show("NotificationTitleFontSize - " + ex.Message);
                                        System.Windows.Application.Current.Shutdown();
                                    }
                                    break;
                                case "NotificationTitleFontFamily":
                                    tbTitle.FontFamily = new FontFamily(IniValue.Trim());
                                    break;
                                case "NotificationBodyFontSize":
                                    try
                                    {
                                        tbBody.FontSize = Int32.Parse(IniValue.Trim());
                                    }
                                    catch (Exception ex)
                                    {
                                        MessageBox.Show("NotificationBodyFontSize - " + ex.Message);
                                        System.Windows.Application.Current.Shutdown();
                                    }
                                    break;
                                case "NotificationBodyFontFamily":
                                    tbBody.FontFamily = new FontFamily(IniValue.Trim());
                                    break;
                                case "NotificationBody":
                                    if (File.Exists(Directory.GetCurrentDirectory() + "\\" + IniValue.Trim()))
                                    {
                                        tbBody.Text = File.ReadAllText(Directory.GetCurrentDirectory() + "\\" + IniValue.Trim(), Encoding.UTF8);
                                    }
                                    else
                                    {
                                        tbBody.Text = "- ERROR: Could not load content for notification body -";
                                        tbBody.FontStyle = FontStyles.Italic;
                                        tbBody.Foreground = Brushes.Red;
                                    }
                                    break;


                                case "ImportantFile":
                                    if (File.Exists(Directory.GetCurrentDirectory() + "\\" + IniValue.Trim()))
                                    {
                                        tbImportant.Text = File.ReadAllText(Directory.GetCurrentDirectory() + "\\" + IniValue.Trim(), Encoding.UTF8);
                                        tbImportant.CharacterCasing = CharacterCasing.Upper;
                                    }
                                    else
                                    {
                                        tbImportant.Text = "- ERROR: Could not load content for notification body -";
                                        tbImportant.FontStyle = FontStyles.Italic;
                                        tbImportant.Foreground = Brushes.Red;
                                    }
                                    break;
                                case "ImportantFontSize":
                                    try
                                    {
                                        tbImportant.FontSize = Int32.Parse(IniValue.Trim());
                                    }
                                    catch (Exception ex)
                                    {
                                        MessageBox.Show("NotificationBodyFontSize - " + ex.Message);
                                        System.Windows.Application.Current.Shutdown();
                                    }
                                    break;
                                case "ImportantFontFamily":
                                    tbImportant.FontFamily = new FontFamily(IniValue.Trim());
                                    break;


                                case "FormHeight":
                                    try
                                    {
                                        Form1.Height = Int32.Parse(IniValue.Trim());
                                    }
                                    catch (Exception ex)
                                    {
                                        MessageBox.Show("FormHeight - " + ex.Message);
                                        System.Windows.Application.Current.Shutdown();
                                    }
                                    break;
                                case "FormWidth":
                                    try
                                    {
                                        Form1.Width = Int32.Parse(IniValue.Trim());
                                    }
                                    catch (Exception ex)
                                    {
                                        MessageBox.Show("FormWidth - " + ex.Message);
                                        System.Windows.Application.Current.Shutdown();
                                    }
                                    break;


                                case "BodyAreaHeightRatio":
                                    try
                                    {
                                        mainGrid.RowDefinitions[3].Height = new GridLength(Int32.Parse(IniValue.Trim()), GridUnitType.Star);
                                    }
                                    catch (Exception ex)
                                    {
                                        MessageBox.Show("BodyAreaHeight - " + ex.Message);
                                        System.Windows.Application.Current.Shutdown();
                                    }
                                    break;
                                case "ImportantAreaHeightRatio":
                                    try
                                    {
                                        mainGrid.RowDefinitions[4].Height = new GridLength(Int32.Parse(IniValue.Trim()), GridUnitType.Star);
                                    }
                                    catch (Exception ex)
                                    {
                                        MessageBox.Show("BodyAreaHeight - " + ex.Message);
                                        System.Windows.Application.Current.Shutdown();
                                    }
                                    break;
                                case "PictureAreaHeight":
                                    try
                                    {
                                        mainGrid.RowDefinitions[9].Height = new GridLength(Int32.Parse(IniValue.Trim()));
                                    }
                                    catch (Exception ex)
                                    {
                                        MessageBox.Show("PictureAreaHeight - " + ex.Message);
                                        System.Windows.Application.Current.Shutdown();
                                    }
                                    break;
                                case "MiddleButtonText":
                                    btnAction.Content = IniValue.Trim();
                                    break;
                                case "MiddleButtonAction":
                                    buttonAction = IniValue.Trim();
                                    break;
                                case "MiddleButtonEnabled":
                                    try
                                    {
                                        btnAction.IsEnabled = bool.Parse(IniValue.Trim());
                                    }
                                    catch (Exception ex)
                                    {
                                        MessageBox.Show("MiddleButtonEnabled - " + ex.Message);
                                        System.Windows.Application.Current.Shutdown();
                                    }
                                    break;
                                case "PictureFileName":
                                    SetImage(IniValue.Trim());
                                    break;
                                case "DoNotShowAgainCheckboxEnabled":
                                    try
                                    {
                                        cbDoNotShow.IsEnabled = bool.Parse(IniValue.Trim());
                                    }
                                    catch (Exception ex)
                                    {
                                        MessageBox.Show("DoNotShowAgainCheckboxEnabled - " + ex.Message);
                                        System.Windows.Application.Current.Shutdown();
                                    }
                                    break;
                                case "DoNotShowAgainCheckboxText":
                                    cbDoNotShow.Content = IniValue.Trim();
                                    break;
                                    //MessageBox.Show(line.Substring(line.IndexOf("[")+1, line.IndexOf("]") - line.IndexOf("[") - 1 ));
                                    //MessageBox.Show(line.Substring(line.IndexOf("=") + 1, line.Length - line.IndexOf("=") - 1));
                            }
                        }
                    }

                }
            }
            else
            {
                System.Windows.Application.Current.Shutdown();
            }

        }

        private void btnAction_Click(object sender, RoutedEventArgs e)
        {
            Process.Start(buttonAction);
            System.Windows.Application.Current.Shutdown();
        }

        private void cbDoNotShow_Checked(object sender, RoutedEventArgs e)
        {

            try
            {
                RegistryKey key = Microsoft.Win32.Registry.CurrentUser.CreateSubKey(@"SOFTWARE\Evosoft\Notifications");
                key.SetValue(strRegQuit, "1");
                key.Close();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error while changing settings. Error: " + ex.Message);
            }

        }

        private void cbDoNotShow_Unchecked(object sender, RoutedEventArgs e)
        {
            try
            {
                RegistryKey key = Microsoft.Win32.Registry.CurrentUser.CreateSubKey(@"SOFTWARE\Evosoft\Notifications");
                key.SetValue(strRegQuit, "0");
                key.Close();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error while changing settings. Error: " + ex.Message);
            }
        }

        private void btnExit_Click(object sender, RoutedEventArgs e)
        {
            System.Windows.Application.Current.Shutdown();
        }

        private void tbSignature_TextChanged(object sender, TextChangedEventArgs e)
        {

        }
    }
}
