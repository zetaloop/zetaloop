using System;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Threading;

public static class FontCtl
{
    private const int SW_SHOWNORMAL = 1;
    private const uint CLSCTX_LOCAL_SERVER = 4;
    private const uint FONT_REMOVE_FLAGS = 3;

    private static readonly Guid IID_IShellFolder = new Guid("000214E6-0000-0000-C000-000000000046");
    private static readonly Guid IID_IContextMenu = new Guid("000214E4-0000-0000-C000-000000000046");
    private static readonly Guid CLSID_FontManager = new Guid("08D450B7-F7E5-4424-8229-11888ADB7C14");
    private static readonly Guid IID_IFontManager = new Guid("935AD8EB-CBF8-4FD3-8F4F-385F55258F2E");

    public static void Install(string[] paths, bool allUsers)
    {
        RunSta(delegate
        {
            Dictionary<string, List<string>> groups = new Dictionary<string, List<string>>(StringComparer.OrdinalIgnoreCase);
            foreach (string path in paths)
            {
                string fullPath = Path.GetFullPath(path);
                string directory = Path.GetDirectoryName(fullPath);
                List<string> group;
                if (!groups.TryGetValue(directory, out group))
                {
                    group = new List<string>();
                    groups.Add(directory, group);
                }
                group.Add(fullPath);
            }

            foreach (List<string> group in groups.Values)
                InvokeFileVerb(group.ToArray(), allUsers ? "installAllUsers" : "install");
        });
    }

    public static void Uninstall(string[] paths, bool allUsers)
    {
        RunSta(delegate
        {
            string[] installedPaths = GetInstalledPaths(paths, allUsers);
            if (installedPaths.Length != 0)
                RemoveFonts(installedPaths, allUsers);
        });
    }

