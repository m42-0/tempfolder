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
// NAME:        DisplayProfile.cpp
// AUTHOR:      NVIDIA Corporation
// REQUIRES:    C++11-compatible compiler, WBEM library
// 
// SYNOPSIS:    invoke ProgramManager::saveDisplayProfiles("sample"), verify results
//
// DESCRIPTION: demonstrates how to invoke a static method 
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

#pragma comment(lib, "wbemuuid.lib")                                // WMI engine 

#define WMI_PROP_PATH           L"__PATH"                           // WMI property, inherited by all classes - path to the class instance
#define WMI_METHOD_RETURN       L"ReturnValue"                      // property name in WMI output object with result of a method execution
#define WMI_CLASS               L"ProfileManager"                   // name of the class to inquire
#define WMI_METHOD              L"saveDisplayProfiles"              // name of the method 
#define WMI_PROFILES_PREFIX     L"prefix"                           // name of the input object property
#define WMI_PREFIX_VALUE        L"sample"                           // value of the input object property
#define WMI_NV_NAMESPACE        L"\\root\\cimv2\\nv"                // path to NV namespace. See NVWMI.MOF. Case-insensitive
#define WMI_DEF_TARGET          L"\\\\localhost"                    // by default, target localhost

//
// saves a set of display profiles (one profile per DisplayGrid) with given prefix
//
HRESULT saveDisplayProfiles(const wchar_t* profilePrefix)
{
    HRESULT hr;

    IWbemLocator* pLoc = nullptr;
    IWbemServices* pSvc = nullptr;
    IEnumWbemClassObject* pEnumerator = nullptr;

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

        // see also NVWMI.MOF - ProfileManager class properties and methods from MOF class definition
        // current NVWMI.MOF could be found at %windir%/system32/wbem
        ULONG uReturn = 0;

        // get method signature - input and output objects
        // NOTE: for singleton classes like ProgramManager it will retrieve an actual instance
        IWbemClassObject* pIn = nullptr;
        IWbemClassObject* pOut= nullptr;
        IWbemClassObject* profileManClass = nullptr;
        hr = pSvc->GetObject(WMI_CLASS, 0, nullptr, &profileManClass, nullptr); 
        if(FAILED(hr))
        {
            wprintf_s(L"ERROR : failed to retrieve %s class, code = 0x%08X, %s\n", WMI_CLASS, hr,_com_error(hr).ErrorMessage());
            break;
        }

        // retrieve method signature - input and output objects
        hr = profileManClass->GetMethod(WMI_METHOD, 0, &pIn, &pOut);

        IWbemClassObject* pSaveDisplayProfilesIn = nullptr;
        hr = pIn->SpawnInstance(0, &pSaveDisplayProfilesIn);

        _variant_t varPrefix(profilePrefix);
        hr = pSaveDisplayProfilesIn->Put(WMI_PROFILES_PREFIX,0, &varPrefix, CIM_STRING);
        if(FAILED(hr))
        {
            wprintf_s(L"ERROR : failed to set property %s=%s, code = 0x%08X, %s\n", WMI_PROFILES_PREFIX, varPrefix.bstrVal, hr,_com_error(hr).ErrorMessage());
            break;
        }

        IWbemClassObject* pSaveDisplayProfilesOut = nullptr;
        hr = pOut->SpawnInstance(0, &pSaveDisplayProfilesOut);

        IWbemCallResult* wmiRes = nullptr;
        hr = pSvc->ExecMethod(WMI_CLASS, WMI_METHOD, 0, nullptr, pSaveDisplayProfilesIn, &pSaveDisplayProfilesOut, nullptr);
        if(FAILED(hr))
        {
            wprintf_s(L"ERROR : failed to invoke %s::%s(), code = 0x%08X, %s\n", WMI_CLASS, WMI_METHOD, hr,_com_error(hr).ErrorMessage());
            break;
        }

        if(pSaveDisplayProfilesOut)
        {
            // To see what the method returned, use the following code. The return value will be in &varReturnValue
            VARIANT varReturnValue;
            hr = pSaveDisplayProfilesOut->Get(WMI_METHOD_RETURN, 0, &varReturnValue, nullptr, nullptr);

            wprintf_s(L"invoking %s::%s(%s)\n", WMI_CLASS, WMI_METHOD, WMI_PREFIX_VALUE);
            wprintf_s(L"return code = 0x%08X (%s), return value:%s\n", hr, _com_error(hr).ErrorMessage(),varReturnValue.boolVal?L"SUCCESS":L"FAILURE");
            // When saveDisplayProfiles method succeeds, a new set of display profiles will appear in the "%ProgramData%\NVIDIA Corporation\Drs\nvDisplayProfiles.prd".
            // Their names will be "sample 1", ... "sample N" where N - a number of Mosaics (aka DisplayGrid for NVWMI)

            VariantClear(&varReturnValue);
        }

        pSaveDisplayProfilesOut->Release();
        pSaveDisplayProfilesIn->Release();
        profileManClass->Release();

    } while(S_OK); // bogus loop to simplify error handling

    CoUninitialize();

    return hr;
}


int wmain(int argc, wchar_t* argv[])
{
    HRESULT hr;

    // save display profiles with prefix "sample"
    hr = saveDisplayProfiles(WMI_PREFIX_VALUE);

    return 0;
}

