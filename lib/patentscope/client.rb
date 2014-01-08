require 'net/http'
require 'nokogiri'

module Patentscope

  class Client
    attr_reader :username, :password

    USER_AGENT_STRING = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_4) AppleWebKit/536.30.1 (KHTML, like Gecko) Version/6.0.5 Safari/536.30.1"

    def initialize(args = {})
      @username = args[:username]
      @password = args[:password]
    end

    def get_url(url)
      open(url, "User-Agent" => USER_AGENT_STRING, http_basic_authentication: [username, password]).read
    end

    def post_url(url, content_type = 'text/html', body = '')
      uri                     = URI.parse(url)
      http                    = Net::HTTP.new(uri.host, uri.port)
      request                 = Net::HTTP::Post.new(uri.request_uri)
      request.basic_auth(username, password)
      request["User-Agent"]   = USER_AGENT_STRING
      request["Content-Type"] = content_type
      request.body            = body
      response                = http.request(request)
      response.body
    end
  end
end
