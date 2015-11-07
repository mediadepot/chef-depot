include_recipe 'nginx::source'

nginx_sites = ['plex.nexus.local',
               'deluge.nexus.local',
               'sickbeard.nexus.local',
               'couchpotato.nexus.local',
               'headphones.nexus.local',
               'admin.nexus.local',
               'btsync.nexus.local'
]

nginx_sites.each do |site|
  template "#{node['nginx']['dir']}/sites-available/#{site}" do
    source "nginx_sites_#{site}.erb"
    mode 0777
    owner node[:nginx][:user]
    group node[:nginx][:group]
    variables({
                  :depot => node[:depot],
                  :deluge => node[:deluge],
                  :sickbeard => node[:sickbeard],
                  :couchpotato => node[:couchpotato],
                  :headphones => node[:headphones],
                  :ajenti => node[:ajenti],
                  :btsync => node[:btsync],
                  :openvpn => node[:openvpn]
              })
  end
  nginx_site "#{site}"
end


hostsfile_entry '127.0.0.1' do
  hostname  'nexus'
  aliases   nginx_sites
  comment   'Aliases for nginx sites.'
  action    :append
end
