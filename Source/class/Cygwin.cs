using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Runtime.InteropServices;

namespace CygwinPortableCS
{
    class Cygwin
    {
        public static string GetShortcutTarget(string file)
        {
            try
            {
                var extension = Path.GetExtension(file);
                if (extension != null && extension.ToLower() != ".lnk")
                {
                    throw new Exception("Supplied file must be a .LNK file");
                }

                FileStream fileStream = File.Open(file, FileMode.Open, FileAccess.Read);
                using (System.IO.BinaryReader fileReader = new BinaryReader(fileStream))
                {
                    fileStream.Seek(0x14, SeekOrigin.Begin);     // Seek to flags
                    uint flags = fileReader.ReadUInt32();        // Read flags
                    if ((flags & 1) == 1)
                    {                      // Bit 1 set means we have to
                                           // skip the shell item ID list
                        fileStream.Seek(0x4c, SeekOrigin.Begin); // Seek to the end of the header
                        uint offset = fileReader.ReadUInt16();   // Read the length of the Shell item ID list
                        fileStream.Seek(offset, SeekOrigin.Current); // Seek past it (to the file locator info)
                    }

                    long fileInfoStartsAt = fileStream.Position; // Store the offset where the file info
                                                                 // structure begins
                    uint totalStructLength = fileReader.ReadUInt32(); // read the length of the whole struct
                    fileStream.Seek(0xc, SeekOrigin.Current); // seek to offset to base pathname
                    uint fileOffset = fileReader.ReadUInt32(); // read offset to base pathname
                                                               // the offset is from the beginning of the file info struct (fileInfoStartsAt)
                    fileStream.Seek((fileInfoStartsAt + fileOffset), SeekOrigin.Begin); // Seek to beginning of
                                                                                        // base pathname (target)
                    long pathLength = (totalStructLength + fileInfoStartsAt) - fileStream.Position - 2; // read
                                                                                                        // the base pathname. I don't need the 2 terminating nulls.
                    char[] linkTarget = fileReader.ReadChars((int)pathLength); // should be unicode safe
                    var link = new string(linkTarget);

                    int begin = link.IndexOf("\0\0");
                    if (begin > -1)
                    {
                        int end = link.IndexOf("\\\\", begin + 2) + 2;
                        end = link.IndexOf('\0', end) + 1;

                        string firstPart = link.Substring(0, begin);
                        string secondPart = link.Substring(end);

                        return firstPart + secondPart;
                    }
                    else
                    {
                        return link;
                    }
                }
            }
            catch
            {
                return "";
            }
        }

        public static string CygDrivePath(string fileOrFolder)
        {
            string winDrive = "";
            FileInfo file = new FileInfo(fileOrFolder);
            string drive = Path.GetPathRoot(file.FullName);
            Console.WriteLine(drive);
            string path = file.FullName.Replace(drive, "").Replace("\\", "/").Replace(" ", "\\ ").Replace("(", "\\(").Replace(")", "\\)");
            winDrive = drive.Replace(":", "").Replace("\\", "").ToLower();
            return ("/cygdrive/" + winDrive + "/" + path);
        }

