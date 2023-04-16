class gitea::install {
  group { $gitea::group:
    ensure => present,
  }

  user { $gitea::user:
    managehome => true,
    home       => $gitea::home,
    groups     => [$gitea::group],
    require    => Group[$gitea::group],
  }

  $gitea_dirs = [
    '/etc/gitea/',
    "${gitea::home}/"
    "${gitea::home}/gitea/",
  ]

  file { $gitea_dirs:
    ensure => 'directory',
    owner  => $gitea::user,
    group  => $gitea::group,
    mode   => '0700',
  }

  file { '/etc/gitea/app.ini':
    ensure => 'file',
    owner  => $gitea::user,
    group  => $gitea::group,
    mode   => '0600',
  }

  $gitea_binary_path = "${gitea::home}/gitea/gitea"
  $tmp_gitea_path = "/tmp/gitea-${gitea::version}"
  archive { $tmp_gitea_path:
    ensure  => present,
    source  => "https://dl.gitea.io/gitea/${gitea::version}/gitea-${gitea::version}-linux-amd64",
    creates => $tmp_gitea_path,
    extract => false,
    before  => File[$gitea_binary_path],
    cleanup => false,
    notify  => Class['gitea::service'],
  }

  file { $gitea_binary_path:
    ensure => 'file',
    source => $tmp_gitea_path,
    mode   => '0700',
    owner  => $gitea::user,
    group  => $gitea::group,
    before => File['/usr/local/bin/gitea'],
  }

  file { '/usr/local/bin/gitea':
    ensure => 'link',
    target => $gitea_binary_path,
  }
}
