#!/usr/bin/env bash

# This script helps with enabling SSH for given OSX user.
# This script is not meant to be run in an automation. Run it manually.

USERNAME="jenkins"

###############
############### end of parameters
###############

# com.apple.access_ssh is a special group name on OSX.
# any user part of that group can have SSH connections in.
OSX_SSH_GROUP_NAME="com.apple.access_ssh"

systemsetup -setremotelogin on
# in order to check what groups are are there:
#   dscl . list /Groups PrimaryGroupID
# create a group for limiting SSH access
dseditgroup -o create -q ${OSX_SSH_GROUP_NAME}
# add user into this group
dseditgroup -o edit -a ${USERNAME} -t user ${OSX_SSH_GROUP_NAME}
# now, following should work
#   ssh username@localhost