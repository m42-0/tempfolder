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
# NAME:    Manage3DProfiles.ps1
# AUTHOR:  NVIDIA Corporation
# REQUIRES: PowerShell 2.0
# 
# SYNOPSIS: retrieves properties and executes methods of Profile,ProfileManager class 
#
# DESCRIPTION: Demonstrates how to 
# - set a 3D global profile. 
# - add applications to 3D application profiles
# - set value for 3D application profile setting, specified by ID
# - detect running 3D application with associated 3D profiles
# - restore 3D defaults
#
# See NVWMI Programming Guide in NVWMI.CHM and MOF class definitions in NVWMI.MOF 
# for more details
#
###############################################################################


$namespace = "root\CIMV2\NV"    # Namespace of NVIDIA WMI provider
$class = "ProfileManager"       # class to be queried
if($computer -eq $null)         # if not set globally
{
    $computer  = "localhost"    # substitute with remote machine names or IP of the machine
}

$profileType3DApplication = 0   # 3D Application profile type
$profileType3DGlobal      = 1   # 3D Global profile type

<#
.SYNOPSIS
    Adds new executables to an existing 3D Profile

.DESCRIPTION
    Adds executables, specified as an array of strings, to an existing 3D profile 

.EXAMPLE
    Add-ApplicationsToProfile "MyProfile" @("a1.exe","a2.exe")
#>
function Add-ApplicationsToProfile
{
    Param
    (
        [string]$profileName,
        [array]$apps
    )
    
    $class = "Profile"
    $method ="addApplications"

    $wql = "select * from ApplicationProfile where name='"+$profileName+"'"
    $profile = Get-WmiObject -Query $wql -ComputerName $computer -Namespace $namespace
    if($profile -eq $null)
    {
        "can't find 3D application profile $profileName"
        return
    }

    "Calling $class.$method()"
    $result = Invoke-WmiMethod -Path $profile.__PATH -Name $method -ArgumentList $apps, $null
    if($result.ReturnValue -eq $true)
    {
        $ret = "succeeded"
    }
    else
    {
        $ret = "failed"
    }
    "$method call with apps="+[String]::Join(';', $apps)+": $ret"
    "---"
}

<#
.SYNOPSIS
    Remove specified executables from an existing 3D Profile

.DESCRIPTION
    Remove executables, specified as an array of strings, from an existing 3D Profile

.EXAMPLE
    Remove-ApplicationsFromProfile "MyProfile" @("a1.exe","a2.exe")
#>

function Remove-ApplicationsFromProfile 
{
    Param
    (
        [string]$profileName,
        [array]$apps
    )
    
    $class = "Profile"
    $method ="removeApplications"

    $wql = "select * from ApplicationProfile where name='"+$profileName+"'"
    $profile = Get-WmiObject -Query $wql -ComputerName $computer -Namespace $namespace
    if($profile -eq $null)
    {
        "can't find 3D application profile $profileName"
        return
    }

    "Calling $class.$method()"
    $result = Invoke-WmiMethod -Path $profile.__PATH -Name $method -ArgumentList $apps, $null
    if($result.ReturnValue -eq $true)
    {
        $ret = "succeeded"
    }
    else
    {
        $ret = "failed"
    }
    "$method call with apps="+[String]::Join(';', $apps)+": $ret"
    "---"
}

<#
.SYNOPSIS
    Set setting value to the existing 3D Profile

.DESCRIPTION
    Set setting value to the existing 3D Profile using setting ID

.EXAMPLE
    Set-ProfileSettingById "MyProfile" <id> <value>
#>

function Set-ProfileSettingById
{
    Param
    (
        [string]$profileName,
        [uint32]$id,
        [uint32]$value
    )
    
    $class = "Profile"
    $method ="setValueById"

    $wql = "select * from ApplicationProfile where name='"+$profileName+"'"
    $profile = Get-WmiObject -Query $wql -ComputerName $computer -Namespace $namespace
    if($profile -eq $null)
    {
        "can't find 3D application profile $profileName"
        return
    }

    "Calling $class.$method()"
    $result = Invoke-WmiMethod -Path $profile.__PATH -Name $method -ArgumentList @($id, $value)
    if($result.ReturnValue -eq $true)
    {
        $ret = "succeeded"
    }
    else
    {
        $ret = "failed"
    }
    "$method call with id=$id, value=$value : $ret"
    "---"
}

<#
.SYNOPSIS
    Creates a new 3D profile and associates applications with it

.DESCRIPTION
    Creates a new 3D profile and associates several applications with it, specified in a string, 
    unique application subpahs are separated by ;

.EXAMPLE
    Create-ApplicationProfile ([ref]$profileManager) "MyProfile" "app1.exe;app2.exe"
