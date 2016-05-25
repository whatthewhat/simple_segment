module SimpleSegment
  module Operations
    class Operation
      DEFAULT_CONTEXT = {
        library: {
          name: 'simple_segment',
          version: SimpleSegment::VERSION
        }
      }.freeze

      attr_reader :options, :request

      def initialize(client, options = {})
        @options = options
        @request = Request.new(client)
      end

      def call
        raise 'Must be implemented in a subclass'
      end

      private

      def base_payload
        check_identity!
        current_time = Time.now

        {
          userId: options[:user_id],
          anonymousId: options[:anonymous_id],
          context: DEFAULT_CONTEXT.merge(options[:context].to_h),
          integrations: options[:integrations],
          timestamp: options.fetch(:timestamp, current_time).iso8601,
          sentAt: current_time.iso8601
        }
      end

      def check_identity!
        unless options[:user_id] || options[:anonymous_id]
          raise ArgumentError, 'user_id or anonymous_id must be present'
        end
      end
    end
  end
end
