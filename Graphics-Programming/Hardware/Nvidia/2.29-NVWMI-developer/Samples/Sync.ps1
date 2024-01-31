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
# NAME:    Sync.ps1
# AUTHOR:  NVIDIA Corporation
# REQUIRES: PowerShell 2.0
#
# SYNOPSIS: retrieves properties and executes methods of the Sync class
#
# DESCRIPTION: Sync class represents Sync-capable devices
# script illustrates basic Sync operations
#
# See NVWMI Programming Guide in NVWMI.CHM and MOF class definitions in NVWMI.MOF
# for more details
#
#
###############################################################################


$namespace = "root\CIMV2\NV"    # Namespace of the NVIDIA WMI provider
$classname = "Sync"             # class to be queried
if($computer -eq $null)         # if not set globally
{
    $computer  = "localhost"    # substitute with remote machine names or IP of the machine
}

<#
.SYNOPSIS
   Formats the Sync properties

.DESCRIPTION
   This function format Sync properties

.EXAMPLE
   SyncProperties([ref]$syncObject)
#>
Function SyncProperties
{

    Param
    (
        [ref]$syncObjectsRef
    )

    $syncObjects = [System.Object]$syncObjectsRef.Value

    if($syncObjects)
    {
        foreach($syncObj in $syncObjects)
        {
            $("Sync properties info:")
            $("Sync class version  : " + $syncObj.ver.strValue)
            $("verSyncFirmware     :"  + $syncObj.verSyncFirmware.strValue)
            $("count               :"  + $syncObj.count)
            $("id                  :"  + $syncObj.id)
            $("ordinal             :"  + $syncObj.ordinal)
            $("name                :"  + $syncObj.name)
            $("uname               :"  + $syncObj.uname)
            $("syncDisplays        :"  + [String]::Join('";', $syncObj.syncDisplays)+'";')

            $("Sync status parameters:")
            $("isHouseSync         :"  + $syncObj.isHouseSync)
            $("isStereoSynced      :"  + $syncObj.isStereoSynced)
            $("isSynced            :"  + $syncObj.isSynced)
            $("flStatus            :"  + $syncObj.flStatus)
            $("syncSignalRate      :"  + $syncObj.syncSignalRate)

            $("Sync device control parameters:")
            $("interlaceMode       :"   + $syncObj.interlaceMode)
            $("interval            :"   + $syncObj.interval)
            $("polarity            :"   + $syncObj.polarity)
            $("vmode               :"   + $syncObj.vmode)
            $("source              :"   + $syncObj.source)
            $("startupDelay        :"   + $syncObj.startupDelay)
            $("syncSkew            :"   + $syncObj.syncSkew)
        }
    }
}

<#
.SYNOPSIS
   Fomratted Sync Display properties

.DESCRIPTION
   This method formats Sync display properties

.EXAMPLE
   SyncDisplayProperties([ref]$syncDisplayInstances)
#>
function SyncDisplayProperties
{

    Param
    (
        [ref]$syncDisplayInstancesRef
    )

    $syncDisplayInstances = [System.Object[]]$syncDisplayInstancesRef.Value
    if($syncDisplayInstances)
    {

        foreach($syncDisplay in $syncDisplayInstances)
        {
            $("`nSync display info: "  + $syncDisplay.uname )
            $("ordinal             : " + $syncDisplay.ordinal)
            $("id                  : " + $syncDisplay.id)
            $("isDisplayMasterable : " + $syncDisplay.isDisplayMasterable)

            $syncstate
            switch($syncDisplay.displaySyncState)
            {
                0 { $syncstate ="UnSynced"       }
                1 { $syncstate ="Slave"          }
                2 { $syncstate ="Master"         }
            }
            $("displaySyncState    : " + $syncstate)

        }
    }
}

<#
.SYNOPSIS
   Set the desired sysnc state

.DESCRIPTION
   This script picks up the first sync display that can be Master and set rest as Slave, also unsync if allready sync

