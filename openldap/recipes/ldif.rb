#
# Cookbook Name:: openldap
# Recipe:: ldif
#
# Copyright (c) 2011 New Edge Engineering Ltd
#
# Permission is hereby granted, free of charge, to any person obtaining a copy 
# of this software and associated documentation files (the "Software"), to deal 
# in the Software without restriction, including without limitation the rights 
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
# copies of the Software, and to permit persons to whom the Software is 
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
# SOFTWARE.

search(:organizations).each do |organization|
  if node[:organizations].include?(organization['id']) && organization['ldap']
    bash "slapadd-#{organization['id']}" do
      user "root"
      code <<-EOH
      /etc/init.d/slapd stop
      slapadd -l /tmp/init-#{organization['id']}.ldif -f /etc/ldap/slapd.conf
      /etc/init.d/slapd start
      EOH
      action :nothing
    end
    
    template "/tmp/init-#{organization['id']}.ldif" do
      source "init.ldif.erb"
      variables(
        :item => organization['ldap'],
        :type => "organization"
      )
      not_if "ldapsearch -xLLL -b \"dc=#{organization['ldap']['domain'].split('.').first},dc=#{organization['ldap']['domain'].split('.').last}\""
      notifies :run, resources(:bash => "slapadd-#{organization['id']}")
    end
    
    if organization['ldap']['units']
      organization['ldap']['units'].each do |unit|
        bash "slapadd-#{organization['id']}-#{unit}" do
          user "root"
          code <<-EOH
          /etc/init.d/slapd stop
          slapadd -l /tmp/init-#{organization['id']}-#{unit}.ldif -f /etc/ldap/slapd.conf
          /etc/init.d/slapd start
          EOH
          action :nothing
        end
        
        template "/tmp/init-#{organization['id']}-#{unit}.ldif" do
          source "init.ldif.erb"
          variables(
            :item => { "unit" => unit, "domain" => organization['ldap']['domain'] },
            :type => "unit"
          )
          not_if "ldapsearch -xLLL -b \"ou=#{unit},dc=#{organization['ldap']['domain'].split('.').first},dc=#{organization['ldap']['domain'].split('.').last}\""
          notifies :run, resources(:bash => "slapadd-#{organization['id']}-#{unit}")
        end
      end
    end
    
  end
end

uidx = 1000
memberships = {}

search(:people).each do |person|
  if node[:people].include?(person['id']) && person['ldap']
    bash "slapadd-#{person['id']}" do
      user "root"
      code <<-EOH
      /etc/init.d/slapd stop
      slapadd -l /tmp/init-#{person['id']}.ldif -f /etc/ldap/slapd.conf
      /etc/init.d/slapd start
      EOH
      action :nothing
    end
    
    person['ldap']['uidn'] = uidx
    template "/tmp/init-#{person['id']}.ldif" do
      source "init.ldif.erb"
      variables(
        :item => person['ldap'],
        :type => "person"
      )
      not_if "ldapsearch -xLLL -b \"uid=#{person['ldap']['uid']},ou=#{person['ldap']['unit']},dc=#{person['ldap']['domain'].split('.').first},dc=#{person['ldap']['domain'].split('.').last}\""
      notifies :run, resources(:bash => "slapadd-#{person['id']}")
    end
    
    person['ldap']['groups'].each do |group|
      if memberships[group].nil?
        memberships[group] = []
      end
      memberships[group].push("uid=#{person['ldap']['uid']},ou=people,dc=#{person['ldap']['domain'].split('.').first},dc=#{person['ldap']['domain'].split('.').last}")
    end
  end
  uidx += 1
end

search(:groups).each do |group|
  if node[:groups].include?(group['id']) && group['ldap']
    group['ldap']['members'] = memberships["cn=#{group['ldap']['name']},ou=#{group['ldap']['unit']},dc=#{group['ldap']['domain'].split('.').first},dc=#{group['ldap']['domain'].split('.').last}"]
    
    bash "slapadd-#{group['id']}" do
      user "root"
      code <<-EOH
      /etc/init.d/slapd stop
      slapadd -l /tmp/init-#{group['id']}.ldif -f /etc/ldap/slapd.conf
      /etc/init.d/slapd start
      EOH
      action :nothing
    end
    
    template "/tmp/init-#{group['id']}.ldif" do
      source "init.ldif.erb"
      variables(
        :item => group['ldap'],
        :type => "group"
      )
      not_if "ldapsearch -xLLL -b \"cn=#{group['ldap']['name']},ou=#{group['ldap']['unit']},dc=#{group['ldap']['domain'].split('.').first},dc=#{group['ldap']['domain'].split('.').last}\""
      notifies :run, resources(:bash => "slapadd-#{group['id']}")
    end
  end
end
