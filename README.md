# P2P_AdHoc-Networking
#### A peer-to-peer (P2P) network architecture enabling direct device-to-device communication without the need for an internet connection. The project implements two separate systems based on Ad Hoc networking principles:

  1)  Centralized System:
A network is generated using a centralized access point configured with Hostapd. Other devices act as clients, connecting to the centralized system.

  2)  Decentralized System:
A fully peer-to-peer network is established without any parent-child hierarchy. Devices connect directly to each other by configuring gateway addresses using wpa_supplicant and systemd-networkd profiles on Ubuntu.


## Pre-Requisites

Before setting up the system, it is recommended to have familiarity with:

  1) Setting up and configuring hostapd files and folders on Ubuntu.
  2) Reading and modifying systemd-networkd configuration files.
  3) Editing netplan configuration files for managing network interfaces in Ubuntu.

## Changes to Establish Connection

  1) For Centralized (Hostapd-based) System:
     - Device Name: Update the wlan_x placeholder to your actual device name, such as wlan0, wlan1, etc., depending on whether you are using a built-in Wi-Fi adapter or a USB dongle.
     -  Gateway Setup: While hostapd assigns IP addresses dynamically using DHCP, it is recommended to set a static gateway on each child device to ensure a reliable and automated connection.

  3) For Decentralized System:
     - Netplan Configuration: Edit the netplan.yaml file on each device to assign a static IP address within a chosen IP address family. Select an IP range that fits your application and ensures proper device communication.

## Running the Shell Script
  1) Decentralized System:
     - Navigate to the Ad-Hoc Decentralized folder.
      - Edit the .yaml file as needed to match your IP configuration.
      -   Run the shell script provided in the directory to initialize the decentralized network.

  3) Centralized System (Hostapd):
     - Navigate to the Centralized with Hostapd folder.
     - Edit the hostapd.conf file and the 10-wlan_x_network.txt file accordingly.
     - Rename the 10-wlan_x_network.txt file as needed and update the corresponding file path in the shell script before execution.
     - After making all changes, run the shell script to bring up the centralized network.
