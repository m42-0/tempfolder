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
// COMPANY:     NVIDIA Corporation
// NAME:        System.cpp
// AUTHOR:      NVIDIA Corporation
// REQUIRES:    C++11-compatible compiler, WBEM library, STD C++ library
// 
// SYNOPSIS:    demonstrates properties and methods of the System class
//
// DESCRIPTION: demonstrates how to access class properties, invoke a static method 
//              (e.g. a method of a singleton class), how to assign input parameter,
//              and how to check output results
//
// See NVWMI Programming Guide in NVWMI.CHM and MOF class definitions in NVWMI.MOF 
// for more details.
//
//////////////////////////////////////////////////////////////////////////////////

#define _WIN32_DCOM

#include <SDKDDKVer.h>
#include <windows.h>
#include <stdio.h>
#include <conio.h>
#include <comdef.h>
#include <wbemidl.h>

#include <vector>
using namespace std;

#pragma comment(lib, "wbemuuid.lib")                                // WMI engine 

#define WMI_PROP_PATH           L"__PATH"                           // WMI property, inherited by all classes - path to the class instance
#define WMI_METHOD_RETURN       L"ReturnValue"                      // property name in WMI output object with result of a method execution
#define WMI_CLASS               L"System"                           // name of the class to examine
#define WMI_INFO                L"info"                             // name of the class method to invoke
#define WMI_NV_NAMESPACE        L"\\root\\cimv2\\nv"                // path to NV namespace. See NVWMI.MOF. Case-insensitive
#define WMI_DEF_TARGET          L"\\\\localhost"                    // by default, target localhost
#define WMI_QUERY_LANGUAGE      L"WQL"                              // Always WQL
#define WMI_QUERY_SELECT_ALL    L"SELECT * FROM "                   // WQL query for all properties
#define WMI_QUERY_SELECT_PATH   L"SELECT " WMI_PROP_PATH L" FROM "

