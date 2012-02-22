#
# Cookbook Name:: python
# Recipe:: memcache
#
# Copyright 2011, Imagination
# All rights reserved - Do Not Redistribute
#

["python-memcache", "python-pylibmc" ].each do |pkg|
  package pkg do
    action :upgrade
  end
end
