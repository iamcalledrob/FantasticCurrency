# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{fantastic_currency}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Rob Mason"]
  s.date = %q{2010-02-14}
  s.description = %q{Manage currencies with Active Record}
  s.email = %q{info+gems@slightlyfantastic.com}
  s.extra_rdoc_files = ["README.textile", "lib/fantastic_currency.rb"]
  s.files = ["README.textile", "Rakefile", "lib/fantastic_currency.rb", "Manifest", "fantastic_currency.gemspec"]
  s.homepage = %q{http://github.com/iamcalledrob/FantasticCurrency}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Fantastic_currency", "--main", "README.textile"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{fantastic_currency}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Manage currencies with Active Record}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
