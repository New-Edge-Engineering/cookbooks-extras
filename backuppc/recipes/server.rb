#
# Cookbook Name:: backuppc
# Recipe:: server
#
# Copyright 2012, New Edge Engineering Ltd
#

package "backuppc" do
  action :install
end

# Front BackupPC with an HTTP server
case node[:backuppc][:http_proxy][:variant]
when "nginx"
  include_recipe "backuppc::proxy_nginx"
when "apache2"
  include_recipe "backuppc::proxy_apache2"
end