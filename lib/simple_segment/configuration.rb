require 'simple_segment/logging'

module SimpleSegment
  class Configuration
    include SimpleSegment::Utils
    include SimpleSegment::Logging

    attr_reader :write_key, :on_error, :stub, :logger, :open_timeout, :read_timeout

    def initialize(settings = {})
      symbolized_settings = symbolize_keys(settings)
      @write_key = symbolized_settings[:write_key]
      @on_error = symbolized_settings[:on_error] || proc {}
      @stub = symbolized_settings[:stub]
      @logger = default_logger(symbolized_settings[:logger])
      @open_timeout = symbolized_settings[:open_timeout]
      @read_timeout = symbolized_settings[:read_timeout]
      raise ArgumentError, 'Missing required option :write_key' \
        unless @write_key
    end
  end
end
