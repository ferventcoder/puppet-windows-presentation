# https://learn.puppetlabs.com/
# http://docs.puppetlabs.com/
# http://docs.puppetlabs.com/windows/
# If you want more GUI, Customer support, and access to
# enterprise only features, take a look at Puppet Enterprise
# https://puppetlabs.com/puppet/puppet-enterprise

# Package (uppercased) is to set resource defaults, in this case on
# Windows make the provider for package Chocolatey.
case $operatingsystem {
  'windows':    {
    Package {
      provider => chocolatey,
      #source   => 'C:\vagrant\resources\packages',
    }
  }
}

# Get almost all of the custom resources by installing the Windows
# Module Pack - https://forge.puppetlabs.com/puppetlabs/windows
# puppet module install puppetlabs-windows


# Exercise 2 - Chocolatey Simple Server
#include chocolatey_server

# Exercise 1 - Puppet apply

# https://forge.puppetlabs.com/puppet/windowsfeature
windowsfeature {'NET-Framework-45-Core':
  ensure => present,
  notify => Reboot['reboot_netfx'],
}

# https://forge.puppetlabs.com/puppetlabs/reboot
reboot { 'reboot_netfx':
  message => "Rebooting for .Net Framework install",
  when => pending,
  timeout => 5,
}

# http://docs.puppetlabs.com/references/latest/type.html#file
file { 'c:/temp':
  ensure => 'directory',
  notify => File['c:/temp/testfile.txt'],
}

# http://docs.puppetlabs.com/references/latest/type.html#user
user {'Administrator':
  ensure => present,
}

# http://docs.puppetlabs.com/references/latest/type.html#group
group {'TestUsers':
  ensure => present,
  members => ['Administrator','Administrators'],
}


# https://forge.puppetlabs.com/puppetlabs/acl
acl { 'c:/temp':
  permissions => [
   { identity => 'Administrators', rights => ['full'] },
   { identity => 'Users', rights => ['modify'] }
 ],
  purge => true,
  inherit_parent_permissions => false,
}

# http://docs.puppetlabs.com/references/latest/type.html#service
service {'BITS':
  ensure => 'stopped',
  #ensure => 'running',
  enable => 'manual',
}

# http://docs.puppetlabs.com/references/latest/type.html#file
file { 'c:/temp/testfile.txt':
  ensure => 'file',
  content => 'Test file',
  # content can also be sourced in a file/template/puppet server
  # explore recursive option when you really want to see some fun.
  # http://docs.puppetlabs.com/references/latest/type.html#file-attribute-recurse
}

# http://docs.puppetlabs.com/references/latest/type.html#package
# https://forge.puppetlabs.com/chocolatey/chocolatey
package {'windirstat':
  ensure => installed,
  #ensure => absent,
  # install_options => ['-override', '-installArgs', '"', '/VERYSILENT', '/NORESTART', '"']
}

package {'roundhouse':
  ensure   => '0.8.5.0',
  #ensure => installed, # note that this produced no changes applied after an install
  #ensure => latest,
}

# https://forge.puppetlabs.com/puppetlabs/registry
registry_key {'HKLM\System\TestKey':
  ensure => present,
  #ensure => absent,
} ->
registry_value {'HKLM\System\TestKey\TestValue':
  ensure => present,
  #ensure => absent,
  type => string,
  data => "Just a key for testing",
}
