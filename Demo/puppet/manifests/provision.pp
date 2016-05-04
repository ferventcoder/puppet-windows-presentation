# https://learn.puppet.com/
# http://docs.puppet.com/
# http://docs.puppet.com/windows/
# If you want more GUI, Customer support, and access to
# enterprise only features, take a look at Puppet Enterprise
# https://puppet.com/product

# Package (uppercased) is to set resource defaults, in this case on
# Windows make the provider for package Chocolatey.
case $operatingsystem {
  'windows':    {
    Package {
      provider => chocolatey,
      source   => 'C:\vagrant\resources\packages',
    }
  }
}

# Get all of the custom resources by installing the Windows
# Module Pack - https://forge.puppet.com/puppetlabs/windows
# puppet module install puppetlabs-windows

# https://forge.puppet.com/puppetlabs/acl
acl { 'c:/temp':
  permissions => [
   { identity => 'Administrators', rights => ['full'] },
   { identity => 'Users', rights => ['modify'] }
 ],
  purge => true,
  inherit_parent_permissions => false,
}

# https://forge.puppet.com/puppetlabs/dsc
dsc_xFirewall { 'inbound-2222':
  dsc_ensure => 'present',
  dsc_name => 'inbound2222',
  dsc_displayname => 'Inbound DSC 2222',
  dsc_displaygroup => 'A Puppet + DSC Test',
  dsc_action => 'Allow',
  dsc_enabled => 'false',
  dsc_direction => 'Inbound',
}

# https://forge.puppet.com/puppet/powershell
exec { 'BITS service on':
  command   => 'Start-Service BITS',
  unless    => "if (\$(Get-Service BITS).Status -eq 'Running') { exit 0 } else { exit 1 }",
  provider  => powershell,
  logoutput => true,
}

exec { 'Write Path':
  command   => 'Write-Output $env:PATH',
  provider  => powershell,
  logoutput => true,
}

exec { 'Write Posh Location':
  command   => 'get-process powershell* | %{ Write-Host $($_.Path)}',
  provider  => powershell,
  logoutput => true,
}

# https://forge.puppet.com/puppetlabs/reboot
reboot { 'reboot_pending':
  when => pending,
  timeout => 5,
}

# https://forge.puppet.com/puppetlabs/registry
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

registry_value {'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\AutoAdminLogon':
  ensure => present,
  type => dword,
  data => 0,
}

# https://forge.puppet.com/puppetlabs/wsus_client
class { 'wsus_client':
  server_url             => 'https://internal_server:8530',
  auto_update_option     => "Scheduled",
  scheduled_install_day  => "Tuesday",
  scheduled_install_hour => 2,
}

# http://docs.puppet.com/references/latest/type.html#package
# https://forge.puppet.com/chocolatey/chocolatey
#include chocolatey
# or
class {'chocolatey':
  chocolatey_download_url => 'file:///C:/vagrant/resources/packages/chocolatey.0.9.10-beta-20160503.nupkg',
  use_7zip                => false,
  log_output              => true,
  require                 => Download_file["Download Chocolatey package"]
}

package {'windirstat':
  ensure => installed,
  #ensure => absent,
  # install_options => ['-override', '-installArgs', '"', '/VERYSILENT', '/NORESTART', '"']
}

package {'roundhouse':
  ensure   => '0.8.5.0',
  #ensure => installed, # note that this produced no changes applied after an install
  #ensure => latest,
  #ensure => held,
}

# https://forge.puppet.com/puppet/download_file
download_file { "Download Chocolatey package" :
  url                   => 'https://chocolatey.org/api/v2/package/chocolatey/0.9.10-beta-20160503',
  destination_file      => 'chocolatey.0.9.10-beta-20160503.nupkg',
  destination_directory => 'c:\vagrant\resources\packages'
}

# https://forge.puppet.com/badgerious/windows_env
windows_env {'AnEnvVariable':
  ensure    => present,
  value     => 'super_secret_value',
  mergemode => clobber,
}

# https://forge.puppet.com/puppet/windowsfeature
windowsfeature {'NET-Framework-45-Core':
  ensure => present,
  notify => Reboot['reboot_pending'],
}

windowsfeature { 'Web-WebServer':
  installmanagementtools => true,
} ->
windowsfeature { 'Web-Asp-Net45':
}


# http://docs.puppet.com/references/latest/type.html#file
file { 'c:/temp':
  ensure => 'directory',
  notify => File['c:/temp/testfile.txt'],
}

# http://docs.puppet.com/references/latest/type.html#user
user {'Administrator':
  ensure => present,
  notify => Group['TestUsers'],
}

# http://docs.puppet.com/references/latest/type.html#group
group {'TestUsers':
  ensure => present,
  members => ['Administrator','Administrators'],
}

# http://docs.puppet.com/references/latest/type.html#service
# service {'BITS':
#//   ensure => 'stopped',
#//   #ensure => 'running',
#//   enable => 'manual',
#// }

# http://docs.puppet.com/references/latest/type.html#file
file { 'c:/temp/testfile.txt':
  ensure => 'file',
  content => 'Test file',
  # content can also be sourced in a file/template/puppet server
  # explore recursive option when you really want to see some fun.
  # http://docs.puppet.com/references/latest/type.html#file-attribute-recurse
}


# Exercise 2 - Chocolatey Simple Server
#include chocolatey_server
# or
#class {'chocolatey_server':
#  server_package_source => 'C:/vagrant/resources/packages',
#}
