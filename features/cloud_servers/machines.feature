Feature: Machines
  In order to run machines in cloud servers
  As an user
  I want to be able to launch, destroy or reboot virtual machines

  Background:
    Given I have available machines to run
    And   I log as an user

  Scenario: User can list availables machines for his groups
    When  I'm in root page
    Then  I can see the availabe machines for my groups

  @wip
  Scenario:
    When I'm in root page
    And  I launch an image
    Then A new machine is created
    And  A new page is opened and connect to the new machine