//
// get properties of all class instances
//
HRESULT getClassProperties(const wchar_t* pszClassName)
{
    HRESULT hr;

    IWbemLocator* pLoc = nullptr;
    IWbemServices* pSvc = nullptr;
    IEnumWbemClassObject* pEnumerator = nullptr;
    IWbemClassObject* pWmiObj = nullptr;

    do
    {
        // Initialize COM for multi-threading
        hr = CoInitializeEx(0, COINIT_MULTITHREADED);
        if(FAILED(hr))
        {
            break;
        }

        // Initialize COM Security
        hr = CoInitializeSecurity(nullptr, -1, nullptr, nullptr, RPC_C_IMP_LEVEL_IDENTIFY, RPC_C_AUTHN_LEVEL_CONNECT, nullptr, EOAC_DYNAMIC_CLOAKING, nullptr);
        if(FAILED(hr))
        {
            break;
        }

        // Obtain the initial locator to WMI 
        hr = CoCreateInstance(CLSID_WbemLocator, 0, CLSCTX_INPROC_SERVER, IID_IWbemLocator, (void**)&pLoc);
        if(FAILED(hr))
        {
            wprintf_s(L"ERROR : failed to create instance of the IWbemLocator, code = 0x%08X, %s\n",hr,_com_error(hr).ErrorMessage());
            break;
        }

        // Connect to WMI through the IWbemLocator::ConnectServer method
        BSTR pstrUser = nullptr;                 // User name. nullptr means current user
        BSTR pstrPwd = nullptr;                  // User password. nullptr means current pwd
        BSTR pstrAuthority = nullptr;            // Authority (for example, Kerberos)
        _bstr_t strTarget(WMI_DEF_TARGET WMI_NV_NAMESPACE); // TODO: for remote target, replace 'localhost' with remote name or IP address

        // Connect to the NV namespace with the current user and obtain pointer pSvc to make IWbemServices calls
        hr = pLoc->ConnectServer(strTarget, pstrUser, pstrPwd, nullptr, 0, pstrAuthority, 0, &pSvc);
        if(FAILED(hr))
        {
            wprintf_s(L"ERROR : could not connect to the %s WMI object store, code=0x%08X, %s\n", (wchar_t*)strTarget, hr, _com_error(hr).ErrorMessage());
            break;
        }

        wprintf_s(L"Connected to the %s WMI object store\n", (wchar_t*)strTarget);

        // Set security levels on the proxy 
        hr = CoSetProxyBlanket(pSvc, RPC_C_AUTHN_WINNT, RPC_C_AUTHZ_NONE, nullptr, RPC_C_AUTHN_LEVEL_CALL, RPC_C_IMP_LEVEL_IMPERSONATE, nullptr, EOAC_NONE);
        if(FAILED(hr))
        {
            wprintf_s(L"ERROR : failed to set proxy blanket, code = 0x%08X, %s\n",hr, _com_error(hr).ErrorMessage());
            break;
        }

        IWbemClassObject* pWmiObjClass = nullptr;
        hr = pSvc->GetObject(_bstr_t(pszClassName), 0, nullptr, &pWmiObjClass, nullptr); 
        if(FAILED(hr))
        {
            wprintf_s(L"ERROR : failed to retrieve %s class, code = 0x%08X, %s\n", pszClassName, hr,_com_error(hr).ErrorMessage());
            break;
        }

        // see also NVWMI.MOF - System class properties from MOF class definition
        // current NVWMI.MOF could be found at %windir%/system32/wbem
        SAFEARRAY* psaNames = nullptr;
        hr = pWmiObjClass->GetNames(nullptr, WBEM_FLAG_ALWAYS | WBEM_FLAG_NONSYSTEM_ONLY, nullptr, &psaNames);
        if(FAILED(hr))
        {
            wprintf_s(L"ERROR : GetNames failed, code=0x%08X, %s\n",hr,_com_error(hr).ErrorMessage());
            break;
        }

        long lLower=0;
        long lUpper=0; 
        BSTR propName = nullptr;
        SafeArrayGetLBound(psaNames, 1, &lLower);
        SafeArrayGetUBound(psaNames, 1, &lUpper);
        vector<wstring> vClassProperties;

        for(auto i=lLower; i<=lUpper; i++) 
        {
            hr = SafeArrayGetElement(psaNames, &i, &propName);
            vClassProperties.push_back(propName);
            SysFreeString(propName);
        }

        SafeArrayDestroy(psaNames);
        ULONG uReturn = 0;

        const _bstr_t strWql(WMI_QUERY_LANGUAGE);
        _bstr_t strSelectAll(WMI_QUERY_SELECT_ALL);
        strSelectAll += pszClassName;

        // Use the IWbemServices pointer to make requests of WMI
        ULONG wbemFlags = WBEM_FLAG_FORWARD_ONLY | WBEM_FLAG_RETURN_IMMEDIATELY;
        hr = pSvc->ExecQuery(strWql, strSelectAll, wbemFlags, nullptr, &pEnumerator);
        if(FAILED(hr))
        {
            wprintf_s(L"ERROR : failed to execute query, code = 0x%08X, %s\n",hr,_com_error(hr).ErrorMessage());
            break;
        }

        // Get the data from the query 
        ULONG retVal = 0; // WMI's "ReturnValue"
        _variant_t var;
        CIMTYPE type; // See MSDN article "CIMTYPE_ENUMERATION enumeration" - https://msdn.microsoft.com/en-us/library/aa386309%28v=vs.85%29.aspx 

        while(pEnumerator)
        {
            HRESULT hr = pEnumerator->Next(WBEM_INFINITE, 1, &pWmiObj, &retVal);
            if(FAILED(hr) || !retVal)
            {
                break; // note that pWmiObj does not require Release() in this case
            }

            for(auto it=vClassProperties.cbegin(); it!=vClassProperties.end(); it++)
            {
                auto prop = it->c_str();
                hr = pWmiObj->Get(prop, 0, &var, &type, nullptr);
                if(FAILED(hr))
                {
                    wprintf_s(L"ERROR : failed to get property '%s', code = 0x%08X, %s\n", prop, hr,_com_error(hr).ErrorMessage());
                    continue;       // NOTE : for older versions of NVWMI some properties might not be present, OK to continue
                }

                // print out all simple properties
                if(!(type & CIM_FLAG_ARRAY) && type!=CIM_OBJECT)
                {
                    _bstr_t strVal = var; // convert to string - works only for scalar types - CIM_SINT32, CIM_UINT32, CIM_REAL32, CIM_STRING etc.
                    wprintf_s(L" %s::%s = %s\n", pszClassName, prop, (wchar_t*)strVal);
                }
                else if(type==CIM_OBJECT)
                {
                    // TODO: handle embedded objects
                }
                else if(type & CIM_FLAG_ARRAY)
                {
                    // TODO: handle arrays
                }
                var.Clear();
            }

            pWmiObj->Release();
        }

    } while(S_OK); // bogus loop to simplify error handling

    CoUninitialize();

    return hr;
}

