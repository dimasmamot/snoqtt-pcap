#!/bin/sh

def_command_mqtt_topic="ct_dddvvv"
def_response_mqtt_topic="rt_dddvvv"
def_global_mqtt_topic="gt_dddvvv"
def_alert_mqtt_topic="snoqttv4"
def_management_mqtt_server="192.168.30.19"
def_management_mqtt_port="1883"
def_alert_mqtt_server="192.168.30.19"
def_alert_mqtt_port="1883"
def_device_id="snort_sensor_mmt001"
def_secret_key="sssskkkkddddvvvv"
def_access_token="ddddvvvv"
def_oinkcode="a6e57f37417785ca9af06f735bb9fd89c6985dfe"
def_protected_subnet="192.168.30.0/24"
def_external_subnet="!""\$HOME_NET"
def_netint="eth0"


echo "Welcome to snoqtt temporart snort installation script!"
echo "------------------------------------------------------"

echo "Please provide information regarding alert pipeline service"
echo "Alert mqtt server : (default : ${def_alert_mqtt_server})"
read alert_mqtt_server
echo "Alert mqtt port : (default : ${def_alert_mqtt_port})"
read alert_mqtt_port
echo "Alert topic : (default : ${def_alert_mqtt_topic})"
read alert_mqtt_topic
echo ""

echo "Please provide information regarding sensor management service"
echo "Management mqtt server : (default : ${def_management_mqtt_server})"
read management_mqtt_server
echo "Management mqtt port : (default : ${def_management_mqtt_port})"
read management_mqtt_port
echo "Command topic : (default : ${def_command_mqtt_topic})"
read command_mqtt_topic
echo "Response topic : (default : ${def_response_mqtt_topic})"
read response_mqtt_topic
echo "Global topic : (default : ${def_global_mqtt_topic})"
read global_mqtt_topic
echo ""

echo "Please provide information regarding sensor identification"
echo "Sensor device ID : (default : ${def_device_id})"
read device_id
echo "Secret key : (default : ${def_secret_key})"
read secret_key
echo "Access token : (default : ${def_access_token})"
read access_token
echo "Oinkcode : (default : ${def_oinkcode})"
read oinkcode
echo "Proteceted subnet : (default : ${def_protected_subnet})"
read protected_subnet
echo "External subnet : (default : ${def_external_subnet})"
read external_subnet
echo "Network interface : (default : ${def_netint})"
read netint

echo "# This variable is generated from sensor installer script" >> ~/.bashrc
echo "export ALERT_MQTT_SERVER=${alert_mqtt_server:-${def_alert_mqtt_server}}" >> ~/.bashrc
echo "export ALERT_MQTT_PORT=${alert_mqtt_port:-${def_alert_mqtt_port}}" >> ~/.bashrc
echo "export ALERT_MQTT_TOPIC=${alert_mqtt_topic:-${def_alert_mqtt_topic}}" >> ~/.bashrc
echo "export MANAGEMENT_MQTT_SERVER=${management_mqtt_server:-${def_management_mqtt_server}}" >> ~/.bashrc
echo "export MANAGEMENT_MQTT_PORT=${management_mqtt_port:-${def_management_mqtt_port}}" >> ~/.bashrc
echo "export COMMAND_MQTT_TOPIC=${command_mqtt_topic:-${def_command_mqtt_topic}}" >> ~/.bashrc
echo "export RESPONSE_MQTT_TOPIC=${response_mqtt_topic:-${def_response_mqtt_topic}}" >> ~/.bashrc
echo "export GLOBAL_MQTT_TOPIC=${global_mqtt_topic:-${def_global_mqtt_topic}}" >> ~/.bashrc
echo "export DEVICE_ID=${device_id:-${def_device_id}}" >> ~/.bashrc
echo "export SECRET_KEY=${secret_key:-${def_secret_key}}" >> ~/.bashrc
echo "export ACCESS_TOKEN=${access_token:-${def_access_token}}" >> ~/.bashrc
echo "# End of generated variable" >> ~/.bashrc

. ~/.bashrc

echo "Creating environment variable config file"
echo "COMMAND_MQTT_TOPIC=${command_mqtt_topic:-${def_command_mqtt_topic}}" > kaspa_snoqtt/env-conf.conf
echo "RESPONNSE_MQTT_TOPIC=${response_mqtt_topic:-${def_response_mqtt_topic}}" >> kaspa_snoqtt/env-conf.conf
echo "GLOBAL_MQTT_TOPIC=${global_mqtt_topic:-${def_global_mqtt_topic}}" >> kaspa_snoqtt/env-conf.conf
echo "MANAGEMENT_MQTT_SERVER=${management_mqtt_server:-${def_management_mqtt_server}}" >> kaspa_snoqtt/env-conf.conf
echo "MANAGEMENT_MQTT_PORT=${management_mqtt_port:-${def_management_mqtt_port}}" >> kaspa_snoqtt/env-conf.conf
echo "ALERT_MQTT_TOPIC=${alert_mqtt_topic:-${def_alert_mqtt_topic}}" >> kaspa_snoqtt/env-conf.conf
echo "ALERT_MQTT_SERVER=${alert_mqtt_server:-${def_alert_mqtt_server}}" >> kaspa_snoqtt/env-conf.conf
echo "ALERT_MQTT_PORT=${alert_mqtt_port:-${def_alert_mqtt_port}}" >> kaspa_snoqtt/env-conf.conf
echo "DEVICE_ID=${device_id:-${def_device_id}}" >> kaspa_snoqtt/env-conf.conf
echo "OINKCODE=${oinkcode:-${def_oinkcode}}" >> kaspa_snoqtt/env-conf.conf
echo "PROTECTED_SUBNET=${protected_subnet:-${def_protected_subnet}}" >> kaspa_snoqtt/env-conf.conf
echo "EXTERNAL_SUBNET=${external_subnet:-${def_external_subnet}}" >> kaspa_snoqtt/env-conf.conf
echo "NETINT=${netint:-${def_netint}}" >> kaspa_snoqtt/env-conf.conf
echo "SECRET_KEY=${secret_key:-${def_secret_key}}" >> kaspa_snoqtt/env-conf.conf
echo "ACCESS_TOKEN=${access_token:-${def_access_token}}" >> kaspa_snoqtt/env-conf.conf

echo "Copying file to installation directory"
mkdir -p /etc/snoqtt
cp -R kaspa_snoqtt/. /etc/snoqtt
chmod a+x /etc/snoqtt/create_snoqtt.sh
chmod a+x /etc/snoqtt/recreate_snoqtt.sh
chmod a+x /etc/snoqtt/remove_snoqtt_snoqtt.sh
chmod a+x /etc/snoqtt/start_snoqtt.sh
chmod a+x /etc/snoqtt/stop_snoqtt.sh

echo "Checking docker installation..."
if [ -x "$(command -v)" ]; then
    echo "Docker installed"
else
    echo "Installing docker..."
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
    apt-get update
    apt-get install -y docker-ce
    service docker start
    echo "Docker installed"

