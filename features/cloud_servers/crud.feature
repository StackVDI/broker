Feature: Cloud Servers CRUD
  In order to connect to several cloud servers,
  As an admin
  I want to be able to create, update, delete cloud servers

  Background:
    Given I log as an admin

  Scenario: Admin can create cloud servers
    When I visit the cloud servers link
    And  I add a cloud server
    Then I can see the new cloud server in the cloud servers list

  Scenario: Admin can edit cloud servers
    When I visit the cloud servers link
    And  I add a cloud server
    And  I edit a cloud server
    Then I can see the edited cloud server in the cloud servers list

  Scenario: Admin can delete cloud servers
    When I visit the cloud servers link
    And  I add a cloud server
    And  I delete the cloud server
    Then I can't see the edited cloud server in the cloud servers list

  Scenario: User can't create cloud servers
    When I am not logged in
    And  I log as an user
    When I visit the cloud server link blindy
    Then I get an unauthorized error

