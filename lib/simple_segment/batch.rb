module SimpleSegment
  class Batch
    include SimpleSegment::Utils

    attr_reader :config, :payload
    attr_accessor :context, :integrations

    def initialize(config)
      @config = config
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

      Request.new('/v1/import', config).post(payload)
    end

    private

    def add(operation_class, options, action)
      operation = operation_class.new(symbolize_keys(options), config)
      operation_payload = operation.build_payload
      operation_payload[:action] = action
      payload[:batch] << operation_payload
    end
  end
end
