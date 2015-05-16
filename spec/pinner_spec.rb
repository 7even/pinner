RSpec.describe Pinner do
  describe '#encode_pin' do
    let(:pin) { '123456' }
    
    it 'returns a SHA256 hexdigest of the given pin' do
      expect(subject.encode_pin(pin)).to eq(
        Digest::SHA256.hexdigest(pin + ENV['SALT'])
      )
    end
  end
end
