#!/bin/bash

# Assumption:
#  1. Your original AWS Creds should be stored at ~/.aws/credentials
#  2. You did not specify a region during while initally configuring the AWS
#     cli. The sts command defaults to us-east.
#  2. You've corrected ARN for MFA device (search for FIXME)
#  3. You've given correct MFA Code as cli argument
#  4. You have jq installed. Ref: https://stedolan.github.io/jq/

if [ "$1" == "" ]; then
  echo "Usage: $(basename "$0") <MFA-TOKEN>"
  exit
fi

# Maximum duration for MFA session is 36 hours (129600 seconds)
session_duration=129600

# Taken from AWS Console: FIXME
mfa_device_code="FIXME"

# Taken from command line argument
mfa_code=$1

# This file stores temporary session credentials after making aws cli request
tmp_creds_file="$HOME/.aws/tempcreds"

# Standard AWS Credentials File Path
aws_creds_file="$HOME/.aws/credentials"

# File where original credentials are backed up
orig_creds_file="$HOME/.aws/origcreds"

old_creds=$(cat "${tmp_creds_file}")
regenerate=true
if [ -n "$old_creds" ]; then
  echo "Old Credentials found"
  old_expiry=$(echo ${old_creds} | jq -r ".Credentials.Expiration")
  if [ -n "$old_expiry" ]; then
    echo "Old Expiry: $old_expiry"
    expiry_tstamp=$(date -d ${old_expiry} '+%s')
    now_tstamp=$(date +%s)
    if [ $expiry_tstamp -gt $now_tstamp ]; then
      echo "Old Credentials good to go"
      exit
    fi
  fi
fi
new_creds=""
if [ "$regenerate" = true ]; then
  cp $orig_creds_file $aws_creds_file
  cmd="aws sts get-session-token --duration-seconds ${session_duration} --serial-number ${mfa_device_code} --token-code ${mfa_code}"
  echo "$cmd"
  $cmd > ${tmp_creds_file}
  new_creds=$(cat ${tmp_creds_file})
fi

if [ -z "$new_creds" ]; then
  echo "Request failed"
  exit
fi

access_key_id=$(echo ${new_creds} | jq -r ".Credentials.AccessKeyId")
secret_access_key=$(echo ${new_creds} | jq -r ".Credentials.SecretAccessKey")
session_token=$(echo ${new_creds} | jq -r ".Credentials.SessionToken")
expiry=$(echo ${new_creds} | jq -r ".Credentials.Expiration")

printf "[default]\naws_access_key_id = ${access_key_id}\naws_secret_access_key = ${secret_access_key}\naws_session_token = ${session_token}" > ${aws_creds_file}
echo "All set. Expiry at: $(date -d ${expiry})"
