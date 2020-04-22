# verify security
default['lcc-jenkins']['check_file'] = Chef::Config[:file_cache_path] + '/jenkins.sec'

# turn off jenkins setup wizard
default['jenkins']['master']['jvm_options'] = '-Dhudson.diyChunking=false -Djenkins.install.runSetupWizard=false'

# run on time for lcc-ctl
# default['lcc-jenkins']['lcc-ctl_file'] = Chef::Config[:file_cache_path] + '/scarl-ctl'

# verify file for plugins
default['lcc-jenkins']['plugins_file'] = Chef::Config[:file_cache_path] + '/plugins'

# java version
default['java']['jdk_version'] = '8'
default['java']['oracle']['accept_oracle_download_terms'] = true

# auth
default['lcc-jenkins']['jenkins']['adminuser'] = 'chef'
default['lcc-jenkins']['users']['data_bag'] = 'lcc-jenkins-users'

# plugins
default['lcc-jenkins']['jenkins']['plugins'] = ['github']

# tools
default['lcc-jenkins']['tools'] = %w(yamllint jenkins-job-builder lcc-ctl)

# # jenkins job builder path
default['lcc-jenkins']['jenkins-jobs']['path'] = '/etc/jenkins_jobs'

# jenkins jobs
default['lcc-jenkins']['jenkins-jobs']['data_bag'] = 'lcc-jenkins-jobs'

# requied packages
default['lcc-jenkins']['packages'] = ['python-pip', 'jq']

# docker setup
default['lcc-jenkins']['docker']['logfile'] = '/var/log/dockerservice.log'
default['lcc-jenkins']['docker']['imgname'] = 'lcc-jenkins'
default['lcc-jenkins']['docker']['repo'] = 'jenkins'
default['lcc-jenkins']['docker']['regversion'] = 'latest'
default['lcc-jenkins']['docker']['portmap'] = ['8080:8080', '50000:50000']
default['lcc-jenkins']['docker']['containername'] = 'jenkins'
default['lcc-jenkins']['docker']['dockerinstance'] = false
default['lcc-jenkins']['docker']['version'] = '18.03.0-ce'
default['lcc-jenkins']['docker']['binds'] = ['/var/lib/jenkins:/var/jenkins_home']

# docker build setup
default['lcc-jenkins']['docker']['build_folder'] = '/opt/lcc-jenkins'
default['lcc-jenkins']['docker']['build_files'] = ['add_admin.groovy']
