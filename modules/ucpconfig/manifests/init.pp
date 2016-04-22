# Class: ucpconfig
# ===========================
#
# Full description of class ucpconfig here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'ucpconfig':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2016 Your name here, unless otherwise noted.
#
  
class ucpconfig (
  
  $ucp_master                    = $ucpconfig::params::ucp_master,
  $ucp_deploy_node               = $ucpconfig::params::ucp_deploy_node,
  $ucp_url                       = $ucpconfig::params::ucp_url,
  $ucp_username                  = $ucpconfig::params::ucp_username,
  $ucp_password                  = $ucpconfig::params::ucp_password,
  $ucp_fingerprint               = $ucpconfig::params::ucp_fingerprint,
  $ucp_version                   = $ucpconfig::params::ucp_version,
  $ucp_host_address              = $ucpconfig::params::ucp_host_address,
  $ucp_subject_alternative_names = $ucpconfig::params::ucp_subject_alternative_names,
  $ucp_external_ca               = $ucpconfig::params::ucp_external_ca,
  $ucp_swarm_scheduler           = $ucpconfig::params::ucp_swarm_scheduler,
  $ucp_swarm_port                = $ucpconfig::params::ucp_swarm_port,
  $ucp_controller_port           = $ucpconfig::params::ucp_controller_port,
  $ucp_preserve_certs            = $ucpconfig::params::ucp_preserve_certs,
  $ucp_license_file              = $ucpconfig::params::ucp_license_file,
  $consul_master_ip              = $ucpconfig::params::consul_master_ip,
  $consul_advertise              = $ucpconfig::params::consul_advertise,
  $consul_image                  = $ucpconfig::params::consul_image,
  $consul_bootstrap_num          = $ucpconfig::params::consul_bootstrap_num,
  $docker_network                = $ucpconfig::params::docker_network,
  $docker_network_driver         = $ucpconfig::params::docker_network_driver,
  $docker_cert_path              = $ucpconfig::params::docker_cert_path,
  $docker_host                   = $ucpconfig::params::docker_host,
) inherits ucpconfig::params {

class { 'docker':
  tcp_bind         => 'tcp://127.0.0.1:4243',
  socket_bind      => 'unix:///var/run/docker.sock',
  extra_parameters => "--cluster-store=consul://${consul_master_ip}:8500 --cluster-advertise=eth1:2376",
  } ->

class {'docker::compose':
  version => '1.6.2',
  require => Class['docker']
  } ->

case $::hostname {
  $ucp_master: {

  docker::image { 'scottyc/consul': } ->
  docker::image { 'gliderlabs/registrator': } ->

  docker::run { 'consul':
    image    => 'scottyc/consul',
    hostname => $::hostname,
    command  => "-server --advertise ${consul_master_ip} -bootstrap-expect 1",
    ports    => ['8301:8301', '8301:8301/udp', '8302:8302', '8302:8302/udp', '8400:8400', '8500:8500', '8600:8600', '8600:8600/udp'],
    before   => Class['ucpconfig::master']
    }
  
  contain ucpconfig::master
  contain ucpconfig::config

  
  Class['ucpconfig::master'] -> Class['ucpconfig::config'] 
  }

  $ucp_deploy_node: {
    
     include ucpconfig::node
     contain ucpconfig::config
     contain ucpconfig::compose

    Class['ucpconfig::config'] ->  Class['ucpconfig::node'] -> Class['ucpconfig::compose'] 
  }

  default: {
    
    include ucpconfig::node
    contain ucpconfig::config


    Class['ucpconfig::config'] ->  Class['ucpconfig::node']
    }
  }
}




