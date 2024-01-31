//////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2014 NVIDIA Corporation
//////////////////////////////////////////////////////////////////////////////////
// Permission is hereby granted, free of charge, to any person obtaining a copy 
// of this software and associated documentation files (the "Software"), 
// to deal in the Software without restriction, including without limitation 
// the rights to use, copy, modify, merge, publish, distribute, sublicense, 
// and/or sell copies of the Software, and to permit persons to whom 
// the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in 
// all copies or substantial portions of the Software.
//////////////////////////////////////////////////////////////////////////////////
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, 
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE 
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//
// COMPANY: NVIDIA Corporation
// NAME:    GpuPerfCounters.cs
// AUTHOR:  NVIDIA Corporation
// REQUIRES: .NET Framework 3.5
// 
// SYNOPSIS:  prints out information about all GPUs in a system 
//
// DESCRIPTION: executes info method for every instance of the Gpu class 
//
// See NVWMI Programming Guide in NVWMI.CHM and MOF class definitions in NVWMI.MOF 
// for more details
//
//////////////////////////////////////////////////////////////////////////////////

using System;
using System.Management;
using System.Security;
using System.Security.Permissions;
using System.Runtime.ConstrainedExecution;
using System.Runtime.InteropServices;
using Microsoft.Win32.SafeHandles;

namespace GpuPerfCounters
{

    #region PDH Definitions
    /// 
    /// A safe wrapper around a PDH Log handle.
    /// Use this along with PdhBindInputDataSource and the "H" APIs to bind multiple logs together
    /// 
    [SecurityPermission(SecurityAction.LinkDemand, UnmanagedCode = true)]
    public class PdhLogHandle : SafeHandleZeroOrMinusOneIsInvalid
    {
        public PdhLogHandle() : base(true)
        {
        }

        [ReliabilityContract(Consistency.WillNotCorruptState, Cer.MayFail)]
        protected override bool ReleaseHandle()
        {
            return PdhApi.PdhCloseLog(handle, PdhApi.PDH_FLAGS_CLOSE_QUERY) == 0;
        }
    }

    /// 
    /// A safe wrapper around a query handle
    /// 
    [SecurityPermission(SecurityAction.LinkDemand, UnmanagedCode = true)]
    public class PdhQueryHandle : SafeHandleZeroOrMinusOneIsInvalid
    {
        public PdhQueryHandle() : base(true)
        {
        }

        [ReliabilityContract(Consistency.WillNotCorruptState, Cer.MayFail)]
        protected override bool ReleaseHandle()
        {
            return PdhApi.PdhCloseQuery(handle) == 0;
        }
    }

    /// 
    /// A safe handle around a counter
    /// 
    [SecurityPermission(SecurityAction.LinkDemand, UnmanagedCode = true)]
    public class PdhCounterHandle : SafeHandleZeroOrMinusOneIsInvalid
    {
        public PdhCounterHandle() : base(true)
        {
        }

        [ReliabilityContract(Consistency.WillNotCorruptState, Cer.MayFail)]
        protected override bool ReleaseHandle()
        {
            return PdhApi.PdhRemoveCounter(handle) == 0;
        }
    }

    /// 
    /// The value of a counter as returned by  API.
    /// 
    [StructLayout(LayoutKind.Explicit)]
    public struct PDH_FMT_COUNTERVALUE
    {
        [FieldOffset(0)]public UInt32 CStatus;
        // C/C++ union below - note that offset 8 will work only for 64-bit version of Windows. For 32-bit offset is 4
        [FieldOffset(8)]public int longValue;
        [FieldOffset(8)]public double doubleValue;
        [FieldOffset(8)]public long longLongValue;
        [FieldOffset(8)]public IntPtr AnsiStringValue;
        [FieldOffset(8)]public IntPtr WideStringValue;
    }

