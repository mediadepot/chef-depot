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

#create the depot user.
user node[:depot][:user] do
  shell '/bin/bash'
  comment 'Depot - Media Server'
  home node[:depot][:home_dir]
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

#create depot log folder
directory "#{node[:depot][:log_dir]}" do
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

#install base dependencies.
include_recipe 'build-essential::default'
include_recipe 'python::default'
include_recipe 'git::default'
package 'curl'
package 'ntp'

if node[:instance_role] == 'vagrant'
  package 'ubuntu-desktop' #most vagrant base boxes dont have the desktop packages installed, so impossible to test VNC.
end

#verify permissions on all mounted drives before running greyhole
node[:greyhole][:mounted_drives].each{|mount_path|
  #set permissions on all mounted drives
  execute "chown-#{mount_path}" do
    command "chown -R #{node[:depot][:user]}:users #{mount_path}"
    user 'root'
    action :run
  end

  #make sure gh folder exists, and has the correct permissions
  directory ::File.join(mount_path, 'gh') do
    owner node[:depot][:user]
    group 'users'
    recursive true
    not_if do ::File.directory?(::File.join(mount_path, 'gh')) end
    notifies :run, execute "chmod-#{::File.join(mount_path, 'gh')}"
  end
  execute "chmod-#{::File.join(mount_path, 'gh')}" do
    command "chmod +s #{::File.join(mount_path, 'gh')}"
    user 'root'
    action :nothing
  end
}

include_recipe 'greyhole'

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
if node[:vnc][:enabled]
  include_recipe 'depot::vnc'
end
if node[:smart_monitoring][:enabled]
  include_recipe 'depot::smart_monitoring'
end

