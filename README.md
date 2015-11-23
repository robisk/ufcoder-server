sudo rmmod ftdi_sio usbserial
sudo apt-get remove brltty
http://www.ftdichip.com/Drivers/D2XX.htm

@TODO readme
@TODO install instruction
@TODO install script !
@TODO usb nosudo !
@TODO forever

## Installation
#### Driver
```
First of all, you must install appropriate driver for your Linux platform. Please follow FTDI chip download page http://www.ftdichip.com/Drivers/D2XX.htm and get proper D2XX and VCP drivers.

Next step is to check and change permissions. Please download USB permissions script for Linux at http://dld.is.d-logic.net/index.php/libraries-download/Latest-libs/ufr_linux_usb_permissions_script-7z?format=raw and start it.

If still experiencing the same, check if modules ftdi_sio and usbserial are loaded. If so, unload them :

#lsmod
Module Size Used by
ftdi_sio 26993 0
usbserial 21409 1 ftdi_sio
# sudo rmmod ftdi_sio usbserial
# sudo rmmod ftdi_sio usbserial

.

To make this change persistent, blacklist modules in modprobe.d/ftdi.conf :
$ sudo vim /etc/modprobe.d/ftdi.conf
and edit file /etc/modprobe.d/ftdi.conf ) :
#disable auto load FTDI modules - D-LOGIC
blacklist ftdi_sio
blacklist usbserial
```
#### Dependencies
````
sudo apt-get install npm
sudo npm i n forever -g
sudo n latest
npm i
````
## Start ufcoder-server
forver start node ./server.js
