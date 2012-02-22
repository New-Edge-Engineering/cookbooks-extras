#
# Cookbook Name:: system
# Definition:: locale
#
# Copyright 2011, New Edge Engineering Ltd
#
# All rights reserved - Do Not Redistribute
#

bash "generate-all-locale" do
  user    "root"
  group   "root"
  code <<-EOH
    locale-gen #{node[:system][:locale].nil? || node[:system][:locale].empty? ? '' : node[:system][:locale]}
    #{node[:system][:locale].nil? || node[:system][:locale].empty? ? '' : 'update-locale LANG='+node[:system][:locale]+' LC_ALL="'+node[:system][:locale]+'"'}
  EOH
end
