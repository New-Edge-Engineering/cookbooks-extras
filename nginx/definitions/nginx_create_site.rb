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

define :nginx_create_site, :template => { :source => "nginx.site.erb", :cookbook => nil }, :listen => 80, :domains => [], :ssl => [], :locations => [], :log => "" do
  log "Installing #{params[:nginx_create_site]}"
  template "#{node[:nginx][:dir]}/sites-available/#{params[:nginx_create_site]}" do
    source params[:template][:source]
    if !params[:template][:cookbook].nil?
      cookbook params[:template][:cookbook]
    end
    mode 0644
    owner node[:nginx][:user]
    group node[:nginx][:user]
    variables(
      :listen => params[:listen],
      :domains => params[:domains],
      :log => params[:nginx_create_site],
      :ssl => params[:ssl],
      :locations => params[:locations])
    notifies :reload, resources(:service => "nginx"), :delayed
  end
  
  nginx_site params[:nginx_create_site] do
    action :run
  end 
end