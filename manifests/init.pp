class apache {
  $apache = $apache ? {
    "" => "apache2",
    default => $apache
  }

  $apache_worker = $apache_worker ? {
    "" => "apache2-mpm-prefork",
    default => $apache_worker
  }

  $apache_conf_dir = $apache_conf_dir ? {
    "" => "/etc/${apache}",
    default => $apache_conf_dir
  }

  $apache_conf_file = $apache_conf_file ? {
    "" => "${apache}.conf",
    default => $apache_conf_file
  }

  $apache_init_script = $apache_init_script ? {
    "" => "/etc/init.d/${apache}",
    default => $apache_init_script
  }

  $apache_sites_available = $apache_sites_available ? {
    "" => "${apache_conf_dir}/sites-available",
    default => $apache_sites_available
  }

  $apache_sites_enabled = $apache_sites_enabled ? {
    "" => "${apache_conf_dir}/sites-enabled",
    default => $apache_sites_enabled
  }

  $apache_mods_available = $apache_mods_available ? {
    "" => "${apache_conf_dir}/mods-available",
    default => $apache_mods_available
  }

  $apache_mods_enabled = $apache_mods_enabled ? {
    "" => "${apache_conf_dir}/mods-enabled",
    default => $apache_mods_enabled
  }

  $apache_listen_port = $apache_listen_port ? {
    "" => "80",
    default => $apache_listen_port
  }

  $apache_listen_address = $apache_listen_address ? {
    "" => "*",
    default => $apache_listen_address
  }

  package {
    "apache::package::worker":
      name => $apache_worker,
      ensure => $apache_worker_version ? {
        "" => installed,
        default => $apache_worker_version
      },
      before => Package["apache"];
    "apache":
      name   => $apache,
      ensure => $apache_version ? {
        "" => installed,
        default => $apache_version
      };
  }

  file {
    "apache::config_dir":
      path => $apache_conf_dir,
      ensure => directory,
      require => Package["apache"];
    "apache.conf":
      path => "${apache_conf_dir}/${apache_conf_file}",
      source => "puppet:///apache/apache.conf",
      require => File["apache::config_dir"],
      notify => Service["apache"];
    "envvars":
      path => "${apache_conf_dir}/envvars",
      content => template("apache/envvars.erb"),
      require => File["apache::config_dir"],
      notify => Service["apache"];
    ["${apache_conf_dir}/mods-available",
     "${apache_conf_dir}/mods-enabled",
     "${apache_conf_dir}/conf.d"]:
       ensure => directory;
    ["${apache_conf_dir}/sites-available",
     "${apache_conf_dir}/sites-enabled"]:
      recurse => true,
      purge => true,
      ensure => directory,
      checksum => "mtime",
      notify => Service["apache"];
  }

  apache::config {
    "ports":
      content => "Listen ${apache_listen_address}:${apache_listen_port}\n",
      order => "000";
  }

  service {
    "apache":
      name => $apache,
      enable => true,
      ensure => running,
      hasrestart => true,
      require => Package["apache"],
  }

  if $operatingsystem == "Debian" {
    # Disable the Debian "default" site.
    file { "${sites_enabled}/000-default":
      ensure => absent,
      notify => Service["apache"]
    }
  }
}
