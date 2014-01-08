require 'bundler'
Bundler.setup(:default, :development)

require 'patentscope'
require 'rspec'
require 'vcr'
require 'yaml'
require 'open-uri'

# generate versions of username and password with unsafe characters encoded
unsafe_characters = %q[$&+,/:;=?!@ "'<>#%{}|\^~[]`]
escaped_patentscope_webservice_username = URI::escape(ENV['PATENTSCOPE_WEBSERVICE_USERNAME'], unsafe_characters)
escaped_patentscope_webservice_password = URI::escape(ENV['PATENTSCOPE_WEBSERVICE_PASSWORD'], unsafe_characters)

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
