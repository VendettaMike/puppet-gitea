class gitea::database {
  case $gitea::database_type {
    'postgresql': {
      postgresql::server::db { $gitea::database_name:
        user     => $gitea::database_user,
        owner    => $gitea::database_user,
        password => postgresql_password($gitea::database_user, $gitea::database_password),
        require  => Class['postgresql::server'],
      }
    }
    'sqlite': {
    }
    default: {
      fail('Unrecognized database type for server.')
    }
  }
}
