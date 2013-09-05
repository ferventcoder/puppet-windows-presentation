# default signifies all nodes (aka agents)
node default {


  file { 'c:/temp':
    ensure => 'directory',
    notify => File['c:/temp/testfile.config'],
  }  

  file { 'c:/temp/testfile.config':
    ensure => 'file',
    content => 
'<config>
</config>',
  }

  package {'roundhouse':
    ensure => latest,
    provider => chocolatey,
    source => 'c:\vagrant\resources\packages',
    #install_options => '-pre'
  }

  package {'vcredist2008':
    ensure => latest,
    provider => chocolatey,
    notify => Reboot['reboot_vcredist'],
  }

  reboot { 'reboot_vcredist':
    message => "Rebooting for Redist",
    timeout => 5,
  }

  package { 'Microsoft SqlServer Express':
    ensure => installed,
    provider => windows,
    source => 'c:/vagrant/resources/SQLServer/SQLEXPRWT_x64_ENU.exe',
    require => Package['vcredist2008'],
  } #->
  # service { 'Sql Express'
  #   ensure => 'running',
  #   enable => true,
  # }

}