include_recipe 'apt::default' if ubuntu?

# setup prerequisites
include_recipe 'scalr-jenkins::prereq'

# setup NTP
include_recipe 'ntp::default'

# install jenkins
include_recipe 'jenkins::master'
include_recipe 'scalr-jenkins::jenkinsconfig'
include_recipe 'scalr-jenkins::jenkins_jobs'
