using System;
using System.Collections.Generic;
using System.IO;
using Microsoft.Win32;
using System.Runtime.InteropServices;
using System.Threading;

public static class FontCtl
{
    private const int FONT_INSTALL_MACHINE_FLAGS = 1;
    private const int FONT_INSTALL_USER_FLAGS = 3;
    private const uint CLSCTX_LOCAL_SERVER = 4;
    private const uint FONT_REMOVE_FLAGS = 3;
    private const string FONT_REGISTRY_KEY = @"SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts";

    private static readonly Guid CLSID_FontManager = new Guid("08D450B7-F7E5-4424-8229-11888ADB7C14");
    private static readonly Guid IID_IFontManager = new Guid("935AD8EB-CBF8-4FD3-8F4F-385F55258F2E");

    public static void Install(string[] paths, bool allUsers)
    {
        RunSta(delegate
        {
            string[] installPaths = SelectInstallPaths(paths);
            IFontManager manager = CreateFontManager(allUsers);

            try
            {
                int flags = allUsers ? FONT_INSTALL_MACHINE_FLAGS : FONT_INSTALL_USER_FLAGS;
                ThrowIfFailed(manager.InstallFonts(IntPtr.Zero, new FontNames(installPaths), flags, IntPtr.Zero));
            }
            finally
            {
                Release(manager);
            }
        });
    }

    public static void Uninstall(string[] paths, bool allUsers)
    {
        RunSta(delegate
        {
            string[] installedPaths = GetInstalledPaths(paths, allUsers);
            if (installedPaths.Length == 0)
                return;

            IFontManager manager = CreateFontManager(allUsers);
            try
            {
                RemoveFonts(manager, installedPaths);
            }
            finally
            {
                Release(manager);
            }
        });
    }

    private static string[] SelectInstallPaths(string[] paths)
    {
        HashSet<string> trueTypeFonts = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        foreach (string path in paths)
        {
            string fullPath = Path.GetFullPath(path);
            if (string.Equals(Path.GetExtension(fullPath), ".ttf", StringComparison.OrdinalIgnoreCase))
                trueTypeFonts.Add(Path.ChangeExtension(fullPath, null));
        }

        HashSet<string> selected = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        foreach (string path in paths)
        {
            string fullPath = Path.GetFullPath(path);
            if (string.Equals(Path.GetExtension(fullPath), ".otf", StringComparison.OrdinalIgnoreCase) &&
                trueTypeFonts.Contains(Path.ChangeExtension(fullPath, null)))
                continue;

            selected.Add(fullPath);
        }

        string[] result = new string[selected.Count];
        selected.CopyTo(result);
        return result;
    }

