#!/bin/bash
# portions based on example at http://prasaddomala.com/configure-multi-factor-authentication-mfa-with-aws-cli/

user_profile=default
mfa_profile=mfa

# nuke the token_exp line from the profile in ~/.aws/config to  override and force new token update
exp=$(aws configure get token_exp --profile $mfa_profile)
echo "using expiration of $exp"
now=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
if  "$exp" > "$now" ; then
    echo "The cofigured token is still valid. Exiting without update -- remove token_exp from config to force update"
    exit 1
fi
echo $now

read -p "token: " token

mfa=`aws iam list-mfa-devices --profile $user_profile --output text | awk '{print $3}'`

echo "Using $mfa"

​# different versions of the cli seem to release these in different orders so request everything and do a sort based on keys to get a predictable order
read -r keyid exp secret stoken < <(aws sts get-session-token --profile $user_profile --output json  --serial-number $mfa --token-code $token | egrep "SecretAccessKey|SessionToken|Expiration|AccessKeyId" | sort | awk '{print $2}' | sed -e "s/\"\,*//g" | paste -sd "\t" -)


echo "new keyid: $keyid"
echo "Expires: $exp"

aws configure set aws_access_key_id "$keyid" --profile $mfa_profile
aws configure set aws_secret_access_key  "$secret" --profile $mfa_profile
aws configure set aws_session_token  "$stoken" --profile $mfa_profile
aws configure set token_exp  "$exp" --profile $mfa_profile

echo "Profile $mfa_profile configured -- or source ~/.aws/$mfa_profile.tmp"
# alternatively can use these if you source the tmp file:
echo "export AWS_ACCESS_KEY_ID=\"$keyid\"" > ~/.aws/$mfa_profile.tmp  #source this as desired
echo "export AWS_SECRET_ACCESS_KEY=\"$secret\"" >> ~/.aws/$mfa_profile.tmp
echo "export AWS_SESSION_TOKEN=\"$stoken\"" >> ~/.aws/$mfa_profile.tmp
