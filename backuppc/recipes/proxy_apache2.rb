#
# Cookbook Name:: backuppc
# Recipe:: default
#
# Copyright 2012, New Edge Engineering Ltd
#

include_recipe "apache2"

apache_module "proxy"
apache_module "proxy_http"
apache_module "vhost_alias"

host_name = node[:backuppc][:http_proxy][:host_name] || node[:fqdn]

# Update the username and password
template "#{node[:backuppc][:config_dir]}/htpasswd" do
  variables(
    :username => node[:backuppc][:http_proxy][:basic_auth_username],
    :password => node[:backuppc][:http_proxy][:basic_auth_password]
  )
  owner node[:backuppc][:user]
  group node[:apache][:group]
  mode 0644
end

if node[:backuppc][:http_proxy][:ssl_crt] && node[:backuppc][:http_proxy][:ssl_key]
  cookbook_file "/etc/ssl/private/#{node[:backuppc][:http_proxy][:host_name]}.key" do
    source "#{node[:backuppc][:http_proxy][:ssl_key]}"
  end
  cookbook_file "/etc/ssl/certs/#{node[:backuppc][:http_proxy][:host_name]}.crt" do
    source "#{node[:backuppc][:http_proxy][:ssl_crt]}"
  end
else
  create_ssl_pem "#{node[:backuppc][:http_proxy][:host_name]}" do
    domain node[:backuppc][:http_proxy][:host_name]
    subject "/C=GB/ST=#{node[:backuppc][:http_proxy][:state]}/L=#{node[:backuppc][:http_proxy][:location]}/O=#{node[:backuppc][:http_proxy][:organization]}/OU=Operations/CN=#{node[:backuppc][:http_proxy][:server_name]}/emailAddress=#{node[:backuppc][:http_proxy][:admin_email]}"
  end
  node[:backuppc][:http_proxy][:ssl_key] = "/etc/ssl/private/#{node[:backuppc][:http_proxy][:host_name]}.key"
  node[:backuppc][:http_proxy][:ssl_crt] = "/etc/ssl/certs/#{node[:backuppc][:http_proxy][:host_name]}.crt"
end

template "#{node[:apache][:dir]}/sites-available/backuppc-ssl" do
  source      "backuppc_apache2.erb"
  owner       'root'
  group       'root'
  mode        '0644'
  variables(
    :host_name    => host_name,
    :host_aliases => node[:backuppc][:http_proxy][:host_aliases],
    :ssl_crt      => node[:backuppc][:http_proxy][:ssl_crt],
    :ssl_key      => node[:backuppc][:http_proxy][:ssl_key],
    :shared_dir   => node[:backuppc][:shared_dir],
    :config_dir   => node[:backuppc][:config_dir],
    :realm        => node[:backuppc][:http_proxy][:auth_realm]
  )

  if File.exists?("#{node[:apache][:dir]}/sites-enabled/backuppc-ssl")
    notifies  :restart, 'service[apache2]'
  end
end

apache_site "backuppc-ssl" do
  if node[:backuppc][:http_proxy][:variant] == "apache2"
    enable true
  else
    enable false
  end
end