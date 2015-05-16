require 'redis'

module Pinner
  class SendPin
    PIN_TTL = (60 * 60 * 10).freeze
    
    def call(env)
      pin = generate_pin
      send_pin(pin)
      dump_to_redis(pin)
      
      [200, {}, [pin]]
    end
    
    def generate_pin
      '%06d' % rand(1000000)
    end
    
    def encode_pin(pin)
      Digest::SHA256.hexdigest(pin + ENV['SALT'])
    end
    
    def send_pin(pin)
      # send SMS
    end
    
    def dump_to_redis(pin)
      pin_digest = encode_pin(pin)
      Pinner.redis.set(pin_digest, true)
      Pinner.redis.expire(pin_digest, PIN_TTL)
    end
  end
end
