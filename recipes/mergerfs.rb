#
# Cookbook Name:: depot
# Recipe:: mergerfs
#
# Copyright (C) 2015 Jason Kulatunga
#
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
  # TODO: we should be able to specify "device '/media/drive*'" however Chef doesnt like it.
  device node[:mount][:drives].map {|drive| drive[:mount_point] }.join(':') #'/mnt/drive1:/mnt/drive2:..'
  fstype 'fuse.mergerfs'
  options'direct_io,defaults,allow_other,minfreespace=50G,fsname=mergerfs'
  action [:mount, :enable]
  not_if "mountpoint -q #{node[:depot][:storage_mount_root]}"
end


#create the folder structure inside the storage drive
node[:depot][:mapped_folders].each { |share_name, mapped_folder|
  directory "#{node[:depot][:storage_mount_root]}/#{mapped_folder[:folder_name]}"  do
    owner node[:depot][:user]
    group 'users'
    not_if do ::File.directory?("#{node[:depot][:storage_mount_root]}/#{mapped_folder[:folder_name]}") end
  end

}

