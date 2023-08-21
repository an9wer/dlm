DLM - a Download Manager
========================

dlm is a service for managing your download tasks.

Features
--------

- supporting Youtube and other video hosting websites (based on yt-dlp)
- (WIP) supporting HTTP/HTTPS, FTP, SFTP, BitTorrent, and Metalink (baesd on aria2c)
- a background service - dlm.sh, which is utilized for managing and performing download tasks
- a command-line tool - dlmc.sh, which is utilized for creating download tasks and interacting with the backgroud service

Requirements
------------

- inotify-tools
- sqlite3
- yt-dlp
- aria2c
