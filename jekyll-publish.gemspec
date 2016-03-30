Gem::Specification.new do |s|
  s.name        = 'jekyll-publish'
  s.version     = '0.0.3'
  s.date        = '2016-03-29'
  s.summary     = "Publish Jekyll's static files."
  s.description = "Allows you to easily publish your static website to S3"
  s.authors     = ["Sean Rankine"]
  s.email       = 'srdeveloper@icloud.com'
  s.files       = ["lib/jekyll-publish.rb"]
  s.homepage    =
    'http://rubygems.org/gems/jekyll_publish'
  s.license     = 'MIT'
  s.add_runtime_dependency 'aws-sdk', '>=2.0.0'
end
