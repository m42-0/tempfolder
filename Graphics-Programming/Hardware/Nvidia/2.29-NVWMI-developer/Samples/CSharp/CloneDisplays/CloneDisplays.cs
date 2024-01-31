//////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2015 NVIDIA Corporation
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
// NAME:    CloneDisplays.cs
// AUTHOR:  NVIDIA Corporation
// REQUIRES: .NET Framework 3.5
// 
// SYNOPSIS: Clones all attached displays
//
// DESCRIPTION: demonstrates how to clone displays horizontally 
//              by overlapping at screen width
//
// See NVWMI Programming Guide in NVWMI.CHM and MOF class definitions in NVWMI.MOF 
// for more details
//
//////////////////////////////////////////////////////////////////////////////////

using System;
using System.Collections;
using System.Reflection;
using System.Management;

namespace SampleCloneDisplays
{
    /// <summary>application class</summary>
    class Program
    {
        /// <summary>fixed path to the namespace NV, provided by NVWMI</summary>
        static string nvWmiNamespace = "\\root\\CIMV2\\NV";

        /// <summary>
        /// address of a target computer. Change to a fully qualified NetBIOS name 
        /// or to an IP address of the remote target as necessary. 
        /// Might be overridden from command-line
        /// </summary>
        static string target = "\\\\.";

        /// <summary>count of all detected displays in a system</summary>
        static int displayCount = 0;

        /// <summary>least native screen width (in pixels)</summary>
        static int leastNativeW = int.MaxValue;

        /// <summary>least native screen height (in pixels)</summary>
        static int leastNativeH = 0;

        /// <summary>bits per pixel</summary>
        static int bpp = 0;

        /// <summary>constant - minimal number of displays required for cloning</summary>
        const int cMinDisplayNum = 2;

        /// <summary>refresh rate (in Hz)</summary>
        static float refresh = 0.0f;

        /// <summary>entry point of the program</summary>
        /// <param name="args"></param>
        static void Main(string[] args)
        {
            bool rc = false;
            Program p = new Program();
            if(args.Length > 0)
            {
                target = args[0];  // user may override target in command-line
            }

            try
            {
                string className;
                string methodName;

                bool detected = p.DetectDisplayMode();
                if(!detected)
                {
                    throw new System.ApplicationException("no usable display configuration");
                }
                // define 1xN display grid, where N - number of displays in a system, set display mode to lowest native among all detected displays
                string grid0 = string.Format("rows=1;cols={0};mode={1} {2} {3} {4}", displayCount, leastNativeW, leastNativeH, bpp, refresh);
                string[] grids = new string[] {grid0};

                className = "DisplayManager";
                methodName = "validateDisplayGrids";
                bool validated = p.InvokeStaticMethod(className, methodName, "grids", grids);
                if(!validated)
                {
                    throw new System.ApplicationException("display grids validation has failed");
                }

                methodName = "createDisplayGrids";
                bool created = p.InvokeStaticMethod(className, methodName, "grids", grids);
                if(!created)
                {
                    throw new System.ApplicationException("display grids creation has failed");
                }

                className = "DisplayGrid";
                methodName = "setOverlapCol";
                string selector = "id=1";
                Hashtable argOverlaps = new Hashtable();
                argOverlaps.Add("index", -1);
                argOverlaps.Add("overlap", leastNativeW);
                bool overlapped = p.InvokeMethod(className, methodName, selector, argOverlaps);
                if(!overlapped)
                {
                    throw new System.ApplicationException("display grid overlapping has failed");
                }

                rc = true;
            }
            catch(ApplicationException e)
            {
                Console.WriteLine("ApplicationException caught: " + e.ToString());
            }

            Console.WriteLine("================================");
            Console.WriteLine("{0} : {1}", Environment.GetCommandLineArgs()[0], rc?"SUCCESS":"FAILURE");
            Console.WriteLine("================================");
        }

