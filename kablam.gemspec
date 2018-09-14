Gem::Specification.new do |s|
  s.name        = 'kablam'
  s.version     = '0.0.1'
  s.date        = '2018-09-14'
  s.summary     = "Empty Initialization of Gem"
  s.description = "Gem to make development of everything in rails even faster."
  s.authors     = ["Sergio Rivas"]
  s.email       = 'sergiorivas@163.com'
  s.files       = ["lib/kablam.rb", "lib/kablam/kablam_record.rb"]
  s.homepage    =
    'http://rubygems.org/gems/kablam'
  s.license       = 'MIT'

  s.add_dependency("activerecord")
end
