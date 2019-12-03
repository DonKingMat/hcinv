#!/bin/bash

# Make sure your SL API token is available in file api.token
# Have 'jq' installed on your system

TOKEN=$(cat api.token)
DUMP=$(curl --silent -H "Authorization: Bearer ${TOKEN}" https://api.hetzner.cloud/v1/servers | jq -c '.servers | .[]')
KOMMA=""
SERVERS=$(echo $DUMP | jq -r '.name')

echo -n '{"hetzner": ['

for SERVER in $SERVERS ; do
  echo -n $KOMMA
  echo -n "\"${SERVER}\""
  KOMMA=","
done

echo -n "],"
#echo -n "\"_meta\": { \"hostvars\": {}}}" 
echo -n "\"_meta\": { \"hostvars\": {"

KOMMA=""
for SERVER in $SERVERS ; do
  IP=$(echo $DUMP | jq -r '. | select(.name == "'$SERVER'") | .public_net.ipv4.ip')
  echo -n "${KOMMA} \"${SERVER}\": {\"ip\": \"$IP\""
  KOMMA="},"
done

echo -n "}}}}" 
