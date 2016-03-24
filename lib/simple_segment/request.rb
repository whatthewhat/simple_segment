module SimpleSegment
  class Request
    BASE_URL = 'https://api.segment.io'.freeze
    DEFAULT_HEADERS = {
      'Content-Type' => 'application/json',
      'accept' => 'application/json'
    }.freeze

    attr_reader :path, :write_key

    def initialize(path, config)
      @path = path
      @write_key = config.write_key
    end

    def post(payload, headers: DEFAULT_HEADERS)
      uri = URI(BASE_URL)
      Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        payload = JSON.generate(payload)
        request = Net::HTTP::Post.new(path, headers)
        request.basic_auth write_key, nil

        http.request(request, payload)
      end
    end
  end
end
