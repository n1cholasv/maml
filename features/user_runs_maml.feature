Feature: user runs maml
  In order to quickly start a rails app or a portion of it
  As a programmer
  I want to use Maml
  
  Scenario: user runs maml by itself
    Given a shell
    When I type "maml"
    Then I should see "Thanks for Being a Lazy MAML"