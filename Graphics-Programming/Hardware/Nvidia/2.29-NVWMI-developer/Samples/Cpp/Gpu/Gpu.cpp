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
// NAME:        Gpu.cpp
// AUTHOR:      NVIDIA Corporation
// REQUIRES:    C++11-compatible compiler, WBEM library, STD C++ library
// 
// SYNOPSIS:    demonstrates how to get WMI object properties of the Gpu class 
//              and how to invoke its methods
//
// DESCRIPTION: Queries all properties and invokes info() method of all instances 
//              of the Gpu class
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
#include <sstream>
using namespace std;

#pragma comment(lib, "wbemuuid.lib")                                // WMI engine 

#define WMI_PROP_PATH           L"__PATH"                           // WMI property, inherited by all classes - path to the class instance
#define WMI_METHOD_RETURN       L"ReturnValue"                      // property name in WMI output object with result of a method execution
#define WMI_GPU_CLASS           L"Gpu"                              // name of the class inquire
#define WMI_GPU_INFO            L"info"                             // name of the Gpu class method to obtain information
#define WMI_NV_NAMESPACE        L"\\root\\cimv2\\nv"                // path to NV namespace. See NVWMI.MOF. Case-insensitive
#define WMI_DEF_TARGET          L"\\\\localhost"                    // by default, target localhost
#define WMI_QUERY_LANGUAGE      L"WQL"                              // always WQL
#define WMI_QUERY_SELECT_ALL    L"SELECT * FROM "                   // WQL query for all properties of some class
#define WMI_QUERY_SELECT_PATH   L"SELECT " WMI_PROP_PATH L" FROM "  // WQL query to select property __PATH from instances of some class
#define WMI_QUERY_SELECT_ID_1   L"id=1"                             // WQL query to select instances where property 'id' has value '1'

//
// get properties of all Gpu class instances
//
HRESULT getAllGpuProperties()
{
    HRESULT hr;

    IWbemLocator* pLoc = nullptr;
    IWbemServices* pSvc = nullptr;
    IEnumWbemClassObject* pEnumerator = nullptr;
    IWbemClassObject* pGpu = nullptr;

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

        IWbemClassObject* pGpuClass = nullptr;
        hr = pSvc->GetObject(WMI_GPU_CLASS, 0, nullptr, &pGpuClass, nullptr); 
        if(FAILED(hr))
        {
            wprintf_s(L"ERROR : failed to retrieve %s class, code = 0x%08X, %s\n", WMI_GPU_CLASS, hr,_com_error(hr).ErrorMessage());
            break;
        }

        // see also NVWMI.MOF - Gpu class properties from MOF class definition
        // current NVWMI.MOF could be found at %windir%/system32/wbem
        SAFEARRAY* psaNames = nullptr;
        hr = pGpuClass->GetNames(nullptr, WBEM_FLAG_ALWAYS | WBEM_FLAG_NONSYSTEM_ONLY, nullptr, &psaNames);
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
        vector<wstring> vGpuProperties;

        for(auto i=lLower; i<=lUpper; i++) 
        {
            hr = SafeArrayGetElement(psaNames, &i, &propName);
            vGpuProperties.push_back(propName);
            SysFreeString(propName);
        }

        SafeArrayDestroy(psaNames);
        ULONG uReturn = 0;

        const bstr_t strWql(WMI_QUERY_LANGUAGE);
        const bstr_t strSelectAll(WMI_QUERY_SELECT_ALL WMI_GPU_CLASS);

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
            HRESULT hr = pEnumerator->Next(WBEM_INFINITE, 1, &pGpu, &retVal);
            if(FAILED(hr) || !retVal)
            {
                break; // note that pGpu does not require Release() in this case
            }

            for(auto it=vGpuProperties.cbegin(); it!=vGpuProperties.end(); it++)
            {
                auto prop = it->c_str();
                hr = pGpu->Get(prop, 0, &var, &type, nullptr);
                if(FAILED(hr))
                {
                    wprintf_s(L"ERROR : failed to get property '%s', code = 0x%08X, %s\n", prop, hr,_com_error(hr).ErrorMessage());
                    continue;       // NOTE : for older versions of NVWMI some properties might not be present, OK to continue
                }

                // print out all simple properties
                if(!(type & CIM_FLAG_ARRAY) && type!=CIM_OBJECT)
                {
                    _bstr_t strVal = var; // convert to string - works only for scalar types - CIM_SINT32, CIM_UINT32, CIM_REAL32, CIM_STRING etc.
                    wprintf_s(L" GPU %s= %s\n", prop, (wchar_t*)strVal);
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

            pGpu->Release();
        }

    } while(S_OK); // bogus loop to simplify error handling

    CoUninitialize();

    return hr;
}

