using System;
using System.Drawing;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;

namespace CygwinPortableCS
{
    public class Win32
    {
        public const uint WM_COMMAND = 273U;
        public const uint WM_CLOSE = 16U;
        public const uint WM_SYSCOMMAND = 274U;
        private const int MAX_PATH = 260;
        private const int MAX_TYPE = 80;
        public const int SHIL_LARGE = 0;
        public const int SHIL_SMALL = 1;
        public const int SHIL_EXTRALARGE = 2;
        public const int SHIL_SYSSMALL = 3;
        public const int SHIL_JUMBO = 4;
        public const uint ERROR_SUCCESS = 0U;
        public const uint ERROR_MORE_DATA = 234U;
        public const int CURSOR_HIDDEN = 0;
        public const int CURSOR_SHOWING = 1;
        public const int CURSOR_SUPPRESSED = 2;

        [DllImport("User32.dll")]
        public static extern IntPtr FindWindow(string lpClassName, string lpWindowName);

        [DllImport("User32.dll")]
        public static extern IntPtr FindWindowEx(IntPtr hwndParent, IntPtr hwndChildAfter, string lpszClass, string lpszWindow);

        [DllImport("user32.dll")]
        public static extern IntPtr GetDesktopWindow();

        [DllImport("User32.dll")]
        public static extern IntPtr SendMessage(IntPtr hWnd, uint Msg, IntPtr wParam, IntPtr lParam);

        [DllImport("user32.dll", SetLastError = true)]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool PostMessage(IntPtr hWnd, uint Msg, IntPtr wParam, IntPtr lParam);

        [DllImport("shell32.dll", CharSet = CharSet.Auto)]
        public static extern int SHGetFileInfo(string pszPath, int dwFileAttributes, out Win32.SHFILEINFO psfi, uint cbfileInfo, Win32.SHGFI uFlags);

        [DllImport("User32.dll")]
        public static extern int DestroyIcon(IntPtr hIcon);

        [DllImport("shell32.dll", EntryPoint = "#727")]
        public static extern int SHGetImageList(int iImageList, ref Guid riid, out Win32.IImageList ppv);

        [DllImport("netapi32.dll")]
        public static extern int NetServerEnum([MarshalAs(UnmanagedType.LPWStr)] string servername, int level, out IntPtr bufptr, int prefmaxlen, ref int entriesread, ref int totalentries, Win32.SV_TYPE servertype, [MarshalAs(UnmanagedType.LPWStr)] string domain, IntPtr resume_handle);

        [DllImport("netapi32.dll")]
        public static extern int NetApiBufferFree(IntPtr buffer);

        [DllImport("user32.dll")]
        public static extern bool GetIconInfo(IntPtr hIcon, out Win32.ICONINFO piconinfo);

        [DllImport("user32.dll")]
        public static extern bool GetCursorInfo(out Win32.CURSORINFO pci);

        [DllImport("user32.dll")]
        public static extern IntPtr CopyIcon(IntPtr hIcon);

        [DllImport("gdi32.dll")]
        public static extern IntPtr CreateCompatibleBitmap(IntPtr hdc, int nWidth, int nHeight);

        [DllImport("gdi32.dll", SetLastError = true)]
        public static extern IntPtr CreateCompatibleDC(IntPtr hdc);

        [DllImport("user32.dll")]
        public static extern IntPtr GetWindowDC(IntPtr hWnd);

        [DllImport("user32.dll")]
        public static extern bool ReleaseDC(IntPtr hWnd, IntPtr hDC);

        [DllImport("gdi32.dll", SetLastError = true)]
        public static extern IntPtr SelectObject(IntPtr hdc, IntPtr hgdiobj);

        [DllImport("gdi32.dll")]
        public static extern bool DeleteObject(IntPtr hObject);

        [DllImport("gdi32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool BitBlt(IntPtr hdc, int nXDest, int nYDest, int nWidth, int nHeight, IntPtr hdcSrc, int nXSrc, int nYSrc, Win32.TernaryRasterOperations dwRop);

        [DllImport("gdi32.dll")]
        public static extern bool DeleteDC(IntPtr hdc);

        [DllImport("psapi.dll", SetLastError = true)]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool GetPerformanceInfo(out Win32.PERFORMANCE_INFORMATION pPerformanceInformation, [In] int cb);

        [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Auto)]
        public struct SHFILEINFO
        {
            public IntPtr hIcon;
            public int iIcon;
            public uint dwAttributes;
            [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 260)]
            public string szDisplayName;
            [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 80)]
            public string szTypeName;

