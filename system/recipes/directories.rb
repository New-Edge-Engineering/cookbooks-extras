#
# Cookbook Name:: system
# Recipe:: directory
#
# Copyright 2011, Imagination
# All rights reserved - Do Not Redistribute
#

node[:system][:directories].each do |directory|
  case node[:platform]
  when "debian", "ubuntu"
    directory directory[:path] do
      owner     directory[:owner]
      group     directory[:group]
      mode      directory[:umask]
      recursive true
    end
  end
end
