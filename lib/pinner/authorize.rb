module Pinner
  class Authorize
    def call(env)
      request = Rack::Request.new(env)
      pin = request.params['pin']
      return [400, {}, []] if pin.nil?
      
      pin_digest = Pinner.encode_pin(pin)
      
      if valid_pin?(pin_digest)
        delete_pin(pin_digest)
        [200, { 'X-Access-Token' => Authorize.generate_token }, []]
      else
        [401, {}, []]
      end
    end
    
  private
    def valid_pin?(pin_digest)
      Pinner.redis.exists(pin_digest)
    end
    
    def delete_pin(pin_digest)
      Pinner.redis.del(pin_digest)
    end
    
    class << self
      def generate_token
        Digest::SHA256.hexdigest(Time.now.to_f.to_s + Process.pid.to_s)
      end
    end
  end
end
