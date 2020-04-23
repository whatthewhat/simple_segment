# frozen_string_literal: true

module RudderAnalyticsSync
  module Operations
    class Page < Operation
      def call
        request.post('/v1/page', build_payload)
      end

      def build_payload
        properties = options[:properties] && isoify_dates!(options[:properties])

        base_payload.merge(
          name: options[:name],
          properties: properties
        )
      end
    end
  end
end
