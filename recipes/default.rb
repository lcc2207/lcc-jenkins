include_recipe 'apt::default' if ubuntu?
include_recipe 'yum-epel::default' if rhel?

# setup prerequisites
include_recipe 'lcc-jenkins::prereq'

# setup NTP
include_recipe 'ntp::default'

# install jenkins
include_recipe 'jenkins::master'
include_recipe 'lcc-jenkins::jenkinsconfig'
include_recipe 'lcc-jenkins::jenkins_jobs'
