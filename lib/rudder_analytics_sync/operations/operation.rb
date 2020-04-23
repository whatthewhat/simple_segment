# frozen_string_literal: true

require 'rudder_analytics_sync/utils'

module RudderAnalyticsSync
  module Operations
    class Operation
      include RudderAnalyticsSync::Utils

      DEFAULT_CONTEXT = {
        library: {
          name: 'rudder-sdk-ruby-sync',
          version: RudderAnalyticsSync::VERSION
        },
        traits: {

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
        current_time = Time.now.utc

        anonymous_id = options[:anonymous_id] || uid()
        context[:traits] = (context[:traits] || {}) && {
          anonymousId: anonymous_id,
          userId: options[:user_id] 
        }

        {
          userId: options[:user_id],
          anonymousId: anonymous_id,
          context: context,
          integrations: options[:integrations] || {All: true},
          timestamp: maybe_datetime_in_iso8601(options[:timestamp] || Time.now.utc),
          sentAt: maybe_datetime_in_iso8601(current_time),
          messageId: uid(),
          properties: options[:properties] || {}
        }
      end

      def check_identity!
        raise ArgumentError, 'user_id or anonymous_id must be present' \
          unless options[:user_id] || options[:anonymous_id]
      end
    end
  end
end
