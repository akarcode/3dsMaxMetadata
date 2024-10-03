

# thumbnail size is defined by the size of the viewport during saving in 3dsmax


$MaxFile = 'D:\Folder\File.max'


function Save-MaxThumbnail {

    param (
        [Parameter(Mandatory)][string]$MaxFile
    )


    # c# code converted from andrey's visual basic script
    # scriptspot.com/forums/3ds-max/general-scripting/get-max-file-thumbnail
    $CSharpCode = '
    
        using System;
        using System.Drawing;
        using System.Runtime.InteropServices;
        using System.Security;

        namespace GetThumbs
        {
            [ComImport, Guid("43826d1e-e718-42ee-bc55-a1e261c37bfe"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
            public interface IShellItem
            {
                void BindToHandler(IntPtr pbc, [MarshalAs(UnmanagedType.LPStruct)] Guid bhid, [MarshalAs(UnmanagedType.LPStruct)] Guid riid, out IntPtr ppv);
                void GetParent(out IShellItem ppsi);
                void GetDisplayName(SIGDN sigdnName, out IntPtr ppszName);
                void GetAttributes(uint sfgaoMask, out uint psfgaoAttribs);
                void Compare(IShellItem psi, uint hint, out int piOrder);
            }

            [ComImport, Guid("bcc18b79-ba16-442f-80c4-8a59c30c463b"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
            public interface IShellItemImageFactory
            {
                void GetImage([In, MarshalAs(UnmanagedType.Struct)] SIZE size, [In] SIIGBF flags, out IntPtr phbm);
            }

            [SuppressUnmanagedCodeSecurity]
            public class SafeNativeMethods
            {
            }

            [Flags]
            public enum SIGDN : uint
            {
                DESKTOPABSOLUTEEDITING = 0x8004C000,
                DESKTOPABSOLUTEPARSING = 0x80028000,
                FILESYSPATH = 0x80058000,
                NORMALDISPLAY = 0,
                PARENTRELATIVEEDITING = 0x80031001,
                PARENTRELATIVEFORADDRESSBAR = 0x8001C001,
                PARENTRELATIVEPARSING = 0x80018001,
                URL = 0x80068000
            }

            [Flags]
            public enum SIIGBF
            {
                SIIGBF_BIGGERSIZEOK = 1,
                SIIGBF_ICONONLY = 4,
                SIIGBF_INCACHEONLY = 0x10,
                SIIGBF_MEMORYONLY = 2,
                SIIGBF_RESIZETOFIT = 0,
                SIIGBF_THUMBNAILONLY = 8
            }

            [StructLayout(LayoutKind.Sequential)]
            public struct SIZE
            {
                public int cx;
                public int cy;
                public SIZE(int cx, int cy)
                {
                    this.cx = cx;
                    this.cy = cy;
                }
            }

            [SuppressUnmanagedCodeSecurity]
            public class UnsafeNativeMethods
            {
                [DllImport("shell32.dll", CharSet = CharSet.Unicode, PreserveSig = false)]
                public static extern void SHCreateItemFromParsingName([In, MarshalAs(UnmanagedType.LPWStr)] string pszPath, [In] IntPtr pbc, [In, MarshalAs(UnmanagedType.LPStruct)] Guid riid, out IShellItem ppv);
            }

            public class Thumbs
            {
                public static Bitmap GenerateThumbnail(string filename)
                {
                    IShellItem ppsi = null;
                    IntPtr hbitmap = IntPtr.Zero;
                    Guid uuid = new Guid("43826d1e-e718-42ee-bc55-a1e261c37bfe");
                    UnsafeNativeMethods.SHCreateItemFromParsingName(filename, IntPtr.Zero, uuid, out ppsi);
                    ((IShellItemImageFactory)ppsi).GetImage(new SIZE(0x200, 0x200), SIIGBF.SIIGBF_RESIZETOFIT, out hbitmap);
                    Bitmap bs = Bitmap.FromHbitmap(hbitmap);
                    return bs;
                }
            }
        }

        public class CSharpClass
        {
            public Bitmap GetThumbnail(string filename)
            {
                return GetThumbs.Thumbs.GenerateThumbnail(filename);
            }
        }
    '


    # compile C# code
    $CSharpProvider = New-Object Microsoft.CSharp.CSharpCodeProvider
    $CompilerParams = New-Object System.CodeDom.Compiler.CompilerParameters
    $CompilerParams.ReferencedAssemblies.Add('C:\Windows\Microsoft.NET\Framework\v2.0.50727\System.Drawing.dll') | Out-Null
    $CompilerParams.GenerateInMemory = $True
    $CompilerResult = $CSharpProvider.CompileAssemblyFromSource($CompilerParams, $CSharpCode)
    $CSharpInstance = $CompilerResult.CompiledAssembly.CreateInstance('CSharpClass')


    # grab thumbnail
    $Thumbnail = $CSharpInstance.GetThumbnail($MaxFile)
    $OutputPNG = [IO.Path]::ChangeExtension($MaxFile, 'png')
    $Thumbnail.Save($OutputPNG)

}


Save-MaxThumbnail -MaxFile $MaxFile


