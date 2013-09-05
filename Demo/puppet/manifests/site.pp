
# package {'name_of_package':
#   provider => 'chocolatey',
#   ensure => absent,latest, '1.0',
#   source => 'http://not/default/sources;c:\local;\\some\network\share',
#   install_options => '-installArgs "addtl args for native installer"',
# }


# # package {'putty':
# #   ensure => latest,
# #   provider => 'chocolatey',
# # }

# package {'putty':
#   ensure => absent,
#   provider => 'chocolatey',
# }