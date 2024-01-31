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
# NAME:    nViewProfiles.ps1
# AUTHOR:  NVIDIA Corporation
# REQUIRES: PowerShell 2.0
# 
# SYNOPSIS: retrieves properties and executes method of Profile class 
# for the Global Desktop (nView) profile
#
# DESCRIPTION: This sample demonstrates 
# - enabling nView Desktop manager
# - disabling nView Title Bar Options setting
# - creating a virtual desktop
# - assigning background picture to a newly created virtual desktop
#
# See NVWMI Programming Guide in NVWMI.CHM and MOF class definitions in NVWMI.MOF 
# for more details
#
###############################################################################

$namespace = "root\CIMV2\NV"    # namespace of the NVIDIA WMI provider
if($computer -eq $null)         # if not set globally
{
    $computer  = "localhost"    # substitute with remote machine names or IP of the machine
}

# use the Power Shell cmdlet Get-WmiObject to get instance of the System class from the $computer
$system = Get-WmiObject -computer $computer -class "System" -namespace $namespace 

# if nView is not enabled, attempt to enable
if(!$system.nViewState)
{
    "$computer : nView Desktop Manager disabled"
    $rc=Invoke-WmiMethod -Path $system.__PATH -Name "setnViewState" -ArgumentList $true,$null
    $report = @{$true="succeeded";$false="failed"}[$rc.ReturnValue -eq $true]
    "$computer : attempt to enable nView Desktop Manager $report"
    if(-not $rc)
    {
        "ERROR : can't enable nView on $computer"
        return
    }
}

$profilenViewGlobal = 3         # Global Desktop (nView) profile type is 3
$profiles = Get-WmiObject -class "Profile" -computername $computer -namespace $namespace

if($profiles -eq $null)
{
    "no profiles available"     # legitimate case on RDP connection 
    return
}

# Profile type 3 corresponds to nView Global Profile
$nviewProfile = $profiles | Where-Object {$_.type -eq $profilenViewGlobal} 
if($nviewProfile)
{
    # Print information about nView
    $method="info"
    $nviewProfile.InvokeMethod("info", $null)
    "---"

    # Disable nView Title Bar Options setting
    $method="setValueById"
    $settingId = 1505479702
    $value=0
    $rc = Invoke-WmiMethod -Path $nviewprofile.__PATH -Name $method -ArgumentList $settingId,$value
    "$method($settingId,$value) returns "+$rc.ReturnValue
    "---"

    # Enable another desktop with the specified wall paper and stretch
    # Note: if desktop with this name already exists, method will fail. 
    # In order to modify properties of existing desktop, 
    # please use another setting - "Modify properties of a desktop", id=1496494191 (0x5932B06F)
    $settingId = 1500598283 # 0x5971500B - "Add a desktop" 
    $method="setStringValueById"
    
    # TODO: set your own path to the file with wallpaper on Remote Machine
    # For illustration purpose, path is set to the one of Windows 7 sample wallpapers - Penguins.jpg
    $wallpaperPath="$env:programdata\Documents\My Pictures\Sample Pictures\Penguins.jpg"
    
    # Value format:
    # <desktop name>;<per-monitor flag>;<path to the file with wallpaper image>,<wallpaper option> 
    # Per-monitor flag could be 0 or 1, wallpaper options are 0 - center, 1 - tile, 2 - stretch.
    $value="Custom;1;$wallpaperPath,1" 
    
    $rc = Invoke-WmiMethod -Path $nviewprofile.__PATH -Name $method -ArgumentList $settingId,$value
    "$method($settingId,$value) returns "+$rc.ReturnValue
    "---"
}
