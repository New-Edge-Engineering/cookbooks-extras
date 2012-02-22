#
# Cookbook Name:: postgresql
# Definition:: databases
#
# Copyright 2011, New Edge Engineering Ltd
#
# All rights reserved - Do Not Redistribute
#

require_recipe "postgresql::server"

node[:postgresql][:databases].each do |database|
  create_database "postgresql-create-database" do
    owner    "#{database['owner']}"
    locale   "#{database['locale']}"
    database "#{database['name']}"
  end
end
