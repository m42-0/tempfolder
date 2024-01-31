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
// NAME:        CloneDisplays.cpp
// AUTHOR:      NVIDIA Corporation
// REQUIRES:    C++11-compatible compiler, WBEM library
// 
// SYNOPSIS:    Clones all attached displays
//
// DESCRIPTION: Demonstrates how to create 1xN display grid and 
//              clone all attached displays by overlapping at screen width.
//
//              Generic WMI programming demonstrated:
//              - how to retrieve instances of dynamic WMI classes
//              - how to retrieve properties of WMI class instances, including embedded WMI objects
//              - how to invoke methods of dynamic WMI objects
//              - how to invoke methods of static (singleton) WMI objects
//
// See NVWMI Programming Guide in NVWMI.CHM and MOF class definitions in NVWMI.MOF 
// for more details.
//
//////////////////////////////////////////////////////////////////////////////////


#define _WIN32_DCOM

#include <SDKDDKVer.h>
#include <windows.h>
#include <comdef.h>
#include <wbemidl.h>

#include <map>
#include <string>
#include <sstream>
#include <iostream>

#pragma comment(lib, "wbemuuid.lib")                                // WMI engine 

#define WMI_PROP_PATH               L"__PATH"                           // WMI property, inherited by all classes - path to the class instance
#define WMI_METHOD_RETURN           L"ReturnValue"                      // property name in WMI output object with result of a method execution

#define WMI_QUERY_LANGUAGE          L"WQL"                              // always WQL
#define WMI_QUERY_SELECT_ALL        L"SELECT * FROM "                   // WQL query for all properties

#define WMI_PROFILE_MAN_CLASS       L"ProfileManager"                   // name of the WMI class 
#define WMI_DISPLAY_MAN_CLASS       L"DisplayManager"                   // name of the WMI class 
#define WMI_DISPLAY_CLASS           L"Display"                          // name of the WMI class 
#define WMI_DISPLAY_GRID_CLASS      L"DisplayGrid"                      // name of the WMI class 

#define WMI_VALIDATE_GRIDS_METHOD   L"validateDisplayGrids"             // name of the WMI method 
#define WMI_CREATE_GRIDS_METHOD     L"createDisplayGrids"               // name of the WMI method 
#define WMI_GRIDS_ARG               L"grids"                            // argument of WMI methods validateDisplayGrids, createDisplayGrids

#define WMI_SET_OVERLAP_COL_METHOD  L"setOverlapCol"                    // name of the WMI method 
#define WMI_OVERLAP_COL_INDEX       L"index"                            // argument of WMI method setOverlapCol
#define WMI_OVERLAP_COL_OVERLAP     L"overlap"                          // argument of WMI method setOverlapCol

#define WMI_NV_NAMESPACE            L"\\root\\cimv2\\nv"                // path to NV namespace. See NVWMI.MOF. Case-insensitive
#define WMI_DEF_TARGET              L"\\\\localhost"                    // by default, target localhost

using namespace std;

// auxiliary class for COM error handling
class ComErrorTracker
{
private:
    wostringstream  m_os;       // buffer for exception message
    wstring         m_tag;      // description of attempted operation
    int             m_line;     // location of attempted operation (e.g. __LINE__), set to 0 or negative to turn off
public:
    ComErrorTracker() : m_line(0){}

    void operator =(HRESULT hr)
    {
        if(FAILED(hr))
        {
            m_os<<L"ERROR ";
            if(m_line>0)
            {
                m_os<<"("<<m_line<<")";
            }
            m_os<<L": failed to "<<m_tag<<L", ";
            m_os<<wstring(_com_error(hr).ErrorMessage())<<endl;
            wstring& s = m_os.str();
            // convert to ANSI by narrowing trait wchar_t->char
            string msg(s.begin(),s.end());
            throw runtime_error(msg);
        }
    }

    ComErrorTracker& operator <<(int line)
    {
        m_line = line;
        return *this;
    }

    ComErrorTracker& operator <<(const wchar_t* tag)
    {
        m_tag = tag;
        return *this;
    }
};

