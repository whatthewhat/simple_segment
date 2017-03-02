require 'logger'
module SimpleSegment
  module Logging
    def self.included(klass)
      klass.extend(self)
    end

    def default_logger(logger_option)
      if logger_option
        logger_option
      else
        Logger.new STDOUT
      end
    end
  end
end
