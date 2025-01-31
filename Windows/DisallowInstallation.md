# Prevent Windows user from installing

## Use Group Policy

### Restrict Software Installations
1. Open the Group Policy Editor by typing `gpedit.msc` in the Run dialog (Win + R).
2. Navigate to `User Configuration -> Administrative Templates -> Windows Components -> Windows Installer`.
3. Enable the policy "Disable Windows Installer" and set it to "Always".

### Prevent Access to Control Panel
1. In Group Policy Editor, go to `User Configuration -> Administrative Templates -> Control Panel`.
2. Enable the policy "Prohibit access to Control Panel and PC settings".

### Prevent Software from Running
1. Go to `User Configuration -> Administrative Templates -> System`.
2. Enable the policy "Don't run specified Windows applications" and add installer files like `setup.exe` and `install.exe`.

## Use Local Security Policy
1. Open Local Security Policy by typing `secpol.msc` in the Run dialog.
2. Navigate to `Software Restriction Policies`.
3. Right-click and create new policies if none exist.
4. Under Additional Rules, create a new rule to disallow software installation from specific paths.

## Modify User Account Control (UAC) Settings
1. Go to Control Panel and open User Accounts.
2. Click on Change User Account Control settings.
3. Move the slider to the highest level to always notify and prevent users from installing software without administrator approval.

## Use Standard User Accounts
1. Ensure that users operate on standard user accounts without administrative privileges.
2. Go to `Control Panel -> User Accounts -> Manage another account`.
3. Select the user account and change the account type to Standard User.

## Use Software Restriction Policies/AppLocker
1. In the Group Policy Editor, navigate to `Computer Configuration -> Windows Settings -> Security Settings -> Software Restriction Policies`.
2. Define new software restriction policies to disallow installations.
3. Alternatively, for Windows 10 Enterprise and Education editions, use AppLocker under [code ...
