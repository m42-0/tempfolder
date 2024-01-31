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
# NAME:    PerfCounters.ps1
# AUTHOR:  NVIDIA Corporation
# REQUIRES: PowerShell 2.0
# 
# SYNOPSIS: retrieves several performance counters
#
# DESCRIPTION: script illustrates several ways of accessing performance counters
#
# See NVWMI Programming Guide in NVWMI.CHM and MOF class definitions in NVWMI.MOF 
# for more details
#
#
###############################################################################

if($computer -eq $null)          # if not set globally
{
    $computer  = "localhost"     # substitute with remote machine names or IP of the machine
}

# List all available counters, provided in the "NVIDIA GPU" category. Note that query is case-insensitive
(Get-Counter -ComputerName $computer -ListSet "nvidia gpu").Counter

# Use the Power Shell Cmdlet Get-Counter to read specific counter for all Gpu instances in system. 
# Asterisk in braces means that all instances will be queried
Get-Counter "\\$computer\nvidia gpu(*)\fan speed"

# Use the Power Shell Cmdlet Get-Counter to read specific counter for specific Gpu instance
# Instance selected by regular expression - partial match with wildcard
Get-Counter "\\$computer\nvidia gpu(#0*)\fan speed"

# Use the Power Shell Cmdlet Get-Counter to read specific counter for all Quadro Gpu instances
Get-Counter "\\$computer\nvidia gpu(*quadro*)\fan speed"