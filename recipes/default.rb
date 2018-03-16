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
include_recipe 'ntp::default'

# instal pip
node['scalr-jenkins']['packages'].each do |ospkg|
  package ospkg
end

# install required external tools
node['scalr-jenkins']['tools'].each do |pkg|
  execute 'install pip_pkg' do
    cwd Chef::Config[:file_cache_path]
    command "pip install #{pkg}"
  end
end

# install jenkins
include_recipe 'jenkins::master'
include_recipe 'scalr-jenkins::_jenkinsconfig'
include_recipe 'scalr-jenkins::_jenkins_jobs'
