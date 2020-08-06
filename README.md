# Cloud provisioner

This is a simple Docker container that I use for interacting with Cloud providers in my personal projects.

##### Features
- CentOS8 with zsh terminal
- Shell CLI for supported Cloud providers
- Terraform with Terragrunt
- Useful tools, eg. neovim, git, jq

##### Supported Cloud providers
- Google Cloud Platform

##### Requirements
- docker
- docker-compose

##### Usage
Clone the repository and run the following shell commands:
```
# Google Cloud Platform
docker-compose build gcp-proisioner
docker-compose run gcp-provisioner
```
