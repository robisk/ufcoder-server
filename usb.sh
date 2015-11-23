#!/bin/bash

ROOT_UID=0
if [ "$UID" -eq "$ROOT_UID" ]; then
    #echo -n "Enter new group :"
    #     read GROUPADD
   #
     GROUPADD="usb_access"
      groupadd $GROUPADD
       echo -n "Enter an existing user  :"
           read ADDUSER
      adduser $ADDUSER  $GROUPADD
   echo 'SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", MODE="0664", GROUP="'${GROUPADD}'" ' >> /etc/udev/rules.d/50-dlogic.rules

else
     echo "You Need To Be Root!"
fi
exit 0
