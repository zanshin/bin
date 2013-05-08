#!/usr/bin/env python

# from http://www.cs.cmu.edu/~benhdj/Mac/unix.html#getIP
# added colorized output from http://www.siafoo.net/snippet/88

import urllib, re, sys, os

# if this changes we need to revise the code to get the external IP
ip_telling_url = 'http://www.dyndns.org/cgi-bin/check_ip.cgi'

if len(sys.argv) == 1:
  # get the external IP
  mo = re.search(r'\d+\.\d+\.\d+\.\d+', urllib.urlopen(ip_telling_url).read())
  if mo:
    print '\033[1;36mext\033[1;m ' + mo.group()
  else:
    print '\033[1;36mext\033[1;m not active'
else:
  # get the internal IP of an interface
  targetInt = sys.argv[1]
  output = os.popen('ipconfig getifaddr %s 2>&1' % targetInt).read().strip()
  if re.match(r'\d+\.\d+\.\d+\.\d+', output):
    print '\033[1;36m' + targetInt + '\033[1;m' + ' ' + output
  else:
    print '\033[1;36m%s\033[1;m not active' % targetInt