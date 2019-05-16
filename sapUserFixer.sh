#!/bin/bash

INPUT="$1"
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read ad_user email portal_id sap_email
do
	echo "######################"
	echo "ad_user : $ad_user"
	USERID=$(psql -U reachengine -d studio -c "SELECT id FROM security_user WHERE user_name = '$ad_user'" -tA)
	echo "$USERID"
	psql -U reachengine -d studio -c "SELECT id, user_name, email_address FROM security_user WHERE id = $USERID" -tA
	echo "Making Updates ~ "
	psql -U reachengine -d studio -c "UPDATE security_user SET user_name = '$portal_id' WHERE id = $USERID" -tAq
	psql -U reachengine -d studio -c "UPDATE security_user SET email_address = '$sap_email' WHERE id = $USERID" -tAq
	echo "$ad_user, $email, $portal_id $sap_email"
	psql -U reachengine -d studio -c "SELECT id, user_name, email_address FROM security_user WHERE id = $USERID" -tA
	echo "######################"
done < $INPUT
IFS=$OLDIFS