//
// invoke info method for all instances of the Gpu class 
//
HRESULT invokeAllGpuInfo()
{
    HRESULT hr;

    IWbemLocator* pLoc = nullptr;
    IWbemServices* pSvc = nullptr;
    IEnumWbemClassObject* pEnumerator = nullptr;

    const _bstr_t strInfoMethod(WMI_GPU_INFO);

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
            IWbemClassObject* pGpuClass = nullptr;
            hr = pSvc->GetObject(WMI_GPU_CLASS, 0, nullptr, &pGpuClass, nullptr); 
            if(FAILED(hr))
            {
                wprintf_s(L"ERROR : failed to retrieve %s class, code = 0x%08X, %s\n", WMI_GPU_CLASS, hr,_com_error(hr).ErrorMessage());
                break;
            }

            // retrieve method signature - input and output objects
            hr = pGpuClass->GetMethod(WMI_GPU_INFO, 0, &pIn, &pOut);

            pGpuClass->Release();
        }

        const bstr_t strWql(WMI_QUERY_LANGUAGE);
        const bstr_t strSelectPath(WMI_QUERY_SELECT_PATH WMI_GPU_CLASS);
        // query could be customized to select only properties of interest, 
        // to address Gpu instances it's enough to retrieve either __PATH or __RELPATH
        ULONG wbemFlags = WBEM_FLAG_FORWARD_ONLY | WBEM_FLAG_RETURN_IMMEDIATELY;
        hr = pSvc->ExecQuery(strWql, strSelectPath, wbemFlags, nullptr, &pEnumerator);
        if(FAILED(hr))
        {
            wprintf_s(L"ERROR : failed to execute query, code = 0x%08X, %s\n",hr,_com_error(hr).ErrorMessage());
            break;
        }

        VARIANT varPath;
        vector<_bstr_t> vPaths;
        IWbemClassObject* pGpu = nullptr;
        ULONG retVal = 0; // WMI's "ReturnValue"

        // enumerate instances in query results
        while(pEnumerator)
        {
            HRESULT hr = pEnumerator->Next(WBEM_INFINITE, 1, &pGpu, &retVal);
            if(FAILED(hr) || !retVal)
            {
                break; // note that pGpu does not require Release() in this case
            }

            // Get the value of the "__PATH" property. "__RELPATH" could be used too.
            hr = pGpu->Get(WMI_PROP_PATH, 0, &varPath, nullptr, nullptr);
            vPaths.push_back(_bstr_t(varPath));
            VariantClear(&varPath);

            pGpu->Release();
        }

        pEnumerator->Release();

        for(auto it=vPaths.cbegin(); it!=vPaths.cend(); it++)
        {
            IWbemClassObject* pGpuInfoIn = nullptr;
            if(pIn) // not necessary for Gpu::info() - it doesn't have input parameters
            {
                hr = pIn->SpawnInstance(0, &pGpuInfoIn);
            }

            IWbemClassObject* pGpuInfoOut = nullptr;
            hr = pOut->SpawnInstance(0, &pGpuInfoOut);

            IWbemCallResult* wmiRes = nullptr;
            auto const& strPath=*it;
            hr = pSvc->ExecMethod(strPath, strInfoMethod, 0, nullptr, pGpuInfoIn, &pGpuInfoOut, nullptr);
            if(FAILED(hr))
            {
                wprintf_s(L"ERROR : failed to invoke Gpu::info() for the instance '%s', code = 0x%08X, %s\n", (wchar_t*)strPath, hr,_com_error(hr).ErrorMessage());
                break;
            }

            if(pGpuInfoOut)
            {
                // To see what the method returned, use the following code. The return value will be in &varReturnValue
                VARIANT varReturnValue;
                hr = pGpuInfoOut->Get(WMI_METHOD_RETURN, 0, &varReturnValue, nullptr, nullptr);

                wprintf_s(L"Gpu::info() for the instance '%s'\n", (wchar_t*)strPath);
                wprintf_s(L"return code = 0x%08X (%s):\n", hr, _com_error(hr).ErrorMessage());
                wprintf_s(L"return value:\n%s\n",varReturnValue.bstrVal);

                VariantClear(&varReturnValue);
            }

            pGpuInfoOut->Release();
        }
    } while(S_OK); // bogus loop to simplify error handling

    CoUninitialize();

    return hr;
}

