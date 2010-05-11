class apache {
  $apache = "apache2"
  $apache_worker = "apache2-mpm-prefork"
  $apache_conf_dir = "/etc/apache2"
  $apache_conf = "apache2.conf"
  $apache_control = "/etc/init.d/apache2"
  $sites_available = "${apache_conf_dir}/sites-available"
  $sites_enabled = "${apache_conf_dir}/sites-enabled"
  $mods_available = "${apache_conf_dir}/mods-available"
  $mods_enabled = "${apache_conf_dir}/mods-enabled"

  package {
    "apache-worker":
      name => $apache_worker,
      ensure => installed,
      before => Package["apache"];
    "apache":
      name   => $apache,
      ensure => installed;
  }

  file {
    "apache config dir":
      path => $apache_conf_dir,
      ensure => directory,
      require => Package["apache"];
    "apache.conf":
      path => "${apache_conf_dir}/${apache_conf}",
      source => "puppet:///apache/apache.conf",
      require => File["apache config dir"],
      notify => Service["apache"];
    "envvars":
      path => "${apache_conf_dir}/envvars",
      source => "puppet:///apache/envvars",
      require => File["apache config dir"],
      notify => Service["apache"];
    ["${apache_conf_dir}/mods-available",
     "${apache_conf_dir}/mods-enabled",
     "${apache_conf_dir}/conf.d"]:
       ensure => directory;
     ["${apache_conf_dir}/sites-available",
      "${apache_conf_dir}/sites-enabled"]:
       recurse => true,
       purge => true,
       ensure => directory;
  }

  service { "apache":
    name => $apache,
    enable => true,
    ensure => running,
    hasrestart => true,
    require => Package["apache"],
  }

  # Disable the Debian "default" site.
  file { "${sites_enabled}/000-default":
    ensure => absent,
    notify => Service["apache"]
  }
}
