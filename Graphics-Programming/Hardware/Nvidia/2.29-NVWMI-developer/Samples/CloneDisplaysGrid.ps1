###############################################################################
# Copyright (c) 2015 NVIDIA Corporation
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
# NAME:    CloneDisplaysGrid.ps1
# AUTHOR:  NVIDIA Corporation
# REQUIRES: PowerShell 2.0
# 
# SYNOPSIS: Clones all attached displays by creating DisplayGrid and overlapping displays
#
# DESCRIPTION: demonstrates how to 
# - parse display modes
# - create display grid
# - clone displays horizontally by overlapping at screen width
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

# initialize search variable with large arbitrary value
[int]$leastNativeW = 100000
[int]$leastNativeH = 0
[int]$bpp = 0
[single]$refresh=0.0

# iterate thru all displays, determine native mode with smallest width
foreach($display in $displays)
{
    [int]$width=$display.displayModeNative.width
    
    if($leastNativeW -gt $width)
    {
        # record display mode properties
        $leastNativeW = $width
        $leastNativeH = $display.displayModeNative.height
        $bpp = $display.displayModeNative.colorDepth
        $refresh = $display.displayModeNative.refreshRate
    }
}

if(!$leastNativeH) 
{
    "ERROR : failed to detect display mode, compatible with all displays"
    return $rc
} 

# get the instance of the display manager
$class = "DisplayManager"
$displayManager = Get-WmiObject -class $class -computername $computer -namespace $namespace

if($displayManager -eq $null)
{
    "ERROR : failed to retrieve $class"
    return $rc
}

# define 1xN display grid, where N - number of displays in a system, 
# set display mode to lowest native among all detected displays
[string]$displayCount=$displays.count
$grids = @()
$grids += "rows=1;cols=$displayCount;mode=$leastNativeW $leastNativeH $bpp $refresh"

# Validate display grids first
$method = "validateDisplayGrids"
$params = $displayManager.GetMethodParameters($method)
$params.grids = $grids

"Calling $class.$method()"
$res = $displayManager.InvokeMethod($method,$params,$null)
if($res.ReturnValue)
{
    # validated - now create display grids
    $method ="createDisplayGrids"
    "Calling $class.$method()"
    $res = $displayManager.InvokeMethod($method,$params,$null)
    if( $res.ReturnValue -eq $true )
    {
        "SUCCESS : created $grids"
        $rc = $true
    }
    else
    {
        "ERROR : failed to create $grids"
        $rc = $false
        return $rc
    }
}

# get the instance of the only display grid. It will have id=1
$class = "DisplayGrid"
$cloneGrid = Get-WmiObject -class $class -computername $computer -namespace $namespace -filter "id=1"

if( $cloneGrid -eq $null )
{
    "ERROR : failed to retrieve display grid with id=1"
    $rc = $false
    return $rc
}

$method = "setOverlapCol" 
$params = $cloneGrid.GetMethodParameters($method)
$params.index=-1
$params.overlap=$width

"Calling $class.$method()"
$res = $cloneGrid.InvokeMethod($method,$params,$null)
if( $res.ReturnValue -eq $true )
{
    "SUCCESS : cloned all displays by setting horizontal overlap=$width"
    $rc = $true
}
else
{
    "ERROR : failed to clone displays by horizontal overlap=$width"
    $rc = $false
}

