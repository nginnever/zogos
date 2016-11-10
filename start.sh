#!/bin/bash

clear

cat /home/voxelot/Desktop/zcashascii.txt

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
source /home/voxelot/Desktop/test.conf

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
echo "$PASSWORD" | sudo -S ~/github/amdgpu-pro-fans/./amdgpu-pro-fans.sh --speed=75
echo ""
echo "booting gpu failover script..."
sleep 3

#TODO add this to bash.rc
GPU_MAX_HEAP_SIZE=100
GPU_MAX_ALLOC_PERCENT=99
GPU_SINGLE_ALLOC_PERCENT=100
echo "starting miner..."
#echo "$PASSWORD" | sudo -S ~/github/test/silentarmy/./silentarmy --instances=$instances --use $gpus -c stratum+tcp://$pool -u $address.euclid
$GOPATH/bin/sa-monitor t1d1DQciS8AqViH1GqmPhTrky3qLY3ySbrG 0,1,2,3,4 euclid
#sudo bash -c "echo $GOPATH/bin/sa-monitor t1d1DQciS8AqViH1GqmPhTrky3qLY3ySbrG 0,1,2,3,4 euclid"
