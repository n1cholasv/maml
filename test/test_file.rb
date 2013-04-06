$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + "/../lib"))

require 'test/unit'
require 'maml/maml'
require 'fileutils'


class NoFileTest < Test::Unit::TestCase
  NO_FILE_FOUND_ERROR="Unable to load file"
  
  def test_no_file_found
    assert_equal 2, 2
  end
  
  # when no example or default file exists, create a sample file
  def test_create_example_file
    sample_file='maml.yml'
    FileUtils.rm sample_file if File.exists? sample_file
    Maml::create_sample
    assert File.exists?(sample_file), "create_sample_file"
  end
  
end