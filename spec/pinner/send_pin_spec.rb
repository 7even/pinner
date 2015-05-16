require 'spec_helper'

RSpec.describe Pinner::SendPin do
  describe '#generate_pin' do
    it 'generates a unique pin code' do
      pins = 100.times.map { subject.generate_pin }
      expect(pins.count).to eq(pins.uniq.count)
    end
  end
end
