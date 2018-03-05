puts node['scalr-jenkins']['check_file']
if File.exist?(node['scalr-jenkins']['check_file'])
  node.run_state[:jenkins_username] = node['scalr-jenkins']['jenkins']['adminuser']
  node.run_state[:jenkins_password] = data_bag_item(node['scalr-jenkins']['jenkins']['data_bag'], node['scalr-jenkins']['jenkins']['adminuser'])['password']
end

# pull users databag
users = data_bag(node['scalr-jenkins']['jenkins']['data_bag'])

# create the base users
users.each do |user|
  dbuser = data_bag_item(node['scalr-jenkins']['jenkins']['data_bag'], user)
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
