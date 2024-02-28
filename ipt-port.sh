#!/bin/bash

DEST_IP="192.168.49.2"

START_PORT=30000
END_PORT=30100

for (( port=$START_PORT; port<=$END_PORT; port++ ))
do
    sudo iptables -t nat -A PREROUTING -p tcp --dport $port -j DNAT --to-destination $DEST_IP:$port
done

sudo iptables -P FORWARD ACCEPT

echo "completed successfully."

