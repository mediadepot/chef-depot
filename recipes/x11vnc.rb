#
# Cookbook Name:: depot
# Recipe:: x11vnc
#
# Copyright (C) 2015 Jason Kulatunga

# based off of https://github.com/jgoulah/x11vnc-cookbook/blob/master/recipes/default.rb



package 'x11vnc'

password_opt = ''
unless node['x11vnc']['password'].empty?
  password_file = '/etc/x11vnc.pass'
  password_opt = "-rfbauth #{password_file}"

  execute 'gen x11vnc password file' do
    command "x11vnc -storepasswd #{node['x11vnc']['password']} #{password_file}"
    not_if { ::File.exist?(password_file) }
  end
end

template '/etc/init/x11vnc.conf' do
  source 'etc_init_x11vnc.conf.erb'
  mode 00644
  variables(
      :display         => node['x11vnc']['display'],
      :log_file        => node['x11vnc']['log_file'],
      :executable_args => node['x11vnc']['executable_args'],
      :password_opt    => password_opt
  )
  notifies(:restart, 'service[x11vnc]')
end

service 'x11vnc' do
  action [:enable, :start]
  provider Chef::Provider::Service::Upstart
end