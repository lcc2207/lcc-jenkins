# verify security
default['scalr-jenkins']['check_file'] = Chef::Config[:file_cache_path] + '/jenkins.sec'

# java version
default['java']['jdk_version'] = '8'
default['java']['oracle']['accept_oracle_download_terms'] = true

# auth
default['scalr-jenkins']['jenkins']['adminuser'] = 'chef'
default['scalr-jenkins']['users']['data_bag'] = 'scalr-jenkins-users'

# plugins
default['scalr-jenkins']['jenkins']['plugins'] = ['github']

# tools
default['scalr-jenkins']['tools'] = %w(yamllint jenkins-job-builder scalr-ctl)

# # jenkins config base
default['scalr-jenkins']['jenkins-confg']['path'] = '/etc/scarl-cicd'
#
# # jenkins job builder path
default['scalr-jenkins']['jenkins-job-builder']['path'] = '/etc/jenkins_jobs'

# requied folders
default['scalr-jenkins']['folders'] = [default['scalr-jenkins']['jenkins-confg']['path'], default['scalr-jenkins']['jenkins-job-builder']['path']]

# jenkins Config
default['scalr-jenkins']['jenkins-config']['data_bag'] = 'scalr-jenkins-config'

# jenkins jobs
default['scalr-jenkins']['jenkins-jobs']['data_bag'] = 'scalr-jenkins-jobs'
