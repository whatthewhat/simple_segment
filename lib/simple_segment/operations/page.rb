module SimpleSegment
  module Operations
    class Page < Operation
      def call
        Request.new('/v1/page', config).post(build_payload)
      end

      private

      def build_payload(current_time = Time.now)
        check_identity!

        {
          userId: options[:user_id],
          anonymousId: options[:anonymous_id],
          name: options[:name],
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
