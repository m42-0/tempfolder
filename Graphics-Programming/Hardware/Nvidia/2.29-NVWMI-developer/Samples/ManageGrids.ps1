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
# NAME:    ManageGrids.ps1
# AUTHOR:  NVIDIA Corporation
# 
# SYNOPSIS: demonstrates creating multiple display grids: 
# first grid - 2 columns and 1 row, 1600x1200 at 60 Hz and 32 bpp for 
#              displays attached to Gpu0 (e.g. 1.1 and 1.2), no stereo
# second grid - 2 columns and 1 row, 1280x1024 at 60 Hz and 32 bpp for 
#              displays attached to Gpu1 (e.g. 2.1 and 2.2), no stereo
#
# See NVWMI Programming Guide in NVWMI.CHM and MOF class definitions in NVWMI.MOF 
# for more details
#
###############################################################################

$namespace = "root\CIMV2\NV"     # Namespace of NVIDIA WMI provider
$class     = "DisplayManager"    # class to be queried
if($computer -eq $null)          # if not set globally
{
    $computer  = "localhost"     # substitute with remote machine names or IP of the machine
}
$executionTime = 3               # Allow a delay of 3 seconds for execution of the method
<#
.SYNOPSIS
   Validate and Set a Display Grid

.DESCRIPTION
   This script is useful to create multiple mosaic

.EXAMPLE
   Validate-CreateGrids([ref]$displayManager)
#>
function Validate-CreateGrids
{

    Param
    (
        # instance of the DisplayManager class passed by reference
        [System.Management.ManagementBaseObject]$displayManagerInstance
    )

    # common parameters for the DisplayManager::validateDisplayGrids and DisplayManager::createDisplayGrids
    # TODO: modify as necessary - change display mode, number of rows and columns, layout etc.
    # Only "rows" and "cols" are mandatory
    $grids  =  @()
    $grids  += "rows=1;cols=2;stereo=0;layout=1.1 1.2;mode=1600 1200 32 60"  #add grid 1 parameters
    $grids  += "rows=1;cols=2;layout=2.1 2.2;mode=1280 1024 32 60"           #add grid 2 parameters
    
    # Validate display grids first
    $method = "validateDisplayGrids"
    $params = $displayManagerInstance.GetMethodParameters($method)
    $params.grids = $grids
    
    Start-Sleep  $executionTime
    "Calling $class.$method()"
    $result= $displayManagerInstance.InvokeMethod($method,$params,$null)
    $result
    
    if($result.ReturnValue)
    {
        # validated - now create display grids
        $method="createDisplayGrids"
        Start-Sleep  $executionTime
        "Calling $class.$method()"
        $result= $displayManagerInstance.InvokeMethod($method,$params,$null)
        $result
    }
}

###############################################################################
# 
#  Entry point to script
# 
###############################################################################

# get the instance of the display manager
$displayManager =Get-WmiObject -class $class -computername $computer -namespace $namespace

if($displayManager -eq $Null)
{
    "can't retrieve $class"
    return
}

#validate and create grids
Validate-CreateGrids([ref]$displayManager) 
