# chef-depot-cookbook

## Setup:
This assumes you're using a chef server to manage your environment configuration.

	# Install ChefDK on the vanilla Ubuntu installation
	cd /tmp && curl -LO https://packages.chef.io/stable/ubuntu/12.04/chefdk_0.13.21-1_amd64.deb
	rpm -i /tmp/chefdk_0.13.21-1_amd64.deb
	
	# Create configuration folders
	mkdir -p /etc/chef /var/chef
	
	# Download the knife.rb file from Hosted Chef (or recreate it)
	# NOTE: make sure to specify the environment 
	nano /etc/chef/config.rb
	
	current_dir = File.dirname(__FILE__)
    log_level                :info
    log_location             STDOUT
    node_name                "analogj"
    client_key               "#{current_dir}/analogj.pem"
    validation_client_name   "mediadepot-validator"
    validation_key           "#{current_dir}/mediadepot-validator.pem"
    chef_server_url          "https://api.chef.io/organizations/mediadepot"
    cookbook_path            ["#{current_dir}/../cookbooks"]
	environment				 "example"
	
	# Download the mediadepot-validator.pem from the Hosted Chef
	chef-client --override-runlist "chef-depot::default" --config "/etc/chef/config.rb"


## Testing/Development
  - https://github.com/rancher/rancher/issues/1920 Hairpin nat fails 
  
  - `curl --header 'Host: couchpotato.depot.local' 'http://10.0.2.15:8080'`
  
  - `dig 127.0.0.1 mystack.depot.lan` 
  - `dig 10.0.2.15 mystack.depot` 