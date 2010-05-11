define apache::module ( $ensure = 'present') {
  case $ensure {
    present,installed : {
      exec { "/usr/sbin/a2enmod $name":
        creates => "${apache::mods_enabled}/${name}.load",
  	notify  => Service["apache"],
        require => Package["apache"],
      }
    }
    absent,purged: {
      exec { "/usr/sbin/a2dismod $name":
        onlyif  => "/usr/bin/test -L ${apache::mods_enabled}/${name}.load",
  	notify  => Service["apache"],
        require => Package["apache"],
      }
    }
    default: { err ( "Unknown ensure value: '$ensure'" ) }
  }
}
