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
  
  if data[:modules]
    data[:modules].each do |mod|
      apache_module "#{mod}"
    end
  end
  
  data[:virtualhosts].each do |host|
    if host[:ssl_crt] && host[:ssl_key]
      cookbook_file "/etc/ssl/private/#{host[:ssl_key]}" do
        source "#{:ssl_key}"
      end
      cookbook_file "/etc/ssl/certs/#{host[:ssl_crt]}" do
        source "#{host[:ssl_crt]}"
      end
    else
      create_ssl_pem "#{host[:server_name]}" do
        domain host[:server_name]
        subject "/C=GB/ST=#{host[:state]}/L=#{host[:location]}/O=#{host[:organization]}/OU=Operations/CN=#{host[:server_name]}/emailAddress=#{host[:admin_email]}"
        host[:ssl_key] = "/etc/ssl/private/#{host[:server_name]}.key"
        host[:ssl_crt] = "/etc/ssl/certs/#{host[:server_name]}.crt"
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