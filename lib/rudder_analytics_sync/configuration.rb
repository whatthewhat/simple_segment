# frozen_string_literal: true

require 'rudder_analytics_sync/logging'

module RudderAnalyticsSync
  class Configuration
    include RudderAnalyticsSync::Utils
    include RudderAnalyticsSync::Logging

    attr_reader :write_key, :data_plane_url, :on_error, :stub, :logger, :http_options

    def initialize(settings = {})
      symbolized_settings = symbolize_keys(settings)
      @write_key = symbolized_settings[:write_key]
      @data_plane_url = symbolized_settings[:data_plane_url]
      @on_error = symbolized_settings[:on_error] || proc {}
      @stub = symbolized_settings[:stub]
      @logger = default_logger(symbolized_settings[:logger])
      @http_options = { use_ssl: true }
                      .merge(symbolized_settings[:http_options] || {})
      raise ArgumentError, 'Missing required option :write_key' \
        unless @write_key
    end
  end
end
