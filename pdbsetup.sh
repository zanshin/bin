#!/bin/sh

# pdbsetup - copy property files from their location in newly checked out workspace
#    to their proper location in jBoss server instance.

if [ -z "$1" ] ; then
  echo "Usage: pdbsetup BaseDirectory" >$2 ; exit 1
fi

exit 0