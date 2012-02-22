#
# Cookbook Name:: python
# Recipe:: djangos
#
# Copyright 2011, Imagination
# All rights reserved - Do Not Redistribute
#

if node[:python][:djangos]
  node[:python][:djangos].each do |name, data|
    djangos_site name do
      template   data[:template]
      package    data[:settings_package]
      parameters data[:parameters]
    end
    
    if node[:python][:virtualenv][name]
      bash "#{node[:python][:virtualenv][name][:user]}-egg" do
        user node[:python][:virtualenv][name][:user]
        group node[:python][:virtualenv][name][:group]
        cwd node[:python][:virtualenv][name][:dir]
        code <<-EOH
          source #{node[:python][:virtualenv][name][:dir]}/.virtualenvs/#{node[:python][:virtualenv][name][:user]}/bin/activate
          export PYTHONPATH=#{node[:python][:virtualenv][name][:dir]}/etc:$PYTHONPATH
          easy_install -ZU -i #{node[:python][:basket]} #{data[:egg]}
          #{data[:instructions].join("\n")}
        EOH
      end
    end
  end
end