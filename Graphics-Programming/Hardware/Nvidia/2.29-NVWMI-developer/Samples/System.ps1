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
# NAME:    System.ps1
# AUTHOR:  NVIDIA Corporation
# REQUIRES: PowerShell 2.0
# 
# SYNOPSIS: This script retrieves properties and executes method of a System class
#
# DESCRIPTION: System class is a singleton, representing top-level properties 
# of nVIDIA driver and hardware. Script demonstrates getting System properties 
# and toggling nView Desktop Manager state across multiple machines
#
# See NVWMI Programming Guide in NVWMI.CHM and MOF class definitions in NVWMI.MOF 
# for more details
#
###############################################################################


$namespace = "root\CIMV2\NV"     # Namespace of NVIDIA WMI provider
$class     = "System"            # class to be queried
if($computer -eq $null)          # if not set globally
{
    $computer = "localhost"      # substitute with remote machine names or IP of the machine
}
if($computers -eq $null)         # if not set globally
{
    $computers = @($computer)    # substitute with an array of remote targets, defaulting to a single system
}
 
foreach($computer in $computers)
{
    # Use the Power Shell cmdlet Get-WmiObject to get an instance of the System class from the computer
    $system = Get-WmiObject -computer $computer -class $class -namespace $namespace 

    if($system -eq $null)
    {
        # failed to get an instance of the System class from a machine
        continue
    }

    # 'nViewState' is a property of a System class, 
    # representing nView Desktop Manager state (enabled, disabled or not installed) 
    $nview = $system.nViewState
    $nviewState

    if($nview -eq 1)
    {
        "$computer - nView Desktop Manager: Enabled"
        $nviewState = 0
    }
    else
    {
        "$computer - nView Desktop Manager: Disabled"
        $nviewState = 1
    }

    # toggle nView Desktop Manager state by invoking method 'setnViewState' with the new state value
    $result = $system.InvokeMethod("setnViewState", $nviewState)
    "$computer - Result of toggling nView Desktop Manager State: " + $result

    # print out human-readable information about System Class singleton
    $result = $system.InvokeMethod("info", $null)
    "$computer - Result of invoking $class.info():" 
    $result
}