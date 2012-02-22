# Cookbook Name:: trac
# Attribute :: trac
#
# Copyright 2009 Peter Crossley <peterc@xley.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0c
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
default[:trac]                                       = {}
default[:trac][:global]                              = {}
default[:trac][:global][:name]                       = "Trac Project"
default[:trac][:global][:description]                = ""
default[:trac][:global][:dir]                        = "/etc/trac"
default[:trac][:global][:mainnav]                    = ["wiki","timeline","roadmap","browser","tickets","newticket","search"]
default[:trac][:global][:metanav]                    = ["login","logout","prefs","help","about"]
default[:trac][:global][:ldap][:basedn]              = "dc=organization,dc=com"
default[:trac][:global][:ldap][:bind_passwd]         = "password"
default[:trac][:global][:ldap][:bind_user]           = "cn=admin,dc=organization,dc=com"
default[:trac][:global][:required_groups]            = []
default[:trac][:global][:sections]                   = {} # the ini file sections
default[:trac][:global][:sections][:account_manager] = true
default[:trac][:projects]                            = {}
# apache2site attributes, deprecated in favour of projects.
default[:trac][:project_name]        = "Code :: Trac"
default[:trac][:project_description] = ""
default[:trac][:basedir]             = "/srv/trac"
default[:trac][:mainnav]             = ["wiki","timeline","roadmap","browser","tickets","newticket","search"]
default[:trac][:metanav]             = ["login","logout","prefs","help","about"]
default[:trac][:vhosts]              = fqdn
default[:trac][:required_groups]     = []
default[:trac][:svn_dir]             = "/srv/svn/code-trac"
default[:trac][:svn_branches]        = [""]
default[:trac][:svn_tags]            = [""]
