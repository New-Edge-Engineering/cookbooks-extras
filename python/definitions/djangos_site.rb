#
# Cookbook Name:: python
# Definition:: djangis_site
#
# Copyright 2011, Imagination
# All rights reserved - Do Not Redistribute
#

define :djangos_site, :template => "", :package => 'imagaination', :parameters => {} do
  template "#{params[:template]}" do
    source "djangos-settings.py.erb"
    owner params[:parameters][:owner]
    variables(
      :package =>        params[:package],
      :debug =>          params[:parameters][:debug],
      :template_debug => params[:parameters][:template_debug],
      :db_engine =>      params[:parameters][:db_engine],
      :db_name =>        params[:parameters][:db_name],
      :db_user =>        params[:parameters][:db_user],
      :db_password =>    params[:parameters][:db_password],
      :db_host =>        params[:parameters][:db_host],
      :db_port =>        params[:parameters][:db_port],
      :media_root =>     params[:parameters][:media_root],
      :media_url =>      params[:parameters][:media_url],
      :static_root =>    params[:parameters][:static_root],
      :static_url =>     params[:parameters][:static_url],
      :admins =>         params[:parameters][:admins],
      :time_zone =>      params[:parameters][:time_zone],
      :site_id =>        params[:parameters][:site_id],
      :languages =>      params[:parameters][:languages],
      :parameters =>     params[:parameters][:app_parameters]
    )
  end
end