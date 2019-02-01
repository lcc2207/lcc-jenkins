# verify security
default['scalr-jenkins']['check_file'] = Chef::Config[:file_cache_path] + '/jenkins.sec'

# turn off jenkins setup wizard
default['jenkins']['master']['jvm_options'] = '-Dhudson.diyChunking=false -Djenkins.install.runSetupWizard=false'

# run on time for scalr-ctl
default['scalr-jenkins']['scalr-ctl_file'] = Chef::Config[:file_cache_path] + '/scarl-ctl'

# verify file for plugins
default['scalr-jenkins']['plugins_file'] = Chef::Config[:file_cache_path] + '/plugins'

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
default['scalr-jenkins']['packages'] = ['python-pip', 'jq', 'git', 'pylint']

# docker setup
default['scalr-jenkins']['docker']['logfile'] = '/var/log/dockerservice.log'
default['scalr-jenkins']['docker']['imgname'] = 'scalr-jenkins'
default['scalr-jenkins']['docker']['repo'] = 'jenkins'
default['scalr-jenkins']['docker']['regversion'] = 'latest'
default['scalr-jenkins']['docker']['portmap'] = ['8080:8080', '50000:50000']
default['scalr-jenkins']['docker']['containername'] = 'jenkins'
default['scalr-jenkins']['docker']['dockerinstance'] = false
default['scalr-jenkins']['docker']['version'] = '18.09.1-ce'
default['scalr-jenkins']['docker']['binds'] = ['/var/lib/jenkins:/var/jenkins_home']

# docker build setup
default['scalr-jenkins']['docker']['build_folder'] = '/opt/scalr-jenkins'
default['scalr-jenkins']['docker']['build_files'] = ['add_admin.groovy']