//
// invoke given method for all instances of a given class 
//
HRESULT invokeClassMethod(const wchar_t* pszClassName, const wchar_t* pszMethodName)
{
    HRESULT hr;

    IWbemLocator* pLoc = nullptr;
    IWbemServices* pSvc = nullptr;
    IEnumWbemClassObject* pEnumerator = nullptr;

    const _bstr_t strMethod(pszMethodName);

    do
    {
        // Initialize COM for multi-threading
        hr = CoInitializeEx(nullptr, COINIT_MULTITHREADED);
        if(FAILED(hr))
        {
            break;
        }

        // Initialize COM Security
        hr = CoInitializeSecurity(nullptr, -1, nullptr, nullptr, RPC_C_IMP_LEVEL_IDENTIFY, RPC_C_AUTHN_LEVEL_CONNECT, nullptr, EOAC_DYNAMIC_CLOAKING, nullptr);
        if(FAILED(hr))
        {
            break;
        }

        // Obtain the initial locator to WMI 
        hr = CoCreateInstance(CLSID_WbemLocator, 0, CLSCTX_INPROC_SERVER, IID_IWbemLocator, (void**)&pLoc);
        if(FAILED(hr))
        {
            wprintf_s(L"ERROR : failed to create instance of the IWbemLocator, code = 0x%08X, %s\n",hr,_com_error(hr).ErrorMessage());
            break;
        }

        BSTR pstrUser = nullptr;                            // User name. nullptr means current user
        BSTR pstrPwd = nullptr;                             // User password. nullptr means current pwd
        BSTR pstrAuthority = nullptr;                       // Authority (for example, Kerberos)
        _bstr_t strTarget(WMI_DEF_TARGET WMI_NV_NAMESPACE); // TODO: for remote target, replace 'localhost' with remote name or IP address

        // Connect to the NV namespace with the current user and obtain pointer pSvc to make IWbemServices calls
        hr = pLoc->ConnectServer(strTarget, pstrUser, pstrPwd, nullptr, 0, pstrAuthority, 0, &pSvc);
        if(FAILED(hr))
        {
            wprintf_s(L"ERROR : could not connect to the %s WMI object store, code=0x%08X\n", (wchar_t*)strTarget, hr);
            break;
        }

        wprintf_s(L"Connected to the %s WMI object store\n", (wchar_t*)strTarget);

        // set security levels on the proxy
        hr = CoSetProxyBlanket(pSvc, RPC_C_AUTHN_WINNT, RPC_C_AUTHZ_NONE, nullptr, RPC_C_AUTHN_LEVEL_CALL, RPC_C_IMP_LEVEL_IMPERSONATE, nullptr, EOAC_NONE);
        if(FAILED(hr))
        {
            wprintf_s(L"ERROR : failed to set proxy blanket, code = 0x%08X, %s\n",hr,_com_error(hr).ErrorMessage());
            break;
        }

        // get method signature - input and output objects
        // NOTE: this call does not retrieve actual class instances, only a blueprint of a WMI class - property names, method signatures
        IWbemClassObject* pIn = nullptr;
        IWbemClassObject* pOut= nullptr;
        {
            IWbemClassObject* pWmiObjClass = nullptr;
            hr = pSvc->GetObject(_bstr_t(pszClassName), 0, nullptr, &pWmiObjClass, nullptr); 
            if(FAILED(hr))
            {
                wprintf_s(L"ERROR : failed to retrieve %s class, code = 0x%08X, %s\n", pszClassName, hr,_com_error(hr).ErrorMessage());
                break;
            }

            // retrieve method signature - input and output objects
            hr = pWmiObjClass->GetMethod(WMI_INFO, 0, &pIn, &pOut);

            pWmiObjClass->Release();
        }

        const _bstr_t strWql(WMI_QUERY_LANGUAGE);
        _bstr_t strSelectPath(WMI_QUERY_SELECT_PATH);
        strSelectPath += pszClassName;
        // query could be customized to select only properties of interest, 
        // to address class instances it's enough to retrieve either __PATH or __RELPATH
        ULONG wbemFlags = WBEM_FLAG_FORWARD_ONLY | WBEM_FLAG_RETURN_IMMEDIATELY;
        hr = pSvc->ExecQuery( strWql, strSelectPath, wbemFlags, nullptr, &pEnumerator);
        if(FAILED(hr))
        {
            wprintf_s(L"ERROR : failed to execute query, code = 0x%08X, %s\n",hr,_com_error(hr).ErrorMessage());
            break;
        }

        VARIANT varPath;
        vector<_bstr_t> vPaths;
        IWbemClassObject* pWmiObj = nullptr;
        ULONG retVal = 0; // WMI's "ReturnValue"

        // enumerate instances in query results
        while(pEnumerator)
        {
            HRESULT hr = pEnumerator->Next(WBEM_INFINITE, 1, &pWmiObj, &retVal);
            if(FAILED(hr) || !retVal)
            {
                break; // note that pWmiObj does not require Release() in this case
            }

            // Get the value of the "__PATH" property. "__RELPATH" could be used too.
            hr = pWmiObj->Get(WMI_PROP_PATH, 0, &varPath, nullptr, nullptr);
            vPaths.push_back(_bstr_t(varPath));
            VariantClear(&varPath);

            pWmiObj->Release();
        }

        pEnumerator->Release();

        for(auto it=vPaths.cbegin(); it!=vPaths.cend(); it++)
        {
            IWbemClassObject* pWmiObjInfoIn = nullptr;
            if(pIn) // for clarity only, spawning instance is unnecessary for methods without input parameters (e.g. info() )
            {
                hr = pIn->SpawnInstance(0, &pWmiObjInfoIn);
            }

            IWbemClassObject* pWmiObjInfoOut = nullptr;
            hr = pOut->SpawnInstance(0, &pWmiObjInfoOut);

            IWbemCallResult* wmiRes = nullptr;
            auto const& strPath=*it;
            hr = pSvc->ExecMethod(strPath, strMethod, 0, nullptr, pWmiObjInfoIn, &pWmiObjInfoOut, nullptr);
            if(FAILED(hr))
            {
                wprintf_s(L"ERROR : failed to invoke %s::%s() for the instance '%s', code = 0x%08X, %s\n", 
                    pszClassName, pszMethodName, (wchar_t*)strPath, hr, _com_error(hr).ErrorMessage());
                break;
            }

            if(pWmiObjInfoOut)
            {
                // To see what the method returned, use the following code. The return value will be in &varReturnValue
                VARIANT varReturnValue;
                hr = pWmiObjInfoOut->Get(WMI_METHOD_RETURN, 0, &varReturnValue, nullptr, nullptr);

                wprintf_s(L"%s::%s() for the instance '%s'\n", pszClassName, pszMethodName, (wchar_t*)strPath);
                wprintf_s(L"return code = 0x%08X (%s):\n", hr, _com_error(hr).ErrorMessage());
                wprintf_s(L"return value:\n%s\n", varReturnValue.bstrVal);

                VariantClear(&varReturnValue);
            }

            pWmiObjInfoOut->Release();
        }
    } while(S_OK); // bogus loop to simplify error handling

    CoUninitialize();

    return hr;
}

int wmain(int argc, wchar_t* argv[])
{
    HRESULT hr;
    // use WBEM engine to query properties of all Gpu instances 
    hr = getClassProperties(WMI_CLASS);

    // invoke info() method for all Gpu instances 
    hr = invokeClassMethod(WMI_CLASS, WMI_INFO);

    return 0;
}

