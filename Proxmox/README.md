# Proxmox Guides and Tweaks

## GUI

### Create user

Datacenter > Users > Add

> **Notes**
>
> If you use `Linux PAM Standard Authentication` remember to create the user on the host machine using `adduser` in the host machine's shell. Since this method uses the underlying Linux host as the Authentication service.
>
> You might want to add yourself to the group named `admin` for full access to the system.

### Access the Shell

The hostname (usually below `Datacenter`) > Shell

### Upgrading Proxmox

Login as `root` > The hostname (usually below `Datacenter`) > Updates > Refresh > Upgrade

> **Notes**
>
> Keep the pop-up window open until the process is finished to reduce the chance of curruption

### Adding Custom SSL Certs

The hostname (usually below `Datacenter`) > System > Certificates > Upload Custom Certificate

### Notes

Proxmox has built in notes feature inside its GUI. It also supports `Markdown`.

The hostname (usually below `Datacenter`) > Notes

Usually I follow my own rules for providing the VM / CT ID

```text
# Proxmox Rules

## VM / CT Numbering

| PVE VM / CT ID | Usage |
|:------:|-------|
| 10xx | Template |
| 20xx | Routers |
| 21xx | DNS |
| 30xx | Reverse Proxy |
| 40xx | Testing VM App |
| 50xx | Testing CT App |
| 60xx | Production VM App |
| 70xx | Production CT App |

## OSI Layer Reference

| OSI Layer Number | OSI Layer Name |
|:----------------:|----------------|
| 1 | Physical Layer |
| 2 | Data Link Layer |
| 3 | Network Layer |
| 4 | Transport Layer |
| 5 | Session Layer |
| 6 | Presentation Layer |
| 7 | Application Layer |
```

## CLI

### Upgrade Proxmox

To upgrade `Proxmox`, you must use the command `apt dist-upgrade` in the shell.

> **Notes**
>
> NEVER DO `apt upgrade`

### Connect / Mount Directory from Host to Container

```bash
pct set <container_id> -mp<mount_number> </path/to/directory>,mp=</path/to/directory/in/container>[,ro=1]
```
