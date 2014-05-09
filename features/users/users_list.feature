Feature: List Users
  As an admin
  I want to be able to manage users

  Scenario: Admin can see the user list
    When I log as an admin
    And  I visit user list link
    Then I can see the user's list

  Scenario: Users can't see the user list
    When I log as an user
    And  I visit user list link blindy
    Then I get an unauthorized error

  Scenario: Unconfirmed users are in warning color
    When I log as an admin
    And A user has sign up but not confirmed
    And  I visit user list link
    Then I can see the the user in "warning"

  Scenario: Unapproved users are in info color
    When I log as an admin
    And A user has sign up confirmed, but not approved
    And  I visit user list link
    Then I can see the the user in "info"

  Scenario: Admin can approve users
    When I log as an admin
    And A user has sign up confirmed, but not approved
    And  I visit user list link
    Then I click in not approved link
    And user is approved

  Scenario: Admin can delete users
    When I log as an admin
    And A user has sign up confirmed, but not approved
    And  I visit user list link
    Then I click in delete user link
    And user is deleted

  Scenario: Admin can edit users
    When I log as an admin
    And I have created "first" and "second" role
    And A user has sign up confirmed and approved
    And  I visit user list link
    Then I click in edit user link
    And I am in the user edit page
    And I edit the user
    And I can see the edited user

  Scenario: Admin can upload a CSV file for create users
    When I log as an admin
    And I upload a right CSV file
    Then I can see there the CSV file is OK
    Then I click in Create Users button
    And I can see a list with the users created

  Scenario: Admin uploads a wrong CSV file for create users
    When I log as an admin
    And I upload a wrong CSV file
    Then I can see a list of errors of the file