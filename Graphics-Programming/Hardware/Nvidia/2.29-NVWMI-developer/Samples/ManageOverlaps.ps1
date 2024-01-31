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
#
# PowerShell script with test of 1x4 Display grid functionality:
# - validation of display grid parameters
# - creation
# - setting non-zero overlap
# - setting zero overlap
#
###############################################################################
#############################
# FUNCTIONS
#############################

Function test1x4
{
    $rc = $false
    # Retrieving the instance of the WMI class DesktopManager (singleton)
    $class = "DisplayManager"

    # note that ":" is a special symbol for string concatenations
    $instance = [WmiClass][WmiClass]("\\$computer\$namespace"+":"+$class)

    # array of strings, just one element, defines a single display grid 1x4
    [array]$grids_1_1x4 =  @("rows=1;cols=4;layout=1.1 1.2 1.3 1.4")

    # validate display grids
    $res = Invoke-WmiMethod -Path $instance.__PATH -Name validateDisplayGrids -ArgumentList (,$grids_1_1x4)

    # create display grids if they are valid
    if( $res.ReturnValue -eq $true )
    {
        $res = Invoke-WmiMethod -Path $instance.__PATH -Name createDisplayGrids -ArgumentList (,$grids_1_1x4)
        
        if( $res.ReturnValue -eq $true )
        {
            $grids = Get-WmiObject -class DisplayGrid -computerName $computer -namespace $namespace
            foreach ($g in $grids)
            {
                "effective mode: {0}x{1}" -f $g.displayModeVirtual.width, $g.displayModeVirtual.height
                "physical mode: {0}x{1}" -f $g.displayModePhysical.width, $g.displayModePhysical.height
            }

            $ovl = -320                                     # negative overlap value : adjacent displays will overlap by 320 pixels
            $overlaps = @(-1,$ovl)                          # -1 means "overlap all displays by given value"
            $ew = 4*$g.displayModePhysical.width - 3*$ovl   # effective width. 1st displays won't have any overlap, 
                                                            # only inner column edges will be affected

            foreach ($g in $grids)
            {
                "setOverlapCol @{0} = {1}" -f $overlaps[0], $overlaps[1]
                $res = Invoke-WmiMethod -Path $g.__PATH -Name setOverlapCol -ArgumentList $overlaps

                if( $res.ReturnValue -eq $true )
                {
                    $grids = Get-WmiObject -class DisplayGrid -computerName $computer -namespace $namespace
                    foreach ($g in $grids)
                    {
                        if( $g.displayModeVirtual.width -ne $ew)
                        {
                            "ERROR : effective width {0} != {1}" -f $g.displayModeVirtual.width, $ew
                            $rc = $false
                            return $rc
                        }
                        else
                        {
                            "SUCCESS : effective width {0} == {1}" -f $g.displayModeVirtual.width, $ew
                            $rc = $true
                        }
                    }
                }
                else
                {
                    "ERROR : failed to set overlap: $overlaps"
                    $rc = $false
                    return $rc
                }
            }

            $ovl = 0                                        # overlap value 0 : no overlaps or gaps between adjacent displays
            $overlaps = @(-1,$ovl)                          # -1 means "overlap all displays by given value"
            $ew = 4*$g.displayModePhysical.width - 3*$ovl   # effective width. 1st displays won't have any overlap, 
                                                            # only inner column edges will be affected

            foreach ($g in $grids)
            {
                "setOverlapCol @{0} = {1}" -f $overlaps[0], $overlaps[1]
                $res = Invoke-WmiMethod -Path $g.__PATH -Name setOverlapCol -ArgumentList $overlaps

                if( $res.ReturnValue -eq $true )
                {
                    $grids = Get-WmiObject -class DisplayGrid -computerName $computer -namespace $namespace
                    foreach ($g in $grids)
                    {
                        if( $g.displayModeVirtual.width -ne $ew)
                        {
                            "ERROR : effective width {0} != {1}" -f $g.displayModeVirtual.width, $ew
                            $rc = $false
                            return $rc
                        }
                        else
                        {
                            "SUCCESS : effective width {0} == {1}" -f $g.displayModeVirtual.width, $ew
                            $rc = $true
                        }
                    }
                }
                else
                {
                    "ERROR : failed to set overlap: $overlaps"
                    $rc = $false
                    return $rc
                }
            }
        }
        else
        {
            "ERROR : failed to create $grids_1_1x4"
            $rc = $false
            return $rc
        }
    }
    else
    {
        "ERROR : failed to validate $grids_1_1x4, your hardware might not support this configuration"
        $rc = $false
    }
    return $rc
}

#############################
# ENTRY POINT
#############################

$spins= 10                      # number of test repetitions
if($computer -eq $null)         # if not set globally
{
    $computer  = "localhost"    # substitute with remote machine names or IP of the machine
}
$namespace = 'root\CIMV2\NV'    # WMI namespace of NVWMI provider

for($i=1; $i -le $spins; $i++)
{
    $rc = test1x4
    $rc
    if($rc[($a.length-1)] -ne $true)
    {
        ">>>>> ERROR : failed at $i iteration"
        break
    }
    else
    {
        "=== SUCCESS : at $i iteration"
    }
}