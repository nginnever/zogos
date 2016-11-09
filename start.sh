#!/bin/bash

clear

cat zcashascii.txt

# Example taking input to conf

# echo "Begin Configuration"

# read -p "Please Enter You: " name
# echo "$name" >> names.txt

# clear
# echo -e "Hello $name\nYour name has been added to the list"
# echo "==============="
# cat names.txt

# echo "==============="
# echo "goodbye $name"
# sleep 2

# read from conf
# input="test.conf"

# while IFS= read -r line
# do
# 	echo -e "$line"
# done <"$input"
source test.conf

#echo "reading conf..." >&2
echo "miner: $miner" >&2
echo "driver: $driver" >&2
echo "pool: $pool" >&2
echo "zec address: $address" >&2
if [ $donate = "true" ]; then
	echo "donate: true"
fi
echo "fan speed: $fanspeed%" >&2
echo -e "devices: $gpus\n" >&2

echo "initializing..."
sleep 5
echo -e "increasing fan speed...\n"
~/github/amdgpu-pro-fans/./amdgpu-pro-fans.sh --speed=75
echo ""
echo "booting gpu failover script..."
sleep 3
echo "starting miner..."
#~/github/test/silentarmy/./silentarmy --instances=3 --use $gpus -c stratum+tcp://$pool -u $address.euclid
