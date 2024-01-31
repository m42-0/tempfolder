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
# NAME:    Display.ps1
# AUTHOR:  NVIDIA Corporation
# REQUIRES: PowerShell 2.0
# 
# SYNOPSIS: retrieves properties and executes methods of Display class 
#
# DESCRIPTION: demonstrates how to use Display class representing a physical display 
# - iterating simple properties and objects within display class, 
# - saving EDID data for a display, 
# - display scaling, 
# - rotation, 
# - restoring native mode of the display
#
# See NVWMI Programming Guide in NVWMI.CHM and MOF class definitions in NVWMI.MOF 
# for more details
#
###############################################################################

$namespace = "root\CIMV2\NV"     # Namespace of NVIDIA WMI provider
$class     = "Display"           # class to be queried
if($computer -eq $null)          # if not set globally
{
    $computer  = "localhost"     # substitute with remote machine names or IP of the machine
}


<#
.SYNOPSIS
   Get the properties of an Management Base Object

.DESCRIPTION
   Report properties of an Object, if any proprerty is also an object recursive get its value

.EXAMPLE
   Get-ObjectProperties([ref]$displayProperty)
#>
function Get-ObjectProperties
{
    Param
    (
        # The member object contained in display class passed as a Reference
        [ref]$displayMemberRef
    )

    $result = $Null
    $objects= [System.Management.ManagementBaseObject]$displayMemberRef.Value

    foreach($object in $objects)
    {
        $properties = $object.Properties
        foreach($property in $properties)
        {
            if($property.Value -match [System.Management.ManagementBaseObject])
            {
                $result +="`t"
                $result += Get-ObjectProperties([ref] $property.Value)
            }
            else
            {
                $result +="`t" + $($property.Name +" : "+$property.Value)
            }
        }
    }

    return $result
}


###############################################################################
# 
#  Entry point to script
# 
###############################################################################

# Get all the display attached to the machine
$displays = Get-WmiObject -class $class -computername $computer -namespace $namespace

if($displays -eq $Null)
{
    return
}

# iterate thru all displays
foreach($display in $displays)
{
    # Report each property of a display
    $displayProperties= $display.Properties
    foreach($displayProperty in $displayProperties)
    {
        #Check if the property is Object
        $displayValue = $displayProperty.Value
        $type         = $displayProperty.Type

        if( $type -eq "Object" )
        {
            # if the property is an object
            $res=$displayProperty.Name + "`t"
            $res += Get-ObjectProperties([ref]$displayValue)
            $res
        }
        elseif( $type -eq "Reference" )
        {
            # if the property is an Reference
            $refValues = $displayProperty.Value
            $res       = $displayProperty.Name + "`t"
            foreach($refValue in $refValues)
            {
                $res+= $refValue + "`t"
            }
            $res
        }
        else
        {
            $($displayProperty.Name +"`t" + $displayValue)
        }
    }
}

# for each display execute several WMI methods
foreach($display in $displays)
{
    # skip inactive displays
    if($display.isActive -eq $false)
    {
        continue
    }
    # save current state
    $oldScaling = $display.scaling
    $oldRotation = $display.rotation

    # info method produces human-readable output
    $display.InvokeMethod("info", $path)

    # set scaling mode to Closest - to see visual changes, set resolution lower than native mode
    $scaling = 1
    $("Calling $class.setScaling")
    $display.InvokeMethod("setScaling", $scaling)

    $scaling = $oldScaling 
    $("Calling $class.setScaling")
    $display.InvokeMethod("setScaling", $scaling)

    # rotate display 180 degree
    $rotation = 2
    $("Calling $class.setRotation")
    $display.InvokeMethod("setRotation", $rotation)

    # rotate display back
    $rotation = $oldRotation
    $("Calling $class.setRotation")
    $display.InvokeMethod("setRotation", $rotation)

    # restore native display mode - note this method restores only screen geometry and color depth. 
    # it does not affect scaling or rotation
    $("Calling $class.restoreNativeDisplayMode")
    $display.InvokeMethod("restoreNativeDisplayMode", $Null)
}
