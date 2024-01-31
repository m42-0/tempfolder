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
// NAME:    DisplayProfile.cs
// AUTHOR:  NVIDIA Corporation
// REQUIRES: .NET Framework 3.5
// 
// SYNOPSIS: prints out information about system
//
// DESCRIPTION: executes info method of the System class 
//
// See NVWMI Programming Guide in NVWMI.CHM and MOF class definitions in NVWMI.MOF 
// for more details
//
//////////////////////////////////////////////////////////////////////////////////

using System;
using System.Reflection;
using System.Management;

namespace SampleSystem
{
    /// <summary>
    /// application class
    /// </summary>
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
            string className = "System";
            string methodName = "info";
            Program p = new Program();
            if (args.Length > 0)
            {
                target = args[0];  // user may override target in command-line
            }
            Console.WriteLine(string.Format("target={0}, className={1}, methodName={2}", target, className, methodName));
            p.InvokeStaticMethod(className, methodName);
            Console.WriteLine("================================");
        }

        /// <summary>
        /// invokes a method of a singleton class (aka "static method")
        /// </summary>
        /// <param name="className">Must be a name of a WMI singleton class from the NV namespace</param>
        /// <param name="methodName">Name of a WMI method</param>
        public void InvokeStaticMethod(string className, string methodName)
        {
            try
            {
                ManagementClass classInstance = new ManagementClass(target + nvWmiNamespace, className, null);
                ManagementBaseObject outParams;

                outParams = classInstance.InvokeMethod(methodName, null, null);
                string rc = outParams["ReturnValue"].ToString();
                Console.WriteLine("WMI call output= " + rc);
            }
            catch (ManagementException e)
            {
                Console.WriteLine("Exception caught: " + e.Message);
                Console.WriteLine("Stack trace: " + e.StackTrace);
            }
        }
    }
}

