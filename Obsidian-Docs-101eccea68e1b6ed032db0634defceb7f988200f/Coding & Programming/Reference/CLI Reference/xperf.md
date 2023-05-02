#cli #performance
cd "C:\Program Files (x86)\Windows Kits\10\Windows Performance Toolkit"
xperf -on base+interrupt+dpc
xperf -d c:\temp\trace.etl
xperf -i c:\temp\trace.etl -o

c:\temp\report.txt -a dpcisr

mftrace -a vlc.exe -o c:\temp\trace.etl

xperf.exe -providers kf

xperf -start "NT Kernel Logger" -on PROC_THREAD+LOADER+DPC+INTERRUPT+WDF_DPC+WDF_INTERRUPT