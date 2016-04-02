module SimpleSegment
  class Request
    BASE_URL = 'https://api.segment.io'.freeze
    DEFAULT_HEADERS = {
      'Content-Type' => 'application/json',
      'accept' => 'application/json'
    }.freeze

    attr_reader :path, :write_key, :error_handler

    def initialize(path, config)
      @path = path
      @write_key = config.write_key
      @error_handler = config.on_error
    end

    def post(payload, headers: DEFAULT_HEADERS)
      response, status_code, response_body = nil, nil, nil
      uri = URI(BASE_URL)
      payload = JSON.generate(payload)

      Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        request = Net::HTTP::Post.new(path, headers)
        request.basic_auth write_key, nil
        http.request(request, payload).tap { |res|
          status_code = res.code
          response_body = res.body
          response = res
          response.value
        }
      end
    rescue StandardError => e
      error_handler.call(status_code, response_body, e, response)
    end
  end
end
