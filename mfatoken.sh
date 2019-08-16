#!/bin/bash

# Script Name : mfaotken.sh
# Author      : Mark Nichols
# Purpose     : Generate IAM session token using provided MFA code
# USage       : mfatoken.sh arg1 arg2
#               $ ./mfatoken.sh default-mfa default
# Arguments
#        arg1 : Specifies the MFA profile, containing the Access Key,
#               Secret Access Key, and Session Token
#        arg2 : Specifies the profile name to call STS service with
#

# Need two arguments
# 1 or 2 args ok
if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <MFA_PROFILE_NAME> <BASE_PROFILE_NAME>"
  echo "Where:"
  echo "   <MFA_PROFILE_NAME> = The profile name for the MFA session"
  echo "   <BASE_PROFILE_NAME> = The base session profile"
  exit 2
fi

# Get profile names from arguments
MFA_PROFILE_NAME=$1
BASE_PROFILE_NAME=$2

# Set default region
DEFAULT_REGION="us-east"

# Set default output encoding
DEFAULT_OUTPUT="json"

# Determine if AWS CLI tool is installed and use it
AWS_CLI=`which aws`

if [ $? -ne 0 ]; then
  echo "AWS CLI is not installed; exiting"
  exit 1
else
  echo "Using AWS CLI found at $AWS_CLI"
fi

# MFA Serial: specity MFA serial of IAM user
# E.g.,: arn:aws:iam::123456789123:mfa/iamusername
# Read AWS MFA Serial, Secret Access Key, and Access Key ID from environment
if [ -z "${AWS_MFA_SERIAL}" ];then
    echo "MFA Serial is missing; exiting"
    exit 1
fi

if [ -z "${AWS_SECRET_ACCESS_KEY}" ];then
    echo "AWS Secret Access Key is missing; exiting"
    exit 1
fi

if [ -z "${AWS_ACCESS_KEY_ID}" ];then
    echo "AWS Access Key ID is missing; exiting"
    exit 1
fi

echo "serial: $AWS_MFA_SERIAL"
echo "secret: $AWS_SECRET_ACCESS_KEY"
echo "id    : $AWS_ACCESS_KEY_ID"

# Generate security token flag
GENERATE_ST="true"

# Expiration Time: SessionToken defaults to 12 hour lifespan, can be 15 minutes
# to 36 hours
# MFA_PROFILE_EXISTS=`less ~/.aws/credentials | grep $MFA_PROFILE_NAME | wc -l`
if [ `less ~/.aws/credentials | grep $MFA_PROFILE_NAME | wc -l` ]; then
  EXPIRATION_TIME=$(aws configure get expiration --profile $MFA_PROFILE_NAME)
  echo "$EXPIRATION_TIME"
  NOW=$(date -u +"%Y-%m-%d %T")
  if [[ "$EXPIRATION_TIME" > "$NOW" ]]; then
    echo "The session token is still valid. New security token not required."
    GENERATE_ST="false"
  fi
fi

if [ "$GENERATE_ST" = "true" ]; then
  echo "3"
  read -p "Token code for MFA device ($AWS_MFA_SERIAL): " TOKEN_CODE
  echo "Generating new IAM STS Token ..."

  read -r AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN EXPIRATION AWS_ACCESS_KEY_ID < <(aws sts get-session-token --profile $BASE_PROFILE_NAME --output text --query 'Credentials.*' --serial-number $AWS_MFA_SERIAL --token-code $TOKEN_CODE)

  if [ $? -ne 0 ]; then
    echo "An error occured. AWS credentials file not updated."
  else
    echo "4"
    aws configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY" --profile $MFA_PROFILE_NAME
    aws configure set awd_session_token "$AWS_SESSION_TOKEN" --profile $MFA_PROFILE_NAME
    aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID" --profile $MFA_PROFILE_NAME
    aws configure set expiration "$EXPIRATION_TIME" --profile $MFA_PROFILE_NAME
    aws configure set region "$DEFAULT_REGION" --profile $MFA_PROFILE_NAME
    aws configure set output "$DEFAULT_OUTPUT" --profile $MFA_PROFILE_NAME
    echo "STS Session Token generated and updated in AWS Credentials file successfully."
  fi
fi

