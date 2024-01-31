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
# NAME:    ManageProfiles.ps1
# AUTHOR:  NVIDIA Corporation
# REQUIRES: PowerShell 2.0
# 
# SYNOPSIS: This script retrieves properties and executes method of ProfileManager class
#
# DESCRIPTION: Profile is a collection of settings. There are several profile types 
# e.g. display-related setting forms a Display Profile, 
# 3D setting for an application represented in a 3D Application profile,
# nView settings are collected in Desktop profile,
#
# Profile Manager class manipulates profiles of all types
#
# This sample demonstrates how to 
# - load,lock, save Desktop (nView) profile
# - save Display Profile
# - set global 3D Profile 
# - change vertical synchronization mode (V-sync) 
# - list all profiles of a given type
#
# See NVWMI Programming Guide in NVWMI.CHM and MOF class definitions in NVWMI.MOF 
# for more details
#
###############################################################################


$namespace = "root\CIMV2\NV"    # namespace of the NVIDIA WMI provider
$class     = "ProfileManager"   # class to be queried
if($computer -eq $null)         # if not set globally
{
    $computer = "localhost"     # substitute with remote machine names or IP of the machine
}

<#
.SYNOPSIS
    Displays the current 3D Profile, lists all 3D global profiles, sets a global 3D profile as a Current 3D Profile and reverts back to default

.DESCRIPTION
    Performs various task for 3D Global Profiles

.EXAMPLE
    Set-3DProfile([ref] $profileManager)
#>
function Set-3DProfile
{
    Param
    (
        #profileManager is Instance of ProfileManager class
        [ref]$profileManager
    )

    $profileManagerInstance = [System.Management.ManagementBaseObject]$profileManager.Value
    $("$class.currentProfile3D = "+ $profileManagerInstance.currentProfile3D)
    $("$class.defaultProfile3D = "+ $profileManagerInstance.defaultProfile3D)    

    # get all global 3D profiles
    $type = 1
    $method = "getAllProfiles"
    "Calling $class.$method()"
    $result = $profileManagerInstance.InvokeMethod($method, $type)
    $result

    # turn V-sync off
    $method = "setVSync"
    $vsyncMode = 1
    "Calling $class.$method()"
    $result = $profileManagerInstance.InvokeMethod($method, $vsyncMode)
    $result

    # change current global 3D profile
    $method = "setCurrentProfile3D"
    $name = "3D App - Game Development"
    "Calling $class.$method()"
    $result = $profileManagerInstance.InvokeMethod($method, $name)
    $result

    # restore back the Current 3D Profile
    $method = "setCurrentProfile3D"
    $name = $profileManagerInstance.currentProfile3D
    "Calling $class.$method()"
    $result = $profileManagerInstance.InvokeMethod($method, $name)
    $result

}

<#
.SYNOPSIS
    Peforms save, lock and load of the nView Desktop Manager Profile

.DESCRIPTION
    This function demonstrates saving a Custom profile of nView Desktop Manager Profile, locking the profile and then loading default profile

.EXAMPLE
    Set-NviewProfile([ref] $profileManager)
#>
function Set-NviewProfile
{
    Param
    (
        [ref]$profileManager
    )

    # retrieve the instance from the reference
    $profileManagerInstance = [System.Management.ManagementBaseObject]$profileManager.Value

    # to save a Desktop Profile, nView Desktop Manager should be running
    $system=Get-WmiObject -computer $computer -class "System" -namespace $namespace 
    if($system)
    {
        $nviewState = $system.nViewState
        if($nviewState -eq 0)
        {
            # if nView Desktop Manager is not running, enable it first
            $nviewState = 1
            $result = $system.InvokeMethod("setnViewState", $nviewState)
        }        
    }
    
    # save a custom nView Desktop Manager Profile
    $method = "saveDesktopProfile"
    $name = "Custom"
    "Calling $class.$method()"
    $result = $profileManagerInstance.InvokeMethod($method, $name)
    $result

    # lock the desktop profile - e.g. prevent user from modifying its settings
    $method = "lockDesktopProfile"
    $name = "Custom"
    $lock = 1
    "Calling $class.$method()"
    $result = Invoke-WmiMethod -Path $profileManagerInstance.__PATH -Name $method -ArgumentList $lock,$name
    $result.ReturnValue

    # load default desktop profile
    $method = "loadDesktopProfile"
    $name = "default"
    "Calling $class.$method()"
    $result = $profileManagerInstance.InvokeMethod($method, $name)
    $result

}

<#
.SYNOPSIS
    Saves a set of display profiles, changes rotation and applies saved display profile

.DESCRIPTION
    This function demonstrates how to use display profiles (one profile per display) to change quickly display settings

.EXAMPLE
    Set-DisplayProfile ([ref]$profileManager)
#>
function Set-DisplayProfile
{
    Param
    (
        # a reference to an instance of the ProfileManager class
        [ref]$profileManager
    )

    $profileManagerInstance = [System.Management.ManagementBaseObject]$profileManager.Value

    # save a set of Display Profiles
    $method = "saveDisplayProfiles"
    $displayProfilesPrefix = "myDisplayState"
    "Calling $class.$method()"
    $result = $profileManagerInstance.InvokeMethod($method, $displayProfilesPrefix)
    $result

    # rotate displays to change current display settings
    $displays =Get-WmiObject -class "Display" -computername $computer -namespace $namespace
    foreach($display in $displays)
    {
        # rotate each display by 180 degree
        $rotation = 2
        $("Calling $class.setRotation")
        $display.InvokeMethod("setRotation", $rotation)
    }

    # displays have been rotated  - go back to previous state by applying saved Display Profiles
    $method = "applyDisplayProfiles"
    "Calling $class.$method()"
    $result = $profileManagerInstance.InvokeMethod($method, $displayProfilesPrefix)
    $result
}


###############################################################################
# 
#  Entry point to script
# 
###############################################################################

# retrieve ProfileManager instance (singleton)
$profileManager = Get-WmiObject -class $class -computername $computer -namespace $namespace
if($profileManager -eq $Null)
{
    "ProfileManager not found"
    return
}

Set-NviewProfile([ref]$profileManager)
Set-DisplayProfile([ref]$profileManager)
Set-3DProfile([ref]$profileManager)
