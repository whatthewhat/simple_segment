# frozen_string_literal: true

require 'spec_helper'

describe SimpleSegment::Operations::Track do
  describe '#build_payload' do
    let(:client) { SimpleSegment::Client.new(write_key: 'key') }

    it 'uses an empty hash if no properties were provided' do
      payload = described_class.new(
        client,
        event: 'event',
        user_id: 'id'
      ).build_payload

      expect(payload[:properties]).to eq({})
    end

    context 'timestamps' do
      it 'adds timestamp when it is not provided' do
        Timecop.freeze(Time.new(2025, 11, 26, 20, 5, 54.456, 'UTC')) do
          payload = described_class.new(
            client,
            event: 'event',
            user_id: 'id'
          ).build_payload

          expect(payload[:timestamp]).to eq('2025-11-26T20:05:54.456Z')
        end
      end

      it 'works with Time objects' do
        payload = described_class.new(
          client,
          event: 'event',
          user_id: 'id',
          timestamp: Time.new(2016, 6, 27, 23, 4, 20, '+03:00')
        ).build_payload

        expect(payload[:timestamp]).to eq('2016-06-27T23:04:20.000+03:00')
      end

      it 'works with millisecond-precision Time objects' do
        payload = described_class.new(
          client,
          event: 'event',
          user_id: 'id',
          timestamp: Time.new(2025, 11, 26, 20, 1, 10.567, 'UTC')
        ).build_payload

        expect(payload[:timestamp]).to eq('2025-11-26T20:01:10.567Z')
      end

      it 'works with iso8601 strings' do
        payload = described_class.new(
          client,
          event: 'event',
          user_id: 'id',
          timestamp: '2016-06-27T20:04:20Z'
        ).build_payload

        expect(payload[:timestamp]).to eq('2016-06-27T20:04:20.000Z')
      end

      it 'works with millisecond-precision iso8601 strings' do
        payload = described_class.new(
          client,
          event: 'event',
          user_id: 'id',
          timestamp: '2025-11-26T19:54:10.123Z'
        ).build_payload

        expect(payload[:timestamp]).to eq('2025-11-26T19:54:10.123Z')
      end

      it 'errors with invalid strings' do
        expect do
          described_class.new(
            client,
            event: 'event',
            user_id: 'id',
            timestamp: '2016 06 27T23:04:20'
          ).build_payload
        end.to raise_error(ArgumentError)
      end

      it 'works with stubed calls' do
        stubed_client = SimpleSegment::Client.new(write_key: 'key', stub: true)
        expect(stubed_client.track(
          event: 'event',
          user_id: 'id',
          timestamp: Time.new(2016, 6, 27, 23, 4, 20, '+03:00')
        )[:status]).to eq(200)
      end
    end
  end
end
