require 'bundler'
Bundler.setup(:default, :development)

require 'dotenv'
Dotenv.load
require 'patentscope'
require 'rspec'
require 'vcr'
require 'yaml'
require 'open-uri'

# generate versions of username and password with characters encoded
escaped_patentscope_webservice_username = URI.encode_www_form_component(ENV['PATENTSCOPE_WEBSERVICE_USERNAME'])
escaped_patentscope_webservice_password = URI.encode_www_form_component(ENV['PATENTSCOPE_WEBSERVICE_PASSWORD'])

VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :webmock
  config.default_cassette_options = { record: :new_episodes }
  config.default_cassette_options = { match_requests_on: [:body] }
  config.configure_rspec_metadata!
  config.allow_http_connections_when_no_cassette = true
  config.filter_sensitive_data('*****') { escaped_patentscope_webservice_username }
  config.filter_sensitive_data('*****') { escaped_patentscope_webservice_password }
end

RSpec.configure do |config|
  # config.treat_symbols_as_metadata_keys_with_true_values = true
  config.order = 'random'
end
