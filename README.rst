CAVEATS
-------
This code hasn't been actively used/developed since 0.24.x.
I've left it up for historical interest but you probably should not use it.

puppet-module-apache
--------------------
Puppet module for configuring the apache webserver. Currently
only tested on Debian.

Install into your <puppet module_path>/apache

Use ``include apache`` to install a basic apache server listening on
port 80. There are no sites defined/enabled by default, however.

Tuneables
---------
$apache
     Name of the apache package you want installed. It is assumed the service
     will have the same name.

     Default: ``apache2``

$apache_worker
     Name of the apache worker package you want installed.

     Default: ``apache2-mpm-prefork``

$apache_conf_dir
     Path to the config directory for apache.

     Default: ``/etc/${apache}``

$apache_conf_file
     Name of the main apache config file.

     Default: ``${apache}.conf``

$apache_init_script
     Path to the init script for apache.

     Default: ``/etc/init.d/${apache}``

$apache_sites_available
     Path to the directory which will contain config files for defined sites.

     Default: ``${apache_conf_dir}/sites-available``

$apache_sites_enabled
     Path to the directory which will contain the symlinks for active sites.

     Default: ``${apache_conf_dir}/sites-enabled``

$apache_mods_available
     Path to the directory which will contain config files for apache modules.

     Default: ``${apache_conf_dir}/mods-available``

$apache_mods_enabled
     Path to the directory which will contain the symlinks for active modules.

     Default: ``${apache_conf_dir}/mods-enabled``

$apache_listen_address
     The address apache should listen on.

     Default: ``*``

$apache_listen_port
     The port apache should listen on.

     Default: ``80``

$apache_run_user
     System user to run apache as.

     Default: ``www-data``

$apache_run_group
     System group to run apache as.

     Default: ``www-data``

Defined Types
-------------
apache::config
     Config snippets which will be pulled in via ``Include`` to your apache
     configuration.

     Parameters:

     * ``ensure`` (default: ``present``)
     * ``content``
      * Note ``content`` and ``source`` are mutually exclusive.
     * ``source``
      * Note ``content`` and ``source`` are mutually exclusive.
     * ``order``
      * Order in which this config snippet will be included.

apache::vhost
     Sets up apache virtual hosts by creating files in
     ``${apache_sites_available}`` and, if enabled, symlinks in
     ``${apache_sites_enabled}``.

     Parameters:

     * ``ensure``
     * ``content``
      * Note ``content`` and ``source`` are mutually exclusive.
     * ``source``
      * Note ``content`` and ``source`` are mutually exclusive.

Custom Types/Providers
----------------------
apachemodule
     Custom type to manage Apache modules. Note that all uses of
     apachemodule *must* ``require => Package["apache"]`` to get around
     limitations in Puppet's provider suitability checking.::

     apachemodule {
       "status":
         ensure => present,
         require => Package["apache"];
     }

a2mod
     Provider for ``apachemodule`` which uses a2enmod and a2dismod. Assumes
     that the module dir (``$apache_mods_enabled``) is ``/etc/apache2/mods-enabled``
