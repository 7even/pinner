require 'spec_helper'

RSpec.describe Pinner::SendPin do
  describe '#call' do
    before(:each) do
      allow(subject).to receive(:generate_pin).and_return('123456')
    end
    
    it 'generates the pin' do
      expect(subject).to receive(:generate_pin)
      subject.call({})
    end
    
    it 'sends the pin' do
      expect(subject).to receive(:send_pin).with('123456')
      subject.call({})
    end
    
    it 'dumps the pin to redis' do
      expect(subject).to receive(:dump_to_redis).with('123456')
      subject.call({})
    end
    
    it 'includes the pin in the response body' do
      status, headers, body = subject.call({})
      expect(body).to eq(['123456'])
    end
  end
  
  describe '#generate_pin' do
    it 'generates a unique pin code' do
      pins = 100.times.map { subject.generate_pin }
      expect(pins.count).to eq(pins.uniq.count)
    end
  end
  
  describe '#encode_pin' do
    let(:pin) { subject.generate_pin }
    
    it 'returns a SHA256 hexdigest of the given pin' do
      expect(subject.encode_pin(pin)).to eq(
        Digest::SHA256.hexdigest(pin + ENV['SALT'])
      )
    end
  end
  
  describe '#dump_to_redis' do
    let(:pin_digest) { 'pin:digest' }
    
    before(:each) do
      allow(subject).to receive(:encode_pin).and_return(pin_digest)
    end
    
    it 'puts the pin digest to redis' do
      subject.dump_to_redis('123456')
      expect(Pinner.redis.get(pin_digest)).to eq('true')
    end
    
    it 'sets the TTL to 10 minutes' do
      subject.dump_to_redis('123456')
      expect(Pinner.redis.ttl(pin_digest)).to eq(Pinner::SendPin::PIN_TTL)
    end
    
    after(:each) do
      Pinner.redis.del(pin_digest)
    end
  end
end
