define apache::config($ensure=present, $content='', $source='', $order=500) {
  case $source {
    '': {
      case $content {
        '': {
          fail("Must define either 'source' or 'content' for apache::config!")
        }
        default: {
          $real_content = $content
        }
      }
    }
    default: {
      case $content {
        '': { }
        default: {
          fail("Cannot define both 'source' and 'content' for runit::service!")
        }
      }
    }
  }

  file {
    "${apache::apache_conf_dir}/conf.d/${order}-${name}.conf":
      ensure => $ensure,
      content => $source ? {
        '' => $real_content,
        default => undef
      },
      source => $real_content ? {
        '' => $source,
        default => undef
      },
      mode => 644,
      notify => Service["apache"],
      require => [ Package["apache"], File["${apache::apache_conf_dir}/conf.d"] ];
  }
}
