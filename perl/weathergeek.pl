#!/usr/bin/env perl

# grab all the lines and put in an array
@w = <>;

# keep only certain lines for the current conditions
@t = grep /^ +(Temperature|Wind|Humidity|Conditions|Updated|Observed|Pressure)/, @w;

# erasae the leading spaces and parenthedtical values
for (@t){s/^ +//;s/\(\)//g};

# we want the temperature line to print on the bottom to make it
# easy to see on the desktop.  The temperature is always on the
# second line, so exchange it with the last line.
# ($t[$#t], $t[1]) = ($t[1], $t[$#t]);

# sometimes there is a windchill line, sometimes not.
# add a blank line to the front of the array if there isn't
unshift @t, "\n" if $#t == 2;

# print the lines of interest in the order I want
print join "", @t;