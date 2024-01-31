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
// NAME:    Gpu.cs
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
            string className = "Gpu";
            string methodName = "info";
            try
            {
                Program p = new Program();
                if(args.Length > 0)
                {
                    target = args[0];  // user may override target in command-line
                }

                // 1. calling info() method for all instances of the Gpu class 
                Console.WriteLine(string.Format("target={0}, className={1}, methodName={2}", target, className, methodName));
                p.InvokeMethod(className, methodName);
                Console.WriteLine("================================");

                // 2. calling info() method for a specific instance of the Gpu class 
                string selector = "id=1";
                bool called = p.InvokeMethod(className, methodName, selector);
                if(!called)
                {
                    throw new System.ApplicationException("Gpu Info for " + selector);
                }
                // for systems with single GPU output from step 1. 
                // will be identical to output from step 2.
            }
            catch(ApplicationException e)
            {
                Console.WriteLine("ApplicationException caught: " + e.ToString());
            }

        }

        /// <summary>
        /// invokes a method for all class instances
        /// </summary>
        /// <param name="className">Must be a name of a WMI dynamic class from the NV namespace</param>
        /// <param name="methodName">Name of a WMI method</param>
        public void InvokeMethod(string className, string methodName)
        {
            try
            {
                ManagementObjectSearcher searcher = null;
                ManagementClass classInstance = null;

                // Performs WMI object query in selected namespace
                string wmiScope = target + nvWmiNamespace;
                ManagementScope scope = new ManagementScope(wmiScope);
                WqlObjectQuery query = new WqlObjectQuery("select * from " + className);
                scope.Connect();

                searcher = new ManagementObjectSearcher(scope, query, null);
                classInstance = new ManagementClass(target + nvWmiNamespace, className, null);

                ManagementBaseObject inParams = classInstance.GetMethodParameters(methodName);

                // invoke method for each instance, selected by WQL query
                // assumption is that specified method doesn't require any parameters (e.g. "info" method)
                int i=0;
                foreach(ManagementObject obj in searcher.Get())
                {
                    ManagementBaseObject outParams = null;
                    outParams = obj.InvokeMethod(methodName, inParams, null);
                    string rc = outParams["ReturnValue"].ToString();
                    Console.WriteLine("return of the WMI {0}.{1} method call:", className, methodName);
                    Console.WriteLine(rc);
                    Console.WriteLine("================================");

                    // printing out some properties of the current Gpu instance
                    obj.Get(); // bind WMI object to an instance of the .NET ManagementObject 
                    Console.WriteLine("Unique name of this object: {0}", obj["uname"]);
                    Console.WriteLine("Unique ID of this object: {0}", obj["id"].ToString());
                    ++i;
                }
                Console.WriteLine("================================");
            }
            catch (ManagementException e)
            {
                Console.WriteLine(MethodBase.GetCurrentMethod().Name + " - Exception caught: " + e.Message);
                Console.WriteLine("Stack trace: " + e.StackTrace);
            }
        }

        /// <summary>
        /// invokes a method (without parameters) of a dynamic class for instances selected by specified WQL query 
        /// </summary>
        /// <param name="className">Must be a name of a WMI dynamic class from the NV namespace</param>
        /// <param name="methodName">Name of a WMI method</param>
        /// <param name="selector">Selecting part of the WQL instance query, 
        /// after WHERE statement : example "id=1 AND name=""myName""" will produce WQL query 
        /// SELECT * from className WHERE id=1 AND name="myName"</param>
        public bool InvokeMethod(string className, string methodName, string selector)
        {
            bool rc = false;
            try
            {
                ManagementObjectSearcher searcher = null;
                ManagementClass classInstance = null;

                // Performs WMI object query in selected namespace
                string wmiScope = target + nvWmiNamespace;
                ManagementScope scope = new ManagementScope(wmiScope);
                WqlObjectQuery query = new WqlObjectQuery("select * from "+className+" where "+selector);
                scope.Connect();

                searcher = new ManagementObjectSearcher(scope, query, null);
                classInstance = new ManagementClass(target + nvWmiNamespace, className, null);

                Console.WriteLine(string.Format("invoking {0}:{1}->{2}():", target, className, methodName));
                ManagementBaseObject inParams = classInstance.GetMethodParameters(methodName);

                // invoke method for each instance, selected by WQL query
                // assumption is that specified method doesn't require any parameters (e.g. "info" method)
                foreach(ManagementObject obj in searcher.Get())
                {
                    ManagementBaseObject outParams = null;
                    outParams = obj.InvokeMethod(methodName, inParams, null);
                    string rv = outParams["ReturnValue"].ToString();
                    Console.WriteLine(rv);
                    rc = true;
                }
                Console.WriteLine("================================");
            }
            catch(ManagementException e)
            {
                Console.WriteLine(MethodBase.GetCurrentMethod().Name + " - Exception caught: " + e.Message);
                Console.WriteLine("Stack trace: " + e.StackTrace);
            }
            return rc;
        }
    }
}
