Gem::Specification.new do |s|
  s.name        = 'kablam'
  s.version     = '0.2.9'
  s.date        = Time.now.strftime("%Y-%m-%d")
  s.summary     = "Kablam! All the things you hate. But Faster."
  s.description = "Gem to make development of everything in rails faster. Form creation & styling, all the resource routes, even actioncable messaging!\n {NOTE: In Development. NOT READY FOR TESTING.}"
  s.authors     = ["Sergio Rivas"]
  s.email       = 'sergiorivas@163.com'
  s.files       = `git ls-files`.split("\n")
  s.homepage    =
    'http://rubygems.org/gems/kablam'
  s.license       = 'MIT'

  s.add_dependency("rails", ">= 5.1.6")
  s.add_dependency('rails-i18n', ">= 5.1.1")
  s.add_dependency('puma')
end
