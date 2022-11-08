# Linux OS, Common Commands, Tweaks, and More

## Linux OS

|Distributions|Package Manager|Where I use it?|
|-------------|:-------------:|---------------|
|[Ubuntu Server 18.04](https://releases.ubuntu.com/18.04.6/)|apt|My preferred Linux OS for Servers|
|[Raspbian Buster Lite](https://www.raspberrypi.com/software/operating-systems/)|apt|My preferred Linux OS for Raspberry Pi|
|[Raspbian Bullseye](https://www.raspberrypi.com/software/operating-systems/)|apt|Alternate Linux OS for Raspberry Pi. Not my preferred Linux OS due to compatibility issue with some of my software due to default Python version change from Python2 to Python3|
|[Arch Linux](https://archlinux.org/download/)|pacman|Used in my Homelab|
|[ArcoLinux](https://www.arcolinux.info/downloads/)|pacman|Arch Linux but Desktop ready|
|[Garuda Linux](https://garudalinux.org/downloads.html)|pacman|Arch Linux but Desktop ready|
|[Alpine Linux](https://www.alpinelinux.org/downloads/)|apk|Light Weight Linux|
|[finnix](https://www.finnix.org/)|apt|Live Boot Linux|

## Common Commands

1. Basic Commands

    1. `ls`
    2. `cd`
    3. `mkdir`
    4. `touch`
    5. `history`
    6. `pwd`
    7. `pushd`
    8. `popd`
    9. `!!`
    10. `sudo`
    11. `chmod`
    12. `chown`

2. Networking

    1. `ifconfig`
    2. `iptables`
    3. `ip`
    4. `route`
    5. `rfkill`
    6. `iw`
    7. `iwctl`
    8. `netplan`

3. File System / Storage

    1. `lsblk`
    2. `df`
    3. `fdisk`
    4. `parted`
    5. `mkisofs`
    6. `mount`

         Mount disk / drive / image

        1. Standard

            ```bash
            mount <path/to/disk> <path/to/directory>
            ```

            > Note
            >
            > `path/to/disk` can be found from `lsblk` command and usually starts with `/dev/`

        2. NFS

            ```bash
            mount -t nfs <NFS Server IP>:/<nfs directory> <path/to/directory>
            ```

            > Note
            >
            > Must have `nfs-utils` installed

        3. NTFS

            ```bash
            mount -t ntfs3 <path/to/file_system> <path/to/directory>
            ```

        4. ISO

            1. Check ISO

                ```bash
                file <path/to/file.iso>
                ```

                > Note
                >
                > If output contains the word `boot sector`, proceed to step 2, else continue to step 3

            2. Find boot sector [skip this step if your output on step 1 does not contain the word `boot sector`]

                ```bash
                fdisk <path/to/file.iso>
                ```

                And press `p` to print the ISO partition information.

                > Note
                >
                > Note the value under `Start` and multiply it by 512. This value will be used as offset on the next step

            3. Mount ISO

                ```bash
                mount -o loop[,offset=<offsetvalue>] -t iso9660 <path/to/file.sio> <path/to/directory>
                ```

                > Note
                >
                > Anything inside `[` and `]` is optional, as it is only needed if the ISO file has `boot sector`

4. System Administration

    1. `ssh`

        Connect to other server and get shell access

        ```bash
        ssh [-p <port_number>] [-i </path/to/certificate/file>] <username>@<server_ip>
        ```

    2. `ssh-keygen`

        Generate ssh key

        ```bash
        ssh-keygen [-C <comment>] [-t ed25519 -b 512] [-t rsa -b 4096]
        ```

    3. `ssh-copy-id`

        Copy public key to another server

        ```bash
        ssh-copy-id -i </path/to/file.pub> [-p <ssh_port>] <user>@<server_ip>
        ```

5. Convenience

    1. `ssh-agent` - automatic ssh password input

        ```bash
        eval $(ssh-agent)
        ssh-add
        ```

    2. `sshpass` - better use `ssh-agent`

        Passing password to ssh

        ```bash
        sshpass -p <password> ssh <username>@<server_ip> [-p <port_number>]
        ```
