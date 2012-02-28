#
# Cookbook Name:: jenkins
# Recipe:: proxy_apache2
#
# Author:: Fletcher Nichol <fnichol@nichol.ca>
#
# Copyright 2011, Fletcher Nichol
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

include_recipe "apache2"

apache_module "proxy"
apache_module "proxy_http"
apache_module "vhost_alias"

if node[:jenkins][:http_proxy][:www_redirect] == "enable"
  www_redirect = true
  apache_module "rewrite"
else
  www_redirect = false
end

host_name = node[:jenkins][:http_proxy][:host_name] || node[:fqdn]
ssl = node[:jenkins][:http_proxy][:ssl_pem] && node[:jenkins][:http_proxy][:ssl_key] ? true : false

template "#{node.apache.dir}/htpasswd" do
  variables( :username => node.jenkins.http_proxy.basic_auth_username,
             :password => node.jenkins.http_proxy.basic_auth_password)
  owner node.apache.user
  group node.apache.user
  mode 0600
  not_if { ssl }
end

template "#{node[:apache][:dir]}/sites-available/jenkins" do
  source      "apache_jenkins.erb"
  owner       'root'
  group       'root'
  mode        '0644'
  variables(
    :host_name        => host_name,
    :host_aliases     => node[:jenkins][:http_proxy][:host_aliases],
    :listen_ports     => node[:jenkins][:http_proxy][:listen_ports],
    :www_redirect     => www_redirect,
    :ssl              => ssl
  )

  if File.exists?("#{node[:apache][:dir]}/sites-enabled/jenkins")
    notifies  :restart, 'service[apache2]'
  end
end

apache_site "000-default" do
  enable  false
end

apache_site "jenkins" do
  if node[:jenkins][:http_proxy][:variant] == "apache2"
    enable true
  else
    enable false
  end
end

if ssl
  if node[:jenkins][:http_proxy][:state]
    create_ssl_pem "#{node[:jenkins][:http_proxy][:host_name]}" do
      domain node[:jenkins][:http_proxy][:host_name]
      subject "/C=GB/ST=#{node[:jenkins][:http_proxy][:state]}/L=#{node[:jenkins][:http_proxy][:location]}/O=#{node[:jenkins][:http_proxy][:organization]}/OU=Operations/CN=#{node[:jenkins][:http_proxy][:server_name]}/emailAddress=#{node[:jenkins][:http_proxy][:admin_email]}"
    end
  else
    cookbook_file "/etc/ssl/private/#{node[:jenkins][:http_proxy][:host_name]}.key" do
      source "#{node[:jenkins][:http_proxy][:host_name]}.key"
    end
    cookbook_file "/etc/ssl/certs/#{node[:jenkins][:http_proxy][:host_name]}.crt" do
      source "#{node[:jenkins][:http_proxy][:host_name]}.crt"
    end
    cookbook_file "/etc/ssl/certs/#{node[:jenkins][:http_proxy][:host_name]}.pem" do
      source "#{node[:jenkins][:http_proxy][:host_name]}.pem"
    end
  end
  
  template "#{node[:apache][:dir]}/sites-available/jenkins-ssl" do
    source      "apache_jenkins_ssl.erb"
    owner       'root'
    group       'root'
    mode        '0644'
    variables(
      :host_name        => host_name,
      :host_aliases     => node[:jenkins][:http_proxy][:host_aliases],
      :listen_ports     => node[:jenkins][:http_proxy][:listen_ports],
      :www_redirect     => www_redirect,
      :ssl              => ssl
    )
  
    if File.exists?("#{node[:apache][:dir]}/sites-enabled/jenkins-ssl")
      notifies  :restart, 'service[apache2]'
    end
  end
  
  apache_site "jenkins-ssl" do
    if node[:jenkins][:http_proxy][:variant] == "apache2"
      enable true
    else
      enable false
    end
  end
end

