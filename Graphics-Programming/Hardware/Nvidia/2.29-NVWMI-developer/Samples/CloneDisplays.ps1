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
# NAME:    CloneDisplays.ps1
# AUTHOR:  NVIDIA Corporation
# REQUIRES: PowerShell 2.0
# 
# SYNOPSIS: Clones two displays, attached to 1st GPU
#
# DESCRIPTION: demonstrates how to 
# - clone displays by createClone method
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


###############################################################################
# 
#  Entry point to script
# 
###############################################################################
$rc = $false                     # script return code

$class = "Gpu"
$gpus = Get-WmiObject -class $class -computername $computer -namespace $namespace

if($gpus -eq $null)
{
    "ERROR : failed to retrieve all Gpus"
    return $rc
}

$gpuId=0
if($gpus.count -lt 2)
{
    $gpuId=$gpus.id
}
else
{
    $gpuId=$gpus[0].id
}

# retrieve all attached displays
$class = "Display"
$displays = Get-WmiObject -class $class -computername $computer -namespace $namespace

if($displays -eq $null)
{
    "ERROR : failed to retrieve all attached displays"
    return $rc
}

if($displays.count -lt 2)
{
    "ERROR : at least 2 attached displays required"
    return $rc
}

$sourceId = 0
$targetIds = @()
foreach($d in $displays)
{
    if($gpuId -eq [int]::Parse($d.locus[0]))
    {
        if($sourceId -eq 0)
        {
            $sourceId = $d.id
        }
        else
        {
            $targetIds += $d.id
            # One target is enough to demo createClone() method
            if($targetIds.Count -gt 0)
            { 
                break
            }
        }
    }
}

# get the instance of the display manager
$class = "DisplayManager"
$displayManager = Get-WmiObject -class $class -computername $computer -namespace $namespace

if($displayManager -eq $null)
{
    "ERROR : failed to retrieve $class"
    return $rc
}

$method = "createClone"
$params = $displayManager.GetMethodParameters($method)
$params.type = 0 # 0 - basic clone, 1 - smart clone
$params.source = $sourceId
$params.targets = $targetIds

"Calling $class.$method()"
$res = $displayManager.InvokeMethod($method,$params,$null)
if( $res.ReturnValue -eq $true )
{
    "SUCCESS : targets are cloned to source"
    $rc = $true
}
else
{
    "ERROR : failed to create clone"
    $rc = $false
    return $rc
}

