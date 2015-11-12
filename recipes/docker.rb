#
# Cookbook Name:: depot
# Recipe:: docker
#
# Copyright (C) 2015 Jason Kulatunga
#

# start the docker service

docker_installation_binary 'default' do
  version '1.7.1'
end

docker_service_manager_upstart 'default' do
  host ['unix:///var/run/docker.sock', 'tcp://127.0.0.1:2376']
  action :start
end

docker_rancher 'depot_rancher_server' do
  settings({
               'catalog.url' => 'https://github.com/mediadepot/rancher-catalog.git'
           })
  port node[:manager][:listen_port]
  notifies :create, 'docker_rancher_agent[depot_rancher_agent]', :delayed
end

docker_rancher_agent 'depot_rancher_agent' do
  manager_ipaddress node['ipaddress']
  manager_port node[:manager][:listen_port]
  single_node_mode true
  action :nothing
end
