#!/bin/bash



starttime=$(date +%s)



ls -algR /homes/mhn/code > /homes/mhn/tmp2
grep -R campus /homes/mhn/code > /homes/mhn/tmp3
endtime=$(date +%s)



elapsedtime=$(( endtime - starttime))
echo $elapsedtime
