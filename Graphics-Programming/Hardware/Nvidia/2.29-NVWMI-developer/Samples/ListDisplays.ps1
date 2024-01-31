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
# NAME:    ListDisplays.ps1
# AUTHOR:  NVIDIA Corporation
# REQUIRES: PowerShell 2.0
# 
# SYNOPSIS: List important properties for all attached displays in human-readable format
#
# DESCRIPTION: Demonstrates how to 
#  - access important properties of the Display class
#  - access Display class instance via reference 
#  - assemble absolute path to WMI object from reference string
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

$displays = gwmi -class "Display" -computername $computer -namespace $namespace
$idx=1
foreach($d in $displays)
{
    $active = @{$true="ACTIVE  ";$false="DISABLED"}[$d.isActive -eq 1]
    "Display{0}: id={1}, NVAPI id=0x{2:X} ({2}), {3}, uname={4}" -f $idx, $d.id, $d.nvapiId, $active, $d.uname
    "    native mode: {0}x{1}, {2} bpp @ {3} Hz" -f $d.displayModeNative.width, $d.displayModeNative.height, $d.displayModeNative.colorDepth, $d.displayModeNative.refreshRate
    if($idx -lt $displays.Count)
    {
        "----"
    }
    ++$idx
}
"===="
$grids = gwmi -class "DisplayGrid" -computername $computer -namespace $namespace
foreach($g in $grids)
{
    "{0}: id={1}, pos=({2};{3})" -f $g.uname, $g.id, $g.positionRow, $g.positionCol
    "  current physical mode: {0}x{1}, {2} bpp @ {3} Hz" -f $g.displayModePhysical.width, $g.displayModePhysical.height, $g.displayModePhysical.colorDepth, $g.displayModePhysical.refreshRate
    "  current virtual mode : {0}x{1}, {2} bpp @ {3} Hz" -f $g.displayModeVirtual.width, $g.displayModeVirtual.height, $g.displayModeVirtual.colorDepth, $g.displayModeVirtual.refreshRate
    
    # accessing Display instance by reference. References in 'displays' are relative, computer and WMI namespace has to be added
    foreach($dref in $g.displays)
    {
        $di = [wmi]("\\$computer\$namespace"+":"+$dref)
        if($di -eq $null)
        {
            "bad reference"
        }
        else
        {
            "    Display {0} with ID={1}" -f $di.uname, $di.id
        }
    }
}
