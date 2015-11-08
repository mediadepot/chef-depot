#
# Cookbook Name:: depot
# Recipe:: duckdns
#
# Copyright (C) 2015 Jason Kulatunga
#

template "#{node[:duckdns][:install_dir]}/duckdns.sh" do
  source "srv_apps_depot_tools_duckdns.sh.erb"
  owner node[:depot][:user]
  group node[:depot][:group]
  mode 0775
  variables({
                :depot => node[:depot]
            })
end


#copy over the cron job (update the dsn entry )
cron "duck_dns_updater" do
  command "#{node[:duckdns][:install_dir]}/duckdns.sh >/dev/null 2>&1"
  minute "*/15"
  #run the cron job every 15 minutes.
  user node[:depot][:user]
end
