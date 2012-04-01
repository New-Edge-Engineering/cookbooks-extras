#
# Cookbook Name:: php
# Recipe:: pear_channels
#
# Copyright 2011, New Edge Engineering Ltd
#
# All rights reserved - Do Not Redistribute
#

require_recipe "php"

node[:php][:pear_channels].each do |channel|
  php_pear_channel "#{channel}" do
    action :update
  end
end
