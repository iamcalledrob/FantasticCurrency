require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('fantastic_currency', '0.1.3') do |p|
  p.description     = "Manage currencies with Active Record"
  p.url             = "http://github.com/iamcalledrob/FantasticCurrency"
  p.author          = "Rob Mason"
  p.email           = "info+gems@slightlyfantastic.com"
  p.ignore_pattern  = ["tmp/*", "script/*"]
  p.development_dependencies = []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }
