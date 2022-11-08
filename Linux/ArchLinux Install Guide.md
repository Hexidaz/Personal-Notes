# Personal Arch Install Guide

This is my guide to install ***Arch Linux*** on a new system. It is recommended to read the [`Arch Wiki`][Arch Wiki] instead as it covers much more then what this guide offers! This guide will cover the installation of  `Arch Linux` with `GRUB` as the bootloader in a clean `UEFI` system.

## Pre-Installation

Preparation:

1. Get the [Arch Linux Live Boot Image / ISO][Download Arch ISO]
2. Verify the image's signature and checksums
3. Prepare an installation media ( **2GB USB Flash Drive** is the minimum recommended )
4. Boot the live environment ( make sure to disable `Secure Boot` )

> **Note**
>
> Read the [Arch Wiki][Arch Wiki] when there is any trouble encountered !

## Set Keyboard Layout

Default console keymap is US. Available layouts can be listed with:

```bash
ls /usr/share/kbd/keymaps/**/*.map.gz
```

To modify the layout, append a corresponding file name to loadkeys, omitting path and file extension. For example, to set a US keyboard layout:

```text
loadkeys us
```

## Verify Boot Mode

If `UEFI` is enabled on an UEFI motherboard, Archiso will boot Arch Linux accordingly via systemd-boot. To verify this, list the efivars directory:  

```bash
ls /sys/firmware/efi/efivars
```

If the command shows the directory without error, then the system is booted in **UEFI** mode. If the directory does not exist, the system may be booted in **BIOS** (or **CSM**) mode.

## Connect to Internet

Intallation of Arch Linux require internet access. This is used to download the packages needed for the minimal install of Arch Linux. Find the name of our interfaces using:

```bash
ip link
```

You should see something like this:

```text
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
  link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: enp0s0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc fq_codel state DOWN mode DEFAULT group default qlen 1000
  link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff
3: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DORMANT group default qlen 1000
  link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff permaddr 00:00:00:00:00:00
```

+ `lo` - is the loopback interface or usually used for `localhost`
+ `enp0s0` - wired interface or LAN interface usually starts with `enp` or `eth`
+ `wlan0` - wireless interface or WiFi interface usually starts with `wlan`

### Unblock Interfaces (if blocked / internet not working)

Some interface maybe software blocked or disabled. Show the state of each interface using:

```bash
rfkill list
```

You should see the interface name and the state of the interface. If any of the interface you need to use were blocked then:

```bash
rfkill unblock <interface id>
```

### Connect Internet - Wired Connection (LAN Cable)

If you are on a wired connection, you can enable dhcp on your wired interface by using

```bash
systemctl start dhcpcd@<interface name>
```

For example:

```bash
systemctl start dhcpcd@enp0s0
```

### Connect Internet - Wireless Connection

If you are on a device with wireless interface, you can connect to a wireless access point using `iwctl` command from `iwd`. Note that it's already enabled by default.  

Get to iwd:

```bash
iwctl
```

Scan for network.

```bash
[iwd] station wlan0 scan
```

Get the list of scanned networks by:

```bash
[iwd] station wlan0 get-networks
```

Connect to your network.

```bash
[iwd] station wlan0 connect <NETWORK NAME>
```

> If your network requires password, it will automatically prompt you for the password.

Exit `iwd` using `CTRL + D`.  

Ping archlinux website to make sure we are online:

```bash
ping archlinux.org
```

If you receive Unknown host or Destination host unreachable response, means you are not yet online. Make sure your network has internet access and redo the steps above.

## Update the system clock

Use `timedatectl` to ensure the system clock is accurate:

```bash
timedatectl set-ntp true
```

To check the service status, use `timedatectl status`.

## Disk Partition and Layout

When recognized by the (live) system, disks are assigned to a block device such as `/dev/sda`, `/dev/nvme0n1` or `/dev/mmcblk0`. To identify these devices, use `lsblk` or `fdisk`.  The most common main drive is **/dev/sda**.

List all disk using:

```bash
lsblk
```

> **Note:**
>
> Linux requires `boot` or `/boot` and `root` or `/` partition. But other partition like `swap` and `home` or `/home` partition is recommended. *This guide will not cover the `swap` and `home` partition. As I usually use `swapfile` for `swap` and no custom home parition.*

### Partition the disk

Use `cfdisk` to partition the disk: 

```bash
cfdisk /dev/sda
```

This command will show a simple GUI looks like windows `diskmanagement`.

> **Note:**  
>
> If this drive is a new drive, it will ask for `partition tables`. Its recommended to use `gpt`.  

**Recommended:**
|Partition Name|Recommended Size|Mount Point|File Format|Partition Type|
|:-------------|:--------------:|:----------|:----------|:-------------|
|EFI           |1GB             |/mnt/boot  |FAT32      |EFI System Partition|
|root          |>20GB           |/mnt       |ext4       |Linux root(/) |

1. Create `EFI` partition
    1. Select any free partition
    2. Select `[New]`
    3. Press <kbd>Enter</kbd>
    4. Type your partition size (e.g 1G)
    5. Press <kbd>Enter</kbd>
    6. Select partition thet is just created
    7. Select `[Type]`
    8. Press <kbd>Enter</kbd>
    9. Select `EFI System`

2. Create `root` partition
    1. Select any free partition
    2. Select `[New]`
    3. Press <kbd>Enter</kbd>
    4. Type your partition size (e.g 50G)
    5. Press <kbd>Enter</kbd>

3. Select `[Write]` option and press <kbd>Enter</kbd>

## Verify the Partition

Check the partition that has been created.

```bash
lsblk
```

It should show something like this.

| NAME | MAJ:MIN | RM | SIZE | RO | TYPE | MOUNTPOINT |
| ---  | ---     | --- | --- | --- | --- | ---        |
| sda  | 8:0     | 0   | 50G | 0  |      |            |
| sda1 | 8:1     | 0   | 1G  | 0  | part |            |
| sda2 | 8:2     | 0   | 49G | 0  | part |            |

**`sda`** is the main disk
**`sda1`** is the efi partition
**`sda2`** is the root partition

## Format the Partition

Format the partition to the intended filesystem as mentioned [here](#partition-the-disk).

1. EFI partition must be in `FAT32`

    ```bash
    mkfs.fat -F32 /dev/sda1
    ```

2. root partition is recommended to be in `ext4` (default linux filesystem)

    ```bash
    mkfs.ext4 /dev/sda2
    ```

## Mount the Partition

1. Mount root partition

    ```bash
    mount /dev/sda2 /mnt
    ```

2. Mount efi partition

    ```bash
    mkdir /mnt/boot
    mount /dev/sda1 /mnt/boot
    ```

## Install Arch Linux

Install `base`, `linux`, `linux-firmware`, and `base-devel` packages into the system for the minmal install of Arch Linux.

```bash
pacstrap /mnt base base-devel linux linux-firmware
```

The `base` package does not include all tools from the live installation, so installing other packages may be necessary for a fully functional base system. In particular, consider installing:

+ userspace utilities for the management of file systems that will be used on the system,
    + **`unrar`**: The RAR uncompression program
    + **`unzip`**: For extracting and viewing files in `.zip` archives
    + **`p7zip`**: 7Zip Command-line file archiver with high compression ratio
    + `unarchiver`: `unar` and `lsar`: Objective-C tools for uncompressing archive files
    + `gvfs-mtp`: Virtual filesystem implementation for `GIO` (`MTP` backend; Android, media player)
    + `libmtp`: Library implementation of the Media Transfer Protocol
    + `android-udev`: Udev rules to connect Android devices to your linux box
    + `mtpfs`: A FUSE filesystem that supports reading and writing from any MTP device
    + `xdg-user-dirs`: Manage user directories like `~/Desktop` and `~/Music`
    + `ntfs-3g`: NTFS filesystem driver and utilities

+ specific firmware for other devices not included in `linux-firmware`,

+ software necessary for networking,
    + **`dhcpcd`**: RFC2131 compliant DHCP client daemon
    + **`iwd`**: Internet Wireless Daemon
    + **`inetutils`**: A collection of common network programs
    + **`iputils`**: Network monitoring tools, including `ping`

+ a text editor(s),
    + **`nano`**
    + **`vim`**
    + `vi`

+ packages for accessing documentation in man and info pages,
    + **`man-db`**
    + **`man-pages`**

+ and more useful tools:
    + **`git`**: the fast distributed version control system
    + **`less`**: A terminal based program for viewing text files
    + **`bash-completion`**: Programmable completion for the bash shell
    + `zsh`: Bash alternative
    + `usbutils`: USB Device Utilities
    + `tmux`: A terminal multiplexer

> **Notes**
>
> Packages in **bold** are recommened packages.

## Generate fstab

`fstab` is the file that lets the system know what disk to mount on boot to boot your system. Create `fstab` using:

```bash
genfstab -U /mnt >> /mnt/etc/fstab
```

Check the resulting `/mnt/etc/fstab` file, and edit it in case of errors.

## Arch-Chroot

Move to the installed system. *I believe `chroot` stands for `change root`?*

```bash
arch-chroot /mnt
```

## Time Zone

Timezones can be found under `/usr/share/zoneinfo/`. Since I am in  Indonesia, I will be using `/usr/share/zoneinfo/Asia/Jakarta`. Select the appropriate timezone for your country:

```bash
ln -sf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
```

Run hwclock to generate `/etc/adjtime`:

```bash
hwclock --systohc
```

> This command assumes the hardware clock is set to UTC.

## Localization

The `locale` defines which language the system uses, and other regional considerations such as currency denomination, numerology, and character sets. Possible values are listed in `/etc/locale.gen`. Uncomment `en_US.UTF-8`, as well as other needed localisations.

Uncomment `en_US.UTF-8 UTF-8` and other needed locales in `/etc/locale.gen`, save, and generate them with:

```bash
locale-gen
```

Create the `locale.conf` file, and set the LANG variable accordingly:

```bash
locale > /etc/locale.conf
```

If you set the keyboard layout earlier, make the changes persistent in `vconsole.conf`:

```bash
echo "KEYMAP=us" > /etc/vconsole.conf
```

## Network Configuration

Create the hostname file. This guide will use `ArchLinux` as hostname (aka `device name` in windows, this will be the one shown on your router).

```bash
echo "ArchLinux" > /etc/hostname
```

Open `/etc/hosts` to add matching entries to `hosts`:

```text
127.0.0.1    localhost  
::1          localhost  
127.0.1.1    ArchLinux.localdomain   ArchLinux
```

If the system has a permanent IP address, it should be used instead of `127.0.1.1`.

## Initramfs

Creating a new initramfs is usually not required, because mkinitcpio was run on installation of the kernel package with pacstrap.

```bash
mkinitcpio -p linux
```

## Add Repositories - `multilib` (optional - as enabling this allows pacman to downlaod 32bit application)

Enable multilib in `/etc/pacman.conf`. Open it with your text editor of choice:

### Add `multilib` Repository

Uncomment `multilib` (remove `#` from the beginning of the lines). It should look like this:

```conf
[multilib]
Include = /etc/pacman.d/mirrorlist
```

### Colorful `pacman` (package manager) and Bonus Easter Eggs

You can enable the *"easter-eggs"* in `pacman`, the package manager of Arch Linux.  

1. Open `/etc/pacman.conf`
2. Find `# Misc options`.
3. Uncomment `Color`, to add colors to `pacman`.
4. Uncommnet `ParallelDownloads = 5`, to allow download several package in parallel.
5. Add `ILoveCandy` under the `Color` string, to enable the *"easter-egg"* (actually shows Pac-Man on the download progress bar instead of `==>`)

It should look like this:

```conf
# Misc options
#UseSyslog
Color
ILoveCandy
#NoProgressBar
CheckSpace
#VerbosePkgLists
ParallelDownloads = 5
```

### Update Repositories and Packages

To check for update and check if you have successfully enabled the *"easter-egg"*, run:

```bash
pacman -Syu
```

If updating returns an error, open the `/etc/pacman.conf` again and check for any errors.

> **Note**
>
> If updating returns error that says something about unknown trust, run these:
>
> ```bash
> pacman-key --init
> pacman-key --populate archlinux
> pacman-key --refresh-keys
> pacman -S archlinux-keyring
> ```

## Set Root Password (Optional)

Set the root password:

```bash
passwd
```

## Add a User Account (Optional)

Add a new user account. In this guide, I'll use `ArchUser` as the username of the new user.  

```bash
useradd -m -g users -G wheel,storage,power,video,audio,rfkill,input -s /bin/bash ArchUser
```

This will create a new user and its `home` folder with `sudo` previleges.

Set the password of the new user named `ArchUser`:

```bash
passwd ArchUser
```

## Add the New User to `sudoers`

If you want a root privilege in the future by using the `sudo` command, you should grant one yourself:

```bash
EDITOR=vim visudo
```

Uncomment the line (Remove #) so it looks like this:

```conf
%wheel ALL=(ALL) ALL
```

## Auto Enable Internet Connection

To enable the network daemons on your next reboot, you need to enable `dhcpcd.service` for wired connection and `iwd.service` for a wireless one.

```bash
systemctl enable dhcpcd iwd
```

## Install the boot loader

### GRUB

Install GRUB installer and its dependencies

```bash
pacman -S grub efibootmgr dosfstools os-prober mtools
```

Install GRUB

```bash
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB_EUFI --recheck
```

Initiate default GRUB configuration

```bash
grub-mkconfig -o /boot/grub/grub.cfg
```

## Exit `chroot` and Reboot  

Exit the chroot environment by typing `exit` or pressing <kbd>Ctrl + d</kbd>. You can also unmount all mounted partition after this.

Finally, type `reboot` to reboot your system.

[Arch Wiki]: https://wiki.archlinux.org/
[Download Arch ISO]: https://archlinux.org/download/
