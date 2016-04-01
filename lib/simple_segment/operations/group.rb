module SimpleSegment
  module Operations
    class Group < Operation
      def call
        Request.new('/v1/group', config).post(build_payload)
      end

      def build_payload
        raise ArgumentError, 'group_id must be present' unless options[:group_id]

        base_payload.merge({
          traits: options[:traits],
          groupId: options[:group_id]
        })
      end
    end
  end
end
