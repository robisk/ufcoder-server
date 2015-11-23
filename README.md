sudo rmmod ftdi_sio usbserial
sudo apt-get remove brltty
http://www.ftdichip.com/Drivers/D2XX.htm

## Installation
Tested under ubuntu 14.04
#### uFR ubuntu usb workaround
```
sudo ./setup.sh
```
#### Allow specific user to access (read/write) usb
You have to type username
```
sudo ./usb.sh
```
`You have to reboot system after running script, to gain effect`

#### App dependencies
````
sudo apt-get install npm
sudo npm i n forever -g
sudo n latest
npm i
````

#### Config file
```
cp ./config/app.example.json ./config/app.json
```

## Usage
#### Start ufcoder-server
Develop
```
forever start -c node ./server.js
```
Production
```
node ./server.js
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
  "Your": "JSON to store"
}
```
