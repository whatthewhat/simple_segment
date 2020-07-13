# frozen_string_literal: true

module SimpleSegment
  module Operations
    class Track < Operation
      def call
        request.post('/v1/track', build_payload)
      end

      def build_payload
        raise ArgumentError, 'event name must be present' unless options[:event]

        properties = options[:properties] || {}

        base_payload.merge(
          event: options[:event],
          properties: isoify_dates!(properties)
        )
      end
    end
  end
end
