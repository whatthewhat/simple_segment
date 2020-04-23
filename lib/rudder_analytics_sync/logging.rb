# frozen_string_literal: true

require 'logger'
module RudderAnalyticsSync
  module Logging
    def self.included(klass)
      klass.extend(self)
    end

    def default_logger(logger_option)
      logger_option || Logger.new(STDOUT)
    end
  end
end