typedef map<const wchar_t*,variant_t> KeyValueMap;

bool detectDisplayMode(IWbemServices* pSvc, int& displayCount, int& leastW, int& leastH, int& bpp, float& refresh)
{
    bool rc = false;
    IEnumWbemClassObject* pEnumerator = nullptr;
    IWbemClassObject* pObj = nullptr;
    IWbemClassObject* pNativeMode=nullptr;

    ULONG wbemFlags = WBEM_FLAG_FORWARD_ONLY | WBEM_FLAG_RETURN_IMMEDIATELY;
    const bstr_t strWql(WMI_QUERY_LANGUAGE);
    const bstr_t strSelectAll(WMI_QUERY_SELECT_ALL WMI_DISPLAY_CLASS);

    ComErrorTracker ceTrack;
    try
    {
        ceTrack<<__LINE__<<L"execute query";
        ceTrack = pSvc->ExecQuery(strWql, strSelectAll, wbemFlags, nullptr, &pEnumerator);

        variant_t var;
        variant_t varNative;
        CIMTYPE type; // See MSDN article "CIMTYPE_ENUMERATION enumeration" - https://msdn.microsoft.com/en-us/library/aa386309%28v=vs.85%29.aspx 
        ULONG retVal = 0; // WMI's "ReturnValue"
        leastW = INT_MAX;
        displayCount = 0;

        while(pEnumerator)
        {
            int width;

            ceTrack<<__LINE__<<L"get next instance of WMI class Display";
            ceTrack = pEnumerator->Next(WBEM_INFINITE, 1, &pObj, &retVal);

            if(!pObj || !retVal) // enumeration done, no more objects
            {
                break;
            }

            ceTrack<<__LINE__<<L"get displayModeNative";
            ceTrack = pObj->Get(L"displayModeNative", 0, &varNative, &type, nullptr);

            // Display.displayModeNative is a WMI object of DisplayMode type, it could be accessed via COM interface IUnknown
            ceTrack<<__LINE__<<L"query IWbemClassObject";
            ceTrack = ((IUnknown*)varNative)->QueryInterface(IID_IWbemClassObject, (void**)&pNativeMode);

            ceTrack<<__LINE__<<L"get width";
            ceTrack = pNativeMode->Get(L"width", 0, &var, &type, nullptr);
            width = var;
            var.Clear();

            // negative dimensions of native display mode indicate unavailable display
            if(width>0 && width<leastW)
            {
                leastW = width;
                ceTrack<<__LINE__<<L"get height";
                ceTrack = pNativeMode->Get(L"height", 0, &var, &type, nullptr);
                leastH = var;
                var.Clear();

                ceTrack<<__LINE__<<L"get colorDepth";
                ceTrack = pNativeMode->Get(L"colorDepth", 0, &var, &type, nullptr);
                bpp = var;
                var.Clear();

                ceTrack<<__LINE__<<L"get refreshRate";
                ceTrack = pNativeMode->Get(L"refreshRate", 0, &var, &type, nullptr);
                refresh = var;
                var.Clear();
                rc = true;
            }

            pNativeMode->Release();
            pNativeMode = nullptr;

            pObj->Release();
            pObj = nullptr;

            // count only enabled displays
            if(width>0)
            {
                ++displayCount;
            }
        }
    }
    catch(const runtime_error& e)
    {
        cout<<e.what();
    }

    if(pNativeMode)
    {
        pNativeMode->Release();
    }

    if(pObj)
    {
        pObj->Release();
    }

    if(pEnumerator)
    {
        pEnumerator->Release();
    }
    
    // at least two attached displays required
    if(displayCount<2)
    {
        rc = false;
    }

    return rc;
}

