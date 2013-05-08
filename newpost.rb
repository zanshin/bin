#!/usr/bin/env ruby
#
# newpost.rb new-post-title
#
# Author: Mark Nichols, 8/2011
#
# This script automates the process of creating a new Octopress posting.
# 1. The Octopress rake new_post task is called passing in the posting name
# 2. The Octopress rake isolate taks is called to sequester all other postings in the _stash
# 3. The new file is opened in TextMate
#
# This script requires one parameters and relies on one assumption:
# - the script assumes it is being run at the root of your Octopress installation
# - the script needs the title of the new posting to be created. The title needs to be quote delimited as it 
#   may contain spaces.
#
# A symbolic link of `Rakefile.rake` that points to the provided `Rakefile` needs to be created.
#
# who when        what
# mhn 2012-01-12  initial version of script
# mhn 2013-01-27  updated to use Dir.pwd to grab current working location

require 'rake'

# where your Octopress Rakefile lives...
#WEBLOG = ARGV[0]
#BLOG_DIR = "/Users/mark/Projects/octopress/#{WEBLOG}"
BLOG_DIR = Dir.pwd
POST_DIR = "#{BLOG_DIR}/source/_posts"

# build the rake new_post command
#new_title = '"' + ARGV[1] + '"'
new_title = ARGV[0]
rake_new_post = "new_post[#{new_title}]"

puts "Running: " + rake_new_post + " in "+ BLOG_DIR

# stuff to capture output
def capture_stdout
  s = StringIO.new
  oldstdout = $stdout
  $stdout = s
  yield
  s.string
ensure
  $stdout = oldstdout
end

Dir.chdir(BLOG_DIR) do
  # setup rake and then create a new_post
  Rake.application.init
  Rake.application.rake_require("Rakefile", paths=["#{BLOG_DIR}"])
  new_result = capture_stdout {Rake.application.invoke_task("#{rake_new_post}")}
  puts new_result
  
  # parse the new_post result into the file name, isolate it, and open it for editing
  title_slug = new_result.split("/")
  new_post = title_slug[2].strip
  rake_isolate = "isolate[#{new_post}]"
  puts "Running: " + rake_isolate
  isolate_result = capture_stdout {Rake.application.invoke_task("#{rake_isolate}")}
  puts "Posting created and isolated, opening in editor..."
  exec "subl -n #{POST_DIR}/#{new_post}"
end
