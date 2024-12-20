#!/bin/bash

if [[ -z "$1" ]] && [[ -z "$2" ]]; then
  echo 'Usage: ./ssh-dns.sh <all,anycast,external,dc> <command>'
fi

case $1 in

  all)
    ssh -t est-dns-p-app-07.campus.ksu.edu $2 &
    ssh -t est-dns-p-app-16.campus.ksu.edu $2 &
    ssh -t est-dns-p-app-17.campus.ksu.edu $2 &
                ssh -t est-dns-p2-anycast-01.campus.ksu.edu $2 &
                ssh -t est-dns-p2-anycast-02.campus.ksu.edu $2 &
                ssh -t est-dns-p2-anycast-03.campus.ksu.edu $2 &
                ssh -t est-dns-p2-anycast-04.campus.ksu.edu $2 &
                ssh -t est-dns-p2-anycast-05.campus.ksu.edu $2 &
                ssh -t est-dns-p2-anycast-06.campus.ksu.edu $2 &
                ssh -t est-dns-p2-anycast-07.campus.ksu.edu $2 &
                ssh -t est-dns-p2-external-01.compute.lwc.ksu.edu $2 &
                ssh -t est-dns-p2-external-03.sharedservices.aws.ksu.edu $2 &
                ssh -t est-dns-p2-master-01.campus.ksu.edu $2 &
                ssh -t est-dns-p2-master-02.campus.ksu.edu $2 &
    ;;

  anycast)
                ssh -t est-dns-p2-anycast-01.campus.ksu.edu $2 &
                ssh -t est-dns-p2-anycast-02.campus.ksu.edu $2 &
                ssh -t est-dns-p2-anycast-03.campus.ksu.edu $2 &
                ssh -t est-dns-p2-anycast-04.campus.ksu.edu $2 &
                ssh -t est-dns-p2-anycast-05.campus.ksu.edu $2 &
                ssh -t est-dns-p2-anycast-06.campus.ksu.edu $2 &
                ssh -t est-dns-p2-anycast-07.campus.ksu.edu $2 &
    ;;

  external)
                ssh -t est-dns-p-app-07.campus.ksu.edu $2 &
                ssh -t est-dns-p2-external-01.compute.lwc.ksu.edu $2 &
                ssh -t est-dns-p2-external-03.sharedservices.aws.ksu.edu $2 &
    ;;

  aws)
    ssh -t est-dns-p-app-16.campus.ksu.edu $2 &
    ssh -t est-dns-p-app-17.campus.ksu.edu $2 &
                ssh -t est-dns-p2-external-03.sharedservices.aws.ksu.edu $2 &
                ;;
  master)
                ssh -t est-dns-p-app-16.campus.ksu.edu $2 &
                ssh -t est-dns-p-app-17.campus.ksu.edu $2 &
                ssh -t est-dns-p2-master-01.campus.ksu.edu $2 &
                ssh -t est-dns-p2-master-02.campus.ksu.edu $2 &
                ;;
esac

case $2 in

  run-chef)
    2="sudo chef-client -o est-dns"
    ;;

esac
