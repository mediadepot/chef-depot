# Storage Drive

- **Who**: The `storage` drive is created by MergerFS and managed by MediaDepot.
- **What**: It stores the following types of data: 
	- completed files downloaded via a torrent client (`deluge`, `hadouken`, `rutorrent`, etc) are automatically stored in their associated `downloads` subfolder
	- processed files (which have been moved and/or renamed by a third party application like Couchpotato, Sickbeard) are stored in their associated folder.
- **When**: 
 	- files in the `downloads` subdirectories are created by a torrent client. 
 	- files in the `tvshows`, `movies`, and other directories are files that have been movied by third party applications to thier associated folder.
- **Where**: The `storage` drive is actually made up of multiple harddrives all joined together.
- **Why**: By joining all the harddrives together using MergerFS, we are able to store an constantly expanding amount of data in a single folder-structure, without needing to worry about individual drive capacity
- **How**: The `storage` drive is created by MergerFS, you can read more on its github page. 
