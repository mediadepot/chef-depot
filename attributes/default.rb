default['build-essential']['compile_time'] = true

#default configuration
default[:depot][:salt] = 'rounds=500000$cEc2u3rRmSc0rvR1'
default[:depot][:home_dir] = "/home/#{node[:depot][:user]}"
default[:depot][:apps_dir] = '/srv/apps'
default[:depot][:log_dir] = '/var/log/depot'
default[:depot][:share_root] = '/var/share'
default[:depot][:local_mount_root] = '/mnt/samba'
#the following paths are created by the mount_shares_locally service, and match the samba share names.
default[:depot][:processing_path] = "#{node[:depot][:local_mount_root]}/processing"
#The seed root, where files are downloaded to, and can be deleted from after seeding is compelted. (files are copied to the other shares by apps.)
default[:depot][:downloads_path] = "#{node[:depot][:local_mount_root]}/downloads"
default[:depot][:blackhole_path] = "#{node[:depot][:local_mount_root]}/blackhole"
#special folders that map from the blackhole directory to the downloads folder
default[:depot][:mapped_folders] = {
    'tvshows' => {
        :folder_name => '[Tvshows]',
        :label => 'tvshows'
    },
    'movies' =>{
        :folder_name => '[Movies]',
        :label => 'movies'
    },
    'music' => {
        :folder_name => '[Music]',
        :label => 'music'
    }
}
default[:depot][:tvshows_path] = "#{node[:depot][:local_mount_root]}/tvshows"
default[:depot][:movies_path] = "#{node[:depot][:local_mount_root]}/movies"
default[:depot][:music_path] = "#{node[:depot][:local_mount_root]}/music"

default[:depot][:applications] = [
    'backup_library_config',
    'btsync',
    'conky',
    'couchpotato',
    'deluge',
    'headphones',
    'plex',
    'smart_monitoring',
    'sickbeard',
    'openssh',
    'openvpn',
    'popcorn_time',
    'update_service',
    'vnc'
]

default[:pushover]= {
    :appid => 'aNiH7or6Q5F1ennDtQpSvhbtY4ot6C', #Depot appID, sends notifications about status of server.
}

##conky configuration

##duckdns configuration
default[:duckdns][:install_dir] = '/srv/apps/duckdns'


##greyhole configuration
default[:greyhole][:db][:user] = 'greyhole_user'
default[:greyhole][:db][:password] = '89y63jdwe' #this shouldnt really be tweaked, its set by the greyhole install script.
default[:greyhole][:db][:name] = 'greyhole'

##manager configuration
default[:manager][:listen_port] = '50000'
default[:manager][:load_balancer][:listen_port] = '50001'

##nginx configuration
default[:nginx][:install_method] = 'source'
default[:nginx][:user] = "#{node[:depot][:user]}"
default[:nginx][:group] = "#{node[:depot][:group]}"
default[:nginx][:init_style] = 'upstart'
default[:nginx][:source]['use_existing_user'] = true

##sshd configuration
default[:openssh][:server][:password_authentication] = 'no'

##OpenVPN Access Server configuration
default[:openvpn][:webui][:login] = "#{node[:depot][:user]}"
default[:openvpn][:webui][:listen_port] = '943'
default[:openvpn][:server][:tcp_listen_port] = '60002'
default[:openvpn][:server][:udp_listen_port] = '60001'


