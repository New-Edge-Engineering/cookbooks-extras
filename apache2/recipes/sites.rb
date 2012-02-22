#
# Cookbook Name:: nginx
# Recipe:: sites
#
# Copyright 2011, Imagination
# All rights reserved - Do Not Redistribute
#

# sets up sites and locations

node[:apache][:sites].each do |site, data|
  Log "Installing #{site}"
  
  data[:virtualhosts].each do |host|
    if host[:ssl_crt] || host[:ssl_key]
      create_ssl_pem "#{host[:server_name]}" do
        domain host[:server_name]
        subject "/C=GB/ST=#{host[:state]}/L=#{host[:location]}/O=#{host[:organization]}/OU=Operations/CN=#{host[:server_name]}/emailAddress=#{host[:admin_email]}"
      end
    end
  end
  
  template "#{node[:apache][:dir]}/sites-available/#{site}" do
    source "#{data[:template].nil? ? 'apache.site.erb' : data[:template]}"
    if !data[:cookbook].nil?
      cookbook "#{data[:cookbook]}"
    end
    owner "root"
    group "root"
    mode 0644
    variables(
      :virtualhosts => data[:virtualhosts]
    )
    notifies :reload, resources(:service => "apache2"), :delayed
  end
  
  apache_site "#{site}" do
    action :run
  end
end