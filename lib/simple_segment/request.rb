module SimpleSegment
  class Request
    BASE_URL = 'https://api.segment.io'.freeze
    DEFAULT_HEADERS = {
      'Content-Type' => 'application/json',
      'accept' => 'application/json'
    }.freeze

    attr_reader :write_key, :error_handler, :stub, :logger, :open_timeout, :read_timeout

    def initialize(client)
      @write_key = client.config.write_key
      @error_handler = client.config.on_error
      @stub = client.config.stub
      @logger = client.config.logger
      @open_timeout = client.config.open_timeout
      @read_timeout = client.config.read_timeout
    end

    def post(path, payload, headers: DEFAULT_HEADERS)
      response = nil
      status_code = nil
      response_body = nil

      uri = URI(BASE_URL)
      payload = JSON.generate(payload)
      if stub
        logger.debug "stubbed request to \
        #{path}: write key = #{write_key}, \
        payload = #{payload}"

        { status: 200, error: nil }
      else
        options = {}
        options[:use_ssl] = true
        options[:open_timeout] = open_timeout if open_timeout
        options[:read_timeout] = read_timeout if read_timeout
        Net::HTTP.start(uri.host, uri.port, options) do |http|
          request = Net::HTTP::Post.new(path, headers)
          request.basic_auth write_key, nil
          http.request(request, payload).tap do |res|
            status_code = res.code
            response_body = res.body
            response = res
            response.value
          end
        end
      end
    rescue StandardError => e
      error_handler.call(status_code, response_body, e, response)
    end
  end
end
