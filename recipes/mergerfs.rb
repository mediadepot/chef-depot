#
# Cookbook Name:: depot
# Recipe:: mergerfs
#
# Copyright (C) 2015 Jason Kulatunga
#

#download new version of libfuse and fuse (because otherwise merger has problems)

remote_file "#{Chef::Config[:file_cache_path]}/libfuse2_2.9.5-1_amd64.deb" do
  source 'http://http.us.debian.org/debian/pool/main/f/fuse/libfuse2_2.9.5-1_amd64.deb'
  mode 0644
end
dpkg_package 'libfuse2_2.9.5-1_amd64.deb' do
  source "#{Chef::Config[:file_cache_path]}/libfuse2_2.9.5-1_amd64.deb"
  action :install
end

remote_file "#{Chef::Config[:file_cache_path]}/fuse_2.9.5-1_amd64.deb" do
  source 'http://http.us.debian.org/debian/pool/main/f/fuse/fuse_2.9.5-1_amd64.deb'
  mode 0644
end
dpkg_package 'fuse_2.9.5-1_amd64.deb' do
  source "#{Chef::Config[:file_cache_path]}/fuse_2.9.5-1_amd64.deb"
  action :install
end

remote_file "#{Chef::Config[:file_cache_path]}/mergerfs_2.12.3.debian-wheezy_amd64.deb" do
  source 'https://github.com/trapexit/mergerfs/releases/download/2.12.3/mergerfs_2.12.3.debian-wheezy_amd64.deb'
  mode 0644
end

dpkg_package 'mergerfs_2.12.3.debian-wheezy_amd64.deb' do
  source "#{Chef::Config[:file_cache_path]}/mergerfs_2.12.3.debian-wheezy_amd64.deb"
  action :install
end

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
node[:depot][:mapped_folders].each { |share_name, mapped_folder|
  directory "#{node[:depot][:storage_mount_root]}/#{mapped_folder[:folder_name]}"  do
    owner node[:depot][:user]
    group 'users'
    not_if do ::File.directory?("#{node[:depot][:storage_mount_root]}/#{mapped_folder[:folder_name]}") end
  end

  #add special folders to downloads. Torrents added to the blackhole folder will be saved to the
  #associated downloads folder after completed.
  directory "#{node[:depot][:downloads_path]}/#{mapped_folder[:folder_name]}" do
    recursive true
    owner node[:depot][:user]
    group 'users'
  end
}

#verify permissions on storage folder and sub directories
execute "chown-#{node[:depot][:storage_mount_root]}" do
  command "chown -R #{node[:depot][:user]}:users #{node[:depot][:storage_mount_root]}"
  user 'root'
  action :run
end
