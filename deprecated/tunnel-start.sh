#!/bin/bash

while [ 1 ]; do
  ssh -N -L 3689:eeyore.gotdns.org:3689 mark@eeyore.gotdns.org
  sleep 5
done