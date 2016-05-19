module SimpleSegment
  class Batch
    include SimpleSegment::Utils

    attr_reader :client, :payload
    attr_accessor :context, :integrations

    def initialize(client)
      @client = client
      @payload = { batch: [] }
      @context = {}
      @integrations = {}
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

    def commit
      if payload[:batch].length == 0
        raise ArgumentError, 'A batch must contain at least one action'
      end
      payload[:context] = context
      payload[:integrations] = integrations

      Request.new(client).post('/v1/import', payload)
    end

    private

    def add(operation_class, options, action)
      operation = operation_class.new(client, symbolize_keys(options))
      operation_payload = operation.build_payload
      operation_payload[:action] = action
      payload[:batch] << operation_payload
    end
  end
end
