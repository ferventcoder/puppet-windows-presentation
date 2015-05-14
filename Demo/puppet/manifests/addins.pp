windowsfeature {'NET-Framework-Core':
  ensure => present,
}

package {'dotNet3.5':
  ensure => installed
}
