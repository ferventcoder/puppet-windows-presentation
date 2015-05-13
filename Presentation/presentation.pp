file {'c:/temp/testfile.txt':
  ensure  => 'file',
  content => 'test file',
}

package {'git':
  ensure  => latest,
}

service {'WebClient':
  ensure  => 'stopped',
  enable  => 'manual',
}

acl {'c:/temp':
  permissions => [
   { identity => 'Administrators', rights => ['full'] },
   { identity => 'Users', rights => ['read','execute'] }
  ],
}



