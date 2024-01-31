========================================================================
    CONSOLE APPLICATION : GpuPerfCounters Project Overview
========================================================================

GpuPerfCounters application demonstrates how to get WMI object properties of the Gpu class 
and how to query performance counters, provided by NVWMI. Note that name of the counter with 
CPU temperature differs across releases. It could be "Temperature C", "Temperature" or "Temperature °C". 


GpuPerfCounters.vcxproj
    This is the main project file for VC++ projects.
    It contains information about the version of Visual C++ that generated the file, and
    information about the platforms, configurations, and project features.

GpuPerfCounters.vcxproj.filters
    This is the filters file for VC++ projects. 
    It contains information about the association between the files in your project 
    and the filters. This association is used in the IDE to show grouping of files with
    similar extensions under a specific node (for e.g. ".cpp" files are associated with the
    "Source Files" filter).

GpuPerfCounters.cpp
    This is the main application source file. It is written on C++11, but could be easily ported to the ANSI C.

