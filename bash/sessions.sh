#!/bin/bash

# Usage Function
function usage {
  echo "Usage: $(basename "$0") -s servicename-tier [-a app-node-count]" 2>"&1"
  echo 'Display active Wildfly application node session counts'
  echo '   -s: REQUIRED The service name, including its tier.'
  echo '   -a: OPTIONAL The number of app nodes if not 4.'
  exit 1
}

if [[ ${#} -lt 1 ]]; then
  usage
elif [[ ${#} -lt 2 ]]; then
  service=$1
  inst=4
elif [[ ${#} -lt 3 ]]; then
  service=$1
  inst=$2
fi

echo -e "\n\tWildfly Session Counts\n"

fmt=" %-30s\t\t\t%s\t%s \n"
printf "$fmt" "NODE NAME" "BLUE" "GREEN"

for (( x=1; x<="$inst"; x++ ))
do
    printf "$fmt" $(echo ome-$service-app-0$x) \
    $(curl -s http://ome-$service-app-0$x.prod.aws.ksu.edu/mod_cluster-manager/ | egrep "id:.*:blue_cluster" | wc -l)" \
    $(curl -s http://ome-$service-app-0$x.prod.aws.ksu.edu/mod_cluster-manager/ | egrep "id:.*:green_cluster" | wc -l)"
done

