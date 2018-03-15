# create directory for scalr-ctl config
directory '/etc/scarl-cicd' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

# setup jenkins jobs
template '/etc/scarl-cicd/cicd.yml' do
  source 'jenkinsjob.erb'
  owner 'jenkins'
  group 'jenkins'
  variables(
    job_name: 'dev-app-3',
    gitrepo: 'https://github.com/lcc2207/test1.git',
    farmid: '2627'
  )
end
