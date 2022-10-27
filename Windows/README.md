# Windows Software, Tweaks, and More

## Software

|Product|Usage|
|-------|-----|
|[Power Toys](https://github.com/microsoft/PowerToys)|Has many tools that helps `Power Users`|
|[Core Temp](https://www.alcpu.com/CoreTemp/)|CPU Temperature Monitoring|
|[CPUZ](https://www.cpuid.com/softwares/cpu-z.html)|Shows your PC / Laptop specs|
|[Macrium Reflect](https://www.macrium.com/reflectfree)|Disk Cloning and Backups|
|[7zip](https://www.7-zip.org/)|File archiving utility|
|[Windows Terminal](https://apps.microsoft.com/store/detail/windows-terminal/9N0DX20HK701?hl=en-us&gl=us)|Modern terminal app|
|[Sublime Text](https://www.sublimetext.com/)|Hackable Text / Code Editor|
|[VSCode](https://code.visualstudio.com/)|Hackable Text / Code Editor|
|[VSCodium](https://vscodium.com/)|VSCode but with telemetry removed|
|[WSL2](./WSL2.md)|Allows you to run full Linux on Windows|
|[Scoop](https://scoop.sh/)|Unofficial Package Manager for Windows, but it installs aplication in user space|
|[Chocolatey](https://chocolatey.org/)|Unofficial Package Manager for Windows|

## TWEAKS

### REGEDIT

|Product|Key Location|Key Name|Type|Base|Value|Usage|
|-------|------------|--------|----|----|-----|-----|
|Synaptic Touchpad|HKEY_CURRENT_USER\SOFTWARE\Synaptics\SynTP\TouchpadPS2TM2848|2FingerTapAction|DWORD|HEX|2|Tap 2 Finger as Right Click|
|Synaptic Touchpad|HKEY_CURRENT_USER\SOFTWARE\Synaptics\SynTP\TouchpadPS2TM2848|EdgeMotion|DWORD|HEX|1|Enable Edge Motion While Dragging Something|
|Synaptic Touchpad|HKEY_CURRENT_USER\SOFTWARE\Synaptics\SynTP\TouchpadPS2TM2848|MomentumMotion|DWORD|HEX|1|Enable Flicking Motion|
|Synaptic Touchpad|HKEY_CURRENT_USER\SOFTWARE\Synaptics\SynTP\TouchpadPS2TM2848|MomentumMotionFriction|DWORD|HEX|f|Flick Motion Friction (Lower value for less friction)|
