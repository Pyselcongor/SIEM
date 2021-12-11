copy /z /y "\\PRD-SRV-V-BCK\Logiciels\Talc SI\Site_Logiciels - Documents\SIEM\Sysmon-config.xml" "C:\windows\"
sysmon -c c:\windows\Sysmon-config.xml

sc query "Sysmon" | Find "RUNNING"
If "%ERRORLEVEL%" EQU "1" (
goto startsysmon
)
:startsysmon
net start Sysmon

If "%ERRORLEVEL%" EQU "1" (
goto installsysmon
)
:installsysmon
"\\PRD-SRV-V-BCK\Logiciels\Talc SI\Site_Logiciels - Documents\SIEM\Sysmon64.exe" /accepteula -i c:\windows\Sysmon-config.xml