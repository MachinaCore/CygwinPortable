using System;
using System.Drawing;
using System.IO;
using System.Runtime.InteropServices;

namespace CygwinPortableCS
{
    class IconFromFile
    {
        public static Icon GetSystemIcon(string path)
        {
            try
            {
                Win32.SHFILEINFO psfi = new Win32.SHFILEINFO();
                int dwFileAttributes = 128;
                Win32.SHGFI uFlags = Win32.SHGFI.SHGFI_SYSICONINDEX;
                if (Win32.SHGetFileInfo(path, dwFileAttributes, out psfi, (uint)Marshal.SizeOf((object)psfi), uFlags) == 0)
                    return (Icon)null;
                int iIcon = psfi.iIcon;
                Guid riid = new Guid("46EB5926-582E-4017-9FDF-E8998DAA0950");
                Win32.IImageList ppv;
                Win32.SHGetImageList(2, ref riid, out ppv);
                IntPtr zero = IntPtr.Zero;
                int flags = 1;
                ppv.GetIcon(iIcon, flags, ref zero);
                Icon icon = (Icon)Icon.FromHandle(zero).Clone();
                Win32.DestroyIcon(psfi.hIcon);
                return icon;
            }
            catch
            {
            }
            return (Icon)null;
        }

    }
}
