RSpec.describe Pinner::Authorize do
  describe '#call' do
    context 'without a pin' do
      let(:env) { Rack::MockRequest.env_for('/authorize', method: 'POST') }
      
      it 'responds with 400 Bad Request' do
        response = subject.call(env)
        expect(response.first).to eq(400)
      end
    end
    
    context 'with an unknown pin' do
      let(:env) do
        Rack::MockRequest.env_for(
          '/authorize',
          method: 'POST',
          params: { pin: '123123' }
        )
      end
      
      it 'responds with 401 Unauthorized' do
        response = subject.call(env)
        expect(response.first).to eq(401)
      end
    end
    
    context 'with a known pin' do
      before(:each) do
        sender = Pinner::SendPin.new
        @pin = sender.generate_pin
        sender.dump_to_redis(@pin)
      end
      
      let(:env) do
        Rack::MockRequest.env_for(
          '/authorize',
          method: 'POST',
          params: { pin: @pin }
        )
      end
      
      let(:token) { '1234567890abcdef' }
      
      before(:each) do
        allow(described_class).to receive(:generate_token).and_return(token)
      end
      
      it 'responds with 200 OK and an access token' do
        response = subject.call(env)
        
        expect(response.first).to eq(200)
        expect(response[1]['X-Access-Token']).to eq(token)
      end
      
      it 'deletes the pin from redis' do
        subject.call(env)
        
        expect(Pinner.redis.exists(Pinner.encode_pin(@pin))).to eq(false)
      end
    end
  end
  
  describe '.generate_token' do
    it 'generates a unique access token' do
      tokens = 1000.times.map { described_class.generate_token }
      expect(tokens.count).to eq(tokens.uniq.count)
    end
  end
end
