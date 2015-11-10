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
  package 'ubuntu-desktop' #most vagrant base boxes dont have the desktop packages installed, so impossible to test VNC.
  node[:greyhole][:mounted_drives].each do |mount_path|

    #in vagrant, we dont actually mount any drives, so create folders manually.
    directory mount_path do
      owner node[:depot][:user]
      group 'users'
      recursive true
      not_if do ::File.directory?(mount_path) end
    end

  end
end

#verify permissions on all mounted drives before running greyhole
node[:greyhole][:mounted_drives].each do |mount_path|
  #set permissions on all mounted drives
  execute "chown-#{mount_path}" do
    command "chown -R #{node[:depot][:user]}:users #{mount_path}"
    user 'root'
    action :run
  end

  gh_folder_path = ::File.join(mount_path, 'gh')

  #make sure gh folder exists, and has the correct permissions
  directory gh_folder_path do
    owner node[:depot][:user]
    group 'users'
    recursive true
    not_if do ::File.directory?(gh_folder_path) end
    notifies :run, "execute[chmod-#{gh_folder_path}]"
  end

  execute "chmod-#{gh_folder_path}" do
    command "chmod +s #{gh_folder_path}"
    user 'root'
    action :nothing
  end
end

include_recipe 'depot::greyhole'

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

include_recipe 'depot::docker'
