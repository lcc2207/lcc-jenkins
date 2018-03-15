# create directorys
node['scalr-jenkins']['folders'].each do |dir|
  directory dir do
    owner 'root'
    group 'root'
    mode '0755'
    action :create
  end
end

# create the jenkins-job-builder Config
template "#{node['scalr-jenkins']['jenkins-job-builder']['path']}/jenkins_jobs.ini" do
  source 'jenkins_jobs_ini.erb'
  owner 'jenkins'
  group 'jenkins'
  variables(
    userid: node['scalr-jenkins']['jenkins']['adminuser'],
    password: data_bag_item(node['scalr-jenkins']['users']['data_bag'], node['scalr-jenkins']['jenkins']['adminuser'])['password']
  )
end

# create the scalr-ctl Config
template "#{node['scalr-jenkins']['jenkins-confg']['path']}/cicd.yml" do
  source 'scarlconf.erb'
  owner 'jenkins'
  group 'jenkins'
  variables(
    scarlserver: data_bag_item(node['scalr-jenkins']['jenkins-config']['data_bag'], 'scalr-ctl')['scalr_server'],
    accountId: data_bag_item(node['scalr-jenkins']['jenkins-config']['data_bag'], 'scalr-ctl')['accountId'],
    envId: data_bag_item(node['scalr-jenkins']['jenkins-config']['data_bag'], 'scalr-ctl')['envId']
  )
end

# setup jenkins jobs
jobs = data_bag(node['scalr-jenkins']['jenkins-jobs']['data_bag'])
jobs.each do |job|
  fulljob = "#{node['scalr-jenkins']['jenkins-jobs']['path']}/#{job}"
  template fulljob do
    source 'jenkinsjob.erb'
    owner 'jenkins'
    group 'jenkins'
    variables(
      job_name: data_bag_item(node['scalr-jenkins']['jenkins-jobs']['data_bag'], job)['id'],
      gitrepo: data_bag_item(node['scalr-jenkins']['jenkins-jobs']['data_bag'], job)['gitrepo'],
      farmid: data_bag_item(node['scalr-jenkins']['jenkins-jobs']['data_bag'], job)['farmid']
    )
  end

  execute 'addjobs' do
    cwd Chef::Config[:file_cache_path]
    command "/usr/local/bin/jenkins-jobs update #{fulljob}"
  end
end
