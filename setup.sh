if [ ! "`whoami`" = "root" ]
then
    echo "Please run script as root."
    exit 1
fi

sudo rmmod ftdi_sio usbserial
sudo touch /etc/modprobe.d/ftdi.conf
grep -q -F 'blacklist ftdi_sio' /etc/modprobe.d/ftdi.conf || echo 'blacklist ftdi_sio' >> /etc/modprobe.d/ftdi.conf
grep -q -F 'blacklist usbserial' /etc/modprobe.d/ftdi.conf || echo 'blacklist usbserial' >> /etc/modprobe.d/ftdi.conf
