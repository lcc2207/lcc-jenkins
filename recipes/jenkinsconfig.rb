if File.exist?(node['scalr-jenkins']['check_file'])
  # node.run_state[:jenkins_username] = node['scalr-jenkins']['jenkins']['adminuser']
  # node.run_state[:jenkins_password] = data_bag_item(node['scalr-jenkins']['users']['data_bag'], node['scalr-jenkins']['jenkins']['adminuser'])['password']
  node.run_state[:jenkins_private_key] = data_bag_item(node['scalr-jenkins']['users']['data_bag'], node['scalr-jenkins']['jenkins']['adminuser'])['private_key']
end

# pull users databag
users = data_bag(node['scalr-jenkins']['users']['data_bag'])

# create the base users
users.each do |user|
  dbuser = data_bag_item(node['scalr-jenkins']['users']['data_bag'], user)
  jenkins_user dbuser['id'] do
    retries 2
    retry_delay 60
    full_name dbuser['full_name']
    email dbuser['email']
    password dbuser['password']
    public_keys [dbuser['public_keys']]
  end
end

# Add extra executors
jenkins_script 'Add executors' do
  command <<-EOH.gsub(/^ {4}/, '')
  import jenkins.model.*
  def instance = Jenkins.getInstance()
    instance.setNumExecutors(4)
    instance.save()
  EOH
end

# get jenkins plugin updates
execute 'get-update-json' do
  command "curl -L http://updates.jenkins-ci.org/update-center.json | sed '1d;$d' | curl -X POST -H 'Accept: application/json' -d @- #{node['jenkins']['master']['endpoint']}/updateCenter/byId/default/postBack"
  action :run
end

# setup the verify file for plugins
file node['scalr-jenkins']['plugins_file'] do
  owner 'root'
  group 'root'
  mode '0600'
  action :nothing
end

# install jenkins plugings
node['scalr-jenkins']['jenkins']['plugins'].each do |plugin|
  jenkins_command "install-plugin #{plugin}" do
    action :execute
    retries 3
    retry_delay 10
    not_if { File.exist?(node['scalr-jenkins']['plugins_file']) }
    notifies :create, "file[#{node['scalr-jenkins']['plugins_file']}]"
    notifies :restart, 'service[jenkins]', :delayed unless node['scalr-jenkins']['docker']['dockerinstance']
    notifies :restart, "docker_container[#{node['scalr-jenkins']['docker']['containername']}]", :delayed if node['scalr-jenkins']['docker']['dockerinstance']
  end
  # needs fixed in the base cookbook
  jenkins_plugin plugin do
    action :install
    install_deps true
    only_if { File.exist?(node['scalr-jenkins']['plugins_file']) }
    notifies :restart, 'service[jenkins]', :immediately #:delayed unless node['scalr-jenkins']['docker']['dockerinstance']
    notifies :restart, "docker_container[#{node['scalr-jenkins']['docker']['containername']}]", :delayed if node['scalr-jenkins']['docker']['dockerinstance']
  end
end

# force authentication
jenkins_script 'add_authentication' do
  command <<-EOH.gsub(/^ {4}/, '')
    import jenkins.model.*
    import hudson.security.*
    def instance = Jenkins.getInstance()
    def hudsonRealm = new HudsonPrivateSecurityRealm(true)
    instance.setSecurityRealm(hudsonRealm)
    def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
    strategy.setAllowAnonymousRead(false)
    instance.setAuthorizationStrategy(strategy)
    instance.save()
  EOH
  not_if { File.exist?(node['scalr-jenkins']['check_file']) }
  notifies :create, "file[#{node['scalr-jenkins']['check_file']}]"
end
