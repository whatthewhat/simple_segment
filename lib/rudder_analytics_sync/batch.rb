# frozen_string_literal: true

module RudderAnalyticsSync
  class Batch
    include RudderAnalyticsSync::Utils

    attr_reader :client, :payload

    def self.deserialize(client, payload)
      new(client, symbolize_keys(payload))
    end

    def initialize(client, payload = { batch: [] })
      @client = client
      @payload = payload
    end

    def identify(options)
      add(Operations::Identify, options, __method__)
    end

    def track(options)
      add(Operations::Track, options, __method__)
    end

    def page(options)
      add(Operations::Page, options, __method__)
    end

    def group(options)
      add(Operations::Group, options, __method__)
    end

    def context=(context)
      payload[:context] = context
    end

    def integrations=(integrations)
      payload[:integrations] = integrations
    end

    def serialize
      payload
    end

    def commit
      if payload[:batch].length.zero?
        raise ArgumentError, 'A batch must contain at least one action'
      end

      Request.new(client).post('/v1/batch', payload)
    end

    private

    def add(operation_class, options, action)
      operation = operation_class.new(client, symbolize_keys(options))
      operation_payload = operation.build_payload
      operation_payload[:type] = action
      payload[:batch] << operation_payload
    end
  end
end
