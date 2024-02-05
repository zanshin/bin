#!/usr/bin/env knife exec

# A knife exec script to change chef node's name, preserving all the attributes.
#
# Usage: knife exec rename-node.rb old-name new-name
#
# Script retrieves the Node object, changes its 'name' attribute,
# creates new Node object with updated name and rest of attributes
# untouched. Then it deletes old Node and Client objects from
# database, and logs into the server to update it:
#  - copy validation.pem from the local .chef directory
#  - remove client.pem
#  - comment out node_name from client.rb
#  - delete "name":"[^"]*" entry from attributes.json if file exists
#  - delete attributes.json if empty
#  - run chef-client -N new_id to re-register client
#
# Script makes a few assumptions that may be different in your setup:
#  - that you keep validation.pem locally in .chef/
#  - that you generate client.rb including client_name during chef-client run
#  - that you may have attributes.json file and it is not pretty-printed (no extra spaces)
#  - that chef-client will run with or without attributes.json file
#
# To sum up, you will probably want to review the script and adapt
# parts of it to match your setup, especially shell script part near
# the bottom (here-doc for ssh.exec! invocation).
#
# Based on:
#  - http://tech.superhappykittymeow.com/?p=292
#  - http://help.opscode.com/discussions/questions/130-rename-a-node
#  - http://lists.opscode.com/sympa/arc/chef/2011-05/msg00196.html

abort("usage: ./bin/knife exec #{ARGV[1]} from_id to_id") unless ARGV[3]

require 'net/ssh'
require 'net/scp'

from_id = ARGV[2]
to_id = ARGV[3]

puts "Loading node #{from_id}..."
orig_node = Chef::Node.load(from_id)
node_data = JSON.parse(orig_node.to_json, create_id: nil)

puts "Changing name attribute to #{to_id}..."
node_data['name'] = to_id
node_data.values
         .select { |v| v.is_a?(Hash) and v['name'] }
         .each { |v| v['name'] = to_id }

puts 'Saving modified node...'
# without :create_id => nil JSON::parse will create an actual instance

# new_node = JSON::parse(JSON::dump(node_data))
# JSON::parse fails with "NoMethodError: undefined method `save' for #<Hash:0x007fec1c62df30>"
# Using Chef::JSONCompat.from_json instead
# new_node = Chef::JSONCompat.from_json(JSON::dump(node_data))
new_node = Chef::Node.from_hash(node_data)
new_node.save

unless ENV['KEEP_IT_SAFE']
  puts "Deleting node #{from_id}..."
  orig_node.destroy
  puts "Deleting client #{from_id}..."
  Chef::ApiClient.load(from_id).destroy
end

puts 'Logging into node...'
Net::SSH.start(new_node['fqdn'], Chef::Config[:knife][:ssh_user]) do |ssh|
  puts 'Uploading validation.pem...'
  ssh.scp.upload!("#{File.expand_path('~')}/.chef/zome.pem", '/tmp/validation.pem')
  puts 'Running update script...'
  ssh.exec! <<~EOF do |_ch, stream, data|
    set -e -x
    cd /etc/chef
    sudo mv -v /tmp/validation.pem .
    sudo rm -v client.pem
    sudo sed -i~rename '/node_name/s/^/# /' client.rb
    if [ -f attributes.json ] ; then
      sudo sed -i~rename 's/"name":"[^"]*",*//' attributes.json
      [ `sudo cat attributes.json` = '{}' ] && sudo rm -v attributes.json
      [ -f attributes.json ] && sudo cat attributes.json
    fi
    sudo chef-client -N #{to_id}
    sudo rm -v /etc/chef/validation.pem
  EOF
    if stream == :stderr
      STDERR.write data
      STDERR.flush
    else
      STDOUT.write data
      STDOUT.flush
    end
  end
end

puts 'Done!'
exit 0
# http://wiki.opscode.com/display/chef/Knife+Exec#KnifeExec-PassingArgumentstoKnifeScripts

### Copyright (C) 2012 Maciej Pasternacki <maciej@pasternacki.net>
###
###            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
###                    Version 2, December 2004
###
### Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>
###
### Everyone is permitted to copy and distribute verbatim or modified
### copies of this license document, and changing it is allowed as long
### as the name is changed.
###
###            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
###   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
###
###  0. You just DO WHAT THE FUCK YOU WANT TO.
