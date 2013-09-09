#!/usr/bin/env python
# Written by Rasmus Toftdahl Olesen <rto@pohldata.dk>
# Modified slightly by David A. Wheeler
# Released under the GNU General Public License v. 2 or higher
#
# modified to produce Convergence Wiki formatted output by Mark Nichols.
from string import *
import sys

NAME = "sloc2conf"
VERSION = "0.0.3"
	
if len(sys.argv) != 2:
    print "Usage:"
    print "\t" + sys.argv[0] + " <sloc output file>"
    print "\nThe output of sloccount should be with --wide and --multiproject formatting"
    sys.exit()

colors = { "python" : "blue",
           "ansic" : "yellow",
           "perl" : "purple",
           "cpp" : "green",
           "sh" : "red",
           "yacc" : "brown",
           "css" : "navy",
           # Feel free to make more specific colors.
           "ruby" : "maroon",
           "js" : "gray",
           "java" : "silver",
           "jsp" : "olive",
           "lisp" : "fuchsia",
           "objc" : "purple",
           "html" : "green",
           "xml" : "white",
           "properties" : "teal",
           "asm" : "purple",
           "csh" : "purple",
           "tcl" : "purple",
           "exp" : "purple",
           "awk" : "purple",
           "sed" : "purple",
           "makefile" : "purple",
           "sql" : "aqua",
           "php" : "purple",
           "modula3" : "purple",
           "ml" : "purple",
           "haskell" : "purple",
           "none" : "white"
          }




print "h1. Counted Source Lines of Code (SLOC)"

file = open ( sys.argv[1], "r" )

print "h2. Projects"
line = ""
while line != "SLOC\tDirectory\tSLOC-by-Language (Sorted)\n":
    line = file.readline()

line = file.readline()
while line != "\n":
    num, project, langs = split ( line )
    if int(num) == 0:
        line = file.readline()
        continue

    print "{chart:type=bar|orientation=horizontal|stacked=true|height=75|width=1000} "
    print "||Lines||" + project + "||"
    for lang in split ( langs, "," ):
        l, n = split ( lang, "=" )
        print "||" + l + "|" + n +  "|"
    print "{chart}"
    line = file.readline()


print "h2. Languages"
while line != "Totals grouped by language (dominant language first):\n":
    line = file.readline()

print "||Language||Lines||"
line = file.readline()
while line != "\n":
    lang, lines, per = split ( line )
    lang = lang[:-1]
    print "| {color:" + colors[lang] + "}" + lang + "|" + lines + " " + per + "|"
    line = file.readline()

print "h2. Totals"
while line == "\n":
    line = file.readline()

print "||Description||Result||Notes||"
print "|Total Physical Lines of Code (SLOC):|" + strip(split(line,"=")[1]) + "| |"
line = file.readline()
print "|Estimated development effort:|" + strip(split(line,"=")[1]) + " person-years (person-months) | (Basic COCOMO Model, Person-Months = 2.4 * (KSLOC**1.05))|"
line = file.readline()
line = file.readline()
print "|Schedule estimate:|" + strip(split(line,"=")[1]) + " years (months) | (Basic COCOMO Model, Months = 2.5 * (person-months**0.38))|"
line = file.readline()
line = file.readline()
print "|Total estimated cost to develop:|" + strip(split(line,"=")[1]) + "| (average salary = $56,286/year)|"

file.close()

print "Please credit this data as \"generated using [SLOCCount|http://www.dwheeler.com/sloccount/] by David A. Wheeler.\"\n"
print "Please see the [COCOMO Model|http://en.wikipedia.org/wiki/COCOMO] for more information about the coefficients used in the Basic COCOMO model."