.EXAMPLE
   SetSyncState([ref]$sync) ([ref]$syncDisplays) ($unset)
#>
function SetSyncState
{
    Param
    (
        [ref]$syncInstancesRef,
        [ref]$displayInstancesRef,
        [boolean]$unset
    )

    # Validate the Grids first
    $method = "setSyncStateById"
    $syncDisplayIds  =  @()
    $syncState       =  @()
    $masterSet       = $false

    $displayInstances = [System.Object[]]$displayInstancesRef.Value
    [System.Management.ManagementObject]$syncInstances  = [System.Management.ManagementObject]$syncInstancesRef.Value


    #loop all through the sync displays
    foreach($display in $displayInstances)
    {
        if($unset)
        {
            $syncState += 0 # Unsynced
        }
        elseif( $display.isDisplayMasterable -eq $true -and $masterSet -eq $false)
        {
            $syncState += 2 # set it as master
            $masterSet = $true
        }
        else
        {
            $syncState += 1 # set it as slave
        }

        $syncDisplayIds += $display.id
    }

    #fill the parameters
    $params = $syncInstances.GetMethodParameters($method)
    $params.syncDisplayIds = $syncDisplayIds
    $params.syncState = $syncState

    #set the state
    "Calling $classname.$method()"
    $result = $syncInstances.InvokeMethod($method,$params,$null)
    if($result.ReturnValue -eq $true)
    {
        $ret = "succeeded"
    }
    else
    {
        $ret = "failed"
    }
    "$method call with syncDisplayIds="+$params.syncDisplayIds+", "+"with syncState="+$params.syncState+": $ret"
    "---"
}


<#
.SYNOPSIS
   Set the setStartupDelay

.DESCRIPTION
   Set the amount of delay the frame lock card should wait, until generating sync pulse, this will only be set when we a device synced

.EXAMPLE
   setStartupDelay(10, 100)
#>
function setStartupDelay
{
    Param
    (
        [int]$numOfPixels,
        [int]$numOfLines
    )

    # Validate the Grids first
    $method = "setStartupDelay"
    $syncDisplayIds  =  @()
    $syncState       =  @()
    $masterSet       = $false

    $classname = "Sync"
    $syncInstance  = $syncDisplays = Get-WmiObject -class $classname -computername $computer -namespace $namespace
    if($syncInstance -eq $null)
    {
        "$method failed to get an instance of the Sync class"
        return
    }

    # only if synced add delay of specified number of lines and pixels
    if($syncInstance.isSynced -eq $true)
    {
        # fill in parameter values
        $params = $syncInstance.GetMethodParameters($method)
        $params.numOfPixels = $numOfPixels
        $params.numOfLines = $numOfLines

        # set sync state
        "Calling $classname.$method()"
        $result = $syncInstance.InvokeMethod($method,$params,$null)
        if($result.ReturnValue -eq $true)
        {
            $ret = "succeeded"
        }
        else
        {
            $ret = "failed"
        }
        "$method call with numOfPixels="+$params.numOfPixels+", "+"with numOfLines="+$params.numOfLines+": $ret"
        "---"
    }
}


###############################################################################
#
#  Entry point
#
###############################################################################

$classname = "Sync"
$syncObjects = Get-WmiObject -class $classname -computername $computer -namespace $namespace

if($syncObjects -eq $null)
{
    #Failed to get instances of Sync class from the machine
    continue
}

$classname = "SyncTopology"
$syncDisplays = Get-WmiObject -class $classname  -computername $computer -namespace $namespace

if($syncDisplays -eq $null)
{
    #Failed to get instances of SyncTopology class from the machine
    continue
}

foreach($sync in $syncObjects)
{
    $unset =$false
    SyncProperties([ref]$sync)
    SyncDisplayProperties([ref]$syncDisplays)

    # if synced up, then unsync
    if($sync.isSynced -eq $true)
    {
        $unset=$true
    }
    
    SetSyncState ([ref]$sync) ([ref]$syncDisplays) ($unset)
}

setStartupDelay(100,10)
