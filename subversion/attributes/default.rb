#
# Cookbook Name:: subversion
# Attributes:: server
#
# Copyright 2009, Daniel DeLeo
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

default['subversion']['repo_dir']    = '/var/local/lib/svn/repos'
default['subversion']['repos']       = []
default['subversion']['server_name'] = 'svn'
default['subversion']['user']        = 'subversion'
default['subversion']['password']    = 'subversion'

default['subversion']['site']['ip_address']          = '*'
default['subversion']['site']['port']                = '443'
default['subversion']['site']['admin_email']         = "svn@localhost"
default['subversion']['site']['server_name']         = "svn.local"
default['subversion']['site']['server_aliases']      = "localhost"
default['subversion']['site']['ssl_crt']             = "/etc/ssl/cert/public.pem" 
default['subversion']['site']['ssl_key']             = "/etc/ssl/private/private.key"
default['subversion']['site']['auth_name']           = "Authorisation Realm"
default['subversion']['site']['auth_ldap_binddn']    = "cn=admin,dc=organization,dc=com"
default['subversion']['site']['auth_ldap_bind_pass'] = "password"
default['subversion']['site']['auth_ldap_url']       = "ldap://127.0.0.1:389/ou=people,dc=organization,dc=com?uid"

# For Windows
default['subversion']['msi_source'] = "http://downloads.sourceforge.net/project/win32svn/1.7.0/Setup-Subversion-1.7.0.msi"
default['subversion']['msi_checksum'] = "2ee93a3a2c1f9b720917263295466f92cac6058c6cd8af65592186235cf0ed71"
