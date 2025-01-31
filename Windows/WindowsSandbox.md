# Windows Sandbox

## Config file (.wsb)
```wsb
<Configuration>
  <VGpu>Disable</VGpu>
  <Networking>Disable</Networking>
  <MappedFolders>
    <MappedFolder>
      <HostFolder>C:\Users\Public\Downloads</HostFolder>
      <SandboxFolder>C:\Users\WDAGUtilityAccount\Desktop</SandboxFolder>
      <ReadOnly>true</ReadOnly>
    </MappedFolder>
  </MappedFolders>
  <LogonCommand>
    <Command>explorer.exe C:\users\WDAGUtilityAccount\Downloads</Command>
  </LogonCommand>
</Configuration>
```

## Preinstall / Persistent Apps (actually installs on every start)

> Based on https://hasan-hasanov.com/post/2020/11/25/scoopbox/

1. Create scritp to install apps on boot
```ps1
# Download and install Scoop Package manager
# Note: This will not work if you disable the network access from
# Windows Sandbox configuration file.
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')

# Scoop package manager requires git to be able to install most software.
scoop install git

# Add extra buckets so we have more software to choose from.
scoop bucket add extras
scoop bucket add nerd-fonts
scoop bucket add nirsoft
scoop bucket add java
scoop bucket add jetbrains
scoop bucket add nonportable
scoop bucket add php

# Install Fiddler and Curl
scoop install fiddler, curl
```

2. Create .wsb file and start it from here
```wsb
<Configuration>
  <VGpu>Disabled</VGpu>
  <Networking>Default</Networking>
  <MappedFolders>
    <MappedFolder>
      <HostFolder>C:\Users\YOUR_USERNAME\Desktop\Scripts</HostFolder>
      <SandboxFolder>C:\Users\WDAGUtilityAccount\Desktop\Sandbox\</SandboxFolder>
      <ReadOnly>true</ReadOnly>
    </MappedFolder>
  </MappedFolders>
  <LogonCommand>
    <Command>powershell.exe -ExecutionPolicy Bypass -File C:\Users\WDAGUtilityAccount\Desktop\Sandbox\MainScript.ps1</Command>
  </LogonCommand>
  <AudioInput>Default</AudioInput>
  <VideoInput>Default</VideoInput>
  <ProtectedClient>Default</ProtectedClient>
  <PrinterRedirection>Default</PrinterRedirection>
  <ClipboardRedirection>Default</ClipboardRedirection>
  <MemoryInMB>0</MemoryInMB>
</Configuration>
```
