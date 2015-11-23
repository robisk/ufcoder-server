sudo rmmod ftdi_sio usbserial
sudo apt-get remove brltty
http://www.ftdichip.com/Drivers/D2XX.htm

@TODO readme
@TODO install instruction
@TODO install script !
@TODO usb nosudo !
@TODO forever

## Installation
#### uFR Driver & stuff
```
sudo ./setup.sh
```
#### App dependencies
````
sudo apt-get install npm
sudo npm i n forever -g
sudo n latest
npm i
````
## Start ufcoder-server
forver start node ./server.js

## Usage
#### Start server
```
node ./server.js
forever start -c node ./server.js
```
#### How to use in browser
```
Demo - socketioclient.html
```
