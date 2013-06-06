require File.expand_path('../lib/opener/tokenizer/base/version', __FILE__)

GENERATED_FILES = Dir.glob(
  File.expand_path("../core/target/vicom-tokenizer-all-*.jar", __FILE__)
)

Gem::Specification.new do |gem|
  gem.name                  = 'opener-tokenizer-base'
  gem.version               = Opener::Tokenizer::Base::VERSION
  gem.authors               = ['development@olery.com']
  gem.summary               = 'Tokenize English, Dutch, German, Italian and Spanish to KAF'
  gem.description           = gem.summary
  gem.homepage              = 'http://opener-project.github.com/'
  gem.has_rdoc              = "yard"
  gem.required_ruby_version = ">= 1.9.2"

  gem.files       = `git ls-files`.split("\n").push('core/target/vicom-tokenizer-all-1.0.jar') #+ GENERATED_FILES
  gem.executables = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files  = gem.files.grep(%r{^(test|spec|features)/})

  gem.add_development_dependency 'cucumber'
  gem.add_development_dependency 'rspec'
end
