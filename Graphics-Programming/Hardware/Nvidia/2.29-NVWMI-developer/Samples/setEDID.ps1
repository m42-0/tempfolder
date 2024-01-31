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
# NAME:    setEDID.ps1
# AUTHOR:  NVIDIA Corporation
# REQUIRES: PowerShell 2.0
# 
# SYNOPSIS: retrieves properties and executes EDID-related methods 
#           of the Display class 
#
# DESCRIPTION: demonstrates how to manipulate EDID via Display class methods
# - saving EDID data to a file in text format 
# - setting EDID from saved file in text format
#
# See NVWMI Programming Guide in NVWMI.CHM and MOF class definitions in NVWMI.MOF 
# for more details
#
###############################################################################
# Save and re-apply the EDIDs for all connected displays

$edidPath  = ${env:ProgramData}  # where to save the EDID's. 
$namespace = "root\CIMV2\NV"     # namespace of NVIDIA WMI provider

if($computer -eq $null)          # if not set globally
{
    $computer  = "localhost"     # substitute with remote machine names or IP of the machine
}

# Get all displays attached to the machine
$displays = Get-WmiObject -class Display -computername $computer -namespace $namespace

if($displays -eq $null)
{
    "system has no displays"
    return
}

# iterate thru all displays
foreach($display in $displays)
{
    "processing $computer, " + $display.uname

    $file = Join-Path -Path $edidPath -ChildPath ($display.uname+".txt")

    $res=$display.saveEDID($file)
    if($res.ReturnValue -eq $true)
    {
        "SUCCESS : EDID saved to $file"
        $res = $display.setEDID($file)
        if($res.ReturnValue -eq $true)
        {
            "SUCCESS : EDID set from $file"
        }
        else
        {
            "FAILURE : failed to set EDID from $file"
        }
    }
    else
    {
        "FAILURE : failed to save EDID to $file"
    }
    "==="
}
