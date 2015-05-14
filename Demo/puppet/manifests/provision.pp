case $operatingsystem {
  'windows':    {
    Package {
      provider => chocolatey,
      #source   => 'C:\vagrant\resources\packages',
    }
  }
}

#include chocolatey_server

windowsfeature {'NET-Framework-45-Core':
  ensure => present,
  notify => Reboot['reboot_netfx'],
}

reboot { 'reboot_netfx':
  message => "Rebooting for .Net Framework install",
  when => pending,
  timeout => 5,
}

file { 'c:/temp':
  ensure => 'directory',
  notify => File['c:/temp/testfile.txt'],
}

user {'Administrator':
  ensure => present,
}

acl { 'c:/temp':
  permissions => [
   { identity => 'Administrator', rights => ['full'] },
   { identity => 'Users', rights => ['modify'] }
 ],
  purge => true,
  inherit_parent_permissions => false,
}

service {'BITS':
  ensure => 'stopped',
  #ensure => 'running',
  enable => 'manual',
}

file { 'c:/temp/testfile.txt':
  ensure => 'file',
  content => 'Test file',
}

package {'launchy':
  ensure => installed,
  # install_options => ['-override', '-installArgs', '"', '/VERYSILENT', '/NORESTART', '"']
}

package {'roundhouse':
  ensure   => '0.8.5.0',
  #ensure => installed,
  #ensure => latest,
  #ensure => absent,
}

registry_key {'HKLM\System\TestKey':
  ensure => present,
} ->
registry_value {'HKLM\System\TestKey\TestValue':
  ensure => present,
  type => string,
  data => "Just a key for testing",
}
