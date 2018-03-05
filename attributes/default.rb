# verify security
default['scalr-jenkins']['check_file'] = Chef::Config[:file_cache_path] + '/jenkins.sec'

# java version
default['java']['jdk_version'] = '8'
default['java']['oracle']['accept_oracle_download_terms'] = true