    private static string[] GetInstalledPaths(string[] paths, bool allUsers)
    {
        string directory = allUsers
            ? Environment.GetFolderPath(Environment.SpecialFolder.Fonts)
            : Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), "Microsoft", "Windows", "Fonts");

        HashSet<string> names = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        foreach (string path in paths)
            names.Add(Path.GetFileName(path));

        HashSet<string> fontPaths = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        object shell = null;
        object folder = null;
        object items = null;

        try
        {
            shell = Activator.CreateInstance(Type.GetTypeFromProgID("Shell.Application"));
            folder = InvokeMember(shell, "NameSpace", BindingFlags.InvokeMethod, 20);
            items = InvokeMember(folder, "Items", BindingFlags.InvokeMethod);

            int count = Convert.ToInt32(InvokeMember(items, "Count", BindingFlags.GetProperty));
            for (int index = 0; index < count; index++)
            {
                object item = InvokeMember(items, "Item", BindingFlags.InvokeMethod, index);
                try
                {
                    string name = Convert.ToString(InvokeMember(item, "ExtendedProperty", BindingFlags.InvokeMethod, "System.FileName"));
                    if (names.Contains(name))
                    {
                        object value = InvokeMember(item, "ExtendedProperty", BindingFlags.InvokeMethod, "System.Fonts.FileNames");
                        Array fileNames = value as Array;

                        if (fileNames == null)
                        {
                            fileNames = new[] { value };
                        }

                        foreach (object fileName in fileNames)
                        {
                            if (string.Equals(Path.GetDirectoryName(Convert.ToString(fileName)), directory, StringComparison.OrdinalIgnoreCase))
                            {
                                fontPaths.Add(Convert.ToString(fileName));
                                break;
                            }
                        }
                    }
                }
                finally
                {
                    Release(item);
                }
            }
        }
        finally
        {
            Release(items);
            Release(folder);
            Release(shell);
        }

        string[] result = new string[fontPaths.Count];
        fontPaths.CopyTo(result);
        return result;
    }

    private static object InvokeMember(object target, string name, BindingFlags flags, params object[] arguments)
    {
        return target.GetType().InvokeMember(name, flags, null, target, arguments);
    }

    private static void RemoveFonts(string[] paths, bool allUsers)
    {
        IFontManager manager = CreateFontManager(allUsers);
        try
        {
            ThrowIfFailed(manager.RemoveFonts(IntPtr.Zero, new FontNames(paths), FONT_REMOVE_FLAGS, IntPtr.Zero));
        }
        finally
        {
            Release(manager);
        }
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

    private static void InvokeFileVerb(string[] paths, string verb)
    {
        List<IntPtr> absolutePidls = new List<IntPtr>();
        List<IntPtr> childPidls = new List<IntPtr>();
        IShellFolder parent = null;
        IContextMenu menu = null;

        try
        {
            foreach (string path in paths)
            {
                uint attributes;
                IntPtr absolutePidl;
                ThrowIfFailed(SHParseDisplayName(path, IntPtr.Zero, out absolutePidl, 0, out attributes));
                absolutePidls.Add(absolutePidl);

                IntPtr parentPointer;
                IntPtr childPidl;
                Guid shellFolderId = IID_IShellFolder;
                ThrowIfFailed(SHBindToParent(absolutePidl, ref shellFolderId, out parentPointer, out childPidl));
                childPidls.Add(childPidl);

                if (parent == null)
                    parent = GetObject<IShellFolder>(parentPointer);
                else
                    Marshal.Release(parentPointer);
            }

            menu = GetContextMenu(parent, childPidls.ToArray());
            InvokeVerb(menu, verb);
        }
        finally
        {
            Release(menu);
            Release(parent);
            foreach (IntPtr absolutePidl in absolutePidls)
                Marshal.FreeCoTaskMem(absolutePidl);
        }
    }

    private static IContextMenu GetContextMenu(IShellFolder folder, IntPtr[] childPidls)
    {
        IntPtr menuPointer;
        Guid contextMenuId = IID_IContextMenu;
        ThrowIfFailed(folder.GetUIObjectOf(IntPtr.Zero, (uint)childPidls.Length, childPidls, ref contextMenuId, IntPtr.Zero, out menuPointer));
        return GetObject<IContextMenu>(menuPointer);
    }

    private static void InvokeVerb(IContextMenu menu, string verb)
    {
        IntPtr popup = CreatePopupMenu();
        if (popup == IntPtr.Zero)
            throw new InvalidOperationException("Unable to create context menu");

        IntPtr verbAnsi = Marshal.StringToCoTaskMemAnsi(verb);

        try
        {
            ThrowIfFailed(menu.QueryContextMenu(popup, 0, 1, 0x7fff, 0));

            CMINVOKECOMMANDINFO command = new CMINVOKECOMMANDINFO();
            command.cbSize = (uint)Marshal.SizeOf(typeof(CMINVOKECOMMANDINFO));
            command.lpVerb = verbAnsi;
            command.nShow = SW_SHOWNORMAL;
            ThrowIfFailed(menu.InvokeCommand(ref command));
        }
        finally
        {
            Marshal.FreeCoTaskMem(verbAnsi);
            DestroyMenu(popup);
        }
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

    [StructLayout(LayoutKind.Sequential)]
    private struct CMINVOKECOMMANDINFO
    {
        public uint cbSize;
        public uint fMask;
        public IntPtr hwnd;
        public IntPtr lpVerb;
        public IntPtr lpParameters;
        public IntPtr lpDirectory;
        public int nShow;
        public uint dwHotKey;
        public IntPtr hIcon;
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

    [ComImport]
    [Guid("000214E4-0000-0000-C000-000000000046")]
    [InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    private interface IContextMenu
    {
        [PreserveSig]
        int QueryContextMenu(IntPtr menu, uint index, uint firstCommand, uint lastCommand, uint flags);

        [PreserveSig]
        int InvokeCommand(ref CMINVOKECOMMANDINFO command);

        [PreserveSig]
        int GetCommandString(UIntPtr command, uint flags, IntPtr reserved, IntPtr name, uint nameLength);
    }

    [ComImport]
    [Guid("000214E6-0000-0000-C000-000000000046")]
    [InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    private interface IShellFolder
    {
        [PreserveSig]
        int ParseDisplayName(IntPtr hwnd, IntPtr bindContext, [MarshalAs(UnmanagedType.LPWStr)] string displayName, ref uint eaten, out IntPtr pidl, ref uint attributes);

        [PreserveSig]
        int EnumObjects(IntPtr hwnd, uint flags, out IntPtr enumerator);

        [PreserveSig]
        int BindToObject(IntPtr pidl, IntPtr bindContext, ref Guid interfaceId, out IntPtr value);

        [PreserveSig]
        int BindToStorage(IntPtr pidl, IntPtr bindContext, ref Guid interfaceId, out IntPtr value);

        [PreserveSig]
        int CompareIDs(IntPtr parameter, IntPtr firstPidl, IntPtr secondPidl);

        [PreserveSig]
        int CreateViewObject(IntPtr hwnd, ref Guid interfaceId, out IntPtr value);

        [PreserveSig]
        int GetAttributesOf(uint count, [MarshalAs(UnmanagedType.LPArray, SizeParamIndex = 0)] IntPtr[] pidls, ref uint attributes);

        [PreserveSig]
        int GetUIObjectOf(IntPtr hwnd, uint count, [MarshalAs(UnmanagedType.LPArray, SizeParamIndex = 1)] IntPtr[] pidls, ref Guid interfaceId, IntPtr reserved, out IntPtr value);

        [PreserveSig]
        int GetDisplayNameOf(IntPtr pidl, uint flags, IntPtr name);

        [PreserveSig]
        int SetNameOf(IntPtr hwnd, IntPtr pidl, [MarshalAs(UnmanagedType.LPWStr)] string name, uint flags, out IntPtr outputPidl);
    }

    [DllImport("shell32.dll", CharSet = CharSet.Unicode, PreserveSig = true)]
    private static extern int SHParseDisplayName(string name, IntPtr bindContext, out IntPtr pidl, uint attributesIn, out uint attributesOut);

    [DllImport("shell32.dll", PreserveSig = true)]
    private static extern int SHBindToParent(IntPtr pidl, ref Guid interfaceId, out IntPtr parent, out IntPtr childPidl);

    [DllImport("ole32.dll", CharSet = CharSet.Unicode, PreserveSig = true)]
    private static extern int CoGetObject(string name, ref BIND_OPTS3 options, ref Guid interfaceId, out IntPtr value);

    [DllImport("user32.dll", PreserveSig = true)]
    private static extern IntPtr CreatePopupMenu();

    [DllImport("user32.dll", PreserveSig = true)]
    private static extern bool DestroyMenu(IntPtr menu);
}
