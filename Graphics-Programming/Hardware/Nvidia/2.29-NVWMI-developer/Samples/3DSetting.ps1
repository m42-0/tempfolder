###############################################################################
# Copyright (c) 2013 NVIDIA Corporation
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
# NAME:    3DSetting.ps1
# AUTHOR:  NVIDIA Corporation
# REQUIRES: PowerShell 2.0
# 
# SYNOPSIS: Set a 3D Global Profile setting (e.g. Stereo Swap eyes)
#
# DESCRIPTION: Demonstrates how to set a 3D setting of Global 3D Profile.Retrieve a 
#              3D setting and its value.
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


<#
.SYNOPSIS
    Change a 3D Setting for a given Profile

.DESCRIPTION
    This method demonstrates changing a 3D setting (e.g. Stereo - Swap eyes ) in given profile


.EXAMPLE
    Set-3DProfileSetting ([ref]$3DGlobal) ($settingId) ($value)
#>
function Set-3DProfileSetting
{
    Param
    (
        [System.Management.ManagementBaseObject]$profileInstance,
        $settingId,
        $value 
    )
    $rc = $false
    if($profileInstance)
    {    
        $method="setValueById"           #name of the method
        $ret = Invoke-WmiMethod -Path $3DGlobal.__PATH -Name $method -ArgumentList $settingId,$value
        Write-Host "$class.$method(settingId = $settingId, value = $value) returns $($ret.ReturnValue)"
        if($ret.ReturnValue)
        {
            $rc = $true
        }
    }
    return $rc        
}


###############################################################################
# 
#  Entry point to script
# 
###############################################################################

#1. Retrieve profile instances, get the 3D Global profile instance
$3DGlobal = Get-WmiObject -class $class -computername $computer -namespace $namespace | Where-Object { $_.type -eq $profileType3DGlobal }
if($3DGlobal -eq $Null)
{
    "no instances of class $class, type $profileType3DGlobal" 
    return
}

#2. Fill the setting id "Stereo - Swap eyes" with value = 1 i.e. ON (value= 0 is for "OFF")
$settingId = 296633180
$value = 1

#3. Apply the Setting
$ret = Set-3DProfileSetting([ref]$3DGlobal) ($settingId) ($value)
if(!$ret)
{
    return
}

#4. Retrieve the 3D Global profile instance and verify that value was applied
$3DGlobal = Get-WmiObject -class $class -computername $computer -namespace $namespace | Where-Object { $_.type -eq $profileType3DGlobal } 

# Get all the settings from 3D Global Profile
$settings = $3DGlobal.settings

# Filter the setting Stereo Swap eyes from the settings
$swapEyes = $settings| Where-Object {$_.id -eq $settingId }

# Convert the value array to int
$value = [BitConverter]::ToInt32($swapEyes.value,0)
"'Stereo - Swap eyes' value in $($3DGlobal.name) set to $value"