        public static string[] Folder2CygFolder(string fileOrFolder)
        {
            //Folder2CygFolder(cygwinPath)[0] -> Complete path (e.g. /cygdrive/c/windows/system32/cmd.exe)
            //Folder2CygFolder(cygwinPath)[1] -> If request is a file (True) or a folder (False)
            //Folder2CygFolder(cygwinPath)[2] -> Path only (e.g. /cygdrive/c/windows/system32)
            //Folder2CygFolder(cygwinPath)[3] -> File only (e.g. cmd.exe)
            //Folder2CygFolder(cygwinPath)[4] -> Extension only (e.g. .exe)
            string[] cygPath = new string[5];
            cygPath[0] = "";
            cygPath[1] = "";
            cygPath[2] = "";
            cygPath[3] = "";
            cygPath[4] = "";

            if (Directory.Exists(fileOrFolder))
            {
                cygPath[0] = CygDrivePath(fileOrFolder);
                cygPath[1] = "folder";
                cygPath[2] = CygDrivePath(fileOrFolder);
            }
            else if (File.Exists(fileOrFolder))
            {
                if (Path.GetExtension(fileOrFolder).ToLower() == ".lnk")
                {
                    string shortcut = GetShortcutTarget(fileOrFolder);
                    if (Directory.Exists(shortcut))
                    {
                        cygPath[0] = CygDrivePath(shortcut);
                        cygPath[1] = "folder";
                        cygPath[2] = CygDrivePath(Path.GetDirectoryName(shortcut));
                    }
                    else if (File.Exists(shortcut))
                    {
                        cygPath[0] = CygDrivePath(shortcut);
                        cygPath[1] = "file";
                        cygPath[2] = CygDrivePath(Path.GetDirectoryName(shortcut));
                        cygPath[3] = Path.GetFileName(shortcut).Replace(" ", "\\ ");
                        cygPath[4] = Path.GetExtension(shortcut);
                    }
                }
                else
                {
                    cygPath[0] = CygDrivePath(fileOrFolder);
                    cygPath[1] = "file";
                    cygPath[2] = CygDrivePath(Path.GetDirectoryName(fileOrFolder));
                    cygPath[3] = Path.GetFileName(fileOrFolder).Replace(" ", "\\ ");
                    cygPath[4] = Path.GetExtension(fileOrFolder);
                }
            }
            else
            {
                Console.WriteLine("Not found");
            }

            return cygPath;
        }

        [DllImport("shell32.dll", EntryPoint = "ShellExecute")]
        public static extern long ShellExecute(int hwnd, string cmd, string file, string param1, string param2, int swmode);

