include_recipe 'chef_sugar'
include_recipe 'apt::default' if ubuntu?

# install java for jenkins install
include_recipe 'java::default'

# setup the verify file for security
file node['scalr-jenkins']['check_file'] do
  owner 'root'
  group 'root'
  mode '0600'
  action :nothing
end

# setup NTP
# include_recipe 'ntp::default'

# install jenkins
# include_recipe 'jenkins::master'
