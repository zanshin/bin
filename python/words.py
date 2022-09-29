#!/usr/bin/python
import os
import re
import sys
import getopt

def main(argv):

    # path = '/path/to/jekyll/posts/'
    #path = '/Users/mark/Projects/octopress/solfege/source/_posts/'
    dirpath = '/Users/mark/code/'
    # site = 'zanshin'
    site = 'blog'
    posts = '/_posts/'
    
    try:
        opts, args = getopt.getopt(sys.argv,"hs:",["sitename="])
    except getopt.GetoptError:
        print "words.py -s <sitename>"
        sys.exit(2)

    for opt, arg in opts:
        if opt in ('-h'):
            print "words.py -s <sitename>"
            sys.exit()
        elif opt in ("-s", "--sitename"):
            site = arg 

    wordCount = 0
    path = dirpath+site+posts
     
    # Regex to match YAML front matter and everything after it
    regex = re.compile("(?s)(---.*---)(.*)")

    # Iterate through all posts
    for post in os.listdir(path):
        f = open(path+post, "r")
        result = re.match(regex, f.read())
        # Count words in everything after YAML front matter
        wordCount += len(result.group(2).split())
    print "{:,}".format(wordCount) + " words!"

if __name__ == "__main__":
    main(sys.argv[1:])
