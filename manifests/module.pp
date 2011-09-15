define apache::module($ensure = 'present', $package=undef) {
  case $ensure {
    present,installed : {
      exec { "/usr/sbin/a2enmod $name":
        creates => "${apache::apache_mods_enabled}/${name}.load",
  	notify  => Service["apache"],
        require => Package["apache"],
      }
      if $package {
          package { $package:
              ensure => installed,
          }
      }
    }
    absent,purged: {
      exec { "/usr/sbin/a2dismod $name":
        onlyif  => "/usr/bin/test -L ${apache::apache_mods_enabled}/${name}.load",
  	notify  => Service["apache"],
        require => Package["apache"],
      }
      if $package {
          package { $package:
              ensure => absent,
          }
      }
    }
    default: { err ( "apache::module Unknown ensure value: '$ensure'" ) }
  }
}
