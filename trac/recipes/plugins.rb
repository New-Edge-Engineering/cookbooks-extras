#
# Cookbook Name:: trac
# Definition:: plugins
#
# Copyright 2011, New Edge Engineering Ltd
#
# All rights reserved - Do Not Redistribute
#

include_recipe "trac"

node[:trac][:plugins].each do |plugin|
  easy_install_package "#{plugin[:name]}" do
    if plugin[:version]
      version plugin[:version]
    end
    if plugin[:options]
      options "#{plugin[:options]}"
      action :install
    else
      action :upgrade
    end
  end
end