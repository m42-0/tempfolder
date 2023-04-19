Const KEY = "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\SubSystems\Windows"
dim objShell, regex, str
Set objShell = CreateObject("Wscript.Shell")
Set regex = CreateObject("vbscript.regexp")
regex.IgnoreCase = True
regex.Pattern = "(SharedSection)=(\d+),(\d+),(\d+)"
str = objShell.RegRead (KEY)
str = regex.Replace(str,"$1=1024,20480,1024")
objShell.RegWrite KEY,str,"REG_EXPAND_SZ"