# macos

macOS scripts and tools. This repo is public so managed Macs can fetch files from it without credentials. Don't put anything client-specific or secret here.

## Contents

| Path | What it is |
| --- | --- |
| `dockutil.sh` | Configures users' Docks with [dockutil](https://github.com/kcrawford/dockutil). |
| `opencompanyportal.sh` | Opens Company Portal. |
| `BT_logo_T_600.png`, `BT_logo_icon190x190.png` | Black Text logo. |
| `icons/` | App logos for the Installomator Intune apps, one `<label>.png` per app. |

## Files that live scripts depend on

The Installomator Intune preinstall scripts (bt-utils, `intune/applications/installomator/`) fetch these at install time to show the progress dialog:

- `BT_logo_icon190x190.png` is the Black Text badge on every app's dialog.
- `icons/<label>.png` is each app's logo, named after its Installomator label.

Renaming, moving or deleting any of them breaks the dialog on client Macs. The installs still work, but the pop-up falls back to generic icons. Intune holds its own copy of each script, so changing a path here means rebuilding and re-pasting every affected preinstall.

To add an app logo, save it as a 512 px PNG named after the label, e.g. `icons/lucidlink3.png`. The same file is uploaded as the app's logo in Intune.
