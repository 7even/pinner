require 'bundler/setup'
require 'lotus/router'
require 'pry'

require 'dotenv'
Dotenv.load

$LOAD_PATH << File.expand_path('..', __FILE__)
require 'pinner/send_pin'

module Pinner
  class << self
    def application
      @application ||= Lotus::Router.new do
        get '/', to: -> (env) { [200, {}, ['Hello from pinner!']] }
        get '/send_pin', to: Pinner::SendPin
      end
    end
  end
end
