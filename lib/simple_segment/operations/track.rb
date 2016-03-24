module SimpleSegment
  module Operations
    class Track < Operation
      def call
        Request.new('/v1/track', config).post(build_payload)
      end

      private

      def build_payload(current_time = Time.now)
        check_identity!
        raise ArgumentError, 'event name must be present' unless options[:event]

        {
          event: options[:event],
          userId: options[:user_id],
          anonymousId: options[:anonymous_id],
          properties: options[:properties],
          context: options[:context],
          integrations: options[:integrations],
          timestamp: options.fetch(:timestamp, current_time).iso8601,
          sentAt: current_time.iso8601
        }
      end
    end
  end
end
