CurrentUser=$(/usr/sbin/scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ { print $3 }')
sudo -u $CurrentUser /usr/bin/open "/Applications/Company Portal.app"
