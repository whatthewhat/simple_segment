# frozen_string_literal: true

require 'spec_helper'

describe SimpleSegment::Request do
  context 'API errors handling' do
    before(:example) do
      stub_request(:post, 'https://api.segment.io/v1/track')
        .with(basic_auth: ['key', ''])
        .to_return(status: 500, body: { error: 'Does not compute' }.to_json)
    end

    it 'does not raise an error with default client' do
      client = SimpleSegment::Client.new(write_key: 'key')
      expect do
        described_class.new(client).post('/v1/track', {})
      end.not_to raise_error
    end

    it 'passes http errors to the on_error hook' do
      error_code = nil
      error_body = nil
      response = nil
      exception = nil
      error_handler = proc do |code, body, res, e|
        error_code = code
        error_body = body
        response = res
        exception = e
      end
      client = SimpleSegment::Client.new(
        write_key: 'key',
        on_error: error_handler
      )
      described_class.new(client).post('/v1/track', {})

      expect(error_code).to eq('500')
      expect(error_body).to eq({ error: 'Does not compute' }.to_json)
      expect(response).to be_a(Net::HTTPFatalError)
      expect(exception).to be_a(Net::HTTPInternalServerError)
    end
  end

  context 'with custom host' do
    it 'uses configured host' do
      request_stub = stub_request(:post, 'https://events.eu1.segmentapis.com/v1/track')
                     .with(basic_auth: ['key', ''])
                     .to_return(status: 200)

      client = SimpleSegment::Client.new(
        write_key: 'key',
        host: 'events.eu1.segmentapis.com'
      )
      described_class.new(client).post('/v1/track', {})

      expect(request_stub).to have_been_requested.once
    end
  end
end
