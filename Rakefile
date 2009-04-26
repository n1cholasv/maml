require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new("maml", "0.1.1") do |p|
  p.description = "Modeling Apathy Markup Language"
  p.url = "http://github.com/vanweerd/maml"
  p.author = "Nick Van Weerdenburg"
  p.email = "nick@gmail.com"
  p.ignore_pattern = ["tmp/*", "script/*"]
  p.development_dependencies = []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each{|ext| load ext}
