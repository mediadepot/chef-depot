default['build-essential']['compile_time'] = true

#default configuration
default[:depot][:salt] = 'rounds=500000$cEc2u3rRmSc0rvR1'
default[:depot][:home_dir] = "/home/#{node[:depot][:user]}"
default[:depot][:apps_dir] = '/srv/apps'
default[:depot][:log_dir] = '/var/log/depot'

default[:depot][:storage_mount_root] = '/media/storage' # persistent storage on JBOD disk
default[:depot][:tmp_mount_root] = '/media/temp' # temp storage for downloading

#the following paths are for tmp storage of files that are being downloaded (processing) and torrent files (blackhole).
default[:depot][:processing_path] = "#{node[:depot][:tmp_mount_root]}/processing"
default[:depot][:blackhole_path] = "#{node[:depot][:tmp_mount_root]}/blackhole"

#The seed root, where completed files are copied to, and can be deleted from after seeding is compeleted. (files are copied to the other shares by apps.)
default[:depot][:downloads_path] = "#{node[:depot][:storage_mount_root]}/downloads"

#special folders that are created in the blackhole directory and the downloads folder, and also used as the share name for Samba
default[:depot][:mapped_folders] = [
    'tvshows',
    'movies',
    'music',
    'ebooks',
    'photos',
    'software'
]

default[:pushover]= {
    :appid => 'aNiH7or6Q5F1ennDtQpSvhbtY4ot6C', #Depot appID, sends notifications about status of server.
}

##conky configuration

##duckdns configuration
default[:duckdns][:install_dir] = '/srv/apps/duckdns'

##loadbalancer configuration
default[:load_balancer][:http_listen_port] = '80'
default[:load_balancer][:https_listen_port] = '443'

##manager configuration
default[:manager][:listen_port] = '50000'

##sshd configuration
default[:openssh][:server][:password_authentication] = 'no'
default[:openssh][:authorized_keys] = []

##OpenVPN Access Server configuration
default[:openvpn][:webui][:login] = "#{node[:depot][:user]}"
default[:openvpn][:webui][:listen_port] = '943'
default[:openvpn][:server][:tcp_listen_port] = '60002'
default[:openvpn][:server][:udp_listen_port] = '60001'


##samba configuraion
default[:samba][:workgroup] = 'WORKGROUP'
default[:samba][:interfaces] = '127.0.0.0/8 eth0'
default[:samba][:shares] = {
    'blackhole' => {
        'path' => "#{node[:depot][:blackhole_path]}",
        'create mask' => '0770',
        'directory mask' => '0770',
        'read only' => 'no',
        'available' => 'yes',
        'browseable' => 'yes',
        'writable' => 'yes',
        'guest ok' => 'no',
        'printable' => 'no',
        'force user' => "#{node[:depot][:user]}",
        'force create mode' => '0770',
        'force directory mode' => '0770'
    },
    'processing' => {
        'path' => "#{node[:depot][:processing_path]}",
        'create mask' => '0770',
        'directory mask' => '0770',
        'read only' => 'no',
        'available' => 'yes',
        'browseable' => 'yes',
        'writable' => 'yes',
        'guest ok' => 'no',
        'printable' => 'no',
        'force user' => "#{node[:depot][:user]}",
        'force create mode' => '0770',
        'force directory mode' => '0770'
    },
    'downloads' => {
        'path' => "#{node[:depot][:downloads_path]}",
        'create mask' => '0770',
        'directory mask' => '0770',
        'read only' => 'no',
        'available' => 'yes',
        'browseable' => 'yes',
        'writable' => 'yes',
        'guest ok' => 'no',
        'printable' => 'no',
        'force user' => "#{node[:depot][:user]}",
        'force create mode' => '0770',
        'force directory mode' => '0770'
    }
}

node[:depot][:mapped_folders].each { |share_name|

    default['samba']['shares'][share_name] = {
        'path' => "#{node[:depot][:storage_mount_root]}/#{share_name}",
        'create mask' => '0770',
        'directory mask' => '0770',
        'read only' => 'no',
        'available' => 'yes',
        'browseable' => 'yes',
        'writable' => 'yes',
        'guest ok' => 'no',
        'printable' => 'no',
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

# Smartmontools, S.M.A.R.T disk monitoring
default['smartmontools']['start_smartd'] = 'yes'
default['smartmontools']['smartd_opts']  = ''
default['smartmontools']['devices']      = []
default['smartmontools']['device_opts']  = '-a -o on -S on -s (S/../.././02|L/../../6/03) -m root -M exec /usr/share/smartmontools/smartd-runner'
default['smartmontools']['run_d']        = ['pushover']


## Media Library Updater (Push media to gist.)
default['x11vnc']['password'] = "#{node['depot']['password']}"


