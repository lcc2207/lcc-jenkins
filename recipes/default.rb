include_recipe 'apt::default' if ubuntu?
include_recipe 'yum-epel::default' if rhel?

# disable selinux as if affects jenkins jobs
selinux_state 'disabled' do
  action :disabled
  only_if { centos? }
end

# setup prerequisites
include_recipe 'scalr-jenkins::prereq'

# setup NTP
include_recipe 'ntp::default'

# install jenkins
include_recipe 'jenkins::master'
include_recipe 'scalr-jenkins::jenkinsconfig'
include_recipe 'scalr-jenkins::jenkins_jobs'
