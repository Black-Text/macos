#!/bin/bash

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
# DESCRIPTION
# This script configures users docks using docktutil
# source dockutil https://github.com/kcrawford/dockutil/
# 
# REQUIREMENTS
# dockutil Version 3.0.0 or higher installed to /usr/local/bin/
# Compatible with macOS 11.x and higher
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

export PATH=/usr/bin:/bin:/usr/sbin:/sbin

# COLLECT IMPORTANT USER INFORMATION
# Get the currently logged in user
currentUser=$( echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ { print $3 }' )

# Get uid logged in user
uid=$(id -u "${currentUser}")

# Current User home folder - do it this way in case the folder isn't in /Users
userHome=$(dscl . -read /users/${currentUser} NFSHomeDirectory | cut -d " " -f 2)

# Path to plist
plist="${userHome}/Library/Preferences/com.apple.dock.plist"

# Convenience function to run a command as the current user
# usage: runAsUser command arguments...
runAsUser() {  
	if [[ "${currentUser}" != "loginwindow" ]]; then
		launchctl asuser "$uid" sudo -u "${currentUser}" "$@"
	else
		echo "no user logged in"
		exit 1
	fi
}

# Check if dockutil is installed
if [[ -x "/usr/local/bin/dockutil" ]]; then
    dockutil="/usr/local/bin/dockutil"
else
    echo "dockutil not installed in /usr/local/bin, exiting"
    exit 1
fi

# Version dockutil
dockutilVersion=$(${dockutil} --version)
echo "Dockutil version = ${dockutilVersion}"

# Create a clean Dock
runAsUser "${dockutil}" --remove all --no-restart ${plist}
echo "clean-out the Dock"

# Full path to Applications to add to the Dock
apps=(
"/System/Applications/Launchpad.app"
"/Applications/Safari.app"
"/Applications/Google Chrome.app"
"/Applications/Microsoft Outlook.app"
"/Applications/Microsoft Teams.app"
"/System/Applications/System Settings.app"
)

# Loop through Apps and check if App is installed, If Installed at App to the Dock.
for app in "${apps[@]}"; 
do
	if [[ -e ${app} ]]; then
		runAsUser "${dockutil}" --add "$app" --no-restart ${plist};
	else
		echo "${app} not installed"
    fi
done

# Add Application Folder to the Dock
# runAsUser "${dockutil}" --add /Applications --view grid --display folder --sort name --no-restart ${plist}

# Add logged in users Downloads folder to the Dock
runAsUser "${dockutil}" --add ${userHome}/Downloads --view list --display stack --sort dateadded --no-restart ${plist}

# Disable show recent
# runAsUser defaults write com.apple.dock show-recents -bool FALSE
# echo "Hide show recent from the Dock"

# sleep 3

# Kill dock to use new settings
killall -KILL Dock
echo "Restarted the Dock"

echo "Finished creating default Dock"

exit 0
