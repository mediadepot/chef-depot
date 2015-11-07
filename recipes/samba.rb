#sourced from https://github.com/jtimberman/samba-cookbook

node[:samba][:shares].each do |k,v|
  if v.has_key?('path')
    #this must be owned by the user who mounts the drive?
    directory v['path'] do
      recursive true
      owner node[:depot][:user]
      group node[:depot][:group]
    end
  end
end

#add special folders to downloads and blackhole. Torrents added to the blackhole folder will be saved to the
#associated downloads folder after completed.
node[:depot][:mapped_folders].each_pair do |key,value|

  directory "#{node[:samba][:shares]['downloads']['path']}/#{value[:folder_name]}" do
    recursive true
    owner node[:depot][:user]
    group node[:depot][:group]
  end
  directory "#{node[:samba][:shares]['blackhole']['path']}/#{value[:folder_name]}" do
    recursive true
    owner node[:depot][:user]
    group node[:depot][:group]
  end
end

package node['samba']['server_package']
package 'cifs-utils'
svcs = node['samba']['services']

template node['samba']['config'] do
  source 'etc_samba_smb.conf.erb'
  owner 'root'
  group 'root'
  mode 00644
  variables :shares => node[:samba][:shares]
  svcs.each do |s|
    notifies :restart, "service[#{s}]", :immediately
  end
end

# if users
#   users.each do |u|
#     next unless u["smbpasswd"]
#     samba_user u["id"] do
#       password u["smbpasswd"]
#       action [:create, :enable]
#     end
#   end
# end

samba_user node[:depot][:user] do
  password node[:depot][:password]
  action [:create, :enable]
end


svcs.each do |s|
  service s do
    restart_command "service #{s} restart || true"
    action [:enable, :start]
  end
end
