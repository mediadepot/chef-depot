#
# Cookbook Name:: depot
# Recipe:: mergerfs
#
# Copyright (C) 2015 Jason Kulatunga
#

#download new version of libfuse and fuse (because otherwise merger has problems)

remote_file "#{Chef::Config[:file_cache_path]}/libfuse2_2.9.4-1ubuntu1_amd64.deb" do
  source 'http://mirrors.kernel.org/ubuntu/pool/main/f/fuse/libfuse2_2.9.4-1ubuntu1_amd64.deb'
  mode 0644
end

remote_file "#{Chef::Config[:file_cache_path]}/fuse_2.9.4-1ubuntu1_amd64.deb" do
  source 'http://mirrors.kernel.org/ubuntu/pool/main/f/fuse/fuse_2.9.4-1ubuntu1_amd64.deb'
  mode 0644
end

remote_file "#{Chef::Config[:file_cache_path]}/mergerfs_2.12.3.ubuntu-trusty_amd64.deb" do
  source 'https://github.com/trapexit/mergerfs/releases/download/2.12.3/mergerfs_2.12.3.ubuntu-trusty_amd64.deb'
  mode 0644
end

execute 'install mergerfs package and deps' do
  # command 'dpkg -i libfuse2_2.9.4-1ubuntu1_amd64.deb fuse_2.9.4-1ubuntu1_amd64.deb mergerfs_2.12.3.ubuntu-trusty_amd64.deb'
  command 'dpkg -i *.deb'
  cwd "#{Chef::Config[:file_cache_path]}/"
  user 'root'
  action :run
end

# dpkg_package 'install_mergerfs' do
#   package_name [
#                    "#{Chef::Config[:file_cache_path]}/libfuse2_2.9.4-1ubuntu1_amd64.deb",
#                    "#{Chef::Config[:file_cache_path]}/fuse_2.9.4-1ubuntu1_amd64.deb",
#                    "#{Chef::Config[:file_cache_path]}/mergerfs_2.12.3.ubuntu-trusty_amd64.deb"
#                ]
#   action :install
# end

directory node[:depot][:storage_mount_root]  do
  owner node[:depot][:user]
  group 'users'
  not_if do ::File.directory?(node[:depot][:storage_mount_root]) end
end

mount node[:depot][:storage_mount_root] do
  # TODO: we should be able to specify "device '/mnt/drive*'" however Chef doesnt like it.
  device node[:mount][:drives].map {|drive| drive[:mount_point] }.sort.join(':') #'/mnt/drive1:/mnt/drive2:..'
  fstype 'fuse.mergerfs'
  options'direct_io,defaults,allow_other,minfreespace=50G,fsname=mergerfs'
  action [:enable,:mount] # the order matters, because not_if runs between each action

  not_if "mountpoint -q #{node[:depot][:storage_mount_root]}" # fuse mounts arent idempotent with chef
end

#create the folder structure inside the storage drive
node[:depot][:mapped_folders].each { |folder_name|
  directory "#{node[:depot][:storage_mount_root]}/#{folder_name}"  do
    owner node[:depot][:user]
    group 'users'
    not_if do ::File.directory?("#{node[:depot][:storage_mount_root]}/#{folder_name}") end
  end

  #add special folders to downloads. Torrents added to the blackhole folder will be saved to the
  #associated downloads folder after completed.
  directory "#{node[:depot][:downloads_path]}/#{folder_name}" do
    recursive true
    owner node[:depot][:user]
    group 'users'
  end
}

cookbook_file "#{node[:depot][:storage_mount_root]}/README.md" do
  source 'media_storage_README.md'
  owner node[:depot][:user]
  group 'users'
  mode '0755'
  action :create
end

#verify permissions on storage folder and sub directories
execute "chown-#{node[:depot][:storage_mount_root]}" do
  command "chown -R #{node[:depot][:user]}:users #{node[:depot][:storage_mount_root]}"
  user 'root'
  action :run
end
