require 'simple_segment/utils'
require 'simple_segment/configuration'
require 'simple_segment/operations'

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
      Operations::Identify.new(symbolize_keys(options), config).call
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
      Operations::Track.new(symbolize_keys(options), config).call
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
      Operations::Page.new(symbolize_keys(options), config).call
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
      Operations::Group.new(symbolize_keys(options), config).call
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
      Operations::Alias.new(symbolize_keys(options), config).call
    end

    # A no op, added for backwards compatibility with `analytics-ruby`
    def flush
    end
  end
end
