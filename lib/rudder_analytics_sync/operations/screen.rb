# frozen_string_literal: true

module RudderAnalyticsSync
  module Operations
    class Screen < Operation
      def call
        request.post('/v1/screen', build_payload)
      end

      def build_payload
        properties = (options[:properties] && isoify_dates!(options[:properties])) || {}

        base_payload.merge(
          name: options[:name],
          event: options[:name],
          properties: properties.merge({name: options[:name]})
        )
      end
    end
  end
end
