#
# Cookbook Name:: depot
# Recipe:: docker
#
# Copyright (C) 2015 Jason Kulatunga
#

# start the docker service

docker_installation_binary 'default' do
  version '1.9.0'
end

docker_service_manager_upstart 'default' do
  host ['unix:///var/run/docker.sock', 'tcp://127.0.0.1:2376']
  action :start
end

rancher_manager 'depot_rancher_server' do
  settings({
    'catalog.url' => 'https://github.com/mediadepot/rancher-catalog.git'
  })
  port node[:manager][:listen_port]
  binds ['/etc/profile.d:/etc/profile.d']
end

rancher_auth_local node['depot']['user'] do
  admin_password node['depot']['password']
  manager_ipaddress node['ipaddress']
  manager_port node[:manager][:listen_port]
  not_if do node['rancher']['flag']['authenticated'] end
end

rancher_agent 'depot_rancher_agent' do
  manager_ipaddress node['ipaddress']
  manager_port node[:manager][:listen_port]
  single_node_mode true

  labels lazy {
    host_labels = [
        "depot.user:#{node[:depot][:user]}",
        "depot.password:#{node[:depot][:password]}",
        "depot.internal_domain:#{node[:depot][:internal_domain]}",
        "depot.external_domain:#{node[:depot][:external_domain]}",
        "depot.host.ipaddress:#{node['ipaddress']}",
        "depot.load_balancer.http_listen_port:#{node[:load_balancer][:http_listen_port]}",
        "depot.load_balancer.https_listen_port:#{node[:load_balancer][:https_listen_port]}",
        "depot.couchpotato.api_key:couchcouch",
        "depot.sickrage.api_key:sicksick",
        "depot.headphones.api_key:headhead",
        "depot.pushover.api_key:pushpush"
    ]
    host_labels
  }
  # not_if('sudo docker ps | grep "rancher/agent" | wc -l')
end

#create env_file (for docker-compose files )
template '/etc/profile.d/rancher.sh' do
  source 'etc_profiled_rancher.sh.erb'
  variables lazy {
    {
      :depot => node[:depot],
      :rancher => node[:rancher],
      :manager => node[:manager],
      :load_balancer => node[:load_balancer]
    }
  }
  owner node[:depot][:user]
  group node[:depot][:group]
  mode 0775
end

#git clone the rancher-catalog
git "#{node[:depot][:home_dir]}/rancher-catalog" do
  repository 'https://github.com/mediadepot/rancher-catalog.git'
  revision 'master'
  action :sync
end

#install rancher-compose cli
remote_file "#{Chef::Config[:file_cache_path]}/rancher-compose-linux-amd64-v0.7.4.tar.gz" do
  source 'https://github.com/rancher/rancher-compose/releases/download/v0.7.4/rancher-compose-linux-amd64-v0.7.4.tar.gz'
  mode 0644
end

#TODO: we need to standup the docker compose with the env file above.
#extract rancher-compose and create the utility stack
bash 'extract rancher-compose and create utility stack' do
  user 'root'
  group 'root'
  code lazy {
<<-EOH
    . /etc/profile.d/rancher.sh
    tar xpzf #{Chef::Config[:file_cache_path]}/rancher-compose-linux-amd64-v0.7.4.tar.gz -C /tmp/
    mv /tmp/rancher-compose-*/rancher-compose /usr/local/bin/rancher-compose
    cd #{node[:depot][:home_dir]}/rancher-catalog/templates/utility/0
    #run rancher up on the utility stack
    rancher-compose --access-key #{node['rancher']['automation_api_key']} \
      --secret-key #{node['rancher']['automation_api_secret']} \
      --url http://#{node['ipaddress']}:#{node[:manager][:listen_port]} \
      --project-name utility \
      up -d
EOH
   }
end

