#!/bin/sh

# 1  ================================================================================
echo "=========================================\n"
echo "\e[7m Installing necessary packages \e[0m...\n"
echo "=========================================\n"

echo "\e[5m \e[91m*You might need to enter the password \
for sudo operations*\e[39m \e[25m"


echo "\e[32m Firstly, updating all packages\e[0m...\n"
sudo apt-get update
echo "-----------------------------------------\n"

echo "\e[32m Installing "iw" command \e[0m...\n"
# iw command: configuring wireless devices
sudo apt-get install -y iw
echo "-----------------------------------------\n"

echo "\e[32m Installing RFKill \e[0m...\n"
# rfkill (if not already installed): to unblock wlan network whenever needed
sudo apt-get install -y rfkill
echo "-----------------------------------------\n"

echo "\e[32m Installing Airmon-ng \e[0m...\n"
# airmon-ng: monitoring mode and checking interfering network processes and killing network manager and other wireless connections ...
sudo apt-get install -y aircrack-ng
echo "-----------------------------------------\n"

echo "\e[32m Installing net-tools \e[0m...\n"
# net-tools (if not already installed): used t bring up tools like ifconfig
sudo apt-get install -y net-tools
echo "-------------------------------------------------------------\n"

echo "\e[32m Installing hostapd \e[0m...\n"
# net-tools (if not already installed): used t bring up tools like ifconfig
sudo apt-get install -y hostapd
echo "-------------------------------------------------------------\n"

sleep 1


#  2  ================================================================================
echo "=========================================\n"
echo "\e[7m Disabling unecessary services \e[0m...\n"
echo "=========================================\n"

echo "\e[31m Disabling Network Manager...\e[0m...\n"
# Stop the Network Manager
sudo systemctl stop NetworkManager
echo "Stopped Network Manager service"

# Disabling at the boot-up as well...
sudo systemctl disable NetworkManager-wait-online NetworkManager-dispatcher NetworkManager
echo "Disabled Network Manager service at the start-up"
echo "-----------------------------------------\n"

echo "\e[31m Disabling Avahi-Daemon...\e[0m...\n"
# Disable the socket
sudo systemctl disable avahi-daemon.socket
echo "Disabled the avahi-daemon socket" 

# Disable at start-up now
sudo systemctl disable avahi-daemon.service
echo "Disabled Avahi-Daemon service at the start-up"
echo "-----------------------------------------\n"

echo "\e[31m Disabling WPA Supplicant services...\e[0m...\n"
# Disable the socket
sudo systemctl disable wpa_supplicant
echo "Disabled the avahi-daemon socket" 
sleep 1

#  3  ================================================================================
echo "=========================================\n"
echo "\e[7m Configuring the hostapd \e[0m...\n"
echo "=========================================\n"


echo "\e[33m Creating a configuration file and adding the necessary code in it...\e[0m...\n"
# Creating the conf file for hostapd
sudo touch /etc/hostapd/hostapd.conf

# Adding the code to the .conf file
sudo cp hostapd_conf.txt /etc/hostapd/hostapd.conf
echo "wpa_supplicant.conf file edited and setup ready..."
echo "-----------------------------------------\n"

# Set the configuration file path for the hostapd in /etc/default/hostapd
# sed is a stream editor, where it used "s" to subtitute the commented default path for configuration with the above edited file
sudo sed -i 's|#DAEMON_CONF=""|DAEMON_CONF="/etc/hostapd/hostapd.conf"|' /etc/default/hostapd


#  4  ================================================================================
echo "=========================================\n"
echo "\e[7m Creating the netplan file for the networkd to manage the networks \e[0m...\n"
echo "=========================================\n"

echo "\e[36m Editing the netplan file to use networkd as renderer instead of NetworkManager. \e[0m...\n"
# --- Editing the configuration file for netplan under /etc/netplan/
# Ensure to check the interface names and change it as needed. To automate use /etc/udev/rules.d/70-persistent-net.rules to add the device and name it even before systemd-networkd creates a name and link
sudo cp netplan_yaml.txt /etc/netplan/01-network-manager-all.yaml
echo "\e[36m Generating the netplan and applying it \e[0m...\n"
sudo netplan generate && sudo netplan -d apply

echo "Netplan should be now applied. "
echo "-----------------------------------------\n"
echo "\e[36m Creating the network file for the systemd-networkd to use to assign static address to the adhoc and also assigning ip addresses to the clients connecting using DHCP Server\e[0m...\n"
sudo touch /etc/systemd/network/10-adhoc-wlan_x.network
sudo cp 10-wlan_x_network.txt /etc/systemd/network/10-adhoc-wlan_x.network
echo "Enabling systemd-networkd and starting for the changes ot take effect and create the necessary links by systemd-networkd. "
sudo systemctl enable systemd-networkd && sudo systemctl restart systemd-networkd


#  6  ================================================================================
echo "=========================================\n"
echo "\e[3m\e[42m  Initiating and Joining the connection  \e[0m...\n"
echo "=========================================\n"
echo "\e[92m Unmasking and enabling the hostapd services \e[0m...\n"
# --------- Connecting in the background              
sudo systemctl unmask hostapd
sudo systemctl enable hostapd
sudo systemctl daemon-reload
echo " \e[3m\e[5m \e[4m *** The network should now be established, connected and broadcasting *** \e[0m"
sudo systemctl start hostapd
sleep 1
echo "Loading ..."
echo "\e[96m Displaying the the broadcasting AdHoc network\e[0m"
sleep 1
echo "Still working..."
sleep 2
printf "%s" "Press enter to continue to scan wlan_6 network connection status"
read ans
# Confirmation of key press 
echo "You pressed enter! Continuing...\n"
sleep 2
# ---Check the if the network is connected and broadcasting its SSID (wlan6)
sudo iwgetid wlan_6
echo " \n"
sleep 1
echo "\e[96m \e[0m"
echo "\n"
sleep 2
echo "\e[96m Now, displaying all the connected network to the system: both infrastructure and adhoc. Check for the signal strength and speeds.\e[0m"
sleep 1
echo "Still working..."
# Wait for the user to press a key
printf "%s" "Press enter to display the connected network"
read ans
# Confirmation of key press 
echo "You pressed enter! Continuing...\n"
sleep 2
sleep 1
#--- Check the if the network is available and broadcasting its SSID (wlan1)
sudo iwconfig
echo " \n"
sleep 2
echo "\e[33m Getting the ip address off the network\e[0m\n"
sleep 0.5
echo "\e[93mDisplaying the IP address of the connected network\e[0m\n"
sudo ip addr show 
echo "\e[94;4m End of AdHoc setup script \e[0m"
echo "===================================================\n"
printf "\e[95;2m Do you want to reboot (y/n): \e[0m" 
read ans
if [ -z "$ans" ]; then
  echo "\e[94;3m No input give; please provide either 'y' for yes and 'n' for no \e[0m"
fi
if  echo "$ans" | grep -Eq "^[Yy]$"; then
  echo " \e[91;1m Rebooting the system \e[0m"
  sleep 2
  sudo reboot
else 
  echo "\e[90;5m Reboot cancelled, manual check required to verify if changes are in effect after restart\e[0m"
fi

: << 'END_COMMENT'
iw dev 
iw dev wlan0 link # check connection
END_COMMENT






