    /// 
    /// The counter format 
    /// 
    [Flags()]
    public enum PdhFormat : uint
    {
        PDH_FMT_RAW     = 0x00000010,
        PDH_FMT_ANSI    = 0x00000020,
        PDH_FMT_UNICODE = 0x00000040,
        PDH_FMT_LONG    = 0x00000100,
        PDH_FMT_DOUBLE  = 0x00000200,
        PDH_FMT_LARGE   = 0x00000400,
        PDH_FMT_NOSCALE = 0x00001000,
        PDH_FMT_1000    = 0x00002000,
        PDH_FMT_NODATA  = 0x00004000
    }

    /// 
    /// Static class containing some usefull PDH API's
    /// 
    [SuppressUnmanagedCodeSecurity()]
    internal class PdhApi
    {
        #region A few common flags and status codes
        public const UInt32 PDH_FLAGS_CLOSE_QUERY = 1;
        public const UInt32 PDH_NO_MORE_DATA = 0xC0000BCC;
        public const UInt32 PDH_INVALID_DATA = 0xC0000BC6;
        public const UInt32 PDH_ENTRY_NOT_IN_LOG_FILE = 0xC0000BCD;
        #endregion

        /// 
        /// Opens a query handle
        /// 
        [DllImport("pdh.dll", SetLastError = true, CharSet = CharSet.Auto)]
        public static extern UInt32 PdhOpenQuery(string szDataSource,IntPtr dwUserData,out  PdhQueryHandle phQuery);

        /// 
        /// Opens a query against a bound input source.
        /// 
        [DllImport("pdh.dll", SetLastError = true)]
        public static extern UInt32 PdhOpenQueryH(PdhLogHandle hDataSource, IntPtr dwUserData,out PdhQueryHandle phQuery);

        /// 
        /// Binds multiple logs files together. Use this along with the API's ending in 'H' to string multiple files together.
        /// 
        [DllImport("pdh.dll", SetLastError = true)]
        public static extern UInt32 PdhBindInputDataSource(out PdhLogHandle phDataSource,string szLogFileNameList);

        /// 
        /// Closes a handle to a log
        /// 
        [DllImport("pdh.dll", SetLastError = true)]
        public static extern UInt32 PdhCloseLog(IntPtr hLog,long dwFlags);

        /// 
        /// Closes a handle to the log
        /// 
        [DllImport("pdh.dll", SetLastError = true)]
        public static extern UInt32 PdhCloseQuery(IntPtr hQuery);

        /// 
        /// Removes a counter from the given query.
        /// 
        [DllImport("pdh.dll", SetLastError = true)]
        public static extern UInt32 PdhRemoveCounter(IntPtr hQuery);

        /// 
        /// Adds a counter the query and passes out a handle to the counter.
        /// 
        [DllImport("pdh.dll", SetLastError = true, CharSet = CharSet.Auto)]
        public static extern UInt32 PdhAddCounter(PdhQueryHandle hQuery,string szFullCounterPath,IntPtr dwUserData,out PdhCounterHandle phCounter);

        /// 
        /// Retrieves a data sample from the source.
        /// 
        [DllImport("pdh.dll", SetLastError = true)]
        public static extern UInt32 PdhCollectQueryData(PdhQueryHandle phQuery);

        /// 
        /// Retrieves a specific counter value in the specified format.
        /// 
        [DllImport("pdh.dll", SetLastError = true)]
        public static extern UInt32 PdhGetFormattedCounterValue(PdhCounterHandle phCounter,PdhFormat dwFormat,IntPtr lpdwType,out PDH_FMT_COUNTERVALUE pValue);

    }
    #endregion

    class Program
    {
        /// <summary>
        /// fixed path to the namespace NV, provided by NVWMI
        /// </summary>
        static string nvWmiNamespace = "\\root\\CIMV2\\NV";

        /// <summary>
        /// address of a target computer. Change to a fully qualified NetBIOS name 
        /// or to an IP address of the remote target as necessary. 
        /// Might be overridden from command-line
        /// </summary>
        static string target = "\\\\.";

