define apache::vhost($ensure, $source='', $content='') {
  include apache

  $apache_sites_available = $apache::apache_sites_available
  $apache_sites_enabled = $apache::apache_sites_enabled

  if ($source != '') and ($content != '') {
    err("Cannot define both 'source' and 'content' for apache::vhost!")
  }

  if ($apache_sites_available == "") {
    err("Must define apache_sites_available")
  }

  if ($apache_sites_enabled == "") {
    err("Must define apache_sites_enabled")
  }

  file {
    "${apache_sites_available}/${name}":
      source => $source ? {
        '' => undef,
        default => $source
        },
      content => $content ? {
        '' => undef,
        default => $content
        },
      ensure  => $ensure ? {
        present => present,
        enabled => present,
        absent => absent,
        purged => absent,
        default => $ensure
      };
    "${apache_sites_enabled}/${name}":
      target => "${apache_sites_available}/${name}",
      ensure  => $ensure ? {
        enabled => symlink,
        default => $ensure
      }
  }
}
