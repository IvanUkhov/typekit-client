require 'webmock/rspec'
require 'vcr'
require 'typekit'

require_relative 'support/common_helper'
require_relative 'support/record_helper'

RSpec.configure do |config|
  config.include CommonHelper
  config.disable_monkey_patching!
end

class RSpec::Core::ExampleGroup
  alias_method :described_module, :described_class
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixture/cassette'
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.default_cassette_options = {
    allow_unused_http_interactions: false,
    match_requests_on: [:method, :uri, :body]
  }
  config.allow_http_connections_when_no_cassette = false
end
