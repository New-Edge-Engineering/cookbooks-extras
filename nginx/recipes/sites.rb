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

include_recipe "nginx"

node[:nginx][:sites].each do |site|
  log "creating #{site[:name]}"
  nginx_create_site "#{site[:name]}" do
    template  site[:template]
    listen    site[:port]
    domains   site[:domains]
    ssl       site[:ssl]
    docments  site[:root]
    locations site[:locations]
    action :run
  end
end