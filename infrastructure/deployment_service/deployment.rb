require './haproxy_controller'

haproxy = HAProxyManager::Instance.new ("/root/socket/admin.sock")

`docker-compose up -d --scale deploy=1`
sleep(10)
haproxy.weights("nginx_1", "app", 0)
haproxy.weights("nginx_2", "app", 1)
sleep(10)
`docker-compose up -d --scale irisvpn=0`
sleep(10)
`docker-compose up -d --scale irisvpn=1`

