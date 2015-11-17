using System;
using System.Drawing;
using System.IO;
using System.Runtime.InteropServices;

namespace CygwinPortableCS
{
    class IconFromFile
{
        /* Get Icons */
        private delegate Icon DelegateGetSystemIcon(string path, IconSizeEnum iconsize);

        public enum IconSizeEnum
        {
            SmallIcon16 = Win32.SHIL_SYSSMALL,
            MediumIcon32 = Win32.SHIL_LARGE,
            LargeIcon48 = Win32.SHIL_EXTRALARGE,
            ExtraLargeIcon = Win32.SHIL_JUMBO
        }


        private static Bitmap GetSystemBitmap(string path, IconSizeEnum iconsize)
        {
            Icon icon = GetSystemIcon(path, iconsize);
            return icon.ToBitmap();
        }

        private static Icon GetSystemIcon(string path, IconSizeEnum iconsize)
        {
            try
            {
                Win32.SHFILEINFO psfi = new Win32.SHFILEINFO();
                int dwFileAttributes = 128;
                Win32.SHGFI uFlags = Win32.SHGFI.SHGFI_SYSICONINDEX;
                if (Win32.SHGetFileInfo(path, dwFileAttributes, out psfi, (uint)Marshal.SizeOf((object)psfi), uFlags) == 0)
                    return (Icon)null;
                int i = psfi.iIcon;
                Guid riid = new Guid("46EB5926-582E-4017-9FDF-E8998DAA0950");
                Win32.IImageList ppv;
                Win32.SHGetImageList((int)iconsize, ref riid, out ppv);
                IntPtr picon = IntPtr.Zero;
                int flags = 1;
                ppv.GetIcon(i, flags, ref picon);
                Icon icon = (Icon)Icon.FromHandle(picon).Clone();
                Win32.DestroyIcon(psfi.hIcon);
                return icon;
            }
            catch
            {
            }
            return (Icon)null;
        }


        private static Icon GetIcon(string path)
        {
            try
            {
                Win32.SHFILEINFO psfi = new Win32.SHFILEINFO();
                Win32.SHGFI uFlags = (Win32.SHGFI)(256 | (int)Globals.RuntimeSettings["defaultFileIconType"]);
                if (Win32.SHGetFileInfo(path, 0, out psfi, (uint)Marshal.SizeOf((object)psfi), uFlags) == 0 || psfi.hIcon == IntPtr.Zero)
                    return (Icon)null;
                Icon icon = (Icon)Icon.FromHandle(psfi.hIcon).Clone();
                Win32.DestroyIcon(psfi.hIcon);
                return icon;
            }
            catch
            {
            }
            return (Icon)null;
        }


        public static Icon GetFileIcon(string path, IconSizeEnum iconsize)
        {
            if (string.IsNullOrEmpty(path))
                return (Icon)null;
            try
            {
                if (!File.Exists(path) && !Directory.Exists(path))
                {
                    if (path.Equals("\\"))
                        goto nullIcon;
                }

                //Mono dont support PNG icon (crash if try to use ICON.ToBitmap())
                if ((bool)Globals.RuntimeSettings["Mono"] == true)
                {
                    return GetIcon(path);
                }
                if ((int)Globals.RuntimeSettings["defaultFileIconType"] != 16384)
                {
                    return GetIcon(path);
                }
                DelegateGetSystemIcon delegateGetSystemIcon = new DelegateGetSystemIcon(GetSystemIcon);
                IAsyncResult result = delegateGetSystemIcon.BeginInvoke(path, iconsize, (AsyncCallback)null, (object)null);
                return delegateGetSystemIcon.EndInvoke(result);
            }
            catch
            {
            }
        nullIcon:
            return (Icon)null;
        }
    }
}
