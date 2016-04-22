class ucpconfig::compose {

  file { '/etc/elk':
    ensure => directory,
    }

  file { '/etc/elk/docker-compose.yml':
    ensure  => file,
    content => template('ucpconfig/elk.yml.erb'),
    require => File['/etc/elk'],
    }

  exec { 'docker-compose':
    command => 'bash -l -c "docker-compose -f /etc/elk/docker-compose.yml up -d"',
    path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    timeout => '1800',
    require => Class['ucpconfig::config'],
    }
}