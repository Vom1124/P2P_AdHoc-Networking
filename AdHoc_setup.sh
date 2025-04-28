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

echo "\e[4m \e[32m Installing wpa_supplicant \e[0m...\n"
# wpa_supplicant (if not already there):  implementation of IEEE 802.11i network in linux
sudo apt-get install -y wpasupplicant
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

echo "\e[36m Erasing the wpa_supplicant cache if wpa_supplicant service was already implemented/connected.
This step can throw an error if ran for the first time, if so, ignore the error ...\e[0m\n"
# Disable the socket
sudo rm /var/run/wpa_supplicant/wlan0
echo "----------------------------------------\n"


sleep 1

#  3  ================================================================================
echo "=========================================\n"
echo "\e[7m Configuring the wpa_supplicant \e[0m...\n"
echo "=========================================\n"


echo "\e[33m Creating a configuration file and adding the necessary code in it...\e[0m...\n"
# Creating the conf file for wpa_supplicant
sudo touch /etc/wpa_supplicant/wpa_supplicant.conf

# Adding the code to the .conf file
sudo cp wpa_supplicant_conf.txt /etc/wpa_supplicant/wpa_supplicant.conf
echo "wpa_supplicant.conf file edited and setup ready..."
echo "-----------------------------------------\n"


echo "\e[33m Starting the wpa_supplicant service at start-up with inclusion for taking static ip address from the netplan\e[0m...\n"
# Adding code to the service file
sudo cp wpa_supplicant_systemd_startup.txt /etc/systemd/system/wpa_supplicant.service
sleep 1
echo "Reloading the systemctl-daemon and enabling the wpa_supplicant service at boot-up"
sudo systemctl daemon-reload
sudo systemctl enable wpa_supplicant.service
sleep 0.5
echo "Successfully setup the wpa_supplicant service to start at boot-up"

echo "------------------------------------------------------------\n"



#  4  ================================================================================
echo "=========================================\n"
echo "\e[7m Setting up RFKill to enable wlan0 by blocking RFKill \e[0m...\n"
echo "=========================================\n"


echo "\e[36m Creating an unblock service for RFKill\e[0m...\n"
# Unblocking wlan0
sudo rfkill unblock wlan

# Creating an unblock service
sudo touch  /etc/systemd/system/unblock-wifi.service
sudo cp rfkill_unblock.txt /etc/systemd/system/unblock-wifi.service

# Enabling at boot-up
sudo systemctl enable unblock-wifi
echo "wlan0 will be unblocked at startup by rfkill by default before even wpa_supplicant attempts to connect... "
echo "-----------------------------------------\n"


sleep 1

#  5  ================================================================================
echo "=========================================\n"
echo "\e[7m Setting up static ip address to the added network \e[0m...\n"
echo "=========================================\n"

echo "\e[36m Editing the netplan file to use networkd as renderer instead of NetworkManager. \e[0m...\n"
# --- Editing the configuration file for netplan under /etc/netplan/
sudo cp 01-adhoc-networkd.txt /etc/netplan/01-network-manager-all.yaml

# Apply the netplan
sudo netplan apply

echo "Netplan should be now applied. "
echo "-----------------------------------------\n"


#  6  ================================================================================
echo "=========================================\n"
echo "\e[3m\e[42m  Initiating and Joining the connection  \e[0m...\n"
echo "=========================================\n"


echo "\e[92m Starting a connection in the background \e[0m...\n"
# --------- Connecting in the background              
sudo wpa_supplicant -B -c /etc/wpa_supplicant/wpa_supplicant.conf -i wlan0
echo " \e[3m\e[5m \e[4m *** The network should now be established, connected and broadcasting *** \e[0m"

sleep 2

echo "Loading ..."

echo "\e[96m Displaying the available broadcasting SSIDs\e[0m"

sleep 3

echo "Still working..."

sleep 5

# Check the if the network is available and broadcasting its SSID
sudo iwlist wlan0 scan | grep ESSID

echo " \n"
sleep 2



# Wait for the user to press a key


printf "%s" "Press enter to display the connected network"
read ans

# Confirmation of key press 
echo "You pressed enter! Continuing...\n"

sleep 2

# Check if the network was connected
sudo iwgetid


echo "\e[93mCheck if the connected network is the desired Ad-Hoc network that was just created and configured\e[0m\n"

echo " --------------------------------------------------\n"

echo "\e[33m Getting the ip address off the network\e[0m\n"

sleep 0.5
echo "\e[93mDisplaying the IP address of the connected network\e[0m\n"
sudo ip addr show wlan0 



echo "===================================================\n"



















