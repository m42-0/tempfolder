###############################################################################
# Copyright (c) 2014 NVIDIA Corporation
###############################################################################
# Permission is hereby granted, free of charge, to any person obtaining a copy 
# of this software and associated documentation files (the "Software"), 
# to deal in the Software without restriction, including without limitation 
# the rights to use, copy, modify, merge, publish, distribute, sublicense, 
# and/or sell copies of the Software, and to permit persons to whom 
# the Software is furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in 
# all copies or substantial portions of the Software.
###############################################################################
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, 
# DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE 
# OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
###############################################################################
###############################################################################
#
# COMPANY: NVIDIA Corporation
# NAME:    3DProfile.ps1
# AUTHOR:  NVIDIA Corporation
# REQUIRES: PowerShell 2.0
# 
# SYNOPSIS: retrieves properties and executes methods of Profile class 
#
# DESCRIPTION: Demonstrates how to 
# - set or get a setting of 3D Global Profile. 
# - use setting table to obtain ID, name and description of profile settings 
# - create 3D application profile
# - restore 3D defaults
#
# See NVWMI Programming Guide in NVWMI.CHM and MOF class definitions in NVWMI.MOF 
# for more details
#
###############################################################################


$namespace = "root\CIMV2\NV"     # Namespace of NVIDIA WMI provider
$class     = "Profile"           # class to be queried

if($computer -eq $null)          # if not set globally
{
    $computer  = "localhost"     # substitute with remote machine names or IP of the machine
}

$profileType3DApplication = 0
$profileType3DGlobal      = 1
$profileTypeDisplay       = 4

<#
.SYNOPSIS
    Using setting table and setting 

.DESCRIPTION
    retrieves the 3D settings table, demonstates how to get 3D setting ID using the 3D Setting Table 
    and set a new value for the 3D setting in the Base Profile

.EXAMPLE
    Set-3DProfileSetting ($profiles)
#>
function Set-3DProfileSetting
{
    Param
    (
        # A collection of Profile instances
        $profiles
    )

    $settingTable3D = 0

    # retrieve SettingTable instances 
    $settingTables = Get-WmiObject -class "SettingTable" -computername $computer -namespace $namespace

    # retrieve Setting Table corresponding to 3D Profiles( Global and Application)
    $3DSetting = $settingTables | Where-Object {$_.type -eq $settingTable3D}
    if($3DSetting -eq $null)
    {
        "WARNING : cannot retrieve a SettingTable instance for 3D profiles"
        return
    }

    # get current global 3D profile, determine setting id for Aniso mode and set a new value
    $3DGlobal = $profiles | Where-Object {$_.type -eq $profileType3DGlobal}
    if($3DGlobal)
    {    
        $value = 1 
        $method = "getIdFromName"
        $anisoFilteringId= $3DSetting.InvokeMethod("getIdFromName", "Anisotropic filtering mode")
        $method="setValueById"
        $value=4
        $result = Invoke-WmiMethod -Path $3DGlobal.__PATH -Name $method -ArgumentList $anisoFilteringId,$value
        if($result.ReturnValue -eq $true)
        {
            $ret = "succeeded"
        }
        else
        {
            $ret = "failed"
        }
        "---"
        "$method call for the 'Anisotropic filtering mode', id=$anisoFilteringId : $ret" 
        "---"
    }        
}


<#
.SYNOPSIS
    This function creates a new Profile name "MyProfile" and associates multiple applications with it

.DESCRIPTION
    demonstrates how to create new 3D application profile and how to associate applications with it

.EXAMPLE
    Create-ApplicationProfile
