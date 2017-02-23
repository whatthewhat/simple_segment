require 'spec_helper'

describe SimpleSegment::Client do
  subject(:client) { described_class.new(write_key: 'WRITE_KEY') }
  let(:now) { Time.new(2999,12,29) }

  describe '#identify' do
    it 'sends identity and properties to segment' do
      options = {
        user_id: 'id',
        traits: {
          name: 'Philip J. Fry',
          occupation: 'Delivery Boy'
        },
        context: {
          employer: 'Planet Express'
        },
        integrations: {
          all: true
        },
        timestamp: Time.new(2016,3,23)
      }
      expected_request_body = {
        'userId' => 'id',
        'anonymousId' => nil,
        'traits' => {
          'name' => 'Philip J. Fry',
          'occupation' => 'Delivery Boy'
        },
        'context' => {
          'employer' => 'Planet Express',
          'library' => {
            'name' => 'simple_segment',
            'version' => SimpleSegment::VERSION
          }
        },
        'integrations' => {
          'all' => true
        },
        'timestamp' => Time.new(2016,3,23).iso8601,
        'sentAt' => now.iso8601
      }
      request_stub = stub_request(:post, 'https://WRITE_KEY:@api.segment.io/v1/identify').with(
        body: expected_request_body
      )

      Timecop.freeze(now) do
        client.identify(options)
        expect(request_stub).to have_been_requested.once
      end
    end

    context 'input checks' do
      before(:example) { stub_request(:post, 'https://WRITE_KEY:@api.segment.io/v1/identify') }

      it 'errors with user_id and anonymous_id blank' do
        expect { client.identify }.to raise_error(ArgumentError)
      end

      it 'allows blank user_id if anonymous_id is present' do
        expect { client.identify(anonymous_id: 'id') }.not_to raise_error
      end

      it 'allows timestamp to be a string' do
        expect { client.identify(anonymous_id: 'id', timestamp: Time.new(2016,3,23).iso8601.to_s) }.not_to raise_error
      end
    end
  end

  describe '#track' do
    it 'sends event and properties to segment' do
      options = {
        event: 'Delivered Package',
        user_id: 'id',
        properties: {
          contents: 'Lug nuts',
          delivery_to: 'Robots of Chapek 9'
        },
        context: {
          crew: %w(Bender Fry Leela)
        },
        integrations: {
          all: true
        },
        timestamp: Time.new(2016,3,23)
      }
      expected_request_body = {
        'event' => 'Delivered Package',
        'userId' => 'id',
        'anonymousId' => nil,
        'properties' => {
          'contents' => 'Lug nuts',
          'delivery_to' => 'Robots of Chapek 9'
        },
        'context' => {
          'crew' => %w(Bender Fry Leela),
          'library' => {
            'name' => 'simple_segment',
            'version' => SimpleSegment::VERSION
          }
        },
        'integrations' => {
          'all' => true
        },
        'timestamp' => Time.new(2016,3,23).iso8601,
        'sentAt' => now.iso8601
      }
      request_stub = stub_request(:post, 'https://WRITE_KEY:@api.segment.io/v1/track').with(body: expected_request_body)

      Timecop.freeze(now) do
        client.track(options)
        expect(request_stub).to have_been_requested.once
      end
    end

    context 'input checks' do
      before(:example) { stub_request(:post, 'https://WRITE_KEY:@api.segment.io/v1/track') }

      it 'errors without an event name' do
        expect { client.track(user_id: 'id') }.to raise_error(ArgumentError)
      end

      it 'errors with user_id and anonymous_id blank' do
        expect { client.track(event: 'test') }.to raise_error(ArgumentError)
      end

      it 'allows blank user_id if anonymous_id is present' do
        expect { client.track(event: 'test', anonymous_id: 'id') }.not_to raise_error
      end
    end
  end

  describe '#page' do
    it 'sends page info to segment' do
      options = {
        user_id: 'id',
        name: 'Zoidberg',
        properties: {
          url: 'https://en.wikipedia.org/wiki/Zoidberg'
        },
        context: {
          company: 'Planet Express'
        },
        integrations: {
          all: true
        },
        timestamp: Time.new(2016,3,23)
      }
      expected_request_body = {
        'userId' => 'id',
        'anonymousId' => nil,
        'name' => 'Zoidberg',
        'properties' => {
          'url' => 'https://en.wikipedia.org/wiki/Zoidberg'
        },
        'context' => {
          'company' => 'Planet Express',
          'library' => {
            'name' => 'simple_segment',
            'version' => SimpleSegment::VERSION
          }
        },
        'integrations' => {
          'all' => true
        },
        'timestamp' => Time.new(2016,3,23).iso8601,
        'sentAt' => now.iso8601
      }
      request_stub = stub_request(:post, 'https://WRITE_KEY:@api.segment.io/v1/page').with(body: expected_request_body)

      Timecop.freeze(now) do
        client.page(options)
        expect(request_stub).to have_been_requested.once
      end
    end

    context 'input checks' do
      before(:example) { stub_request(:post, 'https://WRITE_KEY:@api.segment.io/v1/page') }

      it 'errors with user_id and anonymous_id blank' do
        expect { client.page }.to raise_error(ArgumentError)
      end

      it 'allows blank user_id if anonymous_id is present' do
        expect { client.page(anonymous_id: 'id') }.not_to raise_error
      end
    end
  end

  describe '#group' do
    it 'sends group info to segment' do
      options = {
        user_id: 'id',
        group_id: 'group_id',
        traits: {
          name: 'Planet Express'
        },
        context: {
          locale: 'AL1'
        },
        integrations: {
          all: true
        },
        timestamp: Time.new(2016,3,23)
      }
      expected_request_body = {
        'userId' => 'id',
        'anonymousId' => nil,
        'groupId' => 'group_id',
        'traits' => {
          'name' => 'Planet Express'
        },
        'context' => {
          'locale' => 'AL1',
          'library' => {
            'name' => 'simple_segment',
            'version' => SimpleSegment::VERSION
          }
        },
        'integrations' => {
          'all' => true
        },
        'timestamp' => Time.new(2016,3,23).iso8601,
        'sentAt' => now.iso8601
      }
      request_stub = stub_request(:post, 'https://WRITE_KEY:@api.segment.io/v1/group').with(body: expected_request_body)

      Timecop.freeze(now) do
        client.group(options)
        expect(request_stub).to have_been_requested.once
      end
    end

    context 'input checks' do
      before(:example) { stub_request(:post, 'https://WRITE_KEY:@api.segment.io/v1/group') }

      it 'errors without a group id' do
        expect { client.group(user_id: 'id') }.to raise_error(ArgumentError)
      end

      it 'errors with user_id and anonymous_id blank' do
        expect { client.group(group_id: 'id') }.to raise_error(ArgumentError)
      end

      it 'allows blank user_id if anonymous_id is present' do
        expect { client.group(group_id: 'id', anonymous_id: 'id') }.not_to raise_error
      end
    end
  end

  describe '#alias' do
    it 'sends alias info to segment' do
      options = {
        user_id: 'id',
        previous_id: 'previous_id',
        context: {
          locale: 'AL1'
        },
        integrations: {
          all: true
        },
        timestamp: Time.new(2016,3,23)
      }
      expected_request_body = {
        'userId' => 'id',
        'anonymousId' => nil,
        'previousId' => 'previous_id',
        'context' => {
          'locale' => 'AL1',
          'library' => {
            'name' => 'simple_segment',
            'version' => SimpleSegment::VERSION
          }
        },
        'integrations' => {
          'all' => true
        },
        'timestamp' => Time.new(2016,3,23).iso8601,
        'sentAt' => now.iso8601
      }
      request_stub = stub_request(:post, 'https://WRITE_KEY:@api.segment.io/v1/alias').with(body: expected_request_body)

      Timecop.freeze(now) do
        client.alias(options)
        expect(request_stub).to have_been_requested.once
      end
    end

    context 'input checks' do
      before(:example) { stub_request(:post, 'https://WRITE_KEY:@api.segment.io/v1/alias') }

      it 'errors without a previous id' do
        expect { client.alias(user_id: 'id') }.to raise_error(ArgumentError)
      end

      it 'errors with user_id and anonymous_id blank' do
        expect { client.alias(previous_id: 'id') }.to raise_error(ArgumentError)
      end

      it 'allows blank user_id if anonymous_id is present' do
        expect { client.alias(previous_id: 'id', anonymous_id: 'id') }.not_to raise_error
      end
    end
  end

  describe '#flush' do
    it 'does not blow up' do
      expect { client.flush }.not_to raise_error
    end
  end

  describe '#batch' do
    it 'batches events into a single request' do
      request_stub = stub_request(:post, 'https://WRITE_KEY:@api.segment.io/v1/import').with do |request|
        JSON.parse(request.body)['batch'].length == 2
      end
      client.batch do |analytics|
        analytics.identify(user_id: 'id')
        analytics.track(event: 'Delivered Package', user_id: 'id')
      end

      expect(request_stub).to have_been_requested.once
    end
  end
end
