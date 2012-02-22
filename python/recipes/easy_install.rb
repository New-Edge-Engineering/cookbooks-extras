#
# Cookbook Name:: python
# Definition:: easy_install
#
# Copyright 2011, New Edge Engineering Ltd
#
# All rights reserved - Do Not Redistribute
#

# Python easy_install process

node[:python][:easy_install].each do |package|
  bash "easy-install-#{package[:name]}" do
    user  package[:user]
    group package[:group]
    cwd   package[:dir]
    code <<-EOH
      #{package[:virtualenv].nil? || package[:virtualenv].empty? ? '' : 'source '+package[:virtualenv]+'/bin/activate'}
      easy_install -ZU#{node[:python][:package_index].nil? || node[:python][:package_index].empty? ? '' : 'i '+node[:python][:package_index]}#{package[:options].nil? || package[:options].empty? ? '' : ' '+package[:options]} #{package[:name]}#{package[:version].nil? || package[:version].empty? ? '' : '=='+package[:version]}
    EOH
  end
end