    private static string[] GetInstalledPaths(string[] paths, bool allUsers)
    {
        string directory = allUsers
            ? Environment.GetFolderPath(Environment.SpecialFolder.Fonts)
            : Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), "Microsoft", "Windows", "Fonts");

        HashSet<string> names = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        foreach (string path in paths)
            names.Add(Path.GetFileName(path));

        HashSet<string> installedPaths = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        RegistryKey root = allUsers ? Registry.LocalMachine : Registry.CurrentUser;
        using (RegistryKey key = root.OpenSubKey(FONT_REGISTRY_KEY))
        {
            if (key != null)
            {
                foreach (string valueName in key.GetValueNames())
                {
                    string value = key.GetValue(valueName) as string;
                    if (string.IsNullOrEmpty(value))
                        continue;

                    string installedPath = Path.IsPathRooted(value) ? value : Path.Combine(directory, value);
                    if (names.Contains(Path.GetFileName(installedPath)))
                        installedPaths.Add(installedPath);
                }
            }
        }

        string[] result = new string[installedPaths.Count];
        installedPaths.CopyTo(result);
        return result;
    }

    private static void RemoveFonts(IFontManager manager, string[] paths)
    {
        ThrowIfFailed(manager.RemoveFonts(IntPtr.Zero, new FontNames(paths), FONT_REMOVE_FLAGS, IntPtr.Zero));
    }

    private static IFontManager CreateFontManager(bool elevated)
    {
        if (!elevated)
            return (IFontManager)Activator.CreateInstance(Type.GetTypeFromCLSID(CLSID_FontManager, true));

        BIND_OPTS3 options = new BIND_OPTS3();
        options.cbStruct = (uint)Marshal.SizeOf(typeof(BIND_OPTS3));
        options.dwClassContext = CLSCTX_LOCAL_SERVER;

        Guid interfaceId = IID_IFontManager;
        IntPtr managerPointer;
        ThrowIfFailed(CoGetObject("Elevation:Administrator!new:" + CLSID_FontManager.ToString("B"), ref options, ref interfaceId, out managerPointer));
        return GetObject<IFontManager>(managerPointer);
    }

    private static void RunSta(ThreadStart action)
    {
        Exception error = null;
        Thread thread = new Thread(new ThreadStart(delegate
        {
            try
            {
                action();
            }
            catch (Exception exception)
            {
                error = exception;
            }
        }));

        thread.SetApartmentState(ApartmentState.STA);
        thread.Start();
        thread.Join();

        if (error != null)
            throw new InvalidOperationException(error.Message, error);
    }

    private static T GetObject<T>(IntPtr pointer) where T : class
    {
        try
        {
            return (T)Marshal.GetObjectForIUnknown(pointer);
        }
        finally
        {
            Marshal.Release(pointer);
        }
    }

    private static void Release(object value)
    {
        if (value != null && Marshal.IsComObject(value))
            Marshal.FinalReleaseComObject(value);
    }

    private static void ThrowIfFailed(int result)
    {
        if (result < 0)
            Marshal.ThrowExceptionForHR(result);
    }

    [ComVisible(true)]
    [Guid("35D81C54-6448-459C-86B4-A48D1F7746FF")]
    [InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    public interface IEnumFontNames
    {
        [PreserveSig]
        int Next(out IntPtr path);

        [PreserveSig]
        int Reset();

        [PreserveSig]
        int Count(out uint count);
    }

    [ClassInterface(ClassInterfaceType.None)]
    private sealed class FontNames : IEnumFontNames
    {
        private readonly string[] paths;
        private int index;

        public FontNames(string[] paths)
        {
            this.paths = paths;
        }

        public int Next(out IntPtr path)
        {
            if (index == paths.Length)
            {
                path = IntPtr.Zero;
                return 1;
            }

            path = Marshal.StringToCoTaskMemUni(paths[index++]);
            return 0;
        }

        public int Reset()
        {
            index = 0;
            return 0;
        }

        public int Count(out uint count)
        {
            count = (uint)paths.Length;
            return 0;
        }
    }

    [StructLayout(LayoutKind.Sequential)]
    private struct BIND_OPTS3
    {
        public uint cbStruct;
        public uint grfFlags;
        public uint grfMode;
        public uint dwTickCountDeadline;
        public uint dwTrackFlags;
        public uint dwClassContext;
        public uint locale;
        public IntPtr serverInfo;
        public IntPtr hwnd;
    }

    [ComImport]
    [Guid("935AD8EB-CBF8-4FD3-8F4F-385F55258F2E")]
    [InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    private interface IFontManager
    {
        [PreserveSig]
        int InstallFonts(IntPtr hwnd, IEnumFontNames names, int flags, IntPtr events);

        [PreserveSig]
        int RemoveFonts(IntPtr hwnd, IEnumFontNames names, uint flags, IntPtr events);
    }

    [DllImport("ole32.dll", CharSet = CharSet.Unicode, PreserveSig = true)]
    private static extern int CoGetObject(string name, ref BIND_OPTS3 options, ref Guid interfaceId, out IntPtr value);
}
