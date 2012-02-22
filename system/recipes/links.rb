#
# Cookbook Name:: system
# Recipe:: directory
#
# Copyright 2011, Imagination
# All rights reserved - Do Not Redistribute
#

node[:system][:links].each do |lnk|
  case node[:platform]
  when "debian", "ubuntu"
    link lnk[:target] do
      to lnk[:source]
      owner (!lnk[:owner].nil? && !lnk[:owner].empty? ? lnk[:owner] : "root" )
      group (!lnk[:group].nil? && !lnk[:group].empty? ? lnk[:group] : "root" )   
    end
  end
end
