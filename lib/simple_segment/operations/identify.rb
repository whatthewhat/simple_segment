module SimpleSegment
  module Operations
    class Identify < Operation
      def call
        request.post('/v1/identify', build_payload)
      end

      def build_payload
        base_payload.merge(
          traits: options[:traits]
        )
      end
    end
  end
end
