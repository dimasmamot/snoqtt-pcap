#!/bin/sh

echo "Building Docker Image for snoqtt"
sudo docker build -t snoqtt-pcap:4.7 /etc/snoqtt/dockerfile