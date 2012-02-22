#
# Cookbook Name:: postgresql
# Definition:: create_database
#
# Copyright 2011, New Edge Engineering Ltd
#
# All rights reserved - Do Not Redistribute
#

define :create_database, :owner => "postgres", :locale => "en_US.utf8", :database => "" do
  execute "postgres-create-database" do
    command "createdb --encoding UTF8 --locale #{params[:locale]} --owner #{params[:owner]} --template template0 #{params[:database]}"
    group "postgres"
    user "postgres"
    ignore_failure true
    action :run
  end
end