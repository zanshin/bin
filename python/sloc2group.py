#!/usr/bin/env python
# Written by Rasmus Toftdahl Olesen <rto@pohldata.dk>
# Modified slightly by David A. Wheeler
# Released under the GNU General Public License v. 2 or higher
#
# added colors for additional languages, 20090327 mhn
from string import *
import sys

NAME = "sloc2html"
VERSION = "0.0.2"
	
if len(sys.argv) != 2:
    print "Usage:"
    print "\t" + sys.argv[0] + " <sloc output file>"
    print "\nThe output of sloccount should be with --wide and --multiproject formatting"
    sys.exit()

colors = { "java" : "#ffe4c4",
           "xml" : "#6495ed",
           "jsp" : "#98fb98",
           "properties" : "#afeeee",
           "html" : "#fa8072",
           "sql" : "#d2b48c",
           "css" : "#d8bfd8",
           "js" : "#d87093",
           "sh" : "#f08080",
           "perl" : "#87ceeb",
           "ansic" : "#eee8aa",
           # Feel free to make more specific colors.
           "python" : "blue",
           "cpp" : "green",
           "yacc" : "brown",
           "ruby" : "maroon",
           "lisp" : "fuchsia",
           "objc" : "purple",
           "asm" : "purple",
           "csh" : "purple",
           "tcl" : "purple",
           "exp" : "purple",
           "awk" : "purple",
           "sed" : "purple",
           "makefile" : "purple",
           "php" : "purple",
           "modula3" : "purple",
           "ml" : "purple",
           "haskell" : "purple",
           "none" : "white"
          }



print "<html>"
print "<head>"
print "<title>Counted Source Lines of Code (SLOC)</title>"
print "<style type=\"text/css\">"
print "<!-- "
print "h1 { font-weight: bold; font-size: 20px; font-family: Times; }"
print "h2 { font-weight: bold; line-height: 20px; font-size: 15px; font-family: Verdana; margin: 20px 0 0 0; }"
print "p  { font-famiily: Verdana; font-size: 10px; line-height: 20px;}"
print "td { padding: 0 10px 0 5px; color: black; font-family: Verdana; font-size: 10px; line-height: 20px; border-bottom: #ddd; border-width: 0 0 1px 0; border-style: none none solid none; }"
print "th { font-weight: bold; border-bottom: #ddd; border-width: 0 0 2px 0; border-style: none none double none; } "
print " -->"
print "</style>"
print "</head>"
print "<body>"
print "<h1>Counted Source Lines of Code</h1>"

file = open ( sys.argv[1], "r" )

print "<h2>Projects</h2>"
line = ""
while line != "SLOC\tDirectory\tSLOC-by-Language (Sorted)\n":
    line = file.readline()

print "<table>"
print "<tr><th>Lines</th><th>Project</th><th>Language distribution</th></tr>"
line = file.readline()
while line != "\n":
    num, project, langs = split ( line )
    if int(num) == 0:
        line = file.readline()
        continue

    print "<tr><td>" + num + "</td><td><a href=\"" + project + ".html\">" + project + "</a></td><td>"
    print "<table width=\"1000\"><tr>"
    for lang in split ( langs, "," ):
        l, n = split ( lang, "=" )
        print "<td bgcolor=\"" + colors[l] + "\" width=\"" + str( float(n) / float(num) * 1000 ) + "\">" + l + "=" + n + "&nbsp;" + str(int(float(n) / float(num) * 100)) + "%</td>"
    print "</tr></table>"
    print "</td></tr>"
    line = file.readline()
print "</table>"

print "<h2>Languages</h2>"
while line != "Totals grouped by language (dominant language first):\n":
    line = file.readline()

print "<table>"
print "<tr><th>Language</th><th>Lines</th></tr>"
line = file.readline()
while line != "\n":
    lang, lines, per = split ( line )
    lang = lang[:-1]
    print "<tr><td bgcolor=\"" + colors[lang] + "\">" + lang + "</td><td>" + lines + " " + per + "</td></tr>"
    line = file.readline()
print "</table>"

print "<h2>Totals</h2>"
while line == "\n":
    line = file.readline()

print "<table>"
print "<tr><td><strong>Total Physical Lines of Code (SLOC):</strong></td><td>" + strip(split(line,"=")[1]) + "</td><td>&nbsp;</td></tr>"
line = file.readline()
print "<tr><td><strong>Estimated development effort:</strong></td><td>" + strip(split(line,"=")[1]) + " person-years (person-months)</td><td>(Basic COCOMO Model, Person-Months = 2.4 * (KSLOC**1.05))</td></tr>"
line = file.readline()
line = file.readline()
print "<tr><td><strong>Schedule estimate:</strong></td><td>" + strip(split(line,"=")[1]) + " years (months)</td><td>(Basic COCOMO Model, Months = 2.5 * (person-months**0.38))</td></tr>"
line = file.readline()
line = file.readline()
#print "<tr><td>Total estimated cost to develop:</td><td>" + strip(split(line,"=")[1]) + " (average salary = $56,286/year)</td></tr>"
print "</table>"

file.close()

print "<h2>Notes</h2>"
print "<p>The original <a href=\"http://www.dwheeler.com/sloccount/\">SLOCCount</a> was created by David A. Wheeler.</p>"
print "<p>Please see the <a href=\"http://en.wikipedia.org/wiki/COCOMO\" title=\"COCOMO Model\">COCOMO Model</a> for more information about the coefficients used in the Basic COCOMO model.</p>"
print "</body>"
print "</html>"