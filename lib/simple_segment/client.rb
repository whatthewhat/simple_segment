# frozen_string_literal: true

require 'simple_segment/utils'
require 'simple_segment/configuration'
require 'simple_segment/operations'
require 'simple_segment/batch'

module SimpleSegment
  class Client
    include SimpleSegment::Utils

    attr_reader :config

    def initialize(options = {})
      @config = Configuration.new(options)
    end

    # @param [Hash] options
    # @option :user_id
    # @option :anonymous_id
    # @option :traits [Hash]
    # @option :context [Hash]
    # @option :integrations [Hash]
    # @option :timestamp [#iso8601] (Time.now)
    def identify(options)
      Operations::Identify.new(self, symbolize_keys(options)).call
    end

    # @param [Hash] options
    # @option :event [String] required
    # @option :user_id
    # @option :anonymous_id
    # @option :properties [Hash]
    # @option :context [Hash]
    # @option :integrations [Hash]
    # @option :timestamp [#iso8601] (Time.now)
    def track(options)
      Operations::Track.new(self, symbolize_keys(options)).call
    end

    # @param [Hash] options
    # @option :user_id
    # @option :anonymous_id
    # @option :name [String]
    # @option :properties [Hash]
    # @option :context [Hash]
    # @option :integrations [Hash]
    # @option :timestamp [#iso8601] (Time.now)
    def page(options)
      Operations::Page.new(self, symbolize_keys(options)).call
    end

    # @param [Hash] options
    # @option :user_id
    # @option :anonymous_id
    # @option :group_id required
    # @option :traits [Hash]
    # @option :context [Hash]
    # @option :integrations [Hash]
    # @option :timestamp [#iso8601] (Time.now)
    def group(options)
      Operations::Group.new(self, symbolize_keys(options)).call
    end

    # @param [Hash] options
    # @option :user_id
    # @option :anonymous_id
    # @option :previous_id required
    # @option :traits [Hash]
    # @option :context [Hash]
    # @option :integrations [Hash]
    # @option :timestamp [#iso8601] (Time.now)
    def alias(options)
      Operations::Alias.new(self, symbolize_keys(options)).call
    end

    # @yield [batch] Yields a special batch object that can be used to group
    #                `identify`, `track`, `page` and `group` calls into a
    #                single API request.
    # @example
    #   client.batch do |analytics|
    #     analytics.context = { 'foo' => 'bar' }
    #     analytics.identify(user_id: 'id')
    #     analytics.track(event: 'Delivered Package', user_id: 'id')
    #   end
    def batch
      batch = Batch.new(self)
      yield(batch)
      batch.commit
    end

    # A no op, added for backwards compatibility with `analytics-ruby`
    def flush; end
  end
end
