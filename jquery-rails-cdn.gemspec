# -*- encoding: utf-8 -*-
require File.expand_path('../lib/jquery-rails-cdn/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Kenn Ejima"]
  gem.email         = ["kenn.ejima@gmail.com"]
  gem.description   = %q{Add CDN support to jquery-rails}
  gem.summary       = %q{Add CDN support to jquery-rails}
  gem.homepage      = "https://github.com/kenn/jquery-rails-cdn"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "jquery-rails-cdn"
  gem.require_paths = ["lib"]
  gem.version       = Jquery::Rails::Cdn::VERSION

  gem.add_runtime_dependency "jquery-rails"
  gem.add_development_dependency 'minitest'
end
