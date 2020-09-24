#!/bin/ruby
require 'sinatra'
require 'json'

set :bind, '0.0.0.0'

post '/github/push-event' do
  request.body.rewind
  payload_body = request.body.read
  verify_signature(payload_body)
  push = JSON.parse(params[:payload])
  puts "I got some JSON: #{push.inspect}"
end

def verify_signature(payload_body)
  signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), 
						ENV['SECRET_TOKEN'], 
						payload_body)

  return halt 500, "Signatures didn't match!" unless 
	Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
end