bool invokeStaticMethod(IWbemServices* pSvc, const wchar_t* pszClassName, const wchar_t* pszMethodName, const wchar_t* pszParamName, SAFEARRAY* param)
{
    bool rc = false;
    IWbemClassObject* pIn = nullptr;
    IWbemClassObject* pOut= nullptr;

    IWbemClassObject* pInValue = nullptr;
    IWbemClassObject* pOutValue = nullptr;

    IWbemClassObject* singletonClass = nullptr;
    ComErrorTracker ceTrack;

    try
    {
        const bstr_t strClassName(pszClassName);
        const bstr_t strMethodName(pszMethodName);

        ceTrack<<__LINE__<<L"get singleton object";
        ceTrack = pSvc->GetObject(strClassName, 0, nullptr, &singletonClass, nullptr); 

        // retrieve method signature - input and output objects
        ceTrack<<__LINE__<<L"get method signature";
        ceTrack = singletonClass->GetMethod(pszMethodName, 0, &pIn, &pOut);

        ceTrack<<__LINE__<<L"spawn input object";
        ceTrack = pIn->SpawnInstance(0, &pInValue);

        WBEM_E_TYPE_MISMATCH;

        VARIANT varParam;
        varParam.parray = param;
        varParam.vt = VT_ARRAY | VT_BSTR;
        ceTrack<<__LINE__<<L"initialize method parameter";
        ceTrack = pInValue->Put(pszParamName, 0, &varParam, varParam.vt);

        ceTrack<<__LINE__<<L"spawn method output instance";
        ceTrack = pOut->SpawnInstance(0, &pOutValue);

        IWbemCallResult* wmiRes = nullptr;
        ceTrack<<__LINE__<<L"invoke method";
        ceTrack = pSvc->ExecMethod(strClassName, strMethodName, 0, nullptr, pInValue, &pOutValue, nullptr);

        if(pOutValue)
        {
            // To see what the method returned, use the following code. The return value will be in &varReturnValue
            VARIANT varReturnValue;
            ceTrack = pOutValue->Get(WMI_METHOD_RETURN, 0, &varReturnValue, nullptr, nullptr);

            wcout<<L"invoking "<<pszClassName<<L"::"<<pszMethodName<<"("<<pszParamName<<") : ";
            wcout<<(varReturnValue.boolVal?L"SUCCESS":L"FAILURE")<<endl;

            rc = varReturnValue.boolVal!=FALSE;
            VariantClear(&varReturnValue);
        }

    }
    catch(const runtime_error& e)
    {
        cout<<e.what();
    }

    if(pOutValue)
    {
        pOutValue->Release();
    }
    
    if(pInValue)
    {
        pInValue->Release();
    }
    
    if(singletonClass)
    {
        singletonClass->Release();
    }

    if(pOut)
    {
        pOut->Release();
    }

    if(pIn)
    {
        pIn->Release();
    }

    return rc;
}