//
// invoke generic WMI method without arguments for selected instances only
//
bool invokeMethod(const wchar_t* pszClassName, const wchar_t* pszMethodName, const wchar_t* pszSelector)
{
    bool rc = false;
    HRESULT hr;

    IWbemLocator* pLoc = nullptr;
    IWbemServices* pSvc = nullptr;

    const bstr_t strWql(WMI_QUERY_LANGUAGE);
    IEnumWbemClassObject* pEnumerator = nullptr;
    IWbemClassObject* pIn = nullptr;
    IWbemClassObject* pOut= nullptr;
    IWbemClassObject* pWmiClass = nullptr;
    IWbemClassObject* pObj = nullptr;
    IWbemClassObject* pObjIn = nullptr;
    IWbemClassObject* pObjOut = nullptr;

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

        ULONG wbemFlags = WBEM_FLAG_FORWARD_ONLY | WBEM_FLAG_RETURN_IMMEDIATELY;

        wostringstream wos;
        wos<<WMI_QUERY_SELECT_ALL<<pszClassName<<L" WHERE "<<pszSelector;
        bstr_t strSelectPath(wos.str().c_str());

        hr = pSvc->ExecQuery(strWql, strSelectPath, wbemFlags, nullptr, &pEnumerator);
        if(FAILED(hr))
        {
            wprintf_s(L"ERROR : failed to execute WQL query '%s', code = 0x%08X, %s\n",(wchar_t*)strSelectPath,hr,_com_error(hr).ErrorMessage());
            break;
        }

        ULONG retVal = 0; // WMI's "ReturnValue"

        // get method signature - input and output objects
        // NOTE: this call does not retrieve actual class instances, only a blueprint of a WMI class - property names, method signatures
        hr = pSvc->GetObject(bstr_t(pszClassName), 0, nullptr, &pWmiClass, nullptr); 
        if(FAILED(hr))
        {
            wprintf_s(L"ERROR : failed to get WMI class '%s', code = 0x%08X, %s\n",pszClassName,hr,_com_error(hr).ErrorMessage());
            break;
        }

        // retrieve method signature - input and output objects
        hr = pWmiClass->GetMethod(pszMethodName, 0, &pIn, &pOut);
        if(FAILED(hr))
        {
            wprintf_s(L"ERROR : failed to get WMI method '%s', code = 0x%08X, %s\n",pszMethodName,hr,_com_error(hr).ErrorMessage());
            break;
        }

        VARIANT varPath;
        const bstr_t strMethodName(pszMethodName);

        // enumerate instances of WMI class in query results
        while(pEnumerator)
        {
            HRESULT hr = pEnumerator->Next(WBEM_INFINITE, 1, &pObj, &retVal);
            if(FAILED(hr) || !retVal)
            {
                break; // note that pObj does not require Release() in this case
            }

            hr = pObj->Get(WMI_PROP_PATH, 0, &varPath, nullptr, nullptr);
            if(FAILED(hr))
            {
                wprintf_s(L"ERROR : failed to get path to the instance of WMI class, code = 0x%08X, %s\n",hr,_com_error(hr).ErrorMessage());
                break;
            }

            if(pIn) // spawn input object for methods with input parameters
            {
                hr = pIn->SpawnInstance(0, &pObjIn);
                if(FAILED(hr))
                {
                    wprintf_s(L"ERROR : failed to spawn instance of input object, code = 0x%08X, %s\n",hr,_com_error(hr).ErrorMessage());
                    break;
                }
            }

            hr = pOut->SpawnInstance(0, &pObjOut);
            if(FAILED(hr))
            {
                wprintf_s(L"ERROR : failed to spawn instance of output object, code = 0x%08X, %s\n",hr,_com_error(hr).ErrorMessage());
                break;
            }

            IWbemCallResult* wmiRes = nullptr;
            bstr_t strPath(varPath);

            hr = pSvc->ExecMethod(strPath, strMethodName, 0, nullptr, pObjIn, &pObjOut, nullptr);
            if(FAILED(hr))
            {
                wprintf_s(L"ERROR : failed to execute method %s, code = 0x%08X, %s\n",(wchar_t*)strMethodName,hr,_com_error(hr).ErrorMessage());
                break;
            }

            if(pObjOut)
            {
                // To see what the method returned, use the following code. The return value will be in &varReturnValue
                VARIANT varReturnValue;

                hr = pObjOut->Get(WMI_METHOD_RETURN, 0, &varReturnValue, nullptr, nullptr);
                if(FAILED(hr))
                {
                    wprintf_s(L"ERROR : failed to get instance of output object, code = 0x%08X, %s\n",hr,_com_error(hr).ErrorMessage());
                    break;
                }

                wprintf_s(L"Gpu::info() for the instance '%s'\n", (wchar_t*)strPath);
                wprintf_s(L"return code = 0x%08X (%s):\n", hr, _com_error(hr).ErrorMessage());
                wprintf_s(L"return value:\n%s\n",varReturnValue.bstrVal);

                rc = varReturnValue.bVal!=FALSE;
                VariantClear(&varReturnValue);

                pObjOut->Release();
                pObjOut = nullptr;
            }
            if(pObjIn)
            {
                pObjIn->Release();
                pObjIn = nullptr;
            }
        }
    } while(S_OK); // bogus loop to simplify error handling

    if(pObjOut)
    {
        pObjOut->Release();
    }

    if(pObjIn)
    {
        pObjIn->Release();
    }

    if(pWmiClass)
    {
        pWmiClass->Release();
    }

    if(pEnumerator)
    {
        pEnumerator->Release();
    }

    return rc;
}

int wmain(int argc, wchar_t* argv[])
{
    HRESULT hr;

    // use WBEM engine to query properties of all Gpu instances 
    hr = getAllGpuProperties();

    // 1. invoke info() method for all Gpu instances 
    hr = invokeAllGpuInfo();

    // 2. invoke info() method for selected Gpu instance
    hr = invokeMethod(WMI_GPU_CLASS, WMI_GPU_INFO, WMI_QUERY_SELECT_ID_1);

    // for systems with single GPU output from step 1. 
    // will be identical to output from step 2.

    return 0;
}

