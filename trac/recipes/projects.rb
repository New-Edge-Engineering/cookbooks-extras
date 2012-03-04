#
# Cookbook Name:: trac
# Definition:: projects
#
# Copyright 2011, New Edge Engineering Ltd
#
# All rights reserved - Do Not Redistribute
#

include_recipe "trac"

if node[:trac][:global]
  template "trac-global-ini" do
    path "#{node[:trac][:global][:dir]}/trac.ini"
    source "trac.ini.erb"
    owner "www-data"
    group "root"
    mode 0775
    variables(
      :trac_project_desc => node[:trac][:global][:description],
      :trac_project_name => node[:trac][:global][:name],
      :trac_mainnav => node[:trac][:global][:mainnav],
      :trac_metanav => node[:trac][:global][:metanav],
      :trac_ldap => node[:trac][:global][:ldap]
    )
  end  
end
  
node[:trac][:projects].each do |project|    
  directory "#{project[:dir]}" do
    owner "root"
    group "root"
    recursive true
  end
  
  execute "trac-#{project[:name]}-admin-initenv" do
    case project[:db][:type]
      when "sqlite"
        command "trac-admin #{project[:dir]}/#{project[:name]} initenv #{project[:name]} sqlite:db/trac.db svn #{project[:repo][:dir]}"
      when "pgsql"
        command "trac-admin #{project[:dir]}/#{project[:name]} initenv #{project[:name]} postgres://#{project[:db][:username]}:#{project[:db][:password]}@localhost:5432/#{project[:db][:name]} #{project[:repo][:type]} #{project[:repo][:dir]}"
    end
    user "root"
    group "root"
    not_if do File.exists?("#{project[:dir]}/#{project[:name]}/conf/trac.ini") end
  end
  
  directory "#{project[:dir]}/#{project[:name]}/apache" do
    owner "root"
    group "root"
    recursive true
  end

  execute "trac-#{project[:name]}-owner-change" do
    command "chown -Rf www-data:root #{project[:dir]}"
  end

  template "trac-#{project[:name]}-ini" do
    path "#{project[:dir]}/#{project[:name]}/conf/trac.ini"
    source "child.ini.erb"
    owner "www-data"
    group "root"
    mode 0775
    variables(
      :trac_header_logo  => project[:header],
      :trac_logging      => project[:logging],
      :trac_notification => project[:notification],
      :trac_project      => {
        :description => project[:description],
        :name        => project[:name],
        :url         => project[:url],
      },
      :trac_repo         => project[:repo],
      :trac              => {
        :backup    => 'backup',
        :database  => project[:db],
        :repo_dir  => project[:repo][:dir],
        :repo_type => project[:repo][:type]
      }
    )
  end
  
  cookbook_file "#{project[:dir]}/#{project[:name]}/apache/trac.wsgi" do
    source "trac.wsgi"
    owner  "www-data"
    group  "root"
    mode   0755
    action :create_if_missing
  end
  
  execute "trac-#{project[:name]}-upgrade" do
    command "trac-admin #{project[:dir]}/#{project[:name]} upgrade"
  end
  Log "#{project[:name]} Trac Project setup at #{project[:dir]}"
end
