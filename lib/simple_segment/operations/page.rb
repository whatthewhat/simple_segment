module SimpleSegment
  module Operations
    class Page < Operation
      def call
        Request.new('/v1/page', config).post(build_payload)
      end

      private

      def build_payload
        base_payload.merge({
          name: options[:name],
          properties: options[:properties]
        })
      end
    end
  end
end
