#
# Cookbook Name:: depot
# Recipe:: conky
#
# Copyright (C) 2015 Jason Kulatunga
#

package 'conky-all' do
  action :install
end

#copy the conky configuration file to the depot user directory
template "#{node[:depot][:home_dir]}/.conkyrc" do
  source 'home_depot_conkyrc.erb'
  variables({
                :depot => node[:depot],
                :greyhole => node[:greyhole]
            })
  owner node[:depot][:user]
  group node[:depot][:group]
end

#copy the conky template to the final location (figure out autostarting after.)
template 'usr/share/upstart/sessions/conky.conf' do
  source 'usr_share_upstart_sessions_conky.conf.erb'
  mode 0644
  variables({
                :depot => node[:depot]
            })
end

