Gem::Specification.new do |s|
  s.name = %q{spotty}
  s.version = "0.0.1"
  s.date = %q{2015-10-27}
  s.summary = %q{Generic poller designed to be used for AWS EC2 Spot Instance Termination Notices}
  s.license = "MIT"
  s.files = [
    "lib/spotty.rb"
  ]
  s.authors = ["Minh Phan"]
  s.email = "dmphan@ditto.us.com"
  s.require_paths = ["lib"]
  s.add_development_dependency("rake", "~> 10.0")
  s.add_development_dependency("rspec", "~> 3.0")
  s.add_development_dependency "fakeweb", ["~> 1.3"]
end
