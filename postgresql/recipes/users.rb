#
# Cookbook Name :: postgresql
# Definition :: users
#
# Copyright 2011, New Edge Engineering Ltd
#
# All rights reserved - Do Not Redistribute
#

require_recipe "postgresql::server"

node[:postgresql][:users].each do |user|
  create_user "postgresql-creste-user" do
    username "#{user['username']}"
    password "#{user['password']}"
  end
end