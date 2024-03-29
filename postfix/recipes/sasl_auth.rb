#
# Author:: Joshua Timberman(<joshua@opscode.com>)
# Cookbook Name:: postfix
# Recipe:: sasl_auth
#
# Copyright 2009, Opscode, Inc.
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

%w{libsasl2-2  ca-certificates}.each do |pkg|
  package pkg do
    action :install
  end
end

bash "create-cacert.pem" do
  cwd "/etc/postfix"
  code <<-EOH
  cat /etc/ssl/certs/Equifax_Secure_CA.pem >> cacert.pem
  EOH
end

execute "postmap-sasl_passwd" do
  command "postmap /etc/postfix/sasl_passwd"
  action :nothing
end

template "/etc/postfix/sasl_passwd" do
  source "sasl_passwd.erb"
  owner "root"
  group "root"
  mode 0400
  notifies :run, resources(:execute => "postmap-sasl_passwd"), :immediately
  notifies :restart, resources(:service => "postfix")
end

