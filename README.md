sudo rmmod ftdi_sio usbserial
sudo apt-get remove brltty
http://www.ftdichip.com/Drivers/D2XX.htm

@TODO readme
@TODO install instruction
@TODO install script !
@TODO usb nosudo !
@TODO forever

## Installation
Tested under ubuntu 14.04
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
#### How handle event of read card in browser
```
Demo - socketioclient.html
```
#### How to write data to card
POST http://localhost:3000/write

Content-Type: application/json

```
{
  "Your": "json to store"
}
```
