# Ubuntu specific guide

## Application Shortcut File Location

```bash
cd /usr/share/applications
```

## Create Desktop Application Shortcut [GUI App]

1. Create a file named: <shortcut_name>.desktop
2. Copy the content below to the file created in step 1

    ```text
    [Desktop Entry]
    Name[de]=Virtuelle Maschinenverwaltung
    Name[en_GB]=Virtual Machine Manager
    Name=Virtual Machine Manager
    Comment[de]=Virtuelle Maschinen verwalten
    Comment[en_GB]=Manage virtual machines
    Comment=Manage virtual machines
    Icon=virt-manager
    Exec=virt-manager
    Type=Application
    Terminal=false
    Keywords[uk]=vmm;
    Keywords=vmm;
    Categories=System;
    ```

    > **Note:**
    >
    > Change all the value as needed to your application

3. Allow execute permission
4. Right Click the shortcut > 'Allow launching'

## Create Desktop Application Shortcut ( Run as Admin ) [GUI App]

1. Create a file named: <shortcut_name>.desktop
2. Copy the content below to the file created in step 1

    ```text
    [Desktop Entry]
    Name[de]=Virtuelle Maschinenverwaltung
    Name[en_GB]=Virtual Machine Manager
    Name=Virtual Machine Manager
    Comment[de]=Virtuelle Maschinen verwalten
    Comment[en_GB]=Manage virtual machines
    Comment=Manage virtual machines
    Icon=virt-manager
    Exec=pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY virt-manager
    Type=Application
    Terminal=false
    Keywords[uk]=vmm;
    Keywords=vmm;
    Categories=System;
    ```

    > **Note:**
    >
    > Change all the value as needed to your application

3. Allow execute permission
4. Right Click the shortcut > 'Allow launching'
