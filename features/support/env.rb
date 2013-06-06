require_relative '../../lib/opener/tokenizer/en'
require 'rspec/expectations'
require 'tempfile'
require 'pry'

def kernel_root
  File.expand_path("../../../", __FILE__)
end

def kernel
  Opener::Tokenizer::EN.new
end
