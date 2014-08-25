# -*- encoding: utf-8 -*-
# stub: sekrets 1.7.0 ruby lib

Gem::Specification.new do |s|
  s.name = "sekrets"
  s.version = "1.7.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Ara T. Howard"]
  s.date = "2013-12-14"
  s.description = "description: sekrets kicks the ass"
  s.email = "ara.t.howard@gmail.com"
  s.executables = ["sekrets"]
  s.files = ["bin/sekrets"]
  s.homepage = "https://github.com/ahoward/sekrets"
  s.rubyforge_project = "codeforpeople"
  s.rubygems_version = "2.2.2"
  s.summary = "sekrets"

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<highline>, [">= 1.6.15"])
      s.add_runtime_dependency(%q<map>, [">= 6.3.0"])
      s.add_runtime_dependency(%q<fattr>, [">= 2.2.1"])
      s.add_runtime_dependency(%q<coerce>, [">= 0.0.3"])
      s.add_runtime_dependency(%q<main>, [">= 5.1.1"])
    else
      s.add_dependency(%q<highline>, [">= 1.6.15"])
      s.add_dependency(%q<map>, [">= 6.3.0"])
      s.add_dependency(%q<fattr>, [">= 2.2.1"])
      s.add_dependency(%q<coerce>, [">= 0.0.3"])
      s.add_dependency(%q<main>, [">= 5.1.1"])
    end
  else
    s.add_dependency(%q<highline>, [">= 1.6.15"])
    s.add_dependency(%q<map>, [">= 6.3.0"])
    s.add_dependency(%q<fattr>, [">= 2.2.1"])
    s.add_dependency(%q<coerce>, [">= 0.0.3"])
    s.add_dependency(%q<main>, [">= 5.1.1"])
  end
end
