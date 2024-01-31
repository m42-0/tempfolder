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
// COMPANY:     NVIDIA Corporation
// NAME:        GpuPerfCounters.cpp
// AUTHOR:      NVIDIA Corporation
// REQUIRES:    C++11-compatible compiler, WBEM and PDH libraries
// 
// SYNOPSIS:    demonstrates how to get WMI object properties of the Gpu class 
// and how to query performance counters, provided by NVWMI
//
// DESCRIPTION: Queries "id", "nvapiId" and "name" properties from 1st instance 
// of the Gpu class. Formats path to the performance counter with GPU temperature 
// and reports temperature in loop every second until a key is pressed.
//
// See NVWMI Programming Guide in NVWMI.CHM and MOF class definitions in NVWMI.MOF 
// for more details
//
//////////////////////////////////////////////////////////////////////////////////


#define _WIN32_DCOM

#include <SDKDDKVer.h>
#include <windows.h>
#include <stdio.h>
#include <conio.h>
#include <comdef.h>
#include <wbemidl.h>

#include <pdh.h>
#include <pdhmsg.h>

#pragma comment(lib, "wbemuuid.lib")    // WMI engine 
#pragma comment(lib, "pdh.lib")         // PDH engine 

//
// format performance counter path using Gpu instance properties, queried via WBEM engine
//
HRESULT formatGpuCounter(const wchar_t* pszCounterName, wchar_t* pszCounterPath, size_t bufSize)
{
    HRESULT hr;

    IWbemLocator* pLoc = nullptr;
    IWbemServices* pSvc = nullptr;
    IEnumWbemClassObject* pEnumerator = nullptr;
    IWbemClassObject* pGpu = nullptr;

    do
    {
        if(!pszCounterPath || !bufSize)
        {
            wprintf_s(L"ERROR : invalid input parameters\n");
            break;
        }

        // Initialize COM for multi-threading
        hr = CoInitializeEx(0, COINIT_MULTITHREADED);
        if(FAILED(hr))
        {
            break;
        }

        // Initialize COM Security
        hr = CoInitializeSecurity(0, -1, 0, 0, RPC_C_IMP_LEVEL_IDENTIFY, RPC_C_AUTHN_LEVEL_CONNECT, 0, EOAC_DYNAMIC_CLOAKING, 0);
        if(FAILED(hr))
        {
            break;
        }

        // Obtain the initial locator to WMI 
        hr = CoCreateInstance(CLSID_WbemLocator, 0, CLSCTX_INPROC_SERVER, IID_IWbemLocator, (void**)&pLoc);
        if(FAILED(hr))
        {
            wprintf_s(L"ERROR : failed to create instance of the IWbemLocator, code = 0x%08X\n",hr);
            break;
        }

        // Connect to WMI through the IWbemLocator::ConnectServer method
        BSTR pstrUser = nullptr;                 // User name. null means current user
        BSTR pstrPwd = nullptr;                  // User password. null means current pwd
        BSTR pstrAuthority = nullptr;            // Authority (for example, Kerberos)
        _bstr_t strTarget(L"\\\\localhost\\ROOT\\CIMV2\\NV"); // TODO: for remote target, replace 'localhost' with remote name or IP address

        // Connect to the NV namespace with the current user and obtain pointer pSvc to make IWbemServices calls
        hr = pLoc->ConnectServer(strTarget, pstrUser, pstrPwd, nullptr, 0, pstrAuthority, 0, &pSvc);
        if(FAILED(hr))
        {
            wprintf_s(L"ERROR : could not connect to the %s WMI object store, code=0x%08X\n", (wchar_t*)strTarget, hr);
            break;                // Program has failed.
        }

        wprintf_s(L"Connected to the %s WMI object store\n", (wchar_t*)strTarget);

        // Set security levels on the proxy -------------------------
        hr = CoSetProxyBlanket(pSvc, RPC_C_AUTHN_WINNT, RPC_C_AUTHZ_NONE, nullptr, RPC_C_AUTHN_LEVEL_CALL, RPC_C_IMP_LEVEL_IMPERSONATE, nullptr, EOAC_NONE);
        if(FAILED(hr))
        {
            wprintf_s(L"ERROR : failed to set proxy blanket, code = 0x%08X\n",hr);
            break;
        }

        // Use the IWbemServices pointer to make requests of WMI
        // For example, get the name of the operating system
        ULONG wbemFlags = WBEM_FLAG_FORWARD_ONLY | WBEM_FLAG_RETURN_IMMEDIATELY;
        hr = pSvc->ExecQuery( bstr_t(L"WQL"), bstr_t(L"SELECT * FROM Gpu"), wbemFlags, nullptr, &pEnumerator);
        if(FAILED(hr))
        {
            wprintf_s(L"ERROR : failed to execute query, code = 0x%08X\n",hr);
            break;
        }

        // Get the data from the query 
        ULONG retVal = 0; // WMI's "ReturnValue"
        VARIANT varId;
        VARIANT varNvapiId;
        VARIANT varName;

        while(pEnumerator)
        {
            HRESULT hr = pEnumerator->Next(WBEM_INFINITE, 1, &pGpu, &retVal);
            if(hr != WBEM_S_NO_ERROR || !retVal)
            {
                break; // note that pGpu does not require Release() in this case
            }

            // Get the value of the Name property
            hr = pGpu->Get(L"id", 0, &varId, 0, 0);
            hr = pGpu->Get(L"nvapiId", 0, &varNvapiId, 0, 0);
            hr = pGpu->Get(L"name", 0, &varName, 0, 0);

            auto id = varId.ulVal;
            auto nvapiId = varNvapiId.ulVal;
            auto name = varName.bstrVal;

            wprintf_s(L" GPU ID:       %d\n", id);
            wprintf_s(L" GPU NVAPI ID: %d (0x%X)\n", nvapiId, nvapiId);
            wprintf_s(L" GPU name:     %s\n", name);

            // for NVWMI 2.18 and earlier, format string is L"\\NVIDIA GPU(#%d %s (id=%d))\\%s", use "handle" property instead of "nvapiId"
            swprintf_s(pszCounterPath, bufSize, L"\\NVIDIA GPU(#%d %s (id=%d, NVAPI ID=%d))\\%s", id-1, name, id, nvapiId, pszCounterName);

            VariantClear(&varId);
            VariantClear(&varNvapiId);
            VariantClear(&varName);

            pGpu->Release();

            break; // stop demo after 1st GPU
        }

    } while(S_OK); // bogus loop to simplify error handling

    CoUninitialize();

    return hr;
}

