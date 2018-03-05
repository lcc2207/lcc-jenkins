# scalr-jenkins

========================
Installs jenkins, the git plugin and sets basic security.  
- Users will need to sign up on the Jenkins home page to gain access in this cookbook.
- Uses a data bag named <b>scalr-jenkins</b> to hold the password key for the chef user to make runs with auth enabled.
- community cookbooks link - https://supermarket.chef.io/cookbooks/jenkins#berkshelf


Requirements
------------
jenkins community cookbooks
<br><b>data bag</b> : base name is scalr-jenkins
<br><b>password</b> : You will need to password to add to the scalr-jenkins databag, to be use for authentication of chef during later chef runs<br>

----------
TODO: List your cookbook attributes here.

e.g.
#### scalr-jenkins::jenkins
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
  </tr>
</table>

Recipes
-------

default
-------
Installs java, jenkins and configures base security, also enables users sign up option.

data bag
-------
The default data bag name used in the recipe is <b>scalr-jenkins<b>.  This will be use to hold the private key for authentication by chef on later chef runs

Example data bag
----------------

```json
{
  "id":"chef",
  "private_key":"-----BEGIN RSA PRIVATE KEY-----\nMIIEowIBAAKCAQEAzxXlX1zMqVA0JwlKpHC8XgXuKL5M718jSMyJC9jACmnzKnfM\-----END RSA PRIVATE KEY-----",
  "public_keys":"ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAzxXlX1zMqVA0JwlKpHC8XgXuKL5M7",
  "password":"password123"
}
```