        /// <summary>
        /// entry point of the program
        /// </summary>
        /// <param name="args"></param>
        static void Main(string[] args)
        {
            Program p = new Program();
            if (args.Length > 0)
            {
                target = args[0];  // user may override target in command-line
            }

            // name of the counter as listed in the section 
            // "Available NVIDIA GPU Counters" of the page "NVIDIA Performance Counters", NVWMI Programming Guide
            // Note that name of the counter with CPU temperature differs across releases. 
            // It could be "Temperature C", "Temperature" or "Temperature °C".
            string strTemperatureCounter = @"Temperature C";
            p.getGpuCounter(strTemperatureCounter);
        }

        /// <summary>
        /// gets specified performance counter from the first instance of the WMI class Gpu
        /// </summary>
        /// <param name="strCounterName">Name of a Gpu counter</param>
        public void getGpuCounter(string strCounterName)
        {
            try
            {
                string className = "Gpu";
                string strGpuCounter = "";

                // Performs WMI object query in selected namespace
                string wmiScope = target + nvWmiNamespace;
                ManagementScope scope = new ManagementScope(wmiScope);
                WqlObjectQuery wqlQuery = new WqlObjectQuery("select * from " + className);
                scope.Connect();

                ManagementObjectSearcher searcher = new ManagementObjectSearcher(scope, wqlQuery, null);
                ManagementClass classInstance = new ManagementClass(target + nvWmiNamespace, className, null);

                foreach (ManagementObject gpu in searcher.Get())
                {
                    // printing out some properties
                    gpu.Get(); // bind WMI object to an instance of the .NET ManagementObject 

                    uint id = (uint)gpu["id"];                  // GPU ID
                    uint nvapiId = (uint)gpu["nvapiId"];        // GPU NVAPI ID
                    string name = (string)gpu["name"];          // GPU name

                    strGpuCounter = string.Format(@"\NVIDIA GPU(#{0:d} {1} (id={2:d}, NVAPI ID={3:d}))\{4}", id-1, name, id, nvapiId, strCounterName);
                    break; // bail out with the perf counter for the 1st GPU in a system
                }

                PdhQueryHandle query;
                PdhCounterHandle counter;

                // result is PDH_STATUS in C++ 
                UInt32 result = PdhApi.PdhOpenQuery(null, IntPtr.Zero, out query);
                if (result != 0)
                {
                    Console.WriteLine("error opening performance query, status={0:d} (0x{0:X8})", result);
                    return;
                }

                // Add the counter that we want to see
                // The PdhEnumXXX methods can be used to discover them
                result = PdhApi.PdhAddCounter(query, strGpuCounter, IntPtr.Zero, out counter);
                if (result != 0)
                {
                    // 0xC0000BCD (PDH_ENTRY_NOT_IN_LOG_FILE) means the counter was not found in the set, 
                    // happens when counter name is mistyped or non-localized string used in localized OS
                    Console.WriteLine("error adding counter, status={0:d} (0x{0:X8})", result);
                    return;
                }

                do
                {
                    result = PdhApi.PdhCollectQueryData(query);
                    if (result == 0)
                    {
                        PDH_FMT_COUNTERVALUE value;
                        result = PdhApi.PdhGetFormattedCounterValue(counter, PdhFormat.PDH_FMT_DOUBLE, IntPtr.Zero, out value);
                        if (value.CStatus == 0)
                        {
                            Console.WriteLine("temperature = {0:g}", value.doubleValue);
                        }
                        else
                        {
                            // 0xC0000BC6 (PDH_INVALID_DATA) can be returned when more samples are needed to calculate the value. 
                            // Report error and continue calling PdhCollectQueryData 
                            Console.WriteLine("error retrieving counter value, status={0:d} (0x{0:X8})", value.CStatus);
                        }
                    }
                    System.Threading.Thread.Sleep(1000);
                }
                while (result == 0 && !Console.KeyAvailable);
            }
            catch (ManagementException e)
            {
                Console.WriteLine("Exception caught: " + e.Message);
                Console.WriteLine("Stack trace: " + e.StackTrace);
            }
        }
    }
}