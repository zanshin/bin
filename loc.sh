#!/bin/sh
# function to count SLOC and then format for the Wiki
	if [ -z $3 ]
	then
		echo "Usage: loc <source_dir> <unformatted_output_file> <formatted_output_file>"
		exit 1
	fi
#	tempfile=`basename $0`
#	TMPFILE=`/usr/bin/mktemp -q /tmp/${tempfile}.XXXXXX`
#	if [ $? -ne 0 ]; then
#		echo "$0: Can't create temp file, exiting..."
#		exit 1
#	fi
	/usr/local/sloccount/bin/sloccount --wide --multiproject $1 > $2	
	/Users/mhn/bin/sloc2conf.py $2 > $3
	
#	rm ${TMPFILE}
