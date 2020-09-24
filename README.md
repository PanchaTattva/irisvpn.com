# irisvpn.com 

<img src="./app/assets/images/garuda-header.png" width="280" >

----

Project is currently in early Alpha. https://irisvpn-alpha.tattva.network/

## directory overview

```
.
├── docker-compose.yml
├── Dockerfile
├── hooks #used by DockerHub for image builds.
├── infrastructure #devops tools and config files.
```


## development environment setup

Allow others to access your dev environment by connecting
to your VPN, and then bind your rails server to your asigned VPN IP.

`rails server -b 10.8.0.xx`

## deployments

Docker Hub will auto build new images for push to master.

## useful rails commands

`rails db:migrate`

`rails dbconsole`

`rails generate controller [name]`

`rails credentials:edit` (access in code with `Rails.application.credentials.secret_token`)

create database table:

`rails generate model payment currency:string wallet_priv:string wallet_pub:string wallet_addr:string`
