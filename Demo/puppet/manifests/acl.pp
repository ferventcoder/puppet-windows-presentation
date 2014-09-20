file { ['c:/tempperms',
 'c:/tempperms/minimal',
 'c:/tempperms/full',
 'c:/tempperms/fqdn_sid',
 'c:/tempperms/propagation',
 'c:/tempperms/same_user']:
  ensure => directory,
}

acl { 'c:/tempperms/minimal':
  permissions => [
   { identity => 'Administrator', rights => ['full'] },
   { identity => 'Users', rights => ['modify'] }
 ],
}

# same as minimal but fully expressed
acl { 'c:/tempperms/full':
  target      => 'c:/tempperms/full',
  target_type => 'file',
  purge       => false,
  permissions => [
   { identity => 'Administrator', rights => ['full'], type=> 'allow', child_types => 'all', affects => 'all' },
   { identity => 'Users', rights => ['read','execute'], type=> 'allow', child_types => 'all', affects => 'all' }
  ],
  owner       => 'Administrators', #Creator_Owner specific, doesn't manage unless specified
  group       => 'Users', #Creator_Group specific, doesn't manage unless specified
  inherit_parent_permissions => true,
}

acl { 'c:/tempperms/fqdn_sid':
  permissions => [
   { identity => 'S-1-5-32-544', rights => ['full'] },
   { identity => 'NT AUTHORITY\SYSTEM', rights => ['write'] },
   { identity => 'BUILTIN\Users', rights => ['write','execute'] },
   { identity => 'Everyone', rights => ['execute'] },
   { identity => 'Users', rights => ['mask_specific'], mask => '1180073' }, #RX WA #0x1201a9
   { identity => 'Administrator', rights => ['mask_specific'], mask => '1180032' }  #RA,S,WA,Rc #1180032  #0x120180
  ],
}

file { ['c:/tempperms/propagation/child_container',
   'c:/tempperms/propagation/child_container/grandchild_container']:
  ensure => 'directory',
}

file { ['c:/tempperms/propagation/child_object.txt',
   'c:/tempperms/propagation/child_container/grandchild_object.txt']:
  ensure  => 'file',
  content => 'what',
}

acl { 'c:/tempperms/propagation':
  purge       => true,
  permissions => [
   { identity => 'Administrators', rights => ['modify'], affects => 'all' },
   { identity => 'Administrators', rights => ['full'], affects => 'self_only' },
   { identity => 'Administrator', rights => ['full'], affects => 'direct_children_only' },
   { identity => 'Users', rights => ['full'], affects => 'children_only' },
   { identity => 'Authenticated Users', rights => ['read'], affects => 'self_and_direct_children_only' }
  ],
  inherit_parent_permissions => false,
}

acl { 'c:/tempperms/same_user':
  purge       => true,
  permissions => [
   #{ identity => 'SYSTEM', rights => ['modify'], type=> 'deny', child_types => 'none' },
   { identity => 'SYSTEM', rights => ['modify'], child_types => 'none' },
   { identity => 'SYSTEM', rights => ['modify'], child_types => 'containers' },
   { identity => 'SYSTEM', rights => ['modify'], child_types => 'objects' },
   { identity => 'SYSTEM', rights => ['full'], affects => 'self_only' },
   { identity => 'SYSTEM', rights => ['read','execute'], affects => 'direct_children_only' },
   { identity => 'SYSTEM', rights => ['read','execute'], child_types=>'containers', affects => 'direct_children_only' },
   { identity => 'SYSTEM', rights => ['read','execute'], child_types=>'objects', affects => 'direct_children_only' },
   { identity => 'SYSTEM', rights => ['full'], affects => 'children_only' },
   { identity => 'SYSTEM', rights => ['full'], child_types=>'containers', affects => 'children_only' },
   { identity => 'SYSTEM', rights => ['full'], child_types=>'objects', affects => 'children_only' },
   { identity => 'SYSTEM', rights => ['read'], affects => 'self_and_direct_children_only' },
   { identity => 'SYSTEM', rights => ['read'], child_types=>'containers', affects => 'self_and_direct_children_only' },
   { identity => 'SYSTEM', rights => ['read'], child_types=>'objects', affects => 'self_and_direct_children_only' }
  ],
  inherit_parent_permissions => false,
}
