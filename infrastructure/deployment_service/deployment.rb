require './haproxy_controller'
require 'net/http'
require 'json'

ha_backend = ARGV[0]
image = ARGV[1]
container = ARGV[2]

haproxy = HAProxyManager::Instance.new("./infrastructure/volume/admin.sock")

def pull_image(image)
  docker_pull = `docker pull #{image}`

  if pull_log.include? "Status: Image is up"
    exit
  elsif pull_log.include? "Status: Downloaded newer image"
    connection_drain(container, ha_backend)
  end
end

def enable_traffic(container, ha_backend)
  http = Net::HTTP.start('localhost', container_port)
  status_code = nil

  for i in 1..10
    status_code = http.head('/').code
    sleep(10)

    if status_code == "200"
      haproxy.enable(container, ha_backend)
      haproxy.weights(container, ha_backend, 1)
      break
    end
    
    if i == 10
      puts "web service not available. container status: #{status_code}"
      exit
    end
  end
end

def upgrade_image(container, ha_backend)
  `docker-compose pull #{container}`
  `docker-compose up -d #{container}`
end

def connection_drain(container, ha_backend)
  haproxy.weights(container, ha_backend, 0)
  for i in 1..10
    session_info = haproxy.sess
    active_session_count = session_info["#{ha_backend}/#{container}"]
                                       ["#{ha_backend}/#{container}"]
                                       ['used_cur']

    if active_session_count == 0
      upgrade_image(container, ha_backend)
      enable_traffic(container, ha_backend)
    end
    
    if i == 10
      puts "still active connections to the web service. drain failed."
      exit
    end
  end
end
