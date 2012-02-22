#
# Author:: Seth Chisamore <schisamo@opscode.com>
# Cookbook Name:: python
# Recipe:: virtualenv
#
# Copyright 2011, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "python::pip"

python_pip "virtualenv" do
  action :install
end

Log "python virtual environment setup..."
if node[:python][:virtualenv]
  node[:python][:virtualenv].each do |name, data|
    Log "Setting up virtualenv for #{name}"
    # create virtualenv owned by user
    python_virtualenv "#{data[:dir]}/.virtualenvs/#{data[:user]}" do
      inherit data[:site_packages]
      owner data[:user]
      group data[:group]
      action :create
      only_if do File.exists?(data[:dir]) end
    end
    
    # may need re-think this a little to support non-virtual environment
    if !data[:packages].nil?
      data[:packages].each do |pkg|
        Log pkg[:name]
        bash "#{pkg[:name]}-installer" do
          user data[:user]
          group data[:group]
          cwd data[:dir]
          code <<-EOH
            source #{data[:dir]}/.virtualenvs/#{data[:user]}/bin/activate
            easy_install -ZUi #{node[:python][:basket]} #{pkg[:name]}
          EOH
        end
      end
    end
  end
end