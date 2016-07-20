#!/usr/bin/env ruby
require 'pp'
require 'json'
require 'hashdiff'

# requires VPN for est-config2 access

#######
### EST-CONFIG2-DEV
#######
chef_directory_path = '~/code/chef/omedev/chef-repo'
est_config2_dev = {}

cookbooks = JSON.parse(`cd #{chef_directory_path}; knife raw cookbooks/`)
cookbooks.each do |cookbook|
  est_config2_dev.store(cookbook[0], cookbook[1]['versions'][0]['version'])
end

nodes = JSON.parse(`cd #{chef_directory_path}; knife raw nodes/`)
nodes.each do |node|
  est_config2_dev.store(node[0], node[0])
end

roles = JSON.parse(`cd #{chef_directory_path}; knife raw roles/`)
roles.each do |role|
  role_content = JSON.parse(`cd #{chef_directory_path}; knife raw roles/#{role[0]}`)
  est_config2_dev.store(role[0], role_content)
end

data_bags = `cd #{chef_directory_path}; knife list data_bags/ -1`.split(/\n/).reject(&:empty?)
data_bags.each do |data_bag|
  if data_bag != 'data_bags/users'
    data_bag_items = `cd #{chef_directory_path}; knife list #{data_bag} -1`.split(/\n/).reject(&:empty?)
    data_bag_items.each do |data_bag_item|
      data_bag_content = `cd #{chef_directory_path}; knife show #{data_bag_item}`
      est_config2_dev.store(data_bag_item, data_bag_content)
    end
  end
end

######
### EST-CHEF-DEV
#####
chef_directory_path = '~/code/chef/chef12_omedev/chef-repo'
est_chef_dev = {}

cookbooks = JSON.parse(`cd #{chef_directory_path}; knife raw cookbooks/`)
cookbooks.each do |cookbook|
  est_chef_dev.store(cookbook[0], cookbook[1]['versions'][0]['version'])
end

nodes = JSON.parse(`cd #{chef_directory_path}; knife raw nodes/`)
nodes.each do |node|
  est_chef_dev.store(node[0], node[0])
end

roles = JSON.parse(`cd #{chef_directory_path}; knife raw roles/`)
roles.each do |role|
  role_content = JSON.parse(`cd #{chef_directory_path}; knife raw roles/#{role[0]}`)
  est_chef_dev.store(role[0], role_content)
end

data_bags = `cd #{chef_directory_path}; knife list data_bags/ -1`.split(/\n/).reject(&:empty?)
data_bags.each do |data_bag|
  if data_bag != 'data_bags/users'
    data_bag_items = `cd #{chef_directory_path}; knife list #{data_bag} -1`.split(/\n/).reject(&:empty?)
    data_bag_items.each do |data_bag_item|
      data_bag_content = `cd #{chef_directory_path}; knife show #{data_bag_item}`
      est_chef_dev.store(data_bag_item, data_bag_content)
    end
  end
end

#######
### EST-CONFIG2
#######s
chef_directory_path = '~/code/chef/ome/chef-repo'
cookbooks = JSON.parse(`cd #{chef_directory_path}; knife raw cookbooks/`)

est_config2 = {}
cookbooks.each do |cookbook|
  est_config2.store(cookbook[0], cookbook[1]['versions'][0]['version'])
end

nodes = JSON.parse(`cd #{chef_directory_path}; knife raw nodes/`)
nodes.each do |node|
  est_config2.store(node[0], node[0])
end

roles = JSON.parse(`cd #{chef_directory_path}; knife raw roles/`)
roles.each do |role|
  role_content = JSON.parse(`cd #{chef_directory_path}; knife raw roles/#{role[0]}`)
  est_config2.store(role[0], role_content)
end

data_bags = `cd #{chef_directory_path}; knife list data_bags/ -1`.split(/\n/).reject(&:empty?)
data_bags.each do |data_bag|
  if data_bag != 'data_bags/users'
    data_bag_items = `cd #{chef_directory_path}; knife list #{data_bag} -1`.split(/\n/).reject(&:empty?)
    data_bag_items.each do |data_bag_item|
      data_bag_content = `cd #{chef_directory_path}; knife show #{data_bag_item}`
      est_config2.store(data_bag_item, data_bag_content)
    end
  end
end

#######
### EST-CHEF
#######
chef_directory_path = '~/code/chef/chef12_ome/chef-repo'
cookbooks = JSON.parse(`cd #{chef_directory_path}; knife raw cookbooks/`)

est_chef = {}
cookbooks.each do |cookbook|
  est_chef.store(cookbook[0], cookbook[1]['versions'][0]['version'])
end

nodes = JSON.parse(`cd #{chef_directory_path}; knife raw nodes/`)
nodes.each do |node|
  est_chef.store(node[0], node[0])
end

roles = JSON.parse(`cd #{chef_directory_path}; knife raw roles/`)
roles.each do |role|
  role_content = JSON.parse(`cd #{chef_directory_path}; knife raw roles/#{role[0]}`)
  est_chef.store(role[0], role_content)
end

data_bags = `cd #{chef_directory_path}; knife list data_bags/ -1`.split(/\n/).reject(&:empty?)
data_bags.each do |data_bag|
  if data_bag != 'data_bags/users'
    data_bag_items = `cd #{chef_directory_path}; knife list #{data_bag} -1`.split(/\n/).reject(&:empty?)
    data_bag_items.each do |data_bag_item|
      data_bag_content = `cd #{chef_directory_path}; knife show #{data_bag_item}`
      est_chef.store(data_bag_item, data_bag_content)
    end
  end
end

# compare them
diff = HashDiff.diff(est_config2_dev, est_chef_dev)
diff2 = HashDiff.diff(est_config2, est_chef)
File.new("/tmp/compare.txt", "w+")
File.open("/tmp/compare.txt", "a") { |f|
  f.write("comparing EST-config2-dev to est-chef-dev\n\n")

  diff.each do |a|
    f.write("#{a}\n\n")
  end

  f.write("\n\n\ncomparing EST-config2 to est-chef\n\n")

  diff2.each do |a|
    f.write("#{a}\n\n")
  end
  f.close
}
