#
# Cookbook Name:: depot
# Recipe:: openssh
#
# Copyright (C) 2015 Jason Kulatunga
#

#TODO: modify the root user authorized_keys file with the github ssh public keys
#Modify the root user's authorized_keys file.
# directory '/root/.ssh' do
#   owner 'root'
#   group 'root'
#   mode 00700
#   action :create
# end
#
# cookbook_file 'root_ssh_authorized_keys' do
#   path '/root/.ssh/authorized_keys'
#   action :create
#   mode 00600
#   owner 'root'
#   group 'root'
# end
#
# directory "#{node[:depot][:home_dir]}/.ssh" do
#   owner node[:depot][:user]
#   group node[:depot][:group]
#   mode 00700
#   action :create
# end
#
# cookbook_file "home_depot_ssh_authorized_keys" do
#   path "#{node[:depot][:home_dir]}/.ssh/authorized_keys"
#   action :create
#   mode 00600
#   owner node[:depot][:user]
#   group node[:depot][:user]
# end


include_recipe 'openssh::default'