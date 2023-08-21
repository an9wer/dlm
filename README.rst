DLM - a Download Manager
========================

dlm is a service for managing your download tasks.


Features
--------

- supporting Youtube and other video hosting websites (based on yt-dlp)
- (WIP) supporting HTTP/HTTPS, FTP, SFTP, BitTorrent, and Metalink (baesd on aria2c)


Usage
-----

- dlm.sh - a background service, used for performing download tasks
- dlmc.sh - a command-line tool, used for creating and managing download tasks


Requirements
------------

- inotify-tools
- sqlite3
- yt-dlp
- aria2c