//
// query specified performance counter using PDH engine
//
PDH_STATUS queryPerfCounter(const wchar_t* pszCounterPath, const ULONG queryInterval)
{
    HQUERY  hQuery = nullptr;
    HCOUNTER counter;
    PDH_STATUS rc;
    PDH_FMT_COUNTERVALUE counterValue;
    ULONG counterType;
    SYSTEMTIME sampleTime;

    ULONG_PTR pUserData = 0;
    wchar_t* pszDataSource = nullptr;

    do
    {
        // Open a Query
        rc = PdhOpenQuery(pszDataSource, pUserData, &hQuery);
        if(rc != S_OK) 
        {
           wprintf_s(L"ERROR : PdhOpenQuery failed, code = 0x%08X\n", rc);
           break;
        }

        // Add the selected counter to the Query. 
        // NOTE: counter name is sensitive to text encoding. It must be UTF-16
        rc = PdhAddCounter(hQuery, pszCounterPath, 0, &counter);
        if(rc != S_OK) 
        {
            wprintf_s(L"ERROR : PdhAddCounter failed, code = 0x%08X\n", rc);
            break;
        }

        // Most counters require two sample values to display a formatted value.
        // PDH stores the current sample value and the previously collected
        // sample value. This call retrieves the first value that will be used
        // by PdhGetFormattedCounterValue in the first iteration of the loop
        // Note that this value is lost if the counter does not require two
        // values to compute a displayable value.
        rc = PdhCollectQueryData(hQuery);
        if(rc != S_OK) 
        {
            wprintf_s(L"ERROR : PdhCollectQueryData failed, code = 0x%08X\n", rc);
            break;
        }

        // Print counter values until a key is pressed.
        while(!_kbhit()) 
        {
            GetLocalTime(&sampleTime);
            rc = PdhCollectQueryData(hQuery);
            if(rc != S_OK) 
            {
                wprintf_s(L"ERROR : PdhCollectQueryData failed, code = 0x%08X\n", rc);
            }

            // format a timestamp
            wprintf_s(L"%2.2d/%2.2d/%4.4d %2.2d:%2.2d:%2.2d.%3.3d : ", 
                sampleTime.wMonth,sampleTime.wDay,sampleTime.wYear,sampleTime.wHour,sampleTime.wMinute,sampleTime.wSecond,sampleTime.wMilliseconds);

            // compute a displayable value for the counter.
            rc = PdhGetFormattedCounterValue(counter, PDH_FMT_DOUBLE, &counterType, &counterValue);
            if(rc != S_OK) 
            {
                wprintf_s(L"ERROR : PdhGetFormattedCounterValue failed, code = 0x%08X\n", rc);
                break;
            }

            wprintf_s(L"%.20g\n", counterValue.doubleValue);
            Sleep(queryInterval);
        }
    } while(S_OK); // bogus loop to simplify error handling

    // Close the Query
    if(hQuery) 
    {
       PdhCloseQuery(hQuery);
    }
    return rc;
}

int wmain(int argc, wchar_t* argv[])
{
    wchar_t szCounterPath[PDH_MAX_COUNTER_PATH];
    *szCounterPath=0;

    // Note that name of the counter with CPU temperature differs across releases. 
    // It could be "Temperature C", "Temperature" or "Temperature °C".
    // Name of the counter as listed in the section 
    // "Available NVIDIA GPU Counters" of the page "NVIDIA Performance Counters", NVWMI Programming Guide:
    wchar_t szCounterName[] = L"Temperature C";

    // use WBEM engine to query Gpu instances and format path to the performance counter object
    HRESULT hrFormatted = formatGpuCounter(szCounterName, szCounterPath, _countof(szCounterPath));

    // use PDH (Performance Counter 2.0) engine to query performance counter data in a loop
    const ULONG queryInterval = 1000; // in milliseconds
    PDH_STATUS gotCounter = queryPerfCounter(szCounterPath, queryInterval);

    return 0;
}