            public SHFILEINFO(bool b)
            {
                this.hIcon = IntPtr.Zero;
                this.iIcon = 0;
                this.dwAttributes = 0U;
                this.szDisplayName = "";
                this.szTypeName = "";
            }
        }

        [Flags]
        public enum SHGFI
        {
            SHGFI_ICON = 256,
            SHGFI_DISPLAYNAME = 512,
            SHGFI_TYPENAME = 1024,
            SHGFI_ATTRIBUTES = 2048,
            SHGFI_ICONLOCATION = 4096,
            SHGFI_EXETYPE = 8192,
            SHGFI_SYSICONINDEX = 16384,
            SHGFI_LINKOVERLAY = 32768,
            SHGFI_SELECTED = 65536,
            SHGFI_ATTR_SPECIFIED = 131072,
            SHGFI_LARGEICON = 0,
            SHGFI_SMALLICON = 1,
            SHGFI_OPENICON = 2,
            SHGFI_SHELLICONSIZE = 4,
            SHGFI_PIDL = 8,
            SHGFI_USEFILEATTRIBUTES = 16,
            SHGFI_ADDOVERLAYS = 32,
            SHGFI_OVERLAYINDEX = 64,
        }

        public struct IMAGELISTDRAWPARAMS
        {
            public int cbSize;
            public IntPtr himl;
            public int i;
            public IntPtr hdcDst;
            public int x;
            public int y;
            public int cx;
            public int cy;
            public int xBitmap;
            public int yBitmap;
            public int rgbBk;
            public int rgbFg;
            public int fStyle;
            public int dwRop;
            public int fState;
            public int Frame;
            public int crEffect;
        }

        public struct IMAGEINFO
        {
            public IntPtr hbmImage;
            public IntPtr hbmMask;
            public int Unused1;
            public int Unused2;
            public Win32.RECT rcImage;
        }

        public struct RECT
        {
            private int left;
            private int top;
            private int right;
            private int bottom;
        }

        public struct POINT
        {
            public int x;
            public int y;

            public POINT(int x, int y)
            {
                this.x = x;
                this.y = y;
            }

            public static implicit operator Point(Win32.POINT p)
            {
                return new Point(p.x, p.y);
            }

            public static implicit operator Win32.POINT(Point p)
            {
                return new Win32.POINT(p.X, p.Y);
            }
        }

