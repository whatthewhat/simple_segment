# frozen_string_literal: true

require 'logger'
module SimpleSegment
  module Logging
    def self.included(klass)
      klass.extend(self)
    end

    def default_logger(logger_option)
      logger_option || Logger.new($stdout)
    end
  end
end
