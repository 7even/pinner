require 'bundler/setup'
require 'lotus/router'
require 'pry'

require 'dotenv'
Dotenv.load

$LOAD_PATH << File.expand_path('..', __FILE__)
require 'pinner/send_pin'
require 'pinner/authorize'

module Pinner
  class << self
    def application
      @application ||= Lotus::Router.new do
        get '/', to: -> (env) { [200, {}, ['Hello from pinner!']] }
        get '/send_pin', to: Pinner::SendPin
      end
    end
    
    def redis
      @redis ||= Redis.new
    end
    
    def encode_pin(pin)
      Digest::SHA256.hexdigest(pin + ENV['SALT'])
    end
  end
end
