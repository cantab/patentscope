require 'net/http'
require 'open-uri'
require 'uri'

module Patentscope

  class Client
    attr_reader :username, :password

    USER_AGENT_STRING = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_4) AppleWebKit/536.30.1 (KHTML, like Gecko) Version/6.0.5 Safari/536.30.1"
    OPEN_TIMEOUT = 10
    READ_TIMEOUT = 60

    def initialize(args = {})
      @username = args[:username]
      @password = args[:password]
    end

    def get_url(url)
      URI.open(url, "User-Agent" => USER_AGENT_STRING, http_basic_authentication: [username, password]).read
    end

    def post_url(url, content_type = 'text/html', body = '')
      uri                     = URI(url)
      request                 = Net::HTTP::Post.new(uri)
      request.basic_auth(username, password)
      request["User-Agent"]   = USER_AGENT_STRING
      request["Content-Type"] = content_type
      request.body            = body

      Net::HTTP.start(uri.host, uri.port,
                      use_ssl: uri.scheme == 'https',
                      open_timeout: OPEN_TIMEOUT,
                      read_timeout: READ_TIMEOUT) do |http|
        response = http.request(request)
        raise WrongCredentialsError if response.is_a?(Net::HTTPUnauthorized)

        body = response.body.to_s.force_encoding("ISO-8859-1").encode("UTF-8")
        content_type = response.header["Content-Type"].to_s

        if content_type.include?("multipart/related")
          multipart_xml_body(body)
        else
          body
        end
      end
    end

    private

    def multipart_xml_body(body)
      parts = body.split("\r\n\r\n", 2)
      return body unless parts.length == 2

      parts.last.split("\r\n").first.to_s
    end
  end
end
