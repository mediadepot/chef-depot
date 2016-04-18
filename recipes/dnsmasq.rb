package 'dnsmasq'
#https://www.leaseweb.com/labs/2013/08/wildcard-dns-ubuntu-hosts-file-using-dnsmasq/

cookbook_file '/etc/dnsmasq.conf' do
  source 'etc_dnsmasq.conf'
  action :create_if_missing
  notifies :restart, 'service[dnsmasq]', :immediately
end

service 'dnsmasq' do
  action [:enable, :start]
end