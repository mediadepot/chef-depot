#
# Cookbook Name:: depot
# Recipe:: samba
#
# Copyright (C) 2015 Jason Kulatunga
#

#sourced from https://github.com/jtimberman/samba-cookbook

package node['samba']['server_package']
package 'cifs-utils'
svcs = node['samba']['services']

template node['samba']['config'] do
  source 'etc_samba_smb.conf.erb'
  owner 'root'
  group 'root'
  mode 00644
  variables :shares => node[:samba][:shares]
  svcs.each do |s|
    notifies :restart, "service[#{s}]", :immediately
  end
end

samba_user node[:depot][:user] do
  password node[:depot][:password]
  action [:create, :enable]
end


svcs.each do |s|
  service s do
    restart_command "service #{s} restart || true"
    action [:enable, :start]
  end
end
