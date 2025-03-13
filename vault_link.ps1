$host.ui.rawui.foregroundcolor = 'gray'
$host.ui.rawui.backgroundcolor = 'black'
clear-host
write-host @"
 __   __  _______  __   __  ___      _______        ___      ___   __    _  ___   _ 
|  | |  ||   _   ||  | |  ||   |    |       |      |   |    |   | |  |  | ||   | | |
|  |_|  ||  |_|  ||  | |  ||   |    |_     _|      |   |    |   | |   |_| ||   |_| |
|       ||       ||  |_|  ||   |      |   |        |   |    |   | |       ||      _|
|       ||       ||       ||   |___   |   |   ___  |   |___ |   | |  _    ||     |_ 
 |     | |   _   ||       ||       |  |   |  |   | |       ||   | | | |   ||    _  |
  |___|  |__| |__||_______||_______|  |___|  |___| |_______||___| |_|  |__||___| |_|

credits to tksh164 aumid stopgap tools (i made this script for the noobs :p)
		(create separate vault links!! they even separate in the taskbar :o)
"@
write-host "`n    enter to continue..." -foregroundcolor red -nonewline
read-host
clear-host

$exedir = $PWD.Path
if (-not (test-path "$exedir\mklnkwaumid.exe" -pathtype leaf) -or 
    -not (test-path "$exedir\runwaumid.exe" -pathtype leaf)) {
    do {
        $exedir = read-host "enter directory containing mklnkwaumid.exe and runwaumid.exe"
        $exedir = $exedir.Trim('"')
    } until ((test-path "$exedir\mklnkwaumid.exe" -pathtype leaf) -and 
            (test-path "$exedir\runwaumid.exe" -pathtype leaf))
}

write-host "`n====== [vault info] ======" 
write-host "enter the name of your obsidian vault `n" -foregroundcolor darkgray
$vaultname = read-host "vault name"
clear-host
write-host "`n====== [vault info] ======" -foregroundcolor gray
write-host "enter your obsidian vault id`n(right click to enter copied data in the terminal)`n" -foregroundcolor darkgray
$vaultid = read-host "vault id"
clear-host

$lnkdir = join-path $exedir -childpath "links"

if (!(test-path -path $lnkdir -pathtype container)) {
    new-item -itemtype Directory -path $lnkdir
    write-host "links folder created successfully.." -foregroundcolor green
} else {
    write-host "found links folder.." -foregroundcolor darkgray
}

$lnkpath = join-path $lnkdir "$vaultname.lnk"
$appid = "Tksh164.Obsidian.$vaultname"
$runwaumidpath = join-path $exedir "runwaumid.exe"
$arguments = "-tp Tksh164.Obsidian.$vaultname \`"$vaultname - Obsidian\`" obsidian://open?vault=$vaultID"

try {
    & "$exedir\mklnkwaumid.exe" $lnkpath $appid $runwaumidpath $arguments
    write-host "shortcut created!" -foregroundcolor green
}
catch {
    write-host "error creating shortcut: $_`n" -foregroundcolor red
}

write-host "`nwould you like to change the icon?`n"
write-host "	to be able to customize the shortcut icon,`n	remember to add .ico files to a folder in this directory called /icons/`n" -foregroundcolor darkgray
$changeicon = read-host "[y/n]"
clear-host

if ($changeicon -eq 'y') {
    try {
        $iconsdir = join-path $exedir "icons"
        if (-not (test-path $iconsdir -pathtype container)) {
            throw "icons directory not found"
        }

        write-host "`navailable icons:`n"
        get-childitem "$iconsdir\*.ico" | foreach-object { write-host " - $($_.basename)" -foregroundcolor darkgray }

        $iconname = read-host "`nchoosen icon"
        $iconpath = join-path $iconsdir "$iconname.ico"
        
        if (-not (test-path $iconpath)) {
            throw "icon file not found: $iconpath"
        }

        $shell = new-object -comobject wscript.shell
        $shortcut = $shell.createshortcut((join-path $lnkdir "$vaultname.lnk"))
        $shortcut.iconlocation = $iconpath
        $shortcut.save()

	clear-host
        write-host "`nicon updated successfully!" -foregroundcolor green
    }
    catch {
        write-host "`nerror: failed to change icon - $_`n" -foregroundcolor red
    }
}

write-host "create new link? [y/n]" -foregroundcolor darkgray -nonewline
$newlnk = read-host
if ($newlnk -eq 'y') { 
    start-process powershell -argumentlist "-noprofile -executionpolicy bypass -file `"$PSCommandPath`""
}
exit
