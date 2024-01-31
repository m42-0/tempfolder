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
# NAME:    Gpu.ps1
# AUTHOR:  NVIDIA Corporation
# REQUIRES: PowerShell 2.0
# 
# SYNOPSIS: retrieves properties and executes info method of Gpu class 
#
# DESCRIPTION: Gpu class represent an nVIDIA GPU hardware, 
# script illustrates basic operations with Gpu class instance(s)
#
# See NVWMI Programming Guide in NVWMI.CHM and MOF class definitions in NVWMI.MOF 
# for more details
#
#
###############################################################################


$namespace = "root\CIMV2\NV"     # Namespace of NVIDIA WMI provider
$classname = "Gpu"               # class to be queried
if($computer -eq $null)          # if not set globally
{
    $computer  = "localhost"     # substitute with remote machine names or IP of the machine
}

# Use the Power Shell Cmdlet Get-WmiObject to get instance of Gpu class from the computer
$gpus = Get-WmiObject -class $classname -computername $computer -namespace $namespace 

if($gpus -eq $null)
{
    # Failed to get instances of Gpu class from the machine
    continue
}

# print all Gpu instances
$gpus 

# call info() method for all Gpu instances
foreach( $gpu in $gpus )
{
    "---> $classname.info() for {0:s}" -f $gpu.uname
    $res = $gpu.InvokeMethod("info",$Null)
    $res
}


