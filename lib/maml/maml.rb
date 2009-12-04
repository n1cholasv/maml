#!/usr/bin/env ruby
# maml.rb - Model and Migration Apathy Markup Language
# there is only 1 m in maml because I'm lazy.
# Copyright 2009 Zigleo, Inc.
# Author: Nick Van Weerdenburg
# todo: switch all puts to logger
# todo: remove some excess logging
# todo: create a gem
# todo: 
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
      when /^::(\w*)\b[,]?(.*)/; "text"
      when /^:(\w*)\b[,]?(.*)/; "string"
      when /^\.\.(\w*)\b[,]?(.*)/; "float"
      when /^\.(\w*)\b[,]?(.*)/; "integer"
      when /(\w*_id)\b[,]?(.*)/; "integer"
      when /^=(\w*)\b[,]?(.*)/; "boolean"
      when /^%%(\w*)\b[,]?(.*)/; "datetime"
      when /^%(\w*)\b[,]?(.*)/; "date"
      when /^@@(\w*)\b[,]?(.*)/; "timestamp"
      when /^@(\w*)\b[,]?(.*)/; "time"
      when /^&(\w*)\b[,]?(.*)/; "binary"
      when /(\w*)\b[,]?(.*)/; "string"
      else raise "Invalid field type";
   end
   field=Regexp.last_match(1)
   options=Regexp.last_match(2)
   maml_arg= "#{field}:#{type}"
   maml_options= "#{options}"
   return maml_arg, maml_options
end

# build script/generate model arguments from yaml info
def build_model_args maml
  model_args={}
  model_options={}
  maml.each do |app|
    puts "\napplication:#{app[0]}"
    print "models: " 
    app[1].each do |model|
      current_model_args=[]
      current_model_options=[]
      model_name=model[0]
      print "#{model_name} "
      model[1].each do |field|
        arg, options=extract_arg field
        $logger.debug "Extract Arg #{field} ===> #{arg}"
        $logger.debug "Extract Options #{field} ===> #{options}"
        current_model_args << arg
        field_name, field_type=arg.split(":")
        puts "field_name=#{field_name}, field_type=#{field_type}"
        current_model_options << [field_name, options]
      end
      model_args[model_name]=current_model_args
      model_options[model_name]=current_model_options
    end
    puts
  end
  return model_args, model_options
end

# todo: add support for multiple files
# todo: add generate command override options to maml.yml for model specific generations.
def process_args args
  file, go=nil
  generate_command=[]
  
  args.each do |arg|
    if arg[0,1] == "-" then
      command=arg[1,arg.length]
      if command == "go"
        go=true
      else 
        generate_command << command
      end        
    else
      file=arg
    end
  end
  if generate_command.empty?
    generate_command=nil
  else
    generate_command = generate_command.join(" ")
  end
  puts "**** generate_command=#{generate_command}"
  return generate_command,file, go
end

def post_process_migrations model, result
  model_name=model[0]
  puts "model_name: #{model_name}"
  model_fields=model[1]  # join(" ") to create args for generator ..e.g. fieldname1:string fieldname2:integer
  
  # create  app/models/user_group.rb
  model_file_regex="create  app/models/(.*).rb"
  # model_file_name=user_group
  
  # 20090731211953_create_user_groups.rb
  # find migration with same but plural
  # migration_file=
  
  # open file
  # find text field
  # append options
  # 
end


# main function
def main
  puts "\nMAML=Migration Apathy Markup Language"
  puts "======================================"
  puts "Visit http://lazymaml.org for more details"
  puts "Copyright 2009 Zigelo and Nick Van Weerdenburg, Licensed under MIT License\n\n"
  puts "usage: maml.rb <filename> [-generate_command]"
  puts "runs trial by default, add -go for rails generation"
  puts "e.g. maml.rb blog.yml -scaffold"
  puts "OR"
  puts "e.g. maml.rb blog.yml -scaffold -go"
  puts "OR"
  puts "usage: maml.rb"
  puts "(defaults to 'maml.yml' file and generating the model)\n\n"
  puts "use ---haml or similar for adding extra commands. -<anything> is passed to the command-line minus the -"
  puts "maml supports one file at time"
  puts "generated files are in <rails_root>/maml"
  puts "\nSpecify field type by symbol prefix as follows:"
  puts "no prefix=string ; no prefix and _id suffix = integer ; override _id by adding prefix"
  puts "examples: string, integer_id, .integer, ..float,  %date, %%datetime, @time, @@timestamp, :string, ::text, =boolean, &binary"
  puts "------------------------------------------------------------------------\n"
  puts ""
  
  generate_command, file, go = process_args ARGV
  $logger.info "\ngenerate_command=#{generate_command}, file=#{file}"
  @file_provided=true if file
  $logger.info  "@file_provided=#{@file_provided}"
      
  file="maml.yml" unless file
  generate_command="model" unless generate_command
  puts "generate_command=#{generate_command}, file=#{file}"
  
  maml=nil
  begin 
    maml=YAML::load(File.open(file))
    $logger.info "YAML loaded file"
  rescue
    $logger.debug "Unable to load #{file}"
    puts "Unable to load file #{file}"
    exit
  end

  model_args, model_options = build_model_args maml

  puts
  
  # now execute each model
  model_args.each do |model|
    model_name=model[0]
    puts "model_name: #{model_name}"
    model_fields=model[1].join " "
    # File.open("maml.log", "a") { |file| file.write "---- model: #{model_name} (#{model_fields}) ---\n\n" }
    # File.open("maml.log", "a") { |file| file.write 
    $logger.info "---- model: #{model_name} \n\t\t\t#{model_fields.split(" ").join("\n\t\t\t")}\n---\n\n"
    # command="ruby script/generate #{generate_command} #{model_name} #{model_fields} >> maml.log"
    command="ruby script/generate #{generate_command} #{model_name} #{model_fields}"
    puts "command: #{command}\n\n"
    if @file_provided == true
      if go
        puts "=== calling system command ==="
        result=%x[#{command}]
        puts "RESULT ====>\n #{result}"
        post_process_migrations model, result
        
        $logger.info "\n\n#{result}\n\n"
      else
        puts "=== trial run...run with '-go' to generated files ==="
      end
    else
      puts "=== no file provided ==="
    end  
  end
  
  model_options.each do |model|
    model_name=model[0]
    puts "options model_name: #{model_name}"
    
    model[1].each do |options|
      field_name=options[0]
      option_list=options[1]
      options_list_message=""
      if option_list !=nil && option_list.size > 0
        options_list_message="| options => #{option_list}"
      end
      puts "options logic: field_name=#{field_name} #{options_list_message}"
    end
  end
  # todo: parse generated migrations and add options
  # todo: add index logic
    
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
