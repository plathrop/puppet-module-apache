define apache::vhost($ensure, $source='', $content='') {
  include apache

  if ($source != '') and ($content != '') {
    err("Cannot define both 'source' and 'content' for apache::vhost!")
  }

  File { notify => Service["apache"] }

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
      target => "${apache::sites_available}/${name}",
      ensure  => $ensure ? {
        enabled => symlink,
        default => $ensure
      }
  }
}
