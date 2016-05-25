module SimpleSegment
  module Operations
    class Page < Operation
      def call
        request.post('/v1/page', build_payload)
      end

      def build_payload
        base_payload.merge({
          name: options[:name],
          properties: options[:properties]
        })
      end
    end
  end
end
