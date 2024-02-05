#!/bin/bash

# Prompt for LDAP connection credentials
read -p "Enter LDAP Username cn= : " ldap_user
read -s -p "Enter LDAP Password: " ldap_password
echo  # Move to a new line after password input

if [ -z "$ldap_user"  ] || [ -z "$ldap_password"  ]; then
      echo "Error: LDAP username and password are required."
          exit 1
fi

if [ "$#" -ne 1  ]; then
      echo "Usage: $0 <input_file>"
      exit 1
fi

input_file="$1"
mapping_file="directory-mapping"

while IFS= read -r id; do
  ldap_result=$(ldapsearch -x -LLL -h ome-openldap-p-app-05.prod.aws.ksu.edu -D "cn=$ldap_user,dc=k-state,dc=edu" -w "$ldap_password" -b "ou=People,dc=k-state,dc=edu" "(uid=$id)")

    # Check if the LDAP query returned any results
    if [ -n "$ldap_result" ]; then
        display_name=$(echo "$ldap_result" | awk -F': ' '/displayName:/ {print $2}')
        affiliation=$(echo "$ldap_result" | grep "EMPLOYEE_CURRENT" | awk -F': ' '/ksuPersonAffiliations:/ {print $2}')
        mappings=$(grep "$id" "$mapping_file" | wc -l)
        printf "ID: %-20s Name: %-30s Affiliation: %-20s Mapping: %-4s \n" "$id" "$display_name" "$affiliation" "$mappings"
        # echo "ID: $id, DisplayName: $display_name, Affiliation: $affiliation, Mappings: $mappings"
    else
        mappings=$(grep "$id" "$mapping_file" | wc -l)
        printf "ID: %-20s Name: %-30s Affiliation: %-20s Mapping: %-4s \n" "$id" "NOT FOUND IN LDAP" "NONE" "$mappings"
        # echo "ID: $id not found in LDAP"
    fi
done < "$input_file"
