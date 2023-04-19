
Timers:

Get Overview of availabe Timers and find out what/how they are used for (https://www.geoffchappell.com/notes/windows/boot/bcd/elements.htm)

bcdedit /enum

bcdedit /deletevalue X (where X is useplatformclock, x2apicpolicy, etc.)

bcdedit /set disabledynamictick yes (Windows 8+)

This command forces the kernel timer to constantly poll for interrupts instead of wait for them; dynamic tick was implemented as a power saving feature for laptops but hurts desktop performance

bcdedit /set useplatformtick yes (Windows 8+)

Forces the clock to be backed by a platform source, no synthetic timers are allowed

Potentially better performance, sets timer resolution to .5 instead of .501 or .499 ms

bcdedit /set tscsyncpolicy [legacy | default | enhanced] (Windows 8+)

Tells Windows which implementation of TSC to use, try all three and see which you prefer

Services:

Generally speaking, the more services, the more resources are consumed. They might be relevant to system functions or never used at all. Possibilities to disable, control and modify them. Enumerate dependant services and create base set of Service Config.

Service Defaults W11 (https://www.elevenforum.com/t/restore-default-services-in-windows-11.3109/)

https://github.com/amitxv/Service-List-Builder

https://www.nirsoft.net/utils/serviwin.html

DHCP Client, Network Connections, Network List Service, Network Location Awareness, and Network Store Interface Service are required to automatically connect to a local network, but once a static IP is set, they can be disabled.

Power Config:

powercfg -attributes SUB_PROCESSOR 5d76a2ca-e8c0-402f-a133-2158492d58ad -ATTRIB_HIDE

powercfg /energy -> C:\WINDOWS\system32\energy-report.html -> Ctrl+f Platform Timer Resolution:Outstanding Timer Request

https://github.com/rahilpathan/Win10Boost/blob/main/Individual%20Tricks/Boostedplan.bat

https://github.com/rahilpathan/Win10Boost/blob/main/Individual%20Tricks/Fast.bat ;Multiple: Services, SchdTasks,power,tcpip...

::RESTORE DEFAULT POWER PLANS

powercfg -restoredefaultschemes

::SHOW ALL OPTIONS IN POWERPLAN

powercfg -attributes SUB_PROCESSOR 12a0ab44-fe28-4fa9-b3bd-4b64f44960a6 -ATTRIB_HIDE

powercfg -attributes SUB_PROCESSOR 06cadf0e-64ed-448a-8927-ce7bf90eb35d -ATTRIB_HIDE

powercfg -attributes SUB_SLEEP 25DFA149-5DD1-4736-B5AB-E8A37B5B8187 -ATTRIB_HIDE

powercfg -attributes 9596FB26-9850-41fd-AC3E-F7C3C00AFD4B 03680956-93BC-4294-BBA6-4E0F09BB717F -ATTRIB_HIDE

powercfg -attributes SUB_SLEEP A4B195F5-8225-47D8-8012-9D41369786E2 -ATTRIB_HIDE

powercfg -attributes SUB_SLEEP d4c1d4c8-d5cc-43d3-b83e-fc51215cb04d -ATTRIB_HIDE

powercfg -attributes SUB_SLEEP 7bc4a2f9-d8fc-4469-b07b-33eb785aaca0 -ATTRIB_HIDE

powercfg -attributes 2a737441-1930-4402-8d77-b2bebba308a3 d4e98f31-5ffe-4ce1-be31-1b38b384c009 -ATTRIB_HIDE

powercfg -attributes 2a737441-1930-4402-8d77-b2bebba308a3 0853a681-27c8-4100-a2fd-82013e970683 -ATTRIB_HIDE

powercfg -attributes SUB_VIDEO A9CEB8DA-CD46-44FB-A98B-02AF69DE4623 -ATTRIB_HIDE

powercfg -attributes SUB_BUTTONS 5ca83367-6e45-459f-a27b-476b1d01c936 -ATTRIB_HIDE

powercfg -attributes SUB_BUTTONS 99ff10e7-23b1-4c07-a9d1-5c3206d741b4 -ATTRIB_HIDE

powercfg -attributes SUB_DISK dab60367-53fe-4fbc-825e-521d069d2456 -ATTRIB_HIDE

powercfg -attributes SUB_DISK 80e3c60e-bb94-4ad8-bbe0-0d3195efc663 -ATTRIB_HIDE

powercfg -attributes SUB_DISK 0b2d69d7-a2a1-449c-9680-f91c70521c60 -ATTRIB_HIDE

powercfg -attributes 9596FB26-9850-41fd-AC3E-F7C3C00AFD4B 10778347-1370-4ee0-8bbd-33bdacaade49 -ATTRIB_HIDE

powercfg -attributes 9596FB26-9850-41fd-AC3E-F7C3C00AFD4B 34C7B99F-9A6D-4b3c-8DC7-B6693B78CEF4 -ATTRIB_HIDE

powercfg -attributes 19cbb8fa-5279-450e-9fac-8a3d5fedd0c1 12bbebe6-58d6-4636-95bb-3217ef867c1a -ATTRIB_HIDE

powercfg -attributes F15576E8-98B7-4186-B944-EAFA664402D9 -ATTRIB_HIDE

powercfg -attributes SUB_VIDEO aded5e82-b909-4619-9949-f5d71dac0bcc -ATTRIB_HIDE

powercfg -attributes SUB_DISK 6b013a00-f775-4d61-9036-a62f7e7a6a5b -ATTRIB_HIDE

powercfg -attributes SUB_VIDEO f1fbfde2-a960-4165-9f88-50667911ce96 -ATTRIB_HIDE

Device Manager:disable unnecessary devices

Display adapters:

Intel graphics (if you don’t use it, ideally should be disabled in the BIOS)

Network adapters:

All WAN miniports

Microsoft ISATAP Adapter

Storage controllers:

Microsoft iSCSI Initiator

System devices:

Composite Bus Enumerator

Intel Management Engine / AMD PSP

Intel SPI (flash) Controller

Microsoft GS Wavetable Synth

Microsoft Virtual Drive Enumerator (if not using virtual drives)

NDIS Virtual Network Adapter Enumerator

Remote Desktop Device Redirector Bus

SMBus

System speaker

Terminal Server Mouse/Keyboard drivers

UMBus

Application Priority and Affinities (https://github.com/jbara2002/melody_windows/blob/main/registry/Application%20Priority%20and%20Affinities.reg)

Image File Execution Options:

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\NVDisplay.Container.exe]

"MaxLoaderThreads"=dword:00000001

AUDIO

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Multimedia\Audio]

"UserDuckingPreference"=dword:00000003

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\BackgroundModel\BackgroundAudioPolicy]

"AllowHeadlessExecution"=dword:00000001

"AllowMultipleBackgroundTasks"=dword:00000001

"InactivityTimeoutMs"=dword:FFFFFFFF