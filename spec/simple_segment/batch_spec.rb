require 'spec_helper'

describe SimpleSegment::Batch do
  let(:client) { SimpleSegment::Client.new(write_key: 'key') }

  it 'supports identify, group, track and page' do
    request_stub = stub_request(:post, 'https://api.segment.io/v1/import')
                   .with do |request|
                     batch = JSON.parse(request.body)['batch']
                     batch.map do |operation|
                       operation['action']
                     end == %w(identify group track page)
                   end

    batch = described_class.new(client)
    batch.identify(user_id: 'id')
    batch.group(user_id: 'id', group_id: 'group_id')
    batch.track(event: 'Delivered Package', user_id: 'id')
    batch.page(
      user_id: 'id',
      properties: { url: 'https://en.wikipedia.org/wiki/Zoidberg' }
    )
    batch.commit

    expect(request_stub).to have_been_requested.once
  end

  it 'allows to set common context' do
    expected_context = { 'foo' => 'bar' }
    request_stub = stub_request(:post, 'https://api.segment.io/v1/import')
                   .with do |request|
                     context = JSON.parse(request.body)['context']
                     context == expected_context
                   end

    batch = described_class.new(client)
    batch.context = expected_context
    batch.track(event: 'Delivered Package', user_id: 'id')
    batch.commit

    expect(request_stub).to have_been_requested.once
  end

  it 'allows to set common integrations' do
    expected_integrations = { 'foo' => 'bar' }
    request_stub = stub_request(:post, 'https://api.segment.io/v1/import')
                   .with do |request|
                     integrations = JSON.parse(request.body)['integrations']
                     integrations == expected_integrations
                   end

    batch = described_class.new(client)
    batch.integrations = expected_integrations
    batch.track(event: 'Delivered Package', user_id: 'id')
    batch.commit

    expect(request_stub).to have_been_requested.once
  end

  it 'validates event payload' do
    batch = described_class.new(client)

    expect { batch.track(event: nil) }.to raise_error(ArgumentError)
  end

  it 'errors when trying to commit an empty batch' do
    batch = described_class.new(client)

    expect { batch.commit }.to raise_error(ArgumentError)
  end

  it 'can be serialized and deserialized' do
    request_stub = stub_request(:post, 'https://api.segment.io/v1/import')
                   .with do |request|
                     batch = JSON.parse(request.body)['batch']
                     batch.map do |operation|
                       operation['action']
                     end == %w(identify track)
                   end

    batch = described_class.new(client)
    batch.identify(user_id: 'id')
    batch.track(event: 'Delivered Package', user_id: 'id')
    serialized_batch = batch.serialize
    described_class.deserialize(client, serialized_batch).commit

    expect(request_stub).to have_been_requested.once
  end
end
