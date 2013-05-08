#!/usr/bin/env ruby 
# Simple script to send you email when someone unfollows you on twitter.
#
# Replace email on line 24 with the email you want to receive notifications at, and 
# twitter handle on line 23 with your own (or whomever you want to track unfollows for).
#
# Set up a crontab to check however often you like. If someone follows and then unfollows you
# very quickly (within the interval), you won't get an email.
#
# Requires that you can send mail from the command line of the environment where 
# you're running the script using mailx, e.g. `echo "body" | mailx -s "subject" foo@bar.com
# 
# If that's not the case, see http://www.macosxhints.com/article.php?story=20081217161612647
#
# The script will create a file, "followers.csv" in the working directory - that file must
# remain there in order to do the comparison. 
# 
# If you find this useful, follow me on twitter @andrewpbrett. If you unfollow me, I won't
# be offended - but I will know about it :-)
#
# This thing was written, tested, and gisted in all of about 30 minutes, so anyone is free to 
# improve, copy etc. and use for any purpose, free of charge.
 
require 'rubygems'
require 'hpricot'
require 'open-uri'
 
username = "zanshin"
email = "mark@zanshin.net"
 
def get_followers(username, cursor = -1)
  start_url = "http://twitter.com/statuses/followers/#{username}.xml?cursor=#{cursor}"
  followers = []
  doc = Hpricot::XML(open(start_url))
  (doc/:user/:screen_name).each do |u|
    followers << u.inner_html
  end
  cursor = (doc/:next_cursor).inner_html.to_s.strip
  if cursor != "0"
    followers += get_followers(username, cursor)
  end
  return followers
end
 
begin
  doc = open("followers.csv")
rescue
  File.open("followers.csv", 'w') {|f| f.write(get_followers(username).join(',')) }
  doc = open("followers.csv")
end
 
commas = doc.read
previous_followers = commas.split(',')
current_followers = get_followers(username)
 
unfollowers = previous_followers - current_followers
 
if !unfollowers.empty?
  `echo "These users have just unfollowed you on twitter: " + 
  "#{unfollowers.join(', ')}" | mailx -s "You've been unfollowed!" #{email}`
end
 
File.open("followers.csv", 'w') {|f| f.write(get_followers(username).join(',')) }