#
# Cookbook Name:: depot
# Recipe:: default
#
# Copyright (C) 2015 Jason Kulatunga
#

# Hash the password
ruby_block 'set password hash' do
  block {
    hash = node[:depot][:password].crypt("$6$#{node[:depot][:salt]}")
    node.default[:depot][:password_hash] = hash
  }
end

group node[:depot][:group] do
  action :create
  gid '15000'
  append true
end

#create the depot user.
user node[:depot][:user] do
  shell '/bin/bash'
  comment 'Depot - Media Server'
  home node[:depot][:home_dir]
  uid '15000'
  group node[:depot][:group]
  system false
  password lazy { node[:depot][:password_hash] }
end

directory "#{node[:depot][:home_dir]}" do
  owner node[:depot][:user]
  group node[:depot][:group]
  mode 00755
  action :create
end

directory "#{node[:depot][:home_dir]}/.ssh" do
  owner node[:depot][:user]
  group node[:depot][:group]
  mode 00700
  action :create
end

remote_directory node[:depot][:home_dir] do
  source 'depot_home'
  files_owner node[:depot][:user]
  files_group node[:depot][:group]
  files_mode 0644
  owner node[:depot][:user]
  group node[:depot][:group]
  mode 0755
end

#create depot log folder
directory "#{node[:depot][:log_dir]}" do
  owner node[:depot][:user]
  group node[:depot][:group]
  action :create
end

directory "#{node[:depot][:apps_dir]}" do
  owner node[:depot][:user]
  group node[:depot][:group]
  action :create
end

#copy over the init for chefdk + ruby.
template '/etc/profile.d/depot.sh' do
  source 'etc_profiled_depot.sh.erb'
  mode 0775
  variables({
      :depot => node[:depot]
  })
end

#run apt-get update (required for most installs)
execute "apt-get-update-periodic" do
  command "apt-get update"
  ignore_failure true
  # only_if do
  #   File.exists?('/var/lib/apt/periodic/update-success-stamp') &&
  #       File.mtime('/var/lib/apt/periodic/update-success-stamp') < Time.now - 86400
  # end
  action :nothing
end.run_action( :run )

#install base dependencies.
include_recipe 'build-essential::default'
include_recipe 'python::default'
include_recipe 'git::default'
package 'curl'
package 'ntp'

if node[:vagrant]
  # package 'ubuntu-desktop' do
  #   only_if { node[:vagrant][:install_desktop] } #most vagrant base boxes dont have the desktop packages installed, so impossible to test VNC.
  #   notifies :run, 'execute[start-desktop-env]'
  # end
  execute 'set permissions on tmp flder' do
    command 'chmod 1777 /tmp'
    action :run
  end

end

node[:mount][:drives].each do |drive|
  directory drive[:mount_point]  do
    owner node[:depot][:user]
    group 'users'
    not_if do ::File.directory?(drive[:mount_point]) end
  end
  mount drive[:mount_point] do
    device drive[:device]
    device_type drive[:device_type]
    fstype drive[:fstype]
    action [:mount, :enable]
  end
end

# Create the temp folder mount directory structure, because it's not located in the mergerfs JBOD drive.
directory node[:depot][:tmp_mount_root] do
  owner node[:depot][:user]
  group 'users'
  recursive true
  not_if do ::File.directory?(node[:depot][:tmp_mount_root]) end
end
directory node[:depot][:processing_path] do
  owner node[:depot][:user]
  group 'users'
  recursive true
  not_if do ::File.directory?(node[:depot][:processing_path]) end
end
directory node[:depot][:blackhole_path] do
  owner node[:depot][:user]
  group 'users'
  recursive true
  not_if do ::File.directory?(node[:depot][:blackhole_path]) end
end


include_recipe 'depot::mergerfs'
include_recipe 'depot::dnsmasq'

#base applications, installed alphabetically
if node[:conky][:enabled]
  include_recipe 'depot::conky'
end
if node[:openssh][:enabled]
  include_recipe 'depot::openssh'
end
if node[:openvpn][:enabled]
  include_recipe 'depot::openvpn'
end
if node[:smart_monitoring][:enabled]
  include_recipe 'depot::smart_monitoring'
end
if node[:x11vnc][:enabled]
  include_recipe 'depot::x11vnc'
end


include_recipe 'depot::docker'
