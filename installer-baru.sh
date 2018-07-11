#!/bin/bash

echo "Welcome to snoqtt snort installation script!"
echo "--------------------------------------------"

username=""
password=""
device_id=""
sensor_key=""

echo "To begin the installation you need to provide your credential, device_id, & sensor_key"
echo "--------------------------------------------"
echo "Username : "
read username
echo "Password : "
read -s password
echo "Device ID : "
read device_id
echo "Sensor Key : "
read sensor_key 

curl blablabla

tar xvzf package.tar.gz
cp -R kaspa-snoqtt /etc
mv /etc/kaspa-snoqtt /etc/snoqtt

chmod a+x /etc/snoqtt/build_snoqtt.sh
chmod a+x /etc/snoqtt/remove_snoqtt.sh
chmod a+x /etc/snoqtt/start_snoqtt.sh
chmod a+x /etc/snoqtt/stop_snoqtt.sh

echo "Checking docker installation..."
if [ -x "$(command -v)" ]; then
    echo "Docker Already Installed"
else
    echo "Installing docker..."
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
    apt-get update
    apt-get install -y docker-ce
    service docker start
    echo "Docker installed"

/etc/snoqtt/build_snoqtt.sh

echo "Installation Done"