require 'spec_helper'

describe SimpleSegment::Configuration do
  it 'requires a write_key' do
    expect {
      described_class.new(write_key: nil)
    }.to raise_error(ArgumentError)
  end

  it 'works with symbol keys' do
    config = described_class.new(write_key: 'test')
    expect(config.write_key).to eq ('test')
  end

  it 'works with string keys' do
    config = described_class.new('write_key' => 'key')
    expect(config.write_key).to eq ('key')
  end
end
