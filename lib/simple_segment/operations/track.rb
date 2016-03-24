module SimpleSegment
  module Operations
    class Track < Operation
      def call
        Request.new('/v1/track', config).post(build_payload)
      end

      private

      def build_payload(current_time = Time.now)
        raise ArgumentError, 'event name must be present' unless options[:event]

        base_payload.merge({
          event: options[:event],
          properties: options[:properties]
        })
      end
    end
  end
end
