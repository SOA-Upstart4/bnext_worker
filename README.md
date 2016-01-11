# BNextWorker

## Overview

To build the instruction of workers for the service [git://bnext_service](https://github.com/SOA-Upstart4/bnext_service).

## Installation

- Download the project

	`git clone https://github.com/SOA-Upstart4/bnext_worker.git`
	
- Setup all packages needed in this repo (to check it works without bundler runtime)

	`bundle install --standalone`
	
- Create an account at [iron.io](https://hud.iron.io/) and download `iron.json` under the root directory (Note that the code cannot work without `iron.json`)

- Install command line tools

	`curl -sSL https://cli.iron.io/install | sh`
	
- Zip up all files

	`zip -r xxx.zip .`
	
- Upload the package which will be runned at IronWorker

	`iron worker upload --zip xxx.zip --name xxx iron/images:ruby-2.1 ruby xxx.rb`
	
- Check if it works well

	`iron worker queue --wait xxx`
	
