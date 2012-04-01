#
# Cookbook Name:: nginx
# Recipe:: sites
#
# Author:: Matthew Green (<matthew@newedgeengineering.com>)
#
# Copyright 2012, New Edge Engineering Ltd
#
# A generic way to create multiple sites with many locations base upon a template.
#

node[:nginx][:sites].each do |site|
  nginx_create_site site[:name] do
    template  site[:template]
    listen    site[:port]
    domains   site[:domains]
    ssl       site[:ssl]
    locations site[:locations]
    action :run
  end
end