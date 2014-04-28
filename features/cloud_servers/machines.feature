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

  Scenario: User can launch machines
    When I'm in root page
    And  I launch a machine
    Then A new machine is created
    And  A new page is opened and connect to the new machine

  Scenario: User can reboot his machines
    When I'm in root page
    And  I launch a machine
    And  I go to root page
    And  I reboot a machine
    Then The machine is rebooted
  
  Scenario: User can connect to his machines
    When I'm in root page
    And  I launch a machine
    And  I go to root page
    And  I connect to a machine
    Then A new page is opened and connect to the new machine

  Scenario: User can destroy his machines
    When I'm in root page
    And  I launch a machine
    And  I go to root page
    And  I destroy machine
    Then The machine is destroyed



  Scenario: Admin can see all the machines running
    When I am not logged in
    And  I log as an admin
    And  I visit running machines link
    Then I can see all the running machines

