#!/usr/bin/env ruby
# maml.rb - Model and Migration Apathy Markup Language
# there is only 1 m in maml because I'm lazy.
# Copyright 2009 Zigleo, Inc.
# Author: Nick Van Weerdenburg
# todo: switch all puts to logger
# todo: remove some excess logging
# todo: create a gem
require "yaml"
require "logger"

# I love logging
$logger=Logger.new('maml.log') 
$logger.level=Logger::INFO
$logger.info "PLATFORM=#{PLATFORM}"

# look user and project configuration file
user_config_file=ENV['HOME'] + "/.mamlrc"
project_config_file=".mamlrc"
$logger.info("user .mamlrc #{File.exist? user_config_file ? 'found' : 'not found'}")
$logger.info("project .mamlrc #{File.exist? project_config_file ? 'found' : 'not found'}")

module CurrentMethodName
  def this_method
    caller[0]=~/`(.*?)'/
    $1
  end
end

include CurrentMethodName

# simple test fixture
def test
  string_arg
end

def extract_arg maml_field
  maml_arg=nil
  field=nil
  type=nil
  
  $logger.info this_method + "=> maml_field=#{maml_field}"
  type=case maml_field
      when /^::(\w*)\b/; "text"
      when /^:(\w*)\b/; "string"
      when /^\.\.(\w*)\b/; "float"
      when /^\.(\w*)\b/; "integer"
      when /(\w*_id)\b/; "integer"
      when /^=(\w*)\b/; "boolean"
      when /^%%(\w*)\b/; "datetime"
      when /^%(\w*)\b/; "date"
      when /^@@(\w*)\b/; "timestamp"
      when /^@(\w*)\b/; "time"
      when /^&(\w*)\b/; "binary"
      when /(\w*)\b/; "string"
      else raise "Invalid field type";
   end
   field=Regexp.last_match(1)
   maml_arg= "#{field}:#{type}"
end

# build script/generate model arguments from yaml info
def build_model_args maml
  model_args={}
  maml.each do |app|
    puts "\napplication:#{app[0]}"
    print "models: " 
    app[1].each do |model|
      current_model_args=[]
      model_name=model[0]
      print "#{model_name} "
      model[1].each do |field|
        arg=extract_arg field
        $logger.debug "Extract #{field} ===> #{arg}"
        current_model_args << arg
      end
      model_args[model_name]=current_model_args
    end
    puts
  end
  model_args
end

# todo: add support for multiple files
# todo: add generate command override options to maml.yml for model specific generations.
def process_args args
  generate_command,file=nil
  
  args.each do |arg|
    if arg[0,1] == "-" then 
      generate_command=arg[1,arg.length]        
    else
      file=arg
    end
  end
  return generate_command,file
end

# main function
def main
  puts "\nMAML=Migration Apathy Markup Language"
  puts "======================================"
  puts "Visit http://lazymaml.org for more details"
  puts "Copyright 2009 Zigelo and Nick Van Weerdenburg, Licensed under MIT License\n\n"
  puts "usage: maml.rb <filename> [-generate_command]"
  puts "e.g. maml.rb blog.yml -scaffold"
  puts "OR"
  puts "usage: maml.rb"
  puts "(defaults to 'maml.yml' file and generating the model)\n\n"
  puts "maml supports one file at time"
  puts "generated files are in <rails_root>/maml"
  puts "\nSpecify field type by symbol prefix as follows:"
  puts "no prefix=string ; no prefix and _id suffix = integer ; override _id by adding prefix"
  puts "examples: string, integer_id, .integer, ..float,  %date, %%datetime, @time, @@timestamp, :string, ::text, =boolean, &binary"
  puts "------------------------------------------------------------------------\n"
  puts ""
  
  generate_command, file = process_args ARGV
  $logger.info "\ngenerate_command=#{generate_command}, file=#{file}"
  @file_provided=true if file
  $logger.info  "@file_provided=#{@file_provided}"
      
  file="maml.yml" unless file
  generate_command="model" unless generate_command
  puts "generate_command=#{generate_command}, file=#{file}"
  
  maml=YAML::load(File.open(file))
  
  model_args=build_model_args maml

  puts
  
  # now execute each model
  model_args.each do |model|
    model_name=model[0]
    puts "model_name: #{model_name}"
    model_fields=model[1].join " "
    # File.open("maml.log", "a") { |file| file.write "---- model: #{model_name} (#{model_fields}) ---\n\n" }
    File.open("maml.log", "a") { |file| file.write "---- model: #{model_name} \n\t\t\t#{model_fields.split(" ").join("\n\t\t\t")}\n---\n\n" }
    command="ruby script/generate #{generate_command} #{model_name} #{model_fields} >> maml.log"
    puts "command: #{command}\n\n"
    if @file_provided == true
      puts "=== calling system command ==="
      system command
    end  
  end
  puts "\n\nDONE! Look at maml.log for script results, and in app/models, db/migrations, test/fixtures and test/unit for generated code (if you ran maml.rb with a command line arg)"
  unless ARGV[0]
    puts "\n\nUse 'maml.rb maml.yml' (or other file arg) to actuallly run generators. Running with default maml.yml does test run only."
  end
end


# only run main if run standalone (e.g. not via ruby require)
if __FILE__ == $0
   # puts "***** #{File.basename($0)} ran from file *****"

   main
end
