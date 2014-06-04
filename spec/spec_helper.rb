require_relative 'support/rest_helper'
require 'webmock/rspec'
require 'vcr'
require 'typekit'

RSpec.configure do |config|
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.default_cassette_options = {
    allow_unused_http_interactions: false
  }
  config.allow_http_connections_when_no_cassette = false
end
