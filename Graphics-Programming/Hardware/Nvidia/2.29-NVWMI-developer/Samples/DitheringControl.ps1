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
# NAME:    DitheringControl.ps1
# AUTHOR:  NVIDIA Corporation
# REQUIRES: PowerShell 2.0
# 
# SYNOPSIS: Examines and changes dithering state of all attached displays
#
# DESCRIPTION: demonstrates how to 
# - inspect dithering properties of the Display class
# - change dithering state by calling Display::setDither method
#
# See NVWMI Programming Guide in NVWMI.CHM and MOF class definitions in NVWMI.MOF 
# for more details
#
###############################################################################

$namespace = "root\CIMV2\NV"

if($computer -eq $null)
{
    $computer="localhost"
}

$ds = gwmi -class "Display" -computername $computer -namespace $namespace
$idx=1
foreach($d in $ds)
{
    $active = @{$true="ACTIVE  ";$false="DISABLED"}[$d.isActive -eq 1]
    $state = @{0="HW default";1="ENABLED";2="DISABLED"}[$d.ditherState]
    $bits = @{0="6 bit";1="8 bit";2="10 bit"}[$d.ditherBits]
    $mode = @{0="SpatialDynamic";1="SpatialStatic";2="SpatialDynamic2x2";3="SpatialStatic2x2";4="Temporal"}[$d.ditherMode]

    "Display{4}: id={1}, NVAPI id=0x{0:X} ({0}), {3}, uname={2}" -f $d.nvapiId, $d.id, $d.uname, $active, $idx 
    "`told dithering state: {0}, bits: {1}, mode: {2}" -f $state, $bits, $mode

    if($d.isActive -eq 1)
    {
        $method="setDither"
        $params = $d.GetMethodParameters($method)
        $params.state = 2 # 2 - disable dithering
        $params.bits = 1 # 1 - 8 bit
        $params.mode = 4 # 4 - Temporal
        # $params.bits and $params.mode are not required when disabling dither. 
        # When dithering is disabled, bits and mode values are disregarded.
        
        $res = $d.InvokeMethod($method, $params, $null)
        if( $res.ReturnValue -eq $true )
        {
            "SUCCESS : $method to state={0:d}, bits={1:d}, mode={2:d}" -f $params.state, $params.bits, $params.mode
            $rc = $true
        }
        else
        {
            "ERROR : $method to state={0:d}, bits={1:d}, mode={2:d}" -f $params.state, $params.bits, $params.mode
            $rc = $false
            return $rc
        }
    }
    else
    {
        "skipping inactive display"
    }
    "----"

    ++$idx
}

"===="

# Examine dithering state after changes
$ds = gwmi -class "Display" -computername $computer -namespace $namespace
$idx=1
foreach($d in $ds)
{
    $active = @{$true="ACTIVE  ";$false="DISABLED"}[$d.isActive -eq 1]
    $state = @{0="HW default";1="ENABLED";2="DISABLED"}[$d.ditherState]
    $bits = @{0="6 bit";1="8 bit";2="10 bit"}[$d.ditherBits]
    $mode = @{0="SpatialDynamic";1="SpatialStatic";2="SpatialDynamic2x2";3="SpatialStatic2x2";4="Temporal"}[$d.ditherMode]

    "Display{4}: id={1}, NVAPI id=0x{0:X} ({0}), {3}, uname={2}" -f $d.nvapiId, $d.id, $d.uname, $active, $idx 
    "`tnew dithering state: {0}, bits: {1}, mode: {2}" -f $state, $bits, $mode
    "----"

    ++$idx
}
