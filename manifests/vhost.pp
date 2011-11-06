define apache::vhost($ensure=running, $source=false, $content=false, $replace=false) {
  include apache

  $apache_sites_available = $apache::apache_sites_available
  $apache_sites_enabled = $apache::apache_sites_enabled

  if $ensure in [ present, running, absent, purged ] {
    $ensure_real = $ensure
  } else {
    fail('Valid values for ensure: present, running, absent, purged, or stopped')
  }

  if $source and $content {
    fail('You can only specify one of "source" or "content"')
  }

  $source_real = $source ? {
    false   => undef,
    default => $source
  }

  $content_real = $content ? {
    false   => undef,
    default => $content
  }

  $files_ensure = $ensure_real ? {
    /(absent|purged)/ => absent,
    default           => file
  }

  file {
    "${apache_sites_available}/${name}":
      ensure  => $files_ensure,
      source  => $source_real,
      content => $content_real,
      replace => $replace;
    "${apache_sites_enabled}/${name}":
      ensure => $ensure ? {
        enabled => symlink,
        default => $ensure
      },
      target => "${apache_sites_available}/${name}",
      notify => Service['apache'];
  }
}
