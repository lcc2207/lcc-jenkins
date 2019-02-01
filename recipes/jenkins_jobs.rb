# setup the verify file for security
file node['scalr-jenkins']['scalr-ctl_file'] do
  owner 'root'
  group 'root'
  mode '0600'
  action :nothing
end

# run scalr-ctl first time - stops error on first run
execute 'run scalr-ctl first time' do
  command 'scalr-ctl'
  not_if { File.exist?(node['scalr-jenkins']['scalr-ctl_file']) }
  notifies :create, "file[#{node['scalr-jenkins']['scalr-ctl_file']}]"
end

# create directorys
directory node['scalr-jenkins']['jenkins-jobs']['path'] do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

# create the jenkins-job-builder Config
template "#{node['scalr-jenkins']['jenkins-jobs']['path']}/jenkins_jobs.ini" do
  source 'jenkins_jobs_ini.erb'
  owner 'jenkins'
  group 'jenkins'
  variables(
    userid: node['scalr-jenkins']['jenkins']['adminuser'],
    password: data_bag_item(node['scalr-jenkins']['users']['data_bag'], node['scalr-jenkins']['jenkins']['adminuser'])['password']
  )
end

# setup jenkins jobs
jobs = data_bag(node['scalr-jenkins']['jenkins-jobs']['data_bag'])
jobs.each do |job|
  # create the scalr-ctl Config
  template "#{node['scalr-jenkins']['jenkins-jobs']['path']}/#{job}.yml" do
    source 'scarlconf.erb'
    owner 'jenkins'
    group 'jenkins'
    variables(
      scarlserver: data_bag_item(node['scalr-jenkins']['jenkins-jobs']['data_bag'], job)['scalr_server'],
      accountId: data_bag_item(node['scalr-jenkins']['jenkins-jobs']['data_bag'], job)['accountId'],
      envId: data_bag_item(node['scalr-jenkins']['jenkins-jobs']['data_bag'], job)['envId'],
      key_id: data_bag_item(node['scalr-jenkins']['jenkins-jobs']['data_bag'], job)['key_id'],
      secret_key_id: data_bag_item(node['scalr-jenkins']['jenkins-jobs']['data_bag'], job)['secret_key']
    )
  end if data_bag_item(node['scalr-jenkins']['jenkins-jobs']['data_bag'], job)['type'] == 'farm'.downcase

  # create the kitchen Config
  template "#{node['scalr-jenkins']['jenkins-jobs']['path']}/#{job}.sh" do
    source 'kitchen.erb'
    owner 'jenkins'
    group 'jenkins'
    variables(
      scarlserver: data_bag_item(node['scalr-jenkins']['jenkins-jobs']['data_bag'], job)['scalr_server'],
      projectId: data_bag_item(node['scalr-jenkins']['jenkins-jobs']['data_bag'], job)['projectId'],
      envId: data_bag_item(node['scalr-jenkins']['jenkins-jobs']['data_bag'], job)['envId'],
      key_id: data_bag_item(node['scalr-jenkins']['jenkins-jobs']['data_bag'], job)['key_id'],
      secret_key_id: data_bag_item(node['scalr-jenkins']['jenkins-jobs']['data_bag'], job)['secret_key']
    )
  end unless data_bag_item(node['scalr-jenkins']['jenkins-jobs']['data_bag'], job)['type'] == 'farm'.downcase

  fulljob = "#{node['scalr-jenkins']['jenkins-jobs']['path']}/#{job}"
  template fulljob do
    owner 'jenkins'
    group 'jenkins'
    if data_bag_item(node['scalr-jenkins']['jenkins-jobs']['data_bag'], job)['type'] == 'webhook'.downcase
      source 'jenkinsjob_webhook.erb'
      variables(
        job_name: data_bag_item(node['scalr-jenkins']['jenkins-jobs']['data_bag'], job)['id'],
        gitrepo: data_bag_item(node['scalr-jenkins']['jenkins-jobs']['data_bag'], job)['gitrepo'],
        confpath: "#{node['scalr-jenkins']['jenkins-jobs']['path']}/#{job}.sh",
      )
    elsif data_bag_item(node['scalr-jenkins']['jenkins-jobs']['data_bag'], job)['type'] == 'cookbook'.downcase
      source 'jenkinsjob_cookbook.erb'
      variables(
        job_name: data_bag_item(node['scalr-jenkins']['jenkins-jobs']['data_bag'], job)['id'],
        gitrepo: data_bag_item(node['scalr-jenkins']['jenkins-jobs']['data_bag'], job)['gitrepo'],
        confpath: "#{node['scalr-jenkins']['jenkins-jobs']['path']}/#{job}.sh",
      )
    else
      source 'jenkinsjob.erb'
      variables(
        job_name: data_bag_item(node['scalr-jenkins']['jenkins-jobs']['data_bag'], job)['id'],
        gitrepo: data_bag_item(node['scalr-jenkins']['jenkins-jobs']['data_bag'], job)['gitrepo'],
        confpath: "#{node['scalr-jenkins']['jenkins-jobs']['path']}/#{job}.yml",
        farm_template: data_bag_item(node['scalr-jenkins']['jenkins-jobs']['data_bag'], job)['farm_template'],
        farmid: data_bag_item(node['scalr-jenkins']['jenkins-jobs']['data_bag'], job)['farmid'],
        farm_action: data_bag_item(node['scalr-jenkins']['jenkins-jobs']['data_bag'], job)['farm_action'],
        stage_build: data_bag_item(node['scalr-jenkins']['jenkins-jobs']['data_bag'], job)['stage_build'],
        farm_temp_url: data_bag_item(node['scalr-jenkins']['jenkins-jobs']['data_bag'], job)['farm_temp_url']
      )
    end
  end

  execute 'addjobs' do
    cwd Chef::Config[:file_cache_path]
    command "jenkins-jobs update #{fulljob}"
  end
end
