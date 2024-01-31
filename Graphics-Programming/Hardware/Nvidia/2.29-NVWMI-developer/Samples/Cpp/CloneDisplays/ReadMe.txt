========================================================================
    CONSOLE APPLICATION : CloneDisplays Project Overview
========================================================================

CloneDisplays application demonstrates how to clone all attached displays by:
    1. Enumerating all attached displays and verifying that cloning is possible 
    2. Detecting compatible display mode 
    3. Creating a display grid 1xN, spanning horizontally 
    4. Overlapping all displays horizontally at screen width 
    
    General WMI techniques demonstrated:
     - querying instances of dynamic classes
     - querying properties of WMI objects 
     - passing input arguments to WMI methods in safe arrays and scalars
     - parsing return of WMI methods
     - calling methods of dynamic classes
     - calling methods of static classes

KNOWN ISSUES: 
    This application is designed to demonstrate basic steps for cloning. 
    It might fail on complex display configurations, which cannot accomodate 
    all connected displays into 1xN horizontal display grid. For example, 
    1 or more displays attached to one GPU and 1 or more displays attached to another GPU. 
    It might also fail when there is no compatible display mode, available for all displays in a grid.

CloneDisplays.vcxproj
    This is the main project file for VC++ projects.
    It contains information about the version of Visual C++ that generated the file, and
    information about the platforms, configurations, and project features.

CloneDisplays.vcxproj.filters
    This is the filters file for VC++ projects. 
    It contains information about the association between the files in your project 
    and the filters. This association is used in the IDE to show grouping of files with
    similar extensions under a specific node (for e.g. ".cpp" files are associated with the
    "Source Files" filter).

CloneDisplays.cpp
    This is the main application source file. It is written on C++11.

