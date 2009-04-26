# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{maml}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Nick Van Weerdenburg"]
  s.date = %q{2009-04-25}
  s.description = %q{Modeling Apathy Markup Language}
  s.email = %q{nick@gmail.com}
  s.extra_rdoc_files = ["CHANGELOG", "lib/maml.rb", "LICENSE", "README.rdoc"]
  s.files = ["CHANGELOG", "echoe_notes", "init.rb", "lib/maml.rb", "LICENSE", "maml", "maml.gemspec", "maml.yml", "maml_spec.txt", "Manifest", "Rakefile", "README.rdoc"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/vanweerd/maml}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Maml", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{maml}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Modeling Apathy Markup Language}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
