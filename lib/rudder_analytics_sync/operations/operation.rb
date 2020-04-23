# frozen_string_literal: true

module RudderAnalyticsSync
  module Operations
    class Operation
      include RudderAnalyticsSync::Utils

      DEFAULT_CONTEXT = {
        library: {
          name: 'rudder-sdk-ruby-sync',
          version: RudderAnalyticsSync::VERSION
        }
      }.freeze

      def initialize(client, options = {})
        @options = options
        @context = DEFAULT_CONTEXT.merge(options[:context].to_h)
        @request = Request.new(client)
      end

      def call
        raise 'Must be implemented in a subclass'
      end

      private

      attr_reader :options, :request, :context

      def base_payload
        check_identity!
        current_time = Time.now

        {
          userId: options[:user_id],
          anonymousId: options[:anonymous_id],
          context: context,
          integrations: options[:integrations],
          timestamp: timestamp(options.fetch(:timestamp, current_time)),
          sentAt: current_time.iso8601
        }
      end

      def check_identity!
        raise ArgumentError, 'user_id or anonymous_id must be present' \
          unless options[:user_id] || options[:anonymous_id]
      end

      def timestamp(timestamp)
        if timestamp.respond_to?(:iso8601)
          timestamp.iso8601
        else
          Time.iso8601(timestamp).iso8601
        end
      end
    end
  end
end
