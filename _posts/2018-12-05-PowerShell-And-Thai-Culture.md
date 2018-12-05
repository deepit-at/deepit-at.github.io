---
layout:             post

categories:         []
tags:               [ pwsh ]

date:               2018-12-05 21:05:00 +0200
# last_modified_at:   <datetime>
# published:          false

author:             sfarnik
# title:              ''

# image:              https://dummyimage.com/800x480

excerpt_separator:  <!--more-->
# excerpt:
# description:

# redirect_from:
---

In work, we stumbled across some discrepancy when using PowerShell on clients which use the ```th-Th``` culture locale.

For me, when I run PowerShell at my client and type

~~~ powershell
$host
~~~

I can see, that the ```de-AT``` locale (CurrentCulture) is used:

~~~ plain
Name             : ConsoleHost
Version          : 5.1.18290.1000
InstanceId       : 16d3ef7b-5ab3-4d53-b248-bdaa0db35c2f
UI               : System.Management.Automation.Internal.Host.InternalHostUserInterface
CurrentCulture   : de-AT
CurrentUICulture : en-US
PrivateData      : Microsoft.PowerShell.ConsoleHost+ConsoleColorProxy
DebuggerEnabled  : True
IsRunspacePushed : False
Runspace         : System.Management.Automation.Runspaces.LocalRunspace
~~~

![caption](/assets/img/posts/thai-culture-gui.png)
Thai culture configured in Windows
{:.figure}
{:.lead}

However, when using clients in Thailand which have the ```th-TH``` locale configured, the output states that the CurrentCulture is ```en-US```, there is a fallback in place somehow.

<!--more-->

You see, the script itself should supplement and application which does handle the ```th-TH``` locale correctly and using the Buddhist calendar.
So, while the application correctly uses and calculates with the year 2561 (Buddhist calendar), the PowerShell script would assume its 2018 (Gregorian calendar).

After several approaches which didn't help, I came to conclusion that I have to tell PowerShell to use the correct culture locale.
Luckily, when I started using PowerShell I saved a lot of snippets which helped me at this point. One of the functions was called ```Using-Culture```. For reference, I fetched the function from the [PowerShell team blog](https://blogs.msdn.microsoft.com/powershell/2006/04/25/using-culture-culture-culture-script-scriptblock/) - which was written by Jeffrey Snover himself :)
Dating back to the year 2006, the function is already more than 10 years old, but still valid and working.

~~~ powershell
Function Using-Culture (
[System.Globalization.CultureInfo]$culture = (throw “USAGE: Using-Culture -Culture culture -Script {scriptblock}”),
[ScriptBlock]$script= (throw “USAGE: Using-Culture -Culture culture -Script {scriptblock}”))
{
    $OldCulture = [System.Threading.Thread]::CurrentThread.CurrentCulture
    trap
    {
        [System.Threading.Thread]::CurrentThread.CurrentCulture = $OldCulture
    }
    [System.Threading.Thread]::CurrentThread.CurrentCulture = $culture
    Invoke-Command $script
    [System.Threading.Thread]::CurrentThread.CurrentCulture = $OldCulture
}
~~~

I'm no friend of hardcoding things, so what locale should I pass to the function? Obviously, PowerShell doesn't know that the culture it uses is not the expected one. Also I didn't find anything accessible via WMI, only LCID and the likes.
Finally, I decided to use information stored in registry, below is a screenshot showing the corresponding value in registry:

![caption](/assets/img/posts/thai-culture-registry.png)
Thai locale stored in registry
{:.figure}
{:.lead}

Asking the registry from PowerShell is pretty easy and straightforward. However, me being me I took the safe route and didn't assume anything. Also it's possible the script is being run from System or another service in Windows, so I try to get the configured locale from various user profiles, and using the clients system locale as fall back.

~~~ powershell
# there's no out-of-box PSDrive for HKU, we need to manually define the constant and create the PSDrive before using it
New-Variable HKU 2147483651 -opt Constant -ErrorAction SilentlyContinue
New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS -ErrorAction SilentlyContinue | Out-Null

$userName   = (Get-WmiObject Win32_ComputerSystem).UserName
$userSid    = (Get-WmiObject -q "Select * From Win32_Account Where Domain = '$($UserName.Split('\')[0])' And Name = '$($UserName.Split('\')[1])'").SID

if (($UserLocale = (gp "HKU:\$userSid\Control Panel\International").LocaleName) -eq $null) {
    if (($UserLocale = (gp "HKU:\S-1-5-20\Control Panel\International").LocaleName) -eq $null) {
        if (($UserLocale = (gp "HKU:\S-1-5-19\Control Panel\International").LocaleName) -eq $null) {
            if (($UserLocale = (gp "HKU:\S-1-5-18\Control Panel\International").LocaleName) -eq $null) {
                if (($UserLocale = (gp "HKU:\.DEFAULT\Control Panel\International").LocaleName) -eq $null) {
                    $UserLocale = (dism.exe /English /Online /Get-Intl |? { $_ -like 'System locale*' }).Split(':')[1].Trim()
                }
            }
        }
    }
}
~~~

Going forward, I can now use the function from above and tell PowerShell to use the correct culture:

~~~ powershell
$Message = "Hello World!"
((Using-Culture $UserLocale { [DateTime]::Now.ToString('yyyy-MM-dd HH:mm:ss') }) + ' ' + $Message)
~~~

(assuming the ```$UserLocale``` is set to ```th-TH```)
~~~ plain
2561-12-05 20:49:15 Hello World!
~~~

This is the first time I've stumpled across this and I'm not sure why PowerShell doesn't use Thai culture directly.
If you have any clues, drop them in the comments. Also if you have further questions or if you find this article interesting, please let me know.

All the best,<br/>Stefan
