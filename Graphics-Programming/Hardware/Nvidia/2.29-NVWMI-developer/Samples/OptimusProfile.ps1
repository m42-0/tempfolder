###############################################################################
# Copyright (c) 2016 NVIDIA Corporation
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
# NAME:    OptimusProfile.ps1
# AUTHOR:  NVIDIA Corporation
# REQUIRES: PowerShell 2.0
# 
# SYNOPSIS: Forcing Notepad to always run on discrete NVIDIA GPU 
#
# DESCRIPTION: Demonstrates how to create 3D Application Profile with Optimus settings
#
# See NVWMI Programming Guide in NVWMI.CHM and MOF class definitions in NVWMI.MOF 
# for more details
#
###############################################################################

$namespace = "root\CIMV2\NV"     # Namespace of NVIDIA WMI provider
if($computer -eq $null)          # if not set globally
{
    $computer  = "localhost"     # substitute with remote machine names or IP of the machine
}

<#
.SYNOPSIS
    This function creates a new Profile for notepad and assigns it to run on the dGPU in an Optimus configuration

.DESCRIPTION
    This method creates an Application Profile and associates an Application (Notepad.exe) to it

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
    
    $settingTables = Get-WmiObject -class "SettingTable" -computername $computer -namespace $namespace
    if($settingTables -eq $Null)
    {
        return
    }
    
    $appSettings = $settingTables | Where-Object {$_.type -eq 0}
    
    $method = "createProfile"
    $name   = "Optimus Notepad"     # TODO : specify unique profile name
    $applications ="notepad.exe;"   # TODO : specify unique subpath to the application

    # Add the application, if the it exits already it will return false
    $param = $profileManager.GetMethodParameters($method)
    $param.name = $name
    $param.type = 0  # Type 0 for 3D Application Profile
    $param.params = $applications
    $result = $profileManager.InvokeMethod($method, $param, $Null)
    if($result.ReturnValue -eq $true)
    {
        $ret = "succeeded"
    }
    else
    {
        $ret = "failed"
    }
    "---"
    "$method call with name="+$param.name+", apps=$applications : $ret" 
    "---"
    
    # Get the Profile we just created
    $newProfile = Get-WmiObject -Query "select * from ApplicationProfile where name='$name'" -ComputerName $computer -Namespace $namespace
    
    # Get the pair of Optimus ID's needed. 
    # Or you could browse "%ProgramFiles%\NVIDIA Corporation\NVIDIA WMI Provider\NVWMI.CHM", 
    # section "Profile settings available in NVWMI" for setting IDs
    $enableOptimus ="Enable application for Optimus"
    $enableOptimusId = $appSettings.InvokeMethod("getIdFromName",$enableOptimus)
    
    # possible values for generic 3D application - see setting table in NVWMI.CHM
    # NOTE: other flags should not be used without detailed analysis of 3D app behavior
    $runAppOnIgpu = 0 # INTEGRATED
    $runAppOnDgpu = 1 # ENABLE app for dGPU
    $enableOptimusValue = $runAppOnDgpu
    
    $shimRenderMode ="Shim Rendering Mode Options per application for Optimus"
    $shimRenderModeId = $appSettings.InvokeMethod("getIdFromName", $shimRenderMode)
    
    # possible values for generic 3D application - see setting table in NVWMI.CHM
    # NOTE: other flags should not be used without detailed analysis of 3D app behavior
    $defaultRenderMode = 0      # DEFAULT_RENDERING_MODE - Do nothing special
    $inheritRenderMode = 0x100  # ALLOW_INHERITANCE - All spawned processes will retain rendering mode of parent process
    
    # Set the settings with the following parameters
    #    Forced to the dGPU, enableOptimusId = 0x1, shimRenderModeId = 0x100
    #    Forced to the iGPU, enableOptimusId = 0, shimRenderModeId = 0x100
    $result = $newProfile.setValueById($enableOptimusId, $enableOptimusValue)
    if($result.ReturnValue -eq $true)
    {
        $ret = "succeeded"
    }
    else
    {
        $ret = "failed"
    }
    "setting $enableOptimus, ID=0x{0:X} ({0:d}) to value 0x{1:X} ({1:d}) : $ret" -f $enableOptimusId, $enableOptimusValue
    
    $result = $newProfile.setValueById($shimRenderModeId, $inheritRenderMode)
    if($result.ReturnValue -eq $true)
    {
        $ret = "succeeded"
    }
    else
    {
        $ret = "failed"
    }
    "setting $shimRenderMode, ID=0x{0:X} ({0:d}) to value 0x{1:X} ({1:d}) : $ret" -f $shimRenderModeId, $inheritRenderMode
}


<#
.SYNOPSIS
    restores default settings for 3D all profiles. 

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

$profiles = Get-WmiObject -class "Profile" -computername $computer -namespace $namespace
if($profiles -eq $null)
{
    "no instances of class $class"
    return
}

Create-ApplicationProfile

$profileManager = Get-WmiObject -class "ProfileManager" -computername $computer -namespace $namespace
if($profileManager -eq $null)
{
    "can't get Profile Manager instance "
    return
}

Restore-Defaults3D([ref]$profileManager)
