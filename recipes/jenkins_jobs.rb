# setup the verify file for security
file node['lcc-jenkins']['lcc-ctl_file'] do
  owner 'root'
  group 'root'
  mode '0600'
  action :nothing
end

# run lcc-ctl first time - stops error on first run
execute 'run lcc-ctl first time' do
  command 'lcc-ctl'
  not_if { File.exist?(node['lcc-jenkins']['lcc-ctl_file']) }
  notifies :create, "file[#{node['lcc-jenkins']['lcc-ctl_file']}]"
end

# create directorys
directory node['lcc-jenkins']['jenkins-jobs']['path'] do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

# create the jenkins-job-builder Config
template "#{node['lcc-jenkins']['jenkins-jobs']['path']}/jenkins_jobs.ini" do
  source 'jenkins_jobs_ini.erb'
  owner 'jenkins'
  group 'jenkins'
  variables(
    userid: node['lcc-jenkins']['jenkins']['adminuser'],
    password: data_bag_item(node['lcc-jenkins']['users']['data_bag'], node['lcc-jenkins']['jenkins']['adminuser'])['password']
  )
end

# setup jenkins jobs
jobs = data_bag(node['lcc-jenkins']['jenkins-jobs']['data_bag'])
jobs.each do |job|
  # create the lcc-ctl Config
  template "#{node['lcc-jenkins']['jenkins-jobs']['path']}/#{job}.yml" do
    source 'scarlconf.erb'
    owner 'jenkins'
    group 'jenkins'
    variables(
      scarlserver: data_bag_item(node['lcc-jenkins']['jenkins-jobs']['data_bag'], job)['scalr_server'],
      accountId: data_bag_item(node['lcc-jenkins']['jenkins-jobs']['data_bag'], job)['accountId'],
      envId: data_bag_item(node['lcc-jenkins']['jenkins-jobs']['data_bag'], job)['envId'],
      key_id: data_bag_item(node['lcc-jenkins']['jenkins-jobs']['data_bag'], job)['key_id'],
      secret_key_id: data_bag_item(node['lcc-jenkins']['jenkins-jobs']['data_bag'], job)['secret_key']
    )
  end

  fulljob = "#{node['lcc-jenkins']['jenkins-jobs']['path']}/#{job}"
  template fulljob do
    source 'jenkinsjob.erb'
    owner 'jenkins'
    group 'jenkins'
    variables(
      job_name: data_bag_item(node['lcc-jenkins']['jenkins-jobs']['data_bag'], job)['id'],
      gitrepo: data_bag_item(node['lcc-jenkins']['jenkins-jobs']['data_bag'], job)['gitrepo'],
      confpath: "#{node['lcc-jenkins']['jenkins-jobs']['path']}/#{job}.yml",
      farm_template: data_bag_item(node['lcc-jenkins']['jenkins-jobs']['data_bag'], job)['farm_template'],
      farmid: data_bag_item(node['lcc-jenkins']['jenkins-jobs']['data_bag'], job)['farmid'],
      farm_action: data_bag_item(node['lcc-jenkins']['jenkins-jobs']['data_bag'], job)['farm_action'],
      stage_build: data_bag_item(node['lcc-jenkins']['jenkins-jobs']['data_bag'], job)['stage_build'],
      farm_temp_url: data_bag_item(node['lcc-jenkins']['jenkins-jobs']['data_bag'], job)['farm_temp_url']
    )
  end

  execute 'addjobs' do
    cwd Chef::Config[:file_cache_path]
    command "jenkins-jobs update #{fulljob}"
  end
end
