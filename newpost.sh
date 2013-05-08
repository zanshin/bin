#!/bin/sh
#
# newpost.sh automates the process of creating a new Octopress posting.
#
# 1. It changes to the ~/Projects/octopress/zanshin directory
# 2. It runs the 'rake new_post[] command using the posting name passed in as a parameter
# 3. It runs the 'rake isolate command using the posting name to isolate all other postings
# 4. It opens the posting in TextMate for editing
# 
#	who when       what
#	mhn	8.12.2011  initial version of script
#
#
if [ "$1" = "-h" ] ; then
	echo "Usage $0 [ postingname | -h ] \n postingname is the post to create \n Use -h for help."
fi
#
#
echo "Changing to Octopress location"
cd ~/Projects/octopress/zanshin
#
#
echo "Running rake new_post command"
rake new_post['"$1"']
#
#
echo "Running rake isolate command"
#rake isolate 