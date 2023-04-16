#
# @summary manages gitea installation
#
# @param version Gitlab Version to install
# @param home home path of the gitea user
# @param user gitea user
# @param group gitea user group
# @param repository_path where repository should be stored
# @param app_name name for your gitea instance
# @param domain domain where your instance is
# @param run_mode in which mode gitea should be run (dev, prod)
# @param database_type which database should be configured (postgresql, sqlite)
# @param database_host host of the database (currently only for postgresql)
# @param database_name name of the database (currently only for postgresql)
# @param database_user user of the database (currently only for postgresql)
# @param database_password password of the database (currently only for postgresql)
# @param http_protocol which protocol should be used (unix, http)
# @param http_addr listen address
# @param root_url root url of the gitea instance e.g '%(PROTOCOL)s://%(DOMAIN)s:%(HTTP_PORT)s/'
# @param disable_registration disables registration
# @param disable_git_hooks disables git hooks in the webui
# @param lfs_enabled enables git LFS for repositories
# @param lfs_data_path where should lfs data be stored
#
# @author Sebastian Rakel <sebastian@devunit.eu>
#
class gitea (
  String[1] $version,
  String[1] $home,
  String[1] $user,
  String[1] $group,
  String[1] $repository_path,
  String[1] $app_name,
  String[1] $domain,
  Enum['dev', 'prod'] $run_mode,
  Enum['postgresql', 'mysql', 'mariadb', 'sqlite'] $database_type,
  String $database_host,
  String $database_name,
  String $database_user,
  String $database_password,
  Enum['http','unix'] $http_protocol,
  String[1] $http_addr,
  Integer $http_port,
  String[1] $root_url,
  Boolean $disable_registration,
  Boolean $disable_git_hooks,
  Boolean $lfs_enabled,
  Stdlib::Absolutepath $lfs_data_path,
) {
  contain gitea::install
  contain gitea::database
  contain gitea::config
  contain gitea::service

  Class['gitea::install'] -> Class['gitea::database'] -> Class['gitea::config'] ~> Class['gitea::service']
}
