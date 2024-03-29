#
# Cookbook Name:: openldap
# Recipe:: server
#
# Copyright 2008-2009, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
include_recipe "openldap::client"

case node[:platform]
when "debian","ubuntu"
  cookbook_file "/var/cache/local/preseeding/slapd.seed" do
    source "slapd.seed"
    mode 0600
    owner "root"
    group "root"
  end
end

package "db4.8-util" do
  action :upgrade
end

cookbook_file "/var/cache/local/preseeding/slapd.seed" do
  source "slapd.seed"
  mode 0600 
  owner "root"
  group "root"
end

package "slapd" do
  case node[:platform]
  when "debian","ubuntu"
    response_file "/var/cache/local/preseeding/slapd.seed"
  end
  action :upgrade
end

if File.exists?("#{node[:openldap][:ssl_dir]}/#{node[:openldap][:server]}.pem")
  cookbook_file "#{node[:openldap][:ssl_dir]}/#{node[:openldap][:server]}.pem" do
    source "ssl/#{node[:openldap][:server]}.pem"
    mode 0644
    owner "root"
    group "root"
  end
end

service "slapd" do
  action [:enable, :start]
end

node[:openldap][:schemas].each do |schema|
  cookbook_file "#{node[:openldap][:dir]}/schema/#{schema['name']}" do
    source "#{schema['file']}"
    cookbook "#{schema['cookbook']}"
    mode "0644"
  end
end

case node[:lsb][:codename]
when "intrepid","jaunty"
  template "/etc/default/slapd" do
    source "default_slapd.erb"
    owner "root"
    group "root"
    mode 0644
  end

  directory "#{node[:openldap][:dir]}/slapd.d" do
    recursive true
    owner "openldap"
    group "openldap"
    action :create
  end
  
  execute "slapd-config-convert" do
    command "slaptest -f #{node[:openldap][:dir]}/slapd.conf -F #{node[:openldap][:dir]}/slapd.d/"
    user "openldap"
    action :nothing
    notifies :start, resources(:service => "slapd"), :immediately
  end
  
  template "#{node[:openldap][:dir]}/slapd.conf" do
    source "slapd.conf.erb"
    mode 0640
    owner "openldap"
    group "openldap"
    notifies :stop, resources(:service => "slapd"), :immediately
    notifies :run, resources(:execute => "slapd-config-convert")
  end
else
  case node[:platform]
  when "debian","ubuntu"
    template "/etc/default/slapd" do
      source "default_slapd.erb"
      owner "root"
      group "root"
      mode 0644
    end
  end
  
  template "#{node[:openldap][:dir]}/slapd.conf" do
    source "slapd.conf.erb"
    mode 0640
    owner "openldap"
    group "openldap"
    notifies :restart, resources(:service => "slapd")
  end
end

