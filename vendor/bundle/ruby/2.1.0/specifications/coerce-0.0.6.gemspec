# -*- encoding: utf-8 -*-
# stub: coerce 0.0.6 ruby lib

Gem::Specification.new do |s|
  s.name = "coerce"
  s.version = "0.0.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Ara T. Howard"]
  s.date = "2013-12-14"
  s.description = "description: coerce kicks the ass"
  s.email = "ara.t.howard@gmail.com"
  s.homepage = "https://github.com/ahoward/coerce"
  s.licenses = ["same as ruby's"]
  s.rubyforge_project = "codeforpeople"
  s.rubygems_version = "2.2.2"
  s.summary = "coerce"

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<chronic>, [">= 0.6.2"])
    else
      s.add_dependency(%q<chronic>, [">= 0.6.2"])
    end
  else
    s.add_dependency(%q<chronic>, [">= 0.6.2"])
  end
end
