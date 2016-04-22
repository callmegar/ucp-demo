class ucpconfig::node (

  $ucp_url                       = $ucpconfig::ucp_url,
  $ucp_username                  = $ucpconfig::ucp_username,
  $ucp_password                  = $ucpconfig::ucp_password,
  $ucp_fingerprint               = $ucpconfig::ucp_fingerprint,
  $ucp_version                   = $ucpconfig::ucp_version,
  $ucp_host_address              = $ucpconfig::ucp_host_address,
  $ucp_subject_alternative_names = $ucpconfig::ucp_subject_alternative_names, 
                     
){

class { 'docker_ucp':
  ucp_url                   => $ucp_url,
  fingerprint               => $ucp_fingerprint,
  username                  => $ucp_username,
  password                  => $ucp_password ,
  host_address              => $ucp_host_address,
  subject_alternative_names => $ucp_subject_alternative_names,
  replica                   => true,
  version                   => $ucp_version,
  usage                     => false,
  tracking                  => false,
  require                   => Class['docker']
  }
}
