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
      uri                     = URI(url)
      request                 = Net::HTTP::Post.new(uri)
      request.basic_auth(username, password)
      request["User-Agent"]   = USER_AGENT_STRING
      request["Content-Type"] = content_type
      request.body            = body

      Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        response = http.request(request)
        if response.header["Content-Type"].include? "text/html"
          response.body
        elsif response.header["Content-Type"].include? "multipart/related"
          response.body.split("\r\n\r\n")[1].split("\r\n")[0]
        end
      end
    end
  end
end
