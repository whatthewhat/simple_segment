module SimpleSegment
  module Operations
    class Group < Operation
      def call
        Request.new('/v1/group', config).post(build_payload)
      end

      private

      def build_payload(current_time = Time.now)
        check_identity!
        raise ArgumentError, 'group_id must be present' unless options[:group_id]

        {
          userId: options[:user_id],
          anonymousId: options[:anonymous_id],
          groupId: options[:group_id],
          traits: options[:traits],
          context: options[:context],
          integrations: options[:integrations],
          timestamp: options.fetch(:timestamp, current_time).iso8601,
          sentAt: current_time.iso8601
        }
      end
    end
  end
end
