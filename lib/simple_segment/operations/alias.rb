module SimpleSegment
  module Operations
    class Alias < Operation
      def call
        Request.new('/v1/alias', config).post(build_payload)
      end

      def build_payload
        raise ArgumentError, 'previous_id must be present' unless options[:previous_id]

        base_payload.merge({
          previousId: options[:previous_id]
        })
      end
    end
  end
end
