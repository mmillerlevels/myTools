#!/usr/bin/bash

# Copyright 2020 Levels Beyond 
# Author Mike Miller
# shellcheck disable=SC2068

# Read in the ReachEngine URL and system user password, for api usage
echo -e "Please enter your reachengine URL - Ex: 'http://10.20.16.50:8081'"
echo -e "No trailing '/'"
echo
read -r url
echo -e "The system user's password"
echo
read -r system_pass

start_time=$(/usr/bin/date +%h_%d-%H:%M:%S)

echo -e "Grabbing all enabled users in the system"
echo -e "You might be asked to input reachengine's psql password"

# Use psql to snag enabled users. -t prevents the command from returning n of rows
enabled_users=$(/usr/bin/psql studio reachengine -A -t -c "SELECT id FROM security_user WHERE enabled = true AND user_name != 'system'")

# For each id returned as an enabled user, disable then re-enable the user with the api
echo -e "Disabling and re-enabling each user...Standby"
echo
echo "############################################################################################################"
for i in ${enabled_users[@]}
do
    echo -e "Disabling User $i"
    /usr/bin/curl "$url/reachengine/api/security/users/$i" \
    -X "PUT" \
    -H "Connection: keep-alive" \
    -H "Content-Type: application/json" \
    -H "auth_user: system" \
    -H "auth_password: $system_pass" \
    --data "{\"id\":\"$i\",\"enabled\":\"false\"}" \
    --compressed

    echo
    echo -e "Re-Enabling User $i"
    /usr/bin/curl "$url/reachengine/api/security/users/$i" \
    -X "PUT" \
    -H "Connection: keep-alive" \
    -H "Content-Type: application/json" \
    -H "auth_user: system" \
    -H "auth_password: $system_pass" \
    --data "{\"id\":\"$i\",\"enabled\":\"true\"}" \
    --compressed
    echo
    echo "############################################################################################################"
done

echo
end_date=$(/usr/bin/date +%h_%d-%H:%M:%S)
echo -e "This started on $start_time and ended at $end_date"

