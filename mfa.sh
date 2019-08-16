#!/bin/sh

# create filename variable
FILENAME=$HOME/.aws/credentials

# clear FILENAME of previous contents
> $FILENAME

# save default key information for mfa command
echo "[default]" >> $FILENAME
echo "aws_access_key_id = FIXME" >> $FILENAME
echo "aws_secret_access_key = FIXME" >> $FILENAME

# prompt for mfa token
echo "Enter MFA code"
read mfacode

# run aws token command
result=$(aws sts get-session-token --serial-number FIXME --token-code $mfacode)

# clear file again and store new keys
> $FILENAME

access_key_id=$(echo $result | awk '{print $11}' | tr -d '"' | tr -d ',')
secret_access_key=$(echo $result | awk '{print $5}' | tr -d '"' | tr -d ',')
session_tokem=$(echo $result | awk '{ptint $7}' | tr -d '"' |tr -d ',')

echo >> $FILENAME
echo "[default]" >> $FILENAME
echo "aws_access_key_id = $aws_access_key_id" >> $FILENAME
echo "aws_secret_access_key = $secret_access_key" >> $FILENAME
echo "aws_session_token = $session_token" >> $FILENAME

echo "MFA session established"
