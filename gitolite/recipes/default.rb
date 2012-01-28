#
# Cookbook Name:: gitolite
# Recipe:: default
#
# Copyright 2010, RailsAnt, Inc.
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
#
::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
include_recipe "git::default"

node.set_unless['gitolite']['password'] = secure_password
user "git" do
  comment "Git User"
  home "/home/git"
  shell "/bin/bash"
  password node[:gitolite][:password]
end

directory "/home/git" do
  owner "git"
  group "git"
  mode "0755"
end

git "/home/git/gitolite" do
  repository node[:gitolite][:repository_url]
  reference "master"
  action :sync
  user "git"
end
execute "ssh-keygen -q -f /home/git/.ssh/id_rsa -N \"\" " do
  user "git"
  action :run
  not_if {File.exist? '/home/git/.ssh/id_rsa.pub'}
end
execute "cp /home/git/.ssh/id_rsa.pub /home/git/.ssh/authorized_keys" do
  user "git"
  not_if {File.exist? '/home/git/.ssh/authorized_keys'}
end
execute "./gl-system-install" do
  ignore_failure true
  user "git"
  group "git"
  environment ({'HOME' => '/home/git', 'PATH' => '/home/git/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'})
  cwd "/home/git/gitolite/src"
  not_if {File.exists?("/home/git/repositories") }
  return [0,1]
end

search(:users) do |user|
  if user["ssh"]
    (user["ssh"]).each do |key, value|
      template "/home/git/#{key}" do
        source "id_rsa.pub"
        variables(
          :pub => "#{value}"
        )
      end
    end
  end
end
