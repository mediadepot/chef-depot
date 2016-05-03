# Temp Directory

- **Who**: The `temp` directory is created and  managed by MediaDepot.
- **What**: It stores the following types of data: 
	- files that are currently being downloaded via a torrent client (`deluge`, `hadouken`, `rutorrent`, etc) which are stored in the `processing` folder
	- torrent files (stored in the `blackhole` folder) which will be automatically added to your torrent client.
- **When**: 
	- Files in the `blackhole` sub-directories are created by third party applications like Couchpotato, Sickrage, etc. 
	- Files in the `processing` directory are created directly by a torrent client
- **Where**: The `temp` directory is physically located on your OS Drive.
- **Why**: Partially downloaded files are constantly being written to by the torrent clients. 
- **How**: 
