#
# Cookbook Name:: system
# Recipe:: users
#
# Copyright 2011, New Edge Engineering Ltd
#

search(:users) do |user|
  log "#{user['username'] & node[:users]['username']}"
  if user['username'] && node[:users]['username']
    log "#{user['username']}"
  end
end
