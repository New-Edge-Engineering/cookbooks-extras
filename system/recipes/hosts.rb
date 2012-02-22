#
# Cookbook Name:: imagination
# Recipe:: hosts
#
# Copyright 2011, Imagination
# All rights reserved - Do Not Redistribute
#
include_recipe "hosts"

node[:system][:hosts].each do |data|
  hosts_entry data[:name] do
    ip data[:ip]
    aliases data[:aliases]
    comment data[:comment]
  end
end