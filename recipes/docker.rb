# setup prerequisites
include_recipe 'scalr-jenkins::prereq'

node.default['scalr-jenkins']['docker']['dockerinstance'] = true

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
