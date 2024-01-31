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
# NAME:    unfakeEDIDAll.ps1
# AUTHOR:  NVIDIA Corporation
# REQUIRES: PowerShell 2.0
# 
# SYNOPSIS: clears all faked EDIDs on all outputs of all GPUs 
#
# DESCRIPTION: demonstrates how to clear all faked EDID data on all outputs
#
# See NVWMI Programming Guide in NVWMI.CHM and MOF class definitions in NVWMI.MOF 
# for more details
#
###############################################################################
# clears all faked EDIDs on all outputs of all GPUs 

$namespace = "root\CIMV2\NV"        # namespace of NVIDIA WMI provider

if($computer -eq $null)             # if not set globally
{
    $computer  = "localhost"        # substitute with remote machine names or IP of the machine
}

$dm = Get-WmiObject -class DisplayManager -computername $computer -namespace $namespace
if($dm -eq $null)
{
    "system has no displays to manage"
    return
}

$params = $dm.GetMethodParameters("fakeEDIDAll")
$params.filePath = ""               # empty path means 'un-fake'
$params.output = 9                  # 9 == "All", see NVWMI.MOF and NVWMI.CHM
                
$res = $dm.InvokeMethod("fakeEDIDAll",$params,$null)
if($res.ReturnValue -eq $true)
{
    "SUCCESS : all faked EDIDs were removed"
}
else
{
    "FAILURE : failed to un-fake EDID"
}

