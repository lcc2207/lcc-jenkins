include_recipe 'apt::default' if ubuntu?
include_recipe 'yum-epel::default' if rhel?

# setup prerequisites
include_recipe 'scalr-jenkins::prereq'

# setup NTP
include_recipe 'ntp::default'

# install jenkins
include_recipe 'jenkins::master'
include_recipe 'scalr-jenkins::jenkinsconfig'
include_recipe 'scalr-jenkins::jenkins_jobs'
