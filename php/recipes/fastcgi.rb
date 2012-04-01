#
# Cookbook Name:: php
# Recipe:: fastcgi
#
# Copyright 2011, New Edge Engineering Ltd
#
# All rights reserved - Do Not Redistribute
#

require_recipe "php"

template "/etc/init.d/php-fcgi" do
  source "php-fcgi.erb"
  group "root"
  owner "root"
  mode 0755
  variables(
    :user => node['php']['fpm_user']
  )
end

service "php-fcgi" do
  supports :restart => true
  action :start
end