#>
function Create-ApplicationProfile
{
    Param
    (
        [System.Management.ManagementBaseObject]$profileManagerInstance,
        [string]$profileName,
        [string]$apps
    )
    
    $method = "createProfile"
    $param  = $profileManagerInstance.GetMethodParameters($method)

    $param.name = $profileName
    $param.type = $profileType3DApplication
    $param.params = $apps
    
    # note - attempt to create already existing profile will fail
    "Calling $class.$method()"
    $result = $profileManagerInstance.InvokeMethod($method, $param, $Null)
    if($result.ReturnValue -eq $true)
    {
        $ret = "succeeded"
    }
    else
    {
        $ret = "failed"
    }
    "$method call for name=$profileName type=$profileType3DApplication applications="+$apps+": $ret" 
    "---"
}

<#
.SYNOPSIS
    reports the current 3D Global Preset, changes to specified value

.DESCRIPTION
    Reports the current 3D Global Preset and Changes it to "3D App - Default Global Settings"


.EXAMPLE
    Set-3DGlobalPreset ([ref]$profileManager)
#>
function Set-3DGlobalPreset
{
    Param
    (
        [System.Management.ManagementBaseObject]$profileManagerInstance,
        [string]$global3DPreset
    )
    
    $method = "setCurrentProfile3D"

    "Current Global 3D Preset: "+$profileManagerInstance.currentProfile3D
    "Calling $class.$method()"
    $result = Invoke-WmiMethod -Path $profileManagerInstance.__PATH -Name $method -ArgumentList $global3DPreset, $null
    if($result.ReturnValue -eq $true)
    {
        $ret = "succeeded"
    }
    else
    {
        $ret = "failed"
    }
    "$method call for "+$global3DPreset+": $ret"
    "---"
}

<#
.SYNOPSIS
    Reports all active 3D application profiles applied to running 3D applications

.DESCRIPTION
    Applications with associated 3D application profile will be detected and reported. 

.EXAMPLE
    Detect-ApplicationProfiles
#>
function Detect-ApplicationProfiles
{
    $class ="ApplicationProfile"
    $profiles = Get-WmiObject -class $class -computername $computer -namespace $namespace

    if($profiles -eq $null)
    {
        "no running 3D applications"
    }
    else
    {
        foreach($profile in $profiles)
        {
            foreach($app in $profile.applications)
            {
                "Application: "+ $app.name+", 3D profile: "+ $profile.name
            }
            "---"
            $method = "info"
            "Calling $class.$method():"
            $ret = Invoke-WmiMethod -Path $profile.__PATH -Name $method
            $ret.ReturnValue
            "==="
        }
    }
}


<#
.SYNOPSIS
    restores default settings for all 3D profiles. 

.DESCRIPTION
    restores all defaults for 3D global and 3D application profiles. 
    This includes removal of user-created profiles and added applications, 
    reversal of user-specified profile settings.

.EXAMPLE
    Restore-Defaults3D([ref]$profileManager)
#>
function Restore-Defaults3D
{
    Param
    (
        [System.Management.ManagementBaseObject]$profileManagerInstance
    )
    $method = "restoreDefaults3D"
    "Calling ProfileManager.$method()"
    $result = Invoke-WmiMethod -Path $profileManagerInstance.__PATH -Name $method
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
$profileManager = Get-WmiObject -class $class -computername $computer -namespace $namespace
if($profileManager -eq $Null)
{
    "Profile manager instance unavailable"
    return
}

Detect-ApplicationProfiles

# 1. change current global 3D profile (preset in Control Panel)
$global3DPreset = "3D App - Default Global Settings"
Set-3DGlobalPreset ([ref]$profileManager) $global3DPreset

# 2. create new 3D application profile for given apps 
$myNewProfile = [string]"MyProfile"
$applications = "MyApp1.exe;MyApp2.exe;MyApp3.exe"
Create-ApplicationProfile ([ref]$profileManager) $myNewProfile $applications

# 3. add more applications to existing 3D application profile
[array]$moreApps = @()
$moreApps += "Sample1.exe"
$moreApps += "Sample2.exe"
Add-ApplicationsToProfile $myNewProfile $moreApps

# 4. Fill the setting id "Stereo - Swap eyes" with value = 1 i.e. ON (value= 0 is for "OFF")
$settingId = 296633180
$value = 1
Set-ProfileSettingById $myNewProfile $settingId $value 

# 5. remove some applications of existing 3D application profile
Remove-ApplicationsFromProfile $myNewProfile @("MyApp1.exe")
[array]$someApps = @()
$someApps += "MyApp2.exe"
$someApps += "MyApp3.exe"
Remove-ApplicationsFromProfile $myNewProfile $someApps

# 6. examine 3D application profiles in effect for all running 3D applications
Detect-ApplicationProfiles

# 7. revert all changes - newly created 3D application profile, change in global 3D preset etc.
Restore-Defaults3D([ref]$profileManager)
