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
