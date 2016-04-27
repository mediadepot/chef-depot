#
# Cookbook Name:: depot
# Recipe:: smart_monitoring
#
# Copyright (C) 2015 Jason Kulatunga
#

# Modified version of https://github.com/jtimberman/smartmontools-cookbook
node.default['smartmontools']['devices'] = node[:mount][:drives].map {|drive|

  if drive[:device_type] == 'label'
    "/dev/disk/by-label/#{drive[:device]}"
  elsif drive[:device_type] == 'uuid'
    "/dev/disk/by-uuid/#{drive[:device]}"
  else
    #assume that this is a device if not specified
    drive[:device]
  end

} #/dev/sda /dev/sdb ..'


package 'smartmontools'

template '/etc/default/smartmontools' do
  source 'etc_default_smartmontools.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :reload, 'service[smartmontools]'
end

# manage smartmontools rund files
node['smartmontools']['run_d'].each do |rund|
  template "/etc/smartmontools/run.d/#{rund}" do
    source "etc_smartmontools_rund_#{rund}.erb"
    owner 'root'
    group 'root'
    mode '0755'
    variables({
        :depot => node[:depot],
        :pushover => node[:pushover]
    })
  end
end

template '/etc/smartd.conf' do
  source 'etc_smartd.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :reload, 'service[smartmontools]'
end

service 'smartmontools' do
  supports status: true, reload: true, restart: true
  action [:enable, :start]
end


#
#
# include_recipe 'smartmontools::default'