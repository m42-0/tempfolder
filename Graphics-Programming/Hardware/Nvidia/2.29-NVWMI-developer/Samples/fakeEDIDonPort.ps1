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
# NAME:    fakeEDIDonPort.ps1
# AUTHOR:  NVIDIA Corporation
# REQUIRES: PowerShell 2.0
# 
# SYNOPSIS: fake EDID on a given GPU output and port
#
# DESCRIPTION: demonstrates how to fake EDID on a given output type and GPU port 
#  for all GPUs in a system. Note that EDID is expected to be saved in text 
#  format by either NVIDIA Control Panel or by NVWMI Display::saveEDID method
#
# See NVWMI Programming Guide in NVWMI.CHM and MOF class definitions in NVWMI.MOF 
# for more details
#
###############################################################################


$namespace = "root\CIMV2\NV"        # namespace of NVIDIA WMI provider

if($computer -eq $null)             # if not set globally
{
    $computer  = "localhost"        # substitute with remote machine names or IP of the machine
}

if($pathToEdid -eq $null)           # if not set globally
{
    # TODO : modify path to the text file with EDID as necessary. 
    # by default it is a local path %ProgramData%\EDID.txt
    $pathToEdid = Join-Path -Path ${env:ProgramData} -ChildPath "EDID.txt"
    "Attempting to load EDID from file $pathToEdid"
}

$res=Test-Path -Path $pathToEdid 
if(!$res)
{
    "FAILURE : cannot find file with EDID : $pathToEdid is not available"
    return 
}
else
{
    "SUCCESS : file with EDID : $pathToEdid is found" 
}

$gpus = Get-WmiObject -class Gpu -computername $computer -namespace $namespace
if($gpus -eq $null)
{
    "system has no GPUs to manage"
    return
}

foreach($gpu in $gpus)
{
    "processing GPU : " + $gpu.uname
    $params = $gpu.GetMethodParameters("fakeEDIDOnPort")
    $params.filePath = $pathToEdid
    $params.portIndex = 1
    $params.output = 7                  # 7 is DisplayPort, see NVWMI.MOF and NVWMI.CHM - 
    # 1-"VGA", 2-"Component", 3-"S-Video", 4-"HDMI", 5-"DVI", 6-"LVDS", 7-"DP", 8-"Composite"
    
                    
    $res = $gpu.InvokeMethod("fakeEDIDOnPort",$params,$null)
    if($res.ReturnValue -eq $true)
    {
        "SUCCESS : faked EDID on output "+$params.output+", port "+$params.portIndex 
    }
    else
    {
        "FAILURE : failed to fake EDID on output "+$params.output+", port "+$params.portIndex 
    }
}
