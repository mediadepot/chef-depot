default['build-essential']['compile_time'] = true

#default configuration
default[:depot][:salt] = 'rounds=500000$cEc2u3rRmSc0rvR1'
default[:depot][:home_dir] = "/home/#{node[:depot][:user]}"
default[:depot][:tools_dir] = '/srv/apps/depot_tools'
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



##btsync configuration
default[:btsync][:user] = "#{node[:depot][:user]}"
default[:btsync][:listening_port] = '60001'
default[:btsync][:webui][:listen_port] = '54325'
default[:btsync][:webui][:enabled] = true
default[:btsync][:webui][:listen] = "0.0.0.0:#{node[:btsync][:webui][:listen_port]}"
default[:btsync][:webui][:login] = "#{node[:depot][:user]}"
default[:btsync][:webui][:password] = "#{node[:depot][:password]}"
default[:btsync][:shared_folders] = [
    # ENABLING SHARED FOLDERS WILL DISABLE THE WEBUI.
    # {
    #     "secret" => "g8lBCaDHmBu0nH4q4j1a4QPYyhGzoaTnASUsIbTVJ4lhjUf7VDAqBslCNyNm",
    #     "dir" => "/mnt/samba/tvshows/"
    # },
    # {
    #     "secret" => "gYVMHO9HpbfdW0G60pKXe09zWDlL6hufLoxQEdOBhuGyjerzsif5eMVLi6Kc",
    #     "dir" => "/mnt/samba/movies/"
    # },
    # {
    #     "secret" => "se0ejuW0HOWDli6KeG60pKXdbVML6fLzfif5EdOBh9cQgYxhuGyoHpMVLrz9",
    #     "dir" => "/mnt/samba/music/"
    # }
]
##conky configuration

##couchpotato configuration
default[:couchpotato][:listen_port] = '54322'
default[:couchpotato][:api_key] = '7055db1909f34089a1c080ce926c434a'
default[:couchpotato][:install_dir] = '/srv/apps/couchpotato'
default[:couchpotato][:config_dir] = '/etc/couchpotato'
default[:couchpotato][:data_dir] = '/media/couchpotato'
default[:couchpotato][:install_style] = 'git'
default[:couchpotato][:git_url] = 'https://github.com/RuudBurger/CouchPotatoServer.git'
default[:couchpotato][:git_ref] = '04aa2e5fa4dd5a019f763d6bcf60079a7c61650b'
default[:couchpotato][:webui][:login] = "#{node[:depot][:user]}"
default[:couchpotato][:webui][:password] = "#{node[:depot][:password]}"


##deluged configuration

##deluge-web configuration
default[:deluge][:webui][:listen_port] = '54320'
default[:deluge][:webui][:login] = "#{node[:depot][:user]}"
default[:deluge][:webui][:password] = "#{node[:depot][:password]}"
default[:deluge][:webui][:salt] = 'd84456c0316d4804265d19c32519ab92ad8366ce'


##duckdns configuration
default[:duckdns][:install_dir] = '/srv/apps/duckdns'


##greyhole configuration
default[:greyhole][:db][:user] = 'greyhole_user'
default[:greyhole][:db][:password] = '89y63jdwe' #this shouldnt really be tweaked, its set by the greyhole install script.
default[:greyhole][:db][:name] = 'greyhole'

##headphones configuration.
default[:headphones][:listen_port] = '54323'
default[:headphones][:api_key] = 'fe54ab59d71000995f526db4e4ece56b'
default[:headphones][:install_dir] = '/srv/apps/headphones'
default[:headphones][:config_dir] = '/etc/headphones'
default[:headphones][:data_dir] = '/media/headphones'
default[:headphones][:install_style] = 'git'
default[:headphones][:git_url] = 'https://github.com/rembo10/headphones.git'
default[:headphones][:git_ref] = 'a4fa8ca79d46fa042c0eaa6d7bf918a4e90f76d8'
default[:headphones][:webui][:login] = "#{node[:depot][:user]}"
default[:headphones][:webui][:password] = "#{node[:depot][:password]}"

##nginx configuration
default[:nginx][:install_method] = 'source'
default[:nginx][:user] = "#{node[:depot][:user]}"
default[:nginx][:group] = "#{node[:depot][:group]}"
default[:nginx][:init_style] = 'upstart'
default[:nginx][:source]['use_existing_user'] = true


##plex configuration
default[:plex] = {}

##sickbeard configuration
default[:sickbeard][:listen_port] = '54321'
default[:sickbeard][:api_key] = '1234'
default[:sickbeard][:install_dir] = '/srv/apps/sickbeard'
default[:sickbeard][:config_dir] = '/etc/sickbeard'
default[:sickbeard][:data_dir] = '/media/sickbeard'
default[:sickbeard][:install_style] = 'git'
default[:sickbeard][:git_url] = 'https://github.com/echel0n/SickRage.git'
default[:sickbeard][:git_ref] = 'f65262e0e9e3207ad90886c95f487273068748d3'
default[:sickbeard][:webui][:login] = "#{node[:depot][:user]}"
default[:sickbeard][:webui][:password] = "#{node[:depot][:password]}"


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


