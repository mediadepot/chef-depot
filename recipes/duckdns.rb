#
# Cookbook Name:: depot
# Recipe:: duckdns
#
# Copyright (C) 2015 Jason Kulatunga
#

directory node[:duckdns][:install_dir] do
  owner node[:depot][:user]
  group 'users'
  recursive true
  not_if do ::File.directory?(node[:duckdns][:install_dir]) end
end

template "#{node[:duckdns][:install_dir]}/duckdns.sh" do
  source "srv_apps_depot_tools_duckdns.sh.erb"
  owner node[:depot][:user]
  group node[:depot][:group]
  mode 0775
  variables({
                :duckdns_subdomain => node[:depot][:external_domain].split('.')[0],
                :duckdns => node[:duckdns]
            })
end


#copy over the cron job (update the dsn entry )
cron "duck_dns_updater" do
  command "#{node[:duckdns][:install_dir]}/duckdns.sh >/dev/null 2>&1"
  minute "*/15"
  #run the cron job every 15 minutes.
  user node[:depot][:user]
end
