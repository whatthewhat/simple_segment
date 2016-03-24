module SimpleSegment
  module Operations
    class Operation
      attr_reader :options, :config

      def initialize(options = {}, config)
        @options = options
        @config = config
      end

      def call
        raise 'Must be implemented in a subclass'
      end

      private

      def check_identity!
        unless options[:user_id] || options[:anonymous_id]
          raise ArgumentError, 'user_id or anonymous_id must be present'
        end
      end
    end
  end
end
