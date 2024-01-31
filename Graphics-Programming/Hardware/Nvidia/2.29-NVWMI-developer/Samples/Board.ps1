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
# NAME:    Board.ps1
# AUTHOR:  NVIDIA Corporation
# REQUIRES: PowerShell 2.0
# 
# SYNOPSIS: retrieves properties and executes info method of a Board class
#
# DESCRIPTION: Board class represent the board with nVIDIA GPU(s)
# - getting  properties of a Board class, 
# - obtaining human-readable information by calling 'info' method
#
# See NVWMI Programming Guide in NVWMI.CHM and MOF class definitions in NVWMI.MOF 
# for more details
#
##############################################################################

$namespace = "root\CIMV2\NV"     # Namespace of NVIDIA WMI provider
$class     = "Board"             # class to be queried
if($computer -eq $null)          # if not set globally
{
    $computer  = "localhost"     # substitute with remote machine names or IP of the machine
}

# Use the Power Shell cmdlet Get-WmiObject to get instance of Board class from the computer
$boards=Get-WmiObject -computer $computer -class $class -namespace $namespace

if($boards -eq $null)
{
    #Failed to get instances of Board class from the machine
    continue
}

# This command will only display 'gpus', 'thermalProbes' and 'coolers' properties
Get-WmiObject -computer $computer -class $class -namespace $namespace| Select-Object -Property gpus,thermalProbes,coolers

# print out human-readable information about each Board instance
foreach($board in $boards)
{
    $board.InvokeMethod("info",$Null)
}
