require 'redis'

module Pinner
  class SendPin
    attr_reader :redis
    private :redis
    
    def initialize
      @redis = Redis.new
    end
    
    def call(env)
      [200, {}, [generate_pin]]
    end
    
    def generate_pin
      '%06d' % rand(1000000)
    end
  end
end
