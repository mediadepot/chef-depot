{
	############################
    # Display Wizard
    ############################

	############################
    # Prepare for Chef Run
    ############################
    cd /tmp

	# Install Chef Client & Berkshelf
    wget https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chefdk_0.9.0-1_amd64.deb
    sudo dpkg -i chefdk_0.9.0-1_amd64.deb


	# Install git
	sudo apt-get install git -y

	# Clone this repository
	git clone https://github.com/mediadepot/chef-depot.git chef-depot


	cd chef-depot
	# Download Dependencies via Berkshelf
	berks install

	# Create Berkshelf package
	sudo mkdir -p /var/chef
	#sudo chown user /var/chef
	berks package /var/chef/package.tar.gz

	# Extract the Berkshelf package
	cd /var/chef
	tar -xf package.tar.gz -C .

	#copy the data_bags folder from the chef-depot cookbook
	mkdir data_bags
	cp -a cookbooks/chef-depot/data_bags/. data_bags/


	############################
	# Run Chef Converge
	############################

	# Run Chef Zero Client
	sudo chef-client -z -o depot::default
}