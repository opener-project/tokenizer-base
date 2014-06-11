require_relative '../../lib/opener/tokenizers/base'
require 'tempfile'
require 'rspec'

def kernel_root
  File.expand_path("../../../", __FILE__)
end

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end

  config.mock_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end
