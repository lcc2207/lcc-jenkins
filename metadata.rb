name 'scalr-jenkins'
maintainer 'lynn@scalr.com'
maintainer_email 'lynn@scalr.com'
license 'All Rights Reserved'
description 'Installs/Configures scalr-jenkins'
long_description 'Installs/Configures scalr-jenkins'
version '0.1.5'
chef_version '>= 12.1' if respond_to?(:chef_version)

issues_url 'https://github.com/lcc2207/scalr-jenkins/issues'
source_url 'https://github.com/lcc2207/scalr-jenkins'

depends 'apt', '~> 6.1.4'
depends 'chef-sugar'
depends 'java'
depends	'jenkins', '~> 6.0.0'
