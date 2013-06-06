require File.expand_path('../lib/opener/tokenizer/en/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name                  = 'opener-tokenizer-en'
  gem.version               = Opener::Tokenizer::EN::VERSION
  gem.authors               = ['development@olery.com']
  gem.summary               = 'Tokenize an English text to KAF'
  gem.description           = gem.summary
  gem.homepage              = 'http://opener-project.github.com/'
  gem.has_rdoc              = "yard"
  gem.required_ruby_version = ">= 1.9.2"

  gem.files       = `git ls-files`.split("\n")
  gem.executables = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files  = gem.files.grep(%r{^(test|spec|features)/})

  gem.add_development_dependency 'cucumber'
  gem.add_development_dependency 'rspec'
end
