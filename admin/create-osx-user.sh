#!/usr/bin/env bash

##### I M P O R T A N T #####
# This script helps with creating an OSX user.
# Do not use this script blindly as it will allow access to your machine with default password.
#
# This script is not meant to be run in an automation. Run it manually.
#
# CHANGE the password below.
# Also, make sure USER_ID below is not assigned.

USERNAME="jenkins"
PASSWORD="Password1"
REAL_NAME="Jenkins Agent"
GROUP_NAME="staff"

# the first user's id is 500, second is 501 ...
# picking a big number to be on the safe side.
# You can run this one to list UIDs
#   dscl . -list /Users UniqueID
USER_ID=550

# GID 20 is `staff`
GROUP_ID=20


###############
############### end of parameters
###############

echo "IMPORTANT: this script will now create user ${USERNAME} with password ${PASSWORD} and add him to sudoers list."
echo "Your machine will be accessible with SSH using these credentials."

. /etc/rc.common
dscl . create /Users/${USERNAME}
dscl . create /Users/${USERNAME} RealName ${REAL_NAME}
dscl . passwd /Users/${USERNAME} ${PASSWORD}

dscl . create /Users/${USERNAME} UniqueID ${USER_ID}
dscl . create /Users/${USERNAME} PrimaryGroupID ${GROUP_ID}
dscl . create /Users/${USERNAME} UserShell /bin/bash
dscl . create /Users/${USERNAME} NFSHomeDirectory /Users/${USERNAME}
cp -R /System/Library/User\ Template/English.lproj /Users/${USERNAME}
chown -R ${USERNAME}:${GROUP_NAME} /Users/${USERNAME}

echo "${USERNAME}  ALL=(ALL:ALL) ALL" >> /etc/sudoers

echo "Done creating OSX user."