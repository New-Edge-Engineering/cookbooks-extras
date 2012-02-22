#
# Cookbook Name:: system
# Recipe:: package
#
# Copyright 2011, Imagination
# All rights reserved - Do Not Redistribute
#

node[:system][:packages].each do |pkg|
  package pkg[:name] do
    if pkg[:version]
      version pkg[:version]
    end
    action :upgrade
  end
end
