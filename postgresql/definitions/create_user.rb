#
# Cookbook Name:: postgresql
# Definition:: create_user
#
# Copyright 2011, New Edge Engineering Ltd
#
# All rights reserved - Do Not Redistribute
#

define :create_user, :username => "", :password => "" do
  # create users
  execute "postgres-create-users" do
      command "psql --command \"CREATE ROLE #{params[:username]} LOGIN PASSWORD '#{params[:password]}' NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE;\""
      group "postgres"
      user "postgres"
      ignore_failure true
      action :run
  end
end