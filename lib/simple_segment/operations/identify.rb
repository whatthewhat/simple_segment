module SimpleSegment
  module Operations
    class Identify < Operation
      def call
        Request.new('/v1/identify', config).post(build_payload)
      end

      private

      def build_payload
        base_payload.merge({
          traits: options[:traits]
        })
      end
    end
  end
end
