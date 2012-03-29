#
# Cookbook Name:: nginx
# Definition:: create_sites
#
# Author:: Matthew Green (<matthew@newedgeengineering.com>)
#
# Copyright 2012, New Edge Engineering Ltd
#
# A generic way to create multiple sites with many locations base upon a template.
#

define :nginx_create_site, :template => { :source => "nginx.site.erb", cookbook => nil }, port => 80, :domains => [], :locations => [], :log => "" do
  log "Installing #{params[:nginx_create_site]}"
  template "#{node[:nginx][:dir]}/sites-available/#{site}" do
    source :template[:source]
    if !:template[:cookbook].nil?
      cookbook :template[:cookbook]
    end
    mode 0644
    owner node[:nginx][:user]
    group node[:nginx][:user]
    variables(
      :listen => data[:listen],
      :log => data[:log],
      :hostname => data[:domain],
      :locations => data[:locations])
    notifies :reload, resources(:service => "nginx"), :delayed
  end
  
  nginx_site site do
    action :run
  end 
end