# P2P_AdHoc-Networking
#### A peer-to-peer (P2P) network architecture enabling direct device-to-device communication without the need for an internet connection. The project implements two separate systems based on Ad Hoc networking principles:

  1)  Centralized System:
A network is generated using a centralized access point configured with Hostapd. Other devices act as clients, connecting to the centralized system.

  2)  Decentralized System:
A fully peer-to-peer network is established without any parent-child hierarchy. Devices connect directly to each other by configuring gateway addresses using wpa_supplicant and systemd-networkd profiles on Ubuntu.