bool invokeMethod(IWbemServices* pSvc, const wchar_t* pszClassName, const wchar_t* pszMethodName, const wchar_t* pszSelector, KeyValueMap& args)
{
    bool rc = false;

    const bstr_t strWql(WMI_QUERY_LANGUAGE);
    IEnumWbemClassObject* pEnumerator = nullptr;
    IWbemClassObject* pWmiClass = nullptr;

    IWbemClassObject* pIn = nullptr;
    IWbemClassObject* pOut= nullptr;

    IWbemClassObject* pObj = nullptr;
    IWbemClassObject* pObjIn = nullptr;
    IWbemClassObject* pObjOut = nullptr;

    ULONG wbemFlags = WBEM_FLAG_FORWARD_ONLY|WBEM_FLAG_RETURN_IMMEDIATELY;  // semi-synchronous WMI calls
    ULONG retVal = 0;                                                       // WMI's "ReturnValue"

    wostringstream wos;
    ComErrorTracker ceTrack;

    try
    {
        wos<<WMI_QUERY_SELECT_ALL<<pszClassName<<L" WHERE "<<pszSelector;
        bstr_t strSelectPath(wos.str().c_str());
        
        ceTrack<<__LINE__<<L"execute WQL query";
        ceTrack = pSvc->ExecQuery(strWql, strSelectPath, wbemFlags, nullptr, &pEnumerator);

        // get method signature - input and output objects
        // NOTE: this call does not retrieve actual class instances, only a blueprint of a WMI class - property names, method signatures
        ceTrack<<__LINE__<<L"get WMI class";
        ceTrack = pSvc->GetObject(bstr_t(pszClassName), 0, nullptr, &pWmiClass, nullptr); 

        // retrieve method signature - input and output objects
        ceTrack<<__LINE__<<L"get WMI method";
        ceTrack = pWmiClass->GetMethod(pszMethodName, 0, &pIn, &pOut);

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

            ceTrack<<__LINE__<<L"get path to the instance of WMI class";
            ceTrack = pObj->Get(WMI_PROP_PATH, 0, &varPath, nullptr, nullptr);

            if(pIn) // spawn input object for methods with input parameters
            {
                ceTrack<<__LINE__<<L"spawn instance of input object";
                ceTrack = pIn->SpawnInstance(0, &pObjIn);

                for(auto itArg=args.begin(); itArg!=args.end(); itArg++)
                {
                    auto& argName = itArg->first;
                    auto& argValue= itArg->second;

                    ceTrack<<__LINE__<<L"put argument value";
                    ceTrack = pObjIn->Put(argName, 0, &argValue, argValue.vt);
                }
            }

            ceTrack<<__LINE__<<L"spawn instance of output object";
            ceTrack = pOut->SpawnInstance(0, &pObjOut);

            IWbemCallResult* wmiRes = nullptr;
            bstr_t strPath(varPath);

            ceTrack<<__LINE__<<L"execute method";
            ceTrack = pSvc->ExecMethod(strPath, strMethodName, 0, nullptr, pObjIn, &pObjOut, nullptr);

            if(pObjOut)
            {
                // To see what the method returned, use the following code. The return value will be in &varReturnValue
                VARIANT varReturnValue;
                ceTrack<<__LINE__<<L"get instance of output object";
                ceTrack = pObjOut->Get(WMI_METHOD_RETURN, 0, &varReturnValue, nullptr, nullptr);

                wcout<<L"invoking "<<pszClassName<<L"::"<<pszMethodName<<" with "<<args.size()<<" arguments : ";
                wcout<<(varReturnValue.boolVal?L"SUCCESS":L"FAILURE")<<endl;

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
    }
    catch(const runtime_error& e)
    {
        cout<<e.what();
    }

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
    bstr_t strTarget(WMI_DEF_TARGET);
    if(argc>1)
    {
        strTarget = argv[1];
    }
    if(!wcsstr((const wchar_t*)strTarget, WMI_NV_NAMESPACE))
    {
        strTarget += WMI_NV_NAMESPACE;
    }

    IWbemLocator* pLoc = nullptr;
    IWbemServices* pSvc = nullptr;
    SAFEARRAY* pGrids  = nullptr;

    wostringstream wos;
    ComErrorTracker ceTrack;

    try
    {
        ceTrack<<__LINE__<<L"COM initialization";
        ceTrack = CoInitializeEx(0, COINIT_MULTITHREADED);

        ceTrack<<__LINE__<<L"COM security initialization";
        ceTrack = CoInitializeSecurity(nullptr, -1, nullptr, nullptr, RPC_C_IMP_LEVEL_IDENTIFY, RPC_C_AUTHN_LEVEL_CONNECT, nullptr, EOAC_DYNAMIC_CLOAKING, nullptr);

        ceTrack<<__LINE__<<L"create instance of the IWbemLocator";
        ceTrack = CoCreateInstance(CLSID_WbemLocator, 0, CLSCTX_INPROC_SERVER, IID_IWbemLocator, (void**)&pLoc);

        // Connect to WMI through the IWbemLocator::ConnectServer method
        BSTR pstrUser = nullptr;                 // User name. nullptr means current user
        BSTR pstrPwd = nullptr;                  // User password. nullptr means current pwd
        BSTR pstrAuthority = nullptr;            // Authority (for example, Kerberos)

        // Connect to the NV namespace with the current user and obtain pointer pSvc to make IWbemServices calls
        ceTrack<<__LINE__<<L"connect to the WMI object store";
        ceTrack = pLoc->ConnectServer(strTarget, pstrUser, pstrPwd, nullptr, 0, pstrAuthority, 0, &pSvc);

        wcout<<L"Connected to the "<<(wchar_t*)strTarget<<L" WMI object store"<<endl;

        // Set security levels on the proxy 
        ceTrack<<__LINE__<<L"set proxy blanket";
        ceTrack = CoSetProxyBlanket(pSvc, RPC_C_AUTHN_WINNT, RPC_C_AUTHZ_NONE, nullptr, RPC_C_AUTHN_LEVEL_CALL, RPC_C_IMP_LEVEL_IMPERSONATE, nullptr, EOAC_NONE);

        int displayCount=0;
        int width=0; 
        int height=0; 
        int bpp=0; 
        float refresh=0.0f;

        // enumerate displays, get display mode
        auto detected = detectDisplayMode(pSvc, displayCount, width, height, bpp, refresh);
        if(detected)
        {
            cout<<"detected "<<displayCount<<" displays for cloning"<<endl;
            cout<<"using mode: "<<width<<"x"<<height<<"x"<<bpp<<"@ "<<refresh<<" Hz"<<endl;
        }
        else
        {
            throw runtime_error("incompatible display configuration, can't find display mode for cloning");
        }

        // format input string for one and only display grid
        wos<<L"rows=1;cols="<<displayCount<<L";mode="<<width<<L" "<<height<<L" "<<bpp<<L" "<<refresh;
        bstr_t grid1xN(wos.str().c_str());

        pGrids = SafeArrayCreateVector(VT_BSTR,0,1); // create safe array of UTF-16 strings, with 1 element
        if(!pGrids)
        {
            throw bad_alloc();
        }

        long index[]={0};
        BSTR* pData=nullptr;

        ceTrack<<__LINE__<<L"lock safe array";
        ceTrack = SafeArrayAccessData(pGrids, (void**)&pData);

        pData[0] = grid1xN;

        ceTrack<<__LINE__<<L"unlock safe array";
        ceTrack = SafeArrayUnaccessData(pGrids);

        // validate 1xN display grid
        auto validated = invokeStaticMethod(pSvc, WMI_DISPLAY_MAN_CLASS, WMI_VALIDATE_GRIDS_METHOD, WMI_GRIDS_ARG, pGrids);
        if(!validated)
        {
            wcout<<WMI_VALIDATE_GRIDS_METHOD<<L"("<<WMI_GRIDS_ARG<<L"="<<wos.str()<<L")"<<endl;
            throw runtime_error("failure to validate grid");
        }

        // create 1xN display grid
        auto created = invokeStaticMethod(pSvc, WMI_DISPLAY_MAN_CLASS, WMI_CREATE_GRIDS_METHOD, WMI_GRIDS_ARG, pGrids);
        if(!created)
        {
            wcout<<WMI_CREATE_GRIDS_METHOD<<L"("<<WMI_GRIDS_ARG<<L"="<<wos.str()<<L")"<<endl;
            throw runtime_error("failure to create grid");
        }

        // prepare method arguments
        KeyValueMap args;

        // NOTE: variant type must be specified explicitly as CIM_SINT32 (same as VT_I4, 3) for MOF sint32,
        // c-tor for variant_t will assign VT_INT, trigger type mismatch error in Put()
        args.insert( make_pair(WMI_OVERLAP_COL_INDEX  , variant_t(-1L, CIM_SINT32)) );
        args.insert( make_pair(WMI_OVERLAP_COL_OVERLAP, variant_t((LONG)width, CIM_SINT32)) );

        // overlap at width 
        auto overlapped = invokeMethod(pSvc, WMI_DISPLAY_GRID_CLASS, WMI_SET_OVERLAP_COL_METHOD, L"id=1", args);
        if(!overlapped)
        {
            throw runtime_error("failure to overlap grid");
        }
    }
    catch(const exception& e)
    {
        cout<<e.what();
    }

    if(pGrids)
    {
        SafeArrayDestroy(pGrids);
    }

    if(pSvc)
    {
        pSvc->Release();
    }

    if(pLoc)
    {
        pLoc->Release();
    }

    CoUninitialize();

    return 0;
}
