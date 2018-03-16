# verify security
default['scalr-jenkins']['check_file'] = Chef::Config[:file_cache_path] + '/jenkins.sec'

# run on time for scalr-ctl
default['scalr-jenkins']['scalr-ctl_file'] = Chef::Config[:file_cache_path] + '/scarl-ctl'

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

# # jenkins job builder path
default['scalr-jenkins']['jenkins-jobs']['path'] = '/etc/jenkins_jobs'

# jenkins jobs
default['scalr-jenkins']['jenkins-jobs']['data_bag'] = 'scalr-jenkins-jobs'

# requied packages
default['scalr-jenkins']['packages'] = ['python-pip', 'jq']
