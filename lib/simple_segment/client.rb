require 'simple_segment/request'

module SimpleSegment
  class Client
    attr_reader :write_key

    def initialize(options = {})
      @write_key = options.fetch(:write_key)
    end

    # @param [Hash] options
    # @option :user_id
    # @option :anonymous_id
    # @option :traits [Hash]
    # @option :context [Hash]
    # @option :integrations [Hash]
    # @option :timestamp [#iso8601] (Time.now)
    def identify(options)
      payload = build_identify_payload(options)
      Request.new('/v1/identify', write_key: write_key).post(payload)
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
      payload = build_track_payload(options)
      Request.new('/v1/track', write_key: write_key).post(payload)
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
      payload = build_page_payload(options)
      Request.new('/v1/page', write_key: write_key).post(payload)
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
      payload = build_group_payload(options)
      Request.new('/v1/group', write_key: write_key).post(payload)
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
      payload = build_alias_payload(options)
      Request.new('/v1/alias', write_key: write_key).post(payload)
    end

    private

    def build_identify_payload(hash, current_time = Time.now)
      options = symbolize_keys(hash)
      if options[:user_id].nil? && options[:anonymous_id].nil?
        raise ArgumentError, 'user_id or anonymous_id must be present'
      end

      {
        userId: options[:user_id],
        anonymousId: options[:anonymous_id],
        traits: options[:traits],
        context: options[:context],
        integrations: options[:integrations],
        timestamp: options.fetch(:timestamp, current_time).iso8601,
        sentAt: current_time.iso8601
      }
    end

    def build_track_payload(hash, current_time = Time.now)
      options = symbolize_keys(hash)
      event = options.fetch(:event) { raise ArgumentError, 'event name must be present' }
      if options[:user_id].nil? && options[:anonymous_id].nil?
        raise ArgumentError, 'user_id or anonymous_id must be present'
      end

      {
        event: event,
        userId: options[:user_id],
        anonymousId: options[:anonymous_id],
        properties: options[:properties],
        context: options[:context],
        integrations: options[:integrations],
        timestamp: options.fetch(:timestamp, current_time).iso8601,
        sentAt: current_time.iso8601
      }
    end

    def build_page_payload(hash, current_time = Time.now)
      options = symbolize_keys(hash)
      if options[:user_id].nil? && options[:anonymous_id].nil?
        raise ArgumentError, 'user_id or anonymous_id must be present'
      end

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

    def build_group_payload(hash, current_time = Time.now)
      options = symbolize_keys(hash)
      group_id = options.fetch(:group_id) { raise ArgumentError, 'group_id must be present' }
      if options[:user_id].nil? && options[:anonymous_id].nil?
        raise ArgumentError, 'user_id or anonymous_id must be present'
      end

      {
        userId: options[:user_id],
        anonymousId: options[:anonymous_id],
        groupId: group_id,
        traits: options[:traits],
        context: options[:context],
        integrations: options[:integrations],
        timestamp: options.fetch(:timestamp, current_time).iso8601,
        sentAt: current_time.iso8601
      }
    end

    def build_alias_payload(hash, current_time = Time.now)
      options = symbolize_keys(hash)
      previous_id = options.fetch(:previous_id) { raise ArgumentError, 'previous_id must be present' }
      if options[:user_id].nil? && options[:anonymous_id].nil?
        raise ArgumentError, 'user_id or anonymous_id must be present'
      end

      {
        userId: options[:user_id],
        anonymousId: options[:anonymous_id],
        previousId: previous_id,
        context: options[:context],
        integrations: options[:integrations],
        timestamp: options.fetch(:timestamp, current_time).iso8601,
        sentAt: current_time.iso8601
      }
    end

    def symbolize_keys(hash)
      hash.each_with_object({}) { |(key, value), result| result[key.to_sym] = value }
    end
  end
end
