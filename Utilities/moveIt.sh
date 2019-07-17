#!/bin/bash
UHOME="/home"
FILE="/home/mmiller/.bashrc"
#Grab system users
_USERS="$(awk -F':' '{ if ( $3 >= 500 ) print $1 }' /etc/passwd)"
#Do the neefdul
for u in $_USERS
do
   _dir="${UHOME}/${u}"
   if [ -d "$_dir" ]
   then
       /bin/cp "$FILE" "$_dir"
       chown $(id -un $u):$(id -gn $u) "$_dir/${FILE}"
   fi
done