        [InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
        [Guid("46EB5926-582E-4017-9FDF-E8998DAA0950")]
        [ComImport]
        public interface IImageList
        {
            [MethodImpl(MethodImplOptions.PreserveSig)]
            int Add(IntPtr hbmImage, IntPtr hbmMask, ref int pi);

            [MethodImpl(MethodImplOptions.PreserveSig)]
            int ReplaceIcon(int i, IntPtr hicon, ref int pi);

            [MethodImpl(MethodImplOptions.PreserveSig)]
            int SetOverlayImage(int iImage, int iOverlay);

            [MethodImpl(MethodImplOptions.PreserveSig)]
            int Replace(int i, IntPtr hbmImage, IntPtr hbmMask);

            [MethodImpl(MethodImplOptions.PreserveSig)]
            int AddMasked(IntPtr hbmImage, int crMask, ref int pi);

            [MethodImpl(MethodImplOptions.PreserveSig)]
            int Draw(ref Win32.IMAGELISTDRAWPARAMS pimldp);

            [MethodImpl(MethodImplOptions.PreserveSig)]
            int Remove(int i);

            [MethodImpl(MethodImplOptions.PreserveSig)]
            int GetIcon(int i, int flags, ref IntPtr picon);

            [MethodImpl(MethodImplOptions.PreserveSig)]
            int GetImageInfo(int i, ref Win32.IMAGEINFO pImageInfo);

            [MethodImpl(MethodImplOptions.PreserveSig)]
            int Copy(int iDst, Win32.IImageList punkSrc, int iSrc, int uFlags);

            [MethodImpl(MethodImplOptions.PreserveSig)]
            int Merge(int i1, Win32.IImageList punk2, int i2, int dx, int dy, ref Guid riid, ref IntPtr ppv);

            [MethodImpl(MethodImplOptions.PreserveSig)]
            int Clone(ref Guid riid, ref IntPtr ppv);

            [MethodImpl(MethodImplOptions.PreserveSig)]
            int GetImageRect(int i, ref Win32.RECT prc);

            [MethodImpl(MethodImplOptions.PreserveSig)]
            int GetIconSize(ref int cx, ref int cy);

            [MethodImpl(MethodImplOptions.PreserveSig)]
            int SetIconSize(int cx, int cy);

            [MethodImpl(MethodImplOptions.PreserveSig)]
            int GetImageCount(ref int pi);

            [MethodImpl(MethodImplOptions.PreserveSig)]
            int SetImageCount(int uNewCount);

            [MethodImpl(MethodImplOptions.PreserveSig)]
            int SetBkColor(int clrBk, ref int pclr);

            [MethodImpl(MethodImplOptions.PreserveSig)]
            int GetBkColor(ref int pclr);

            [MethodImpl(MethodImplOptions.PreserveSig)]
            int BeginDrag(int iTrack, int dxHotspot, int dyHotspot);

            [MethodImpl(MethodImplOptions.PreserveSig)]
            int EndDrag();

            [MethodImpl(MethodImplOptions.PreserveSig)]
            int DragEnter(IntPtr hwndLock, int x, int y);

            [MethodImpl(MethodImplOptions.PreserveSig)]
            int DragLeave(IntPtr hwndLock);

            [MethodImpl(MethodImplOptions.PreserveSig)]
            int DragMove(int x, int y);

            [MethodImpl(MethodImplOptions.PreserveSig)]
            int SetDragCursorImage(ref Win32.IImageList punk, int iDrag, int dxHotspot, int dyHotspot);

            [MethodImpl(MethodImplOptions.PreserveSig)]
            int DragShowNolock(int fShow);

            [MethodImpl(MethodImplOptions.PreserveSig)]
            int GetDragImage(ref Win32.POINT ppt, ref Win32.POINT pptHotspot, ref Guid riid, ref IntPtr ppv);

            [MethodImpl(MethodImplOptions.PreserveSig)]
            int GetItemFlags(int i, ref int dwFlags);

            [MethodImpl(MethodImplOptions.PreserveSig)]
            int GetOverlayImage(int iOverlay, ref int piIndex);
        }

        public enum NET_API_STATUS : uint
        {
            NERR_Success = 0U,
            ERROR_ACCESS_DENIED = 5U,
            ERROR_NOT_ENOUGH_MEMORY = 8U,
            ERROR_NOT_SUPPORTED = 50U,
            ERROR_INVALID_PARAMETER = 87U,
            ERROR_INVALID_NAME = 123U,
            ERROR_INVALID_LEVEL = 124U,
            ERROR_MORE_DATA = 234U,
            ERROR_SESSION_CREDENTIAL_CONFLICT = 1219U,
            NERR_ServerNotStarted = 2114U,
            NERR_RemoteErr = 2127U,
            NERR_WkstaNotStarted = 2138U,
            NERR_ServiceNotInstalled = 2184U,
            NERR_BadPassword = 2203U,
            NERR_UserNotFound = 2221U,
            NERR_NotPrimary = 2226U,
            NERR_SpeGroupOp = 2234U,
            NERR_PasswordTooShort = 2245U,
            NERR_InvalidComputer = 2351U,
            NERR_LastAdmin = 2452U,
            ERROR_NO_BROWSER_SERVERS_FOUND = 6118U,
            RPC_E_REMOTE_DISABLED = 2147549468U,
            RPC_S_SERVER_UNAVAILABLE = 2147944122U,
        }

        public enum SV_TYPE : uint
        {
            SV_TYPE_WORKSTATION = 1U,
            SV_TYPE_SERVER = 2U,
            SV_TYPE_SQLSERVER = 4U,
            SV_TYPE_DOMAIN_CTRL = 8U,
            SV_TYPE_DOMAIN_BAKCTRL = 16U,
            SV_TYPE_TIME_SOURCE = 32U,
            SV_TYPE_AFP = 64U,
            SV_TYPE_NOVELL = 128U,
            SV_TYPE_DOMAIN_MEMBER = 256U,
            SV_TYPE_PRINTQ_SERVER = 512U,
            SV_TYPE_DIALIN_SERVER = 1024U,
            SV_TYPE_SERVER_UNIX = 2048U,
            SV_TYPE_XENIX_SERVER = 2048U,
            SV_TYPE_NT = 4096U,
            SV_TYPE_WFW = 8192U,
            SV_TYPE_SERVER_MFPN = 16384U,
            SV_TYPE_SERVER_NT = 32768U,
            SV_TYPE_POTENTIAL_BROWSER = 65536U,
            SV_TYPE_BACKUP_BROWSER = 131072U,
            SV_TYPE_MASTER_BROWSER = 262144U,
            SV_TYPE_DOMAIN_MASTER = 524288U,
            SV_TYPE_SERVER_OSF = 1048576U,
            SV_TYPE_SERVER_VMS = 2097152U,
            SV_TYPE_WINDOWS = 4194304U,
            SV_TYPE_DFS = 8388608U,
            SV_TYPE_CLUSTER_NT = 16777216U,
            SV_TYPE_TERMINALSERVER = 33554432U,
            SV_TYPE_CLUSTER_VS_NT = 67108864U,
            SV_TYPE_DCE = 268435456U,
            SV_TYPE_ALTERNATE_XPORT = 536870912U,
            SV_TYPE_LOCAL_LIST_ONLY = 1073741824U,
            SV_TYPE_DOMAIN_ENUM = 2147483648U,
            SV_TYPE_ALL = 4294967295U,
        }

        public struct SERVER_INFO_101
        {
            [MarshalAs(UnmanagedType.U4)]
            public uint sv101_platform_id;
            [MarshalAs(UnmanagedType.LPWStr)]
            public string sv101_name;
            [MarshalAs(UnmanagedType.U4)]
            public uint sv101_version_major;
            [MarshalAs(UnmanagedType.U4)]
            public uint sv101_version_minor;
            [MarshalAs(UnmanagedType.U4)]
            public uint sv101_type;
            [MarshalAs(UnmanagedType.LPWStr)]
            public string sv101_comment;
        }

        public struct SERVER_INFO_100
        {
            [MarshalAs(UnmanagedType.U4)]
            public uint sv100_platform_id;
            [MarshalAs(UnmanagedType.LPWStr)]
            public string sv100_name;
        }

        public struct ICONINFO
        {
            public bool fIcon;
            public int xHotspot;
            public int yHotspot;
            public IntPtr hbmMask;
            public IntPtr hbmColor;
        }

        public struct CURSORINFO
        {
            public int cbSize;
            public int flags;
            public IntPtr hCursor;
            public Win32.POINT ptScreenPos;
        }

        public enum TernaryRasterOperations : uint
        {
            BLACKNESS = 66U,
            NOTSRCERASE = 1114278U,
            NOTSRCCOPY = 3342344U,
            SRCERASE = 4457256U,
            DSTINVERT = 5570569U,
            PATINVERT = 5898313U,
            SRCINVERT = 6684742U,
            SRCAND = 8913094U,
            MERGEPAINT = 12255782U,
            MERGECOPY = 12583114U,
            SRCCOPY = 13369376U,
            SRCPAINT = 15597702U,
            PATCOPY = 15728673U,
            PATPAINT = 16452105U,
            WHITENESS = 16711778U,
            CAPTUREBLT = 1073741824U,
            NOMIRRORBITMAP = 2147483648U,
        }

        public struct PERFORMANCE_INFORMATION
        {
            public int cb;
            public IntPtr CommitTotal;
            public IntPtr CommitLimit;
            public IntPtr CommitPeak;
            public IntPtr PhysicalTotal;
            public IntPtr PhysicalAvailable;
            public IntPtr SystemCache;
            public IntPtr KernelTotal;
            public IntPtr KernelPaged;
            public IntPtr KernelNonPaged;
            public IntPtr PageSize;
            public int HandlesCount;
            public int ProcessCount;
            public int ThreadCount;
        }
    }
}
