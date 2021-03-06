name 'lcc-jenkins'
maintainer 'lynn@fidmail.com'
maintainer_email 'lynn@fidmail.com'
license 'All Rights Reserved'
description 'Installs/Configures lcc-jenkins'
long_description 'Installs/Configures lcc-jenkins'
version '0.1.16'
chef_version '>= 12.1' if respond_to?(:chef_version)

issues_url 'https://github.com/lcc2207/lcc-jenkins/issues'
source_url 'https://github.com/lcc2207/lcc-jenkins'

depends 'apt', '~> 7.1.0'
depends 'chef-sugar'
depends 'java'
depends 'jenkins', '~> 6.2.0'
depends 'ntp', '~> 3.6.0'
depends 'docker', '~> 4.6.5'
depends 'selinux', '~> 2.1.1'
depends 'yum-epel', '~> 3.3.0'
