#!/bin/bash
# Turn Wifi off then on 
networksetup -setairportpower en0 off
echo "--------------Turning WiFi Off----------------"
networksetup -setairportpower en0 on
echo "--------------Turning WiFi On-----------------"
sleep 7s
# Join the correct network for the room
echo "--------------Joining Network-----------------"
networksetup -setairportnetwork en0 WeWork #####REMOVED######
sleep 15s
# Display BSSID SSID and other Wifi info
echo "--------------WiFi Info-----------------------"
airport -I | grep -E 'BSSID|SSID|channel'

#Parse the channel out ex channel: 152,80 -> 152 then determine if 2.4 or 5ghz band based on channel
channel=`airport -I | grep -o 'channel.*' | cut -f2 -d: | cut -f1 -d,`
if [ $channel -gt 17 ];
then
	echo "Band: 5ghz"
else
	echo "Band: 2.4ghz"
fi

#Wifi Signal Strength 
#High quality: 90% ~= -55db
#Medium quality: 50% ~= -75db
#Low quality: 30% ~= -85db
#Unusable quality: 8% ~= -96db
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BIRed='\033[1;91m'        # Red High Intensity
NC='\033[0m'              # No Color
BPurple='\033[1;35m'      # Purple


signal_noise=`airport -I | grep -o 'agrCtlNoise.*' | cut -f2 -d:`
echo "Signal Noise: $signal_noise"

#Parse RSSI then compare signal strength and assign color based on strength
#echo additional network info exlude IPv6 information
signal_strength=`airport -I | grep -o 'agrCtlRSSI.*' | cut -f2 -d:`
if [ $signal_strength -gt -36 ];
then 
	color=$BGreen
elif [ $signal_strength -gt -56 ];
then
	color=$BYellow
elif [ $signal_strength -gt -75 ];
then
	color=$BPurple
else
	color=$BIRed
fi

echo -e "RSSI Signal Strength: $color$signal_strength${NC}"
snr=`expr $signal_strength - $signal_noise`
if [ $snr -gt 40 ];
then
	color=$BGreen
elif [ $snr -gt 25 ];
then
	color=$BYellow
else
	color=$BIRed
fi

echo -e "Signal-Noise-Ratio: $color$snr${NC}"

echo "--------------IP Info-----------------------"
networksetup -getinfo Wi-Fi | grep -Ev 'IPv6|Client ID'
echo "----------------------------------------------"


