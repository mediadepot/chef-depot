#
# Cookbook Name:: depot
# Recipe:: nginx
#
# Copyright (C) 2015 Jason Kulatunga
#

include_recipe 'nginx::source'

nginx_sites = ['manager',
               'openvpn',
]

nginx_sites.each do |site|
  template "#{node['nginx']['dir']}/sites-available/#{site}" do
    source "nginx_sites_#{site}.erb"
    mode 0777
    owner node[:nginx][:user]
    group node[:nginx][:group]
    variables({
                  :depot => node[:depot],
                  :manager => node[:manager],
                  :openvpn => node[:openvpn]

              })
  end
  nginx_site "#{site}.#{node['depot']['domain']}"
end


hostsfile_entry '127.0.0.1' do
  hostname  'nexus'
  aliases   nginx_sites
  comment   'Aliases for nginx sites.'
  action    :append
end
