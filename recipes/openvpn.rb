#
# Cookbook Name:: depot
# Recipe:: openvpn
#
# Copyright (C) 2015 Jason Kulatunga
#

include_recipe 'depot::duckdns'

#http://swupdate.openvpn.org/as/openvpn-as-2.0.10-Ubuntu14.amd_64.deb
remote_file "#{Chef::Config[:file_cache_path]}/openvpn-as-2.0.10-Ubuntu14.amd_64.deb" do
  source 'http://swupdate.openvpn.org/as/openvpn-as-2.0.10-Ubuntu14.amd_64.deb'
  mode 0644
end

dpkg_package 'openvpn-as-2.0.10-Ubuntu14.amd_64' do
  source "#{Chef::Config[:file_cache_path]}/openvpn-as-2.0.10-Ubuntu14.amd_64.deb"
  action :install
end

# #copy the configuration file.
template '/usr/local/openvpn_as/etc/as.conf' do
  source 'usr_local_openvpn_as_etc_as.conf.erb'
  variables({
                :depot => node[:depot],
                :openvpn => node[:openvpn]
            })
end
#
# #copy the configuration file.
# template "/usr/local/openvpn_as/etc/config_templ.json" do
#   source "usr_local_openvpn_as_etc_config.json.erb"
#   variables({
#                 :depot => node[:depot],
#                 :openvpn => node[:openvpn]
#             })
# end


bash 'configure openvpn access server' do
  user 'root'
  cwd '/usr/local/openvpn_as/scripts/'
  code <<-EOH
./sacli stop
sleep 5
./sacli -u #{node[:openvpn][:webui][:login]} -k prop_superuser -v true UserPropPut
./sacli -k admin_ui.https.ip_address -v all ConfigPut
./sacli -k admin_ui.https.port -v #{node[:openvpn][:webui][:listen_port]} ConfigPut
./sacli -k cs.https.ip_address -v all ConfigPut
./sacli -k cs.https.port -v #{node[:openvpn][:webui][:listen_port]} ConfigPut
./sacli -k vpn.client.routing.inter_client -v false ConfigPut
./sacli -k vpn.client.routing.reroute_dns -v custom ConfigPut
./sacli -k vpn.client.routing.reroute_gw -v false ConfigPut
./sacli -k vpn.daemon.0.listen.ip_address -v all ConfigPut
./sacli -k vpn.daemon.0.listen.port -v #{node[:openvpn][:server][:tcp_listen_port]} ConfigPut
./sacli -k vpn.daemon.0.server.ip_address -v all ConfigPut
./sacli -k vpn.server.dhcp_option.dns.0 -v #{node['ipaddress']} ConfigPut
./sacli -k vpn.server.daemon.tcp.port -v #{node[:openvpn][:server][:tcp_listen_port]} ConfigPut
./sacli -k vpn.server.daemon.udp.port -v #{node[:openvpn][:server][:udp_listen_port]} ConfigPut
./sacli -k host.name -v #{node[:depot][:external_domain]} ConfigPut
sleep 5
./sacli start
  EOH
end

service 'openvpnas' do
  action    [:enable, :start]
  provider Chef::Provider::Service::Init::Debian
end
