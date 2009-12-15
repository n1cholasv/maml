class Shell
  def type command_line
  end
  
  def result
    "Thanks for Being a Lazy MAML"
  end
end

Given /^a shell$/ do  
  # pending # express the regexp above with the code you wish you had\
  @shell= Shell.new
end

When /^I type "([^\"]*)"$/ do |command|
  @shell.type command
  # pending # express the regexp above with the code you wish you had
end

Then /^I should see "([^\"]*)"$/ do |expected_result|
  # pending # express the regexp above with the code you wish you had
  @shell.result.should == expected_result
end
