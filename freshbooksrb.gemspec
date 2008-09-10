Gem::Specification.new do |s|
  s.name     = "freshbooksrb"
  s.version  = "0.7"
  s.date     = "2008-09-10"
  s.authors  = ["Sam Pohlenz"]
  s.email    = "sam@sampohlenz.com"

  s.summary  = "Ruby client for FreshBooks"  
  s.homepage = "http://github.com/spohlenz/freshbooksrb"
  s.description = "FreshBooksRb is a Ruby library for integrating your apps with the FreshBooks API (http://developers.freshbooks.com/overview/)"
  
  s.files    = ["lib/freshbooks/base.rb", 
		            "lib/freshbooks/api.rb", 
		            "lib/freshbooksrb.rb"]
	
	s.add_dependency("builder", ">= 2.1.2")
  s.add_dependency("activesupport", ">= 2.1.0")
  s.add_dependency("httparty", ">= 0.1.2")
  s.add_dependency("andand", ">= 0.3.1")
end
