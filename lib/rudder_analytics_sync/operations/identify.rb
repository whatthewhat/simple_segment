# frozen_string_literal: true

module RudderAnalyticsSync
  module Operations
    class Identify < Operation
      def call
        request.post('/v1/identify', build_payload)
      end

      def build_payload
        merged_payload = base_payload.merge(
          traits: options[:traits] && isoify_dates!(options[:traits])
        )
        merged_payload[:context][:traits] = merged_payload[:context][:traits].merge(options[:traits])
        merged_payload
      end
    end
  end
end
