#
# Cookbook Name:: depot
# Recipe:: greyhole
#
# Copyright (C) 2015 Jason Kulatunga
#

#configuration via: https://raw.githubusercontent.com/gboudreau/Greyhole/master/USAGE

apt_repository 'greyhole' do
  uri          'http://www.greyhole.net/releases/deb'
  distribution 'stable'
  components   ['main']
  key          'http://www.greyhole.net/releases/deb/greyhole-debsig.asc'
end
package 'greyhole'

include_recipe 'depot::samba'

#bug, fixed via: https://github.com/opscode-cookbooks/database/issues/76
# package "build-essential"
# package "zlib1g-dev"
# package "libssl-dev"
# package "libreadline-gplv2-dev"
# package "libcurl4-openssl-dev"
package('libmysqlclient-dev'){ action :nothing }.run_action(:install)
chef_gem 'mysql2'
mysql_connection_info = {
    :host     => 'localhost',
    :username => 'root'
}

#create database greyhole.
mysql_database node[:greyhole][:db][:name] do
  connection mysql_connection_info
  action :create
end
#create greyhole_user user, with no privileges.
mysql_database_user node[:greyhole][:db][:user] do
  database_name node[:greyhole][:db][:name]
  connection mysql_connection_info
  password node[:greyhole][:db][:password]
  action :create
end

#grant all privileges to greyhole_user on greyhole database when connecting via localhost.
mysql_database_user node[:greyhole][:db][:user] do
  connection mysql_connection_info
  password node[:greyhole][:db][:password]
  database_name node[:greyhole][:db][:name]
  action :grant
end

#the following script is installed by the greyhole package.
# mysql_database node[:greyhole][:db][:name] do
#   database_name node[:greyhole][:db][:name]
#   connection(
#       :host     => 'localhost',
#       :username =>  node[:greyhole][:db][:user],
#       :password => node[:greyhole][:db][:password]
#   )
#   sql lazy { ::File.open('/usr/share/greyhole/schema-mysql.sql','r:UTF-8').read }
#   action :query
#   not_if "mysql -u root -D greyhole -r -B -N -e \"SELECT * FROM settings\" | grep -q last_read_log_smbd_line"
#
# end
#TODO: for some reason I'm getting syntax errors when attempting to use the mysql_database lwrp. for now we'll just do an
#execute command.
execute 'greyhole-schema' do
  command "mysql -u #{node[:greyhole][:db][:user]} -p#{node[:greyhole][:db][:password]} greyhole < /usr/share/greyhole/schema-mysql.sql"
  user 'root'
  action :run
  not_if "mysql -u root -D greyhole -r -B -N -e \"SELECT * FROM settings\" | grep -q last_read_log_smbd_line"
end




#copy over the config file
template '/etc/init/greyhole_watcher.conf' do
  source 'etc_init_greyhole_watcher.conf.erb'
  owner 'root'
  group 'root'
  variables({
                :depot => node[:depot],
                :pushover => node[:pushover],
                :greyhole => node[:greyhole]
            })
  notifies :start, 'service[greyhole_watcher]',:immediately
end

service 'greyhole_watcher' do
  action    [:enable, :start]
  provider Chef::Provider::Service::Upstart
end

#copy over the config file
template '/etc/greyhole.conf' do
  source 'etc_greyhole.conf.erb'
  owner 'root'
  group 'root'
  variables({
                :depot => node[:depot],
                :greyhole => node[:greyhole]
            })
  notifies :restart, 'service[greyhole]',:immediately
end

service 'greyhole' do
  action    [:enable, :start]
  provider Chef::Provider::Service::Upstart
  supports  :start => true, :stop => true, :status => true, :restart => true
end

#used my the mount_shares_locally script
template "#{node[:depot][:home_dir]}/.smb_credentials" do
  source 'home_depot_smb_credentials.erb'
  owner node[:depot][:user]
  group node[:depot][:user]
  mode 00755
  variables({
                :depot => node[:depot],
                :samba => node[:samba]
            })
end

template '/etc/init/mount_shares_locally.conf' do
  source 'etc_init_mount_shares_locally.conf.erb'
  owner 'root'
  group 'root'
  variables({
                :depot => node[:depot],
                :pushover => node[:pushover],
                :greyhole => node[:greyhole]
            })
  notifies :restart, 'service[mount_shares_locally]',:immediately
end

service 'mount_shares_locally' do
  action    [:enable,:start]
  provider Chef::Provider::Service::Upstart
end

