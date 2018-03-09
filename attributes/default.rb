# verify security
default['scalr-jenkins']['check_file'] = Chef::Config[:file_cache_path] + '/jenkins.sec'

# java version
default['java']['jdk_version'] = '8'
default['java']['oracle']['accept_oracle_download_terms'] = true

# auth
default['scalr-jenkins']['jenkins']['adminuser'] = 'chef'
default['scalr-jenkins']['jenkins']['data_bag'] = 'scalr-jenkins'

# plugins
default['scalr-jenkins']['jenkins']['plugins'] = ['github']

# tools
default['scalr-jenkins']['tools'] = %w('pip' 'yamllint' 'jenkins-job-builder')
