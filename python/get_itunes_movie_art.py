import urllib, urllib2
import json
import webbrowser

SEARCH_URL = "http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/wa/wsSearch?entity=movie&term="

def get_art():
    term = raw_input("Enter movie title: ")
    term = urllib.quote_plus(term)

    response = urllib2.urlopen("%s%s" % (SEARCH_URL, term))
    results = json.load(response)

    if results['resultCount'] > 0:
        for index, result in enumerate(results['results']):
            print "%s. %s" % (index+1, result['trackName'])
        which = raw_input("Enter the number of the movie you want to use: ")
        try:
            which = int(which) - 1
        except:
            which = None
        if which != None:
            url = results['results'][which]['artworkUrl100'].replace("100x100-75.", "")
            webbrowser.open(url)
    else:
        print "No results found"
    
    get_art()

if __name__ == "__main__":
    get_art()