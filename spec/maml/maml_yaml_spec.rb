# parse_yaml_spec.rb
########################

require File.join(File.dirname(__FILE__), "..","spec_helper")

module Maml
  describe "Maml file" do
    before(:each) do
      @illegal1_invalid_field="illegal1_invalid_field.yml"
    end
    
    context "Run With No Arguments" do
      it "should say 'Welcome' when it receives the main() message" do
        result=Maml.main
      end
    end

    context "Parse illegal maml file" do
      it "should say 'Invalid MAML format'" do
        file=YAML::load(File.open(@illegal1_invalid_field))
      end
  
      it "should say too few levels" do
        pending
      end
  
      it "should say too many levels" do
        pending
      end
  
      it "should say illegal field name" do
        pending
      end
  
      it "should say illegal field options" do
        pending
      end

    end

    describe "parse field options" do
      describe "parse illegal field name" do
        it "should return line# and error type" do
        end
      end

      describe "parse illegal field options" do
      end

    end
  end
end    