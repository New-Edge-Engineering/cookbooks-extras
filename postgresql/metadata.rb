maintainer        "New Edge Engineering Ltd"
maintainer_email  "cookbooks@newedgeengineering.com"
license           "Apache 2.0"
description       "Installs and configures postgresql for clients or servers"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.0.1"
recipe            "postgresql", "Includes postgresql::client"
recipe            "postgresql::client", "Installs postgresql client package(s)"
recipe            "postgresql::server", "Installs postgresql server packages, templates"
recipe            "postgresql::server_redhat", "Installs postgresql server packages, redhat family style"
recipe            "postgresql::server_debian", "Installs postgresql server packages, debian family style"
recipe            "postgresql::users", "Creates roles that don't exist"
recipe            "postgresql::databases", "Creates databases that don't exist"

%w{rhel centos fedora ubuntu debian suse}.each do |os|
  supports os
end