#>
function Create-ApplicationProfile
{
    $profileManager = Get-WmiObject -class "ProfileManager" -computername $computer -namespace $namespace
    if($profileManager -eq $Null)
    {
        return
    }
    
    $method = "createProfile"
    $name   = "MyProfile"
    $applications ="notepad.exe;"

    # create new 3D profile for a given application (Notepad). 
    $param = $profileManager.GetMethodParameters($method)
    $param.name = $name
    $param.type = $profileType3DApplication
    $param.params = $applications
    $result = $profileManager.InvokeMethod($method, $param, $Null)
    if($result.ReturnValue -eq $true)
    {
        $ret = "succeeded"
    }
    else
    {
        $ret = "failed" # profile already exists or can't be created
    }
    "---"
    "$method call with name="+$param.name+", apps=$applications : $ret" 
    "---"

    #Add application abc.exe to Google SketchUp profile
    $method="addApplications"
    [array]$apps =@()
    $apps+="abc.exe"
    $apps+="def.exe"
    $sketchInstance = Get-WmiObject -Query "select * from ApplicationProfile where name='Google SketchUp'" -ComputerName $computer -Namespace $namespace

    $result = Invoke-WmiMethod -Path $sketchInstance.__PATH -Name $method -ArgumentList $apps, $null
    if($result.ReturnValue -eq $true)
    {
        $ret = "succeeded"
    }
    else
    {
        $ret = "failed"
    }
    "---"
    "$method call with apps="+[String]::Join(';', $apps)+" : $ret" 
    "---"
}

<#
.SYNOPSIS
    This function demonstrates ho to use SettingTable class to lookup ID from setting name and vice versa

.DESCRIPTION
    Demonstrates class SettingTable in general and how to get ID, setting name for a DisplayProfile setting "positionCol"

.EXAMPLE
    Demo-SettingTable
#>
function Demo-SettingTable
{
    $settingTables = Get-WmiObject -class "SettingTable" -computername $computer -namespace $namespace

    # print info about all SettingTable instances 
    foreach($settingTable in $settingTables)
    {
        $settingTable.InvokeMethod("info", $null)
    }

    # retrieve settings of display type
    $displaySettings = $settingTables | Where-Object {$_.type -eq $profileTypeDisplay}
    if($displaySettings)
    {
        $ret = $displaySettings.InvokeMethod("getIdFromName", "positionCol")
        "ID of setting positionCol is: $ret"
        
        $ret = $displaySettings.InvokeMethod("getNameFromId", 1488614027)
        "Name of setting with ID=1488614027 is: $ret"
    }
}


<#
.SYNOPSIS
    restores default settings for 3D all profiles. 

.DESCRIPTION
    restores all defaults for 3D global and 3D application profiles. 
    This includes removal of user-created profiles and added applications, 
    reversal of user-specified profile settings.

.EXAMPLE
    Restore-Defaults3D
#>
function Restore-Defaults3D
{
    $profileManager = Get-WmiObject -class "ProfileManager" -computername $computer -namespace $namespace
    if($profileManager -eq $null)
    {
        "can't get Profile Manager instance "
        return
    }
    
    $method = "restoreDefaults3D"
    "Calling ProfileManager.$method()"
    $result = Invoke-WmiMethod -Path $profileManager.__PATH -Name $method
    if($result.ReturnValue -eq $true)
    {
        $ret = "succeeded"
    }
    else
    {
        $ret = "failed"
    }
    "$method call: $ret" 
    "---"
}

###############################################################################
# 
#  Entry point to script
# 
###############################################################################

$profiles = Get-WmiObject -class $class -computername $computer -namespace $namespace
if($profiles -eq $null)
{
    "no instances of class $class"
    return
}

# Now get all the Application Profiles that are active
$appProfiles = $profiles | Where-Object {$_.type -eq $profileType3DApplication}

if($appProfiles -eq $null)
{
    "no active application profiles"
}
else
{
    foreach($appProfile in $appProfiles)
    {
        $result = Invoke-WmiMethod -Path $appProfile.__PATH -Name info        
        $result.ReturnValue 
        "---"
    }
}

Set-3DProfileSetting($profiles)
Create-ApplicationProfile
Demo-SettingTable
Restore-Defaults3D