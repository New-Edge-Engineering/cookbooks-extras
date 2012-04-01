#
# Cookbook Name:: php
# Recipe:: pears
#
# Copyright 2011, New Edge Engineering Ltd
#
# All rights reserved - Do Not Redistribute
#

require_recipe "php"

node[:php][:pears].each do |pear|
  php_pear "#{pear}" do
    action :install
  end
end
