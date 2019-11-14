require 'spec_helper'

describe SimpleSegment::Configuration do
  it 'requires a write_key' do
    expect do
      described_class.new(write_key: nil)
    end.to raise_error(ArgumentError)
  end

  it 'works with symbol keys' do
    config = described_class.new(write_key: 'test')
    expect(config.write_key).to eq 'test'
  end

  it 'works with string keys' do
    config = described_class.new('write_key' => 'key')
    expect(config.write_key).to eq 'key'
  end

  context 'defaults' do
    it 'has a default error handler' do
      config = described_class.new(write_key: 'test')
      expect(config.on_error).to be_a(Proc)
    end

    it 'has a default http_options' do
      config = described_class.new(write_key: 'test')
      expect(config.http_options).to eq({ use_ssl: true })
    end
  end

  it 'works with stub' do
    config = described_class.new(write_key: 'test', stub: true)
    expect(config.stub).to eq true
  end

  it 'works with user prefered logging' do
    my_logger = object_double('Logger')
    config = described_class.new(
      write_key: 'test',
      logger: my_logger
    )
    expect(config.logger).to eq(my_logger)
  end

  it 'accepts an http_options' do
    config = described_class.new(write_key: 'test', http_options: { read_timeout: 42 })
    expect(config.http_options).to eq(use_ssl: true, read_timeout: 42)
  end
end
