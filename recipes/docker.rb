# setup prerequisites
include_recipe 'scalr-jenkins::prereq'

node.default['scalr-jenkins']['docker']['dockerinstance'] = true

selinux_state 'disabled' do
  action :disabled
  only_if { centos? }
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
end

# the jekins container user UID is 1000 as is the Ubuntu AMI user
directory '/var/lib/jenkins' do
  owner 'ubuntu'
  group 'ubuntu'
  mode '0755'
  action :create
  recursive true
end

docker_service_manager 'default' do
  host ["tcp://#{node['ipaddress']}:2375", 'unix:///var/run/docker.sock']
  logfile node['scalr-jenkins']['docker']['logfile']
  action :start
end

# create folder to hold the docker build information
directory node['scalr-jenkins']['docker']['build_folder'] do
  owner 'ubuntu'
  group 'ubuntu'
  mode '0755'
  action :create
  recursive true
end

# copy files needed to build image
node['scalr-jenkins']['docker']['build_files'].each do |file|
  cookbook_file "#{node['scalr-jenkins']['docker']['build_folder']}/#{file}" do
    source file
  end
end

# create docker file to add in scalr tools
template "#{node['scalr-jenkins']['docker']['build_folder']}/Dockerfile" do
  source 'Dockerfile.erb'
end

docker_image node['scalr-jenkins']['docker']['imgname'] do
  source node['scalr-jenkins']['docker']['build_folder']
  # tag node['scalr-jenkins']['docker']['regversion']
  action :build_if_missing
end

docker_container node['scalr-jenkins']['docker']['containername'] do
  container_name node['scalr-jenkins']['docker']['containername']
  image node['scalr-jenkins']['docker']['imgname']
  port node['scalr-jenkins']['docker']['portmap']
  tag node['scalr-jenkins']['docker']['regversion']
  binds ['/var/lib/jenkins:/var/jenkins_home']
  restart_policy 'always'
  env ['JAVA_OPTS=-Dhudson.Main.development=true -Djenkins.install.runSetupWizard=false']
  action :run_if_missing
  notifies :delete, "file[#{node['scalr-jenkins']['check_file']}]", :immediately
end

include_recipe 'scalr-jenkins::_jenkinsconfig'
include_recipe 'scalr-jenkins::_jenkins_jobs'