##samba configuraion
default[:samba][:mount_path] = '/mnt/samba' #cannot be changed manually .. lots of references.
default[:samba][:workgroup] = 'WORKGROUP'
default[:samba][:interfaces] = '127.0.0.0/8 eth0'
default[:samba][:shares] = {
    'blackhole' => {
        'path' => '/var/share/blackhole',
        'create mask' => '0770',
        'directory mask' => '0770',
        'read only' => 'no',
        'available' => 'yes',
        'browseable' => 'yes',
        'writable' => 'yes',
        'guest ok' => 'no',
        'printable' => 'no',
        'dfree command' => '/usr/bin/greyhole-dfree',
        'vfs objects' => 'greyhole',
        'force user' => "#{node[:depot][:user]}",
        'force create mode' => '0770',
        'force directory mode' => '0770'
    },
    'processing' => {
        'path' => '/var/share/downloads/processing',
        'create mask' => '0770',
        'directory mask' => '0770',
        'read only' => 'no',
        'available' => 'yes',
        'browseable' => 'yes',
        'writable' => 'yes',
        'guest ok' => 'no',
        'printable' => 'no',
        # "dfree command" => "/usr/bin/greyhole-dfree", #this share should not be a greyhole share
        # "vfs objects" => "greyhole",
        'force user' => "#{node[:depot][:user]}",
        'force create mode' => '0770',
        'force directory mode' => '0770'
    },
    'downloads' => {
        'path' => '/var/share/downloads/completed',
        'create mask' => '0770',
        'directory mask' => '0770',
        'read only' => 'no',
        'available' => 'yes',
        'browseable' => 'yes',
        'writable' => 'yes',
        'guest ok' => 'no',
        'printable' => 'no',
        'dfree command' => '/usr/bin/greyhole-dfree',
        'vfs objects' => 'greyhole',
        'force user' => "#{node[:depot][:user]}",
        'force create mode' => '0770',
        'force directory mode' => '0770'
    },
    'tvshows' => {
        'path' => '/var/share/media/tvshows',
        'create mask' => '0770',
        'directory mask' => '0770',
        'read only' => 'no',
        'available' => 'yes',
        'browseable' => 'yes',
        'writable' => 'yes',
        'guest ok' => 'no',
        'printable' => 'no',
        'dfree command' => '/usr/bin/greyhole-dfree',
        'vfs objects' => 'greyhole',
        'force user' => "#{node[:depot][:user]}",
        'force create mode' => '0770',
        'force directory mode' => '0770'
    },
    'movies' => {
        'path' => '/var/share/media/movies',
        'create mask' => '0770',
        'directory mask' => '0770',
        'read only' => 'no',
        'available' => 'yes',
        'browseable' => 'yes',
        'writable' => 'yes',
        'guest ok' => 'no',
        'printable' => 'no',
        'dfree command' => '/usr/bin/greyhole-dfree',
        'vfs objects' => 'greyhole',
        'force user' => "#{node[:depot][:user]}",
        'force create mode' => '0770',
        'force directory mode' => '0770'
    },
    'music' => {
        'path' => '/var/share/media/music',
        'create mask' => '0770',
        'directory mask' => '0770',
        'read only' => 'no',
        'available' => 'yes',
        'browseable' => 'yes',
        'writable' => 'yes',
        'guest ok' => 'no',
        'printable' => 'no',
        'dfree command' => '/usr/bin/greyhole-dfree',
        'vfs objects' => 'greyhole',
        'force user' => "#{node[:depot][:user]}",
        'force create mode' => '0770',
        'force directory mode' => '0770'
    }
}

default['samba']['hosts_allow'] = '127.0.0.0/8'
default['samba']['bind_interfaces_only'] = 'no'
default['samba']['server_string'] = 'Samba Server'
default['samba']['load_printers'] = 'no'
default['samba']['passdb_backend'] = 'tdbsam'
default['samba']['dns_proxy'] = 'no'
default['samba']['security'] = 'user'
default['samba']['map_to_guest'] = 'Bad User'
default['samba']['socket_options'] = 'TCP_NODELAY'
default['samba']['client_package'] = 'smbclient'
default['samba']['server_package'] = 'samba'
default['samba']['services'] = ['smbd', 'nmbd']
default['samba']['config'] = '/etc/samba/smb.conf'
default['samba']['log_dir'] = '/var/log/samba/%m.log'




## Media Library Updater (Push media to gist.)


