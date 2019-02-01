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

# install gems
 %w(kitchen-scalr).each do |gempkg|
  chef_gem gempkg do
    options "--no-user-install"
  end
end

# install docker
docker_installation 'default' do
  version node['scalr-jenkins']['docker']['version']
  action :create
end

# need to add a check for UID 1000 if it doesn't exist create it
# create a local jenkins user for the jobs recipe
user 'jenkins' do
  # gid node['cookbook_name']['group']
  shell '/bin/bash'
  home '/home/jenkins'
  action :create
end if ubuntu?

# the jekins container user UID is 1000 as is the Ubuntu AMI user
directory '/var/lib/jenkins' do
  owner 'ubuntu'
  group 'ubuntu'
  mode '0755'
  action :create
  recursive true
end if ubuntu?

docker_service_manager 'default' do
  host ["tcp://#{node['ipaddress']}:2375", 'unix:///var/run/docker.sock']
  logfile node['scalr-jenkins']['docker']['logfile']
  action :start
end

# add jenkins user to docker group
group 'docker' do
  action :modify
  members 'jenkins'
  append true
end
