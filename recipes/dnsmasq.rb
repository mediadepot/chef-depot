# package 'dnsmasq'
# #https://www.leaseweb.com/labs/2013/08/wildcard-dns-ubuntu-hosts-file-using-dnsmasq/
# #https://wiki.archlinux.org/index.php/dnsmasq
# #http://laravel.io/forum/01-19-2016-ubuntu-dnsmasq-wildcard-app-to-1921681010-and-127001-to-dev

#copy the dnsmasq configuration file to the NetworkManager config directory
template "/etc/NetworkManager/dnsmasq.d/depot.conf" do
  source 'etc_NetworkManager_dnsmasqd_depot.conf.erb'
  variables({
                :depot => node[:depot],
            })
  notifies :run, 'execute[pkill_dnsmasq]', :immediately
end

#kill any existing dnsmasq process ()
execute 'pkill_dnsmasq' do
  command 'pkill dnsmasq || true'
  action :nothing
  notifies :restart, 'service[network-manager]', :immediately
end

#restart the network manager service
service 'network-manager' do
  action :nothing
end