        /// <summary>
        /// Detects display mode, suitable for all attached displays,
        /// side effect : initializes static members of Program class
        /// </summary>
        public bool DetectDisplayMode()
        {
            bool rc = false;
            try
            {
                // retrieve all attached displays
                ManagementObjectSearcher searcher = null;

                // query WMI object from specified namespace
                string className = "Display";
                string wmiScope = target + nvWmiNamespace;
                ManagementScope scope = new ManagementScope(wmiScope);
                WqlObjectQuery query = new WqlObjectQuery("select * from " + className);
                scope.Connect();

                searcher = new ManagementObjectSearcher(scope, query, null);

                // call Get() to retrieve the collection of WMI objects 
                ManagementObjectCollection allDisplays = searcher.Get();

                // reset display count
                displayCount = 0;
                // iterate thru all displays, determine native mode with smallest width
                foreach(ManagementObject display in allDisplays)
                {
                    display.Get(); // bind WMI object to an instance of the .NET ManagementObject 
                    ManagementBaseObject mode = (ManagementBaseObject)display["displayModeNative"];
                    int w = (int)mode["width"];
                    if(w > 0) // then display is active, with valid display mode
                    {
                        ++displayCount;
                        if(leastNativeW > w)
                        {
                            // initialize static members with display mode values
                            leastNativeW = w;
                            leastNativeH = (int)mode["height"];
                            bpp = (int)mode["colorDepth"];
                            refresh = (float)mode["refreshRate"];
                            rc = true;
                        }
                        Console.WriteLine("uname: {0}, id: {1}", display["uname"], display["id"]);
                    }
                }
                if(displayCount < cMinDisplayNum)
                {
                    Console.WriteLine("ERROR : {0} active displays required, {1} detected", cMinDisplayNum, displayCount);
                    rc = false;
                }

            }
            catch(ManagementException e)
            {
                Console.WriteLine(MethodBase.GetCurrentMethod().Name + " - Exception caught: " + e.Message);
                Console.WriteLine("Stack trace: " + e.StackTrace);
            }
            return rc;
        }

        /// <summary>
        /// invokes a method of a dynamic class for instances selected by specified WQL query 
        /// and with parameters, passed in a hash table
        /// </summary>
        /// <param name="className">Must be a name of a WMI dynamic class from the NV namespace</param>
        /// <param name="methodName">Name of a WMI method</param>
        /// <param name="selector">Selecting part of the WQL instance query, 
        /// after WHERE statement : example "id=1 AND name=""myName""" will produce WQL query 
        /// SELECT * from className WHERE id=1 AND name="myName"</param>
        /// <param name="args">hash table with arguments for WMI method</param>
        public bool InvokeMethod(string className, string methodName, string selector, Hashtable args)
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

                Console.Write(string.Format("invoking {0}:{1}->{2}(", target, className, methodName));
                ManagementBaseObject inParams = classInstance.GetMethodParameters(methodName);
                int i=0;
                foreach(DictionaryEntry a in args)
                {
                    string sep = (i<args.Count-1)?", ":""; // separate arguments with ", " - except
                    Console.Write(string.Format("{0}=\"{1}\"{2}", a.Key.ToString(), a.Value.ToString(), sep));
                    inParams[a.Key.ToString()] = a.Value;
                    ++i;
                }
                Console.WriteLine(")");

                // invoke method for each instance, selected by WQL query
                // assumption is that specified method doesn't require any parameters (e.g. "info" method)
                foreach(ManagementObject obj in searcher.Get())
                {
                    ManagementBaseObject outParams = null;
                    outParams = obj.InvokeMethod(methodName, inParams, null);
                    string rv = outParams["ReturnValue"].ToString();
                    Console.WriteLine("WMI call returns : " + rv);
                    rc = rv.CompareTo("True")==0;
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

        /// <summary>
        /// invokes a method of a singleton class (aka "static method") with single string parameter
        /// </summary>
        /// <param name="className">Must be a name of a WMI singleton class from the NV namespace</param>
        /// <param name="methodName">Name of a WMI method</param>
        /// <param name="paramName">Name of a WMI method parameter</param>
        /// <param name="value">Value of a WMI method parameter</param>
        public bool InvokeStaticMethod(string className, string methodName, string paramName, string[] value)
        {
            bool rc = false;
            try
            {
                Console.WriteLine(string.Format("invoking {0}:{1}->{2}({3}=\"{4}\")", target, className, methodName, paramName, string.Join(" ",value)));

                ManagementClass classInstance = new ManagementClass(target + nvWmiNamespace, className, null);
                ManagementBaseObject inParams = classInstance.GetMethodParameters(methodName);

                inParams[paramName] = value;

                ManagementBaseObject outParams;
                outParams = classInstance.InvokeMethod(methodName, inParams, null);
                string rv = outParams["ReturnValue"].ToString();
                Console.WriteLine("WMI call returns : " + rv);
                rc = rv.CompareTo("True")==0;
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