        public static void CygwinOpen(string fileOrFolder)
        {

            string[] cygFolder = new string[5];

            if (fileOrFolder == "~")
            {
                cygFolder[0] = "~";
                cygFolder[1] = "folder";
                cygFolder[2] = "";
                cygFolder[3] = "";
                cygFolder[4] = "";
            }
            else
            {
                cygFolder = Cygwin.Folder2CygFolder(fileOrFolder);
                Console.WriteLine("Fullpath " + cygFolder[0]);
                Console.WriteLine("FileOrFolder " + cygFolder[1]);
                Console.WriteLine("Path " + cygFolder[2]);
                Console.WriteLine("File " + cygFolder[3]);
                Console.WriteLine("Extension " + cygFolder[4]);
            }



            if (!Directory.Exists(Globals.AppPath + "\\Runtime\\cygwin\\home\\" + Globals.Config["Static"]["Username"].StringValue))
            {
                Globals.Config["Main"]["Shell"].StringValue = "mintty";
                if (File.Exists(Globals.AppPath + "\\Runtime\\cygwin\\bin\\bash.exe"))
                {
                    Directory.CreateDirectory(Globals.AppPath + "\\Runtime\\cygwin\\home\\" + Globals.Config["Static"]["Username"].StringValue);
                }
            }
            Console.WriteLine(Environment.GetEnvironmentVariable("PATH"));
            Console.WriteLine(Environment.GetEnvironmentVariable("PATH"));
            Console.WriteLine(Environment.GetEnvironmentVariable("HOME"));
            Console.WriteLine(Environment.GetEnvironmentVariable("USERNAME"));

            string shellStayOpen = "";
            string path = "";
            string parameter = "";
            string pathname = Globals.AppPath;

            if (Convert.ToBoolean(Globals.Config["Main"]["ExitAfterExec"].StringValue) == false)
            {
                shellStayOpen = ";exec /bin/bash.exe'";
            }
            else
            {
                shellStayOpen = "'";
            }

            if (cygFolder[1] == "file")
            {

                string[] extensions = Globals.Config["Main"]["ExecutableExtension"].StringValue.Split(',');
                if (((IList<string>)extensions).Contains(cygFolder[4].Replace(".", "")))
                {
                    Console.WriteLine("Extension valid -> Executing");
                    string executeCommand = ";./" + cygFolder[3];


                    if (Globals.Config["Main"]["Shell"].StringValue == "ConEmu")
                    {
                        path = Globals.AppPath + "\\Runtime\\ConEmu\\ConEmu.exe";
                        parameter = " /cmd " + Globals.AppPath + "\\Runtime\\cygwin\\bin\\bash.exe --login -i -c 'cd " + cygFolder[2] + executeCommand + shellStayOpen;
                    }
                    else
                    {
                        path = Globals.AppPath + "\\Runtime\\cygwin\\bin\\mintty.exe";
                        parameter = " --config /home/" + Globals.Config["Static"]["Username"].StringValue + "/.minttyrc -e /bin/bash.exe -c 'cd " + cygFolder[2] + executeCommand + shellStayOpen;
                    }

                    pathname = Globals.AppPath;

                    Process process = new Process();
                    var processInfo = new ProcessStartInfo();
                    process.StartInfo.UseShellExecute = false;
                    process.StartInfo.Arguments = parameter + " -new_console:C:\"" + Globals.AppPath + "\\AppInfo\\appicon.ico\"";
                    process.StartInfo.FileName = path;
                    //process.StartInfo.WorkingDirectory = Environment.CurrentDirectory;

                    //Workaround for Case Sensitive variables in .NET 2.0-3.5 -> Its fixed in .NET 4.0
                    //Not really beautiful but working...
                    System.Reflection.FieldInfo contentsField = typeof(System.Collections.Specialized.StringDictionary).GetField("contents", System.Reflection.BindingFlags.Instance | System.Reflection.BindingFlags.NonPublic);
                    System.Collections.Hashtable environment = (System.Collections.Hashtable)contentsField.GetValue(process.StartInfo.EnvironmentVariables);

                    if (Directory.Exists(Globals.PortableAppsPath + "\\PortableApps"))
                    {
                        Console.WriteLine("Running in PortableApps Environment");
                        environment.Remove("PORTABLEAPPS");
                        environment.Add("PORTABLEAPPS", "true");
                    }
                    else
                    {
                        environment.Remove("PORTABLEAPPS");
                        environment.Add("PORTABLEAPPS", "false");
                    }

                    string pathvar = Environment.GetEnvironmentVariable("PATH");
                    if (Globals.Config["Main"]["WindowsPathToCygwin"].BoolValue)
                    {
                        environment.Remove("PATH");
                        environment.Add("PATH", pathvar + ";" + Globals.Config["Main"]["WindowsAdditionalPath"] + ";" + Globals.AppPath + "\\Runtime\\cygwin\\bin");
                    }
                    else
                    {
                        environment.Remove("PATH");
                        environment.Add("PATH", pathvar + ";" + Globals.AppPath + "\\Runtime\\cygwin\\bin");
                    }
                    environment.Remove("ALLUSERSPROFILE");
                    environment.Add("ALLUSERSPROFILE", "C:\\ProgramData");
                    environment.Remove("ProgramData");
                    environment.Add("ProgramData", "C:\\ProgramData");
                    environment.Remove("CYGWIN_HOME");
                    environment.Add("CYGWIN_HOME", Globals.AppPath + "\\Runtime\\cygwin");
                    environment.Remove("USER");
                    environment.Add("USER", Globals.Config["Static"]["Username"].StringValue);
                    environment.Remove("USERNAME");
                    environment.Add("USERNAME", Globals.Config["Static"]["Username"].StringValue);
                    environment.Remove("HOME");
                    environment.Add("HOME", "/home/" + Globals.Config["Static"]["Username"].StringValue);
                    environment.Remove("USBDRV");
                    environment.Add("USBDRV", Path.GetPathRoot(Globals.AppPath));
                    environment.Remove("USBDRVPATH");
                    environment.Add("USBDRVPATH", Path.GetPathRoot(Globals.AppPath));
                    if (Globals.Config["Main"]["WindowsPythonPath"].StringValue != "")
                    {
                        environment.Remove("PYTHONPATH");
                        environment.Add("PYTHONPATH", Globals.Config["Main"]["WindowsPythonPath"].StringValue);
                    }
                    //This is the normal .NET way -> Dont works in 2.0 $HOME is $home in cygwin
                    //process.StartInfo.EnvironmentVariables["USER"] = "cygwin";
                    process.Start();



                }

            }
            if (cygFolder[1] == "folder")
            {
                if (Globals.Config["Main"]["Shell"].StringValue == "ConEmu")
                {
                    path = Globals.AppPath + "\\Runtime\\ConEmu\\ConEmu.exe";
                    parameter = " /cmd " + Globals.AppPath + "\\Runtime\\cygwin\\bin\\bash.exe --login -i -c 'cd " + cygFolder[0] + shellStayOpen;
                }
                else
                {
                    path = Globals.AppPath + "\\Runtime\\cygwin\\bin\\mintty.exe";
                    parameter = " --config /home/" + Globals.Config["Static"]["Username"].StringValue + "/.minttyrc -e /bin/bash.exe -c 'cd " + cygFolder[0] + shellStayOpen;
                }

                pathname = Globals.AppPath;
                Process process = new Process();
                var processInfo = new ProcessStartInfo();
                process.StartInfo.UseShellExecute = false;
                process.StartInfo.Arguments = parameter + " -new_console:C:\""+ Globals.AppPath + "\\AppInfo\\appicon.ico\"";
                process.StartInfo.FileName = path;
                //process.StartInfo.WorkingDirectory = Environment.CurrentDirectory;
                System.Reflection.FieldInfo contentsField = typeof(System.Collections.Specialized.StringDictionary).GetField("contents", System.Reflection.BindingFlags.Instance | System.Reflection.BindingFlags.NonPublic);
                System.Collections.Hashtable environment = (System.Collections.Hashtable)contentsField.GetValue(process.StartInfo.EnvironmentVariables);

                if (Directory.Exists(Globals.PortableAppsPath + "\\PortableApps"))
                {
                    Console.WriteLine("Running in PortableApps Environment");
                    environment.Remove("PORTABLEAPPS");
                    environment.Add("PORTABLEAPPS", "true");
                }
                else
                {
                    environment.Remove("PORTABLEAPPS");
                    environment.Add("PORTABLEAPPS", "false");
                }

                string pathvar = Environment.GetEnvironmentVariable("PATH");
                if (Globals.Config["Main"]["WindowsPathToCygwin"].BoolValue)
                {
                    environment.Remove("PATH");
                    environment.Add("PATH", pathvar + ";" + Globals.Config["Main"]["WindowsAdditionalPath"] + ";" + Globals.AppPath + "\\Runtime\\cygwin\\bin");
                }
                else
                {
                    environment.Remove("PATH");
                    environment.Add("PATH", pathvar + ";" + Globals.AppPath + "\\Runtime\\cygwin\\bin");
                }
                environment.Remove("ALLUSERSPROFILE");
                environment.Add("ALLUSERSPROFILE", "C:\\ProgramData");
                environment.Remove("ProgramData");
                environment.Add("ProgramData", "C:\\ProgramData");
                environment.Remove("CYGWIN_HOME");
                environment.Add("CYGWIN_HOME", Globals.AppPath + "\\Runtime\\cygwin");
                environment.Remove("USER");
                environment.Add("USER", Globals.Config["Static"]["Username"].StringValue);
                environment.Remove("USERNAME");
                environment.Add("USERNAME", Globals.Config["Static"]["Username"].StringValue);
                environment.Remove("HOME");
                environment.Add("HOME", "/home/" + Globals.Config["Static"]["Username"].StringValue);
                environment.Remove("USBDRV");
                environment.Add("USBDRV", Path.GetPathRoot(Globals.AppPath));
                environment.Remove("USBDRVPATH");
                environment.Add("USBDRVPATH", Path.GetPathRoot(Globals.AppPath));
                if (Globals.Config["Main"]["WindowsPythonPath"].StringValue != "")
                {
                    environment.Remove("PYTHONPATH");
                    environment.Add("PYTHONPATH", Globals.Config["Main"]["WindowsPythonPath"].StringValue);
                }
                process.Start();
            }

            }
    }
}
