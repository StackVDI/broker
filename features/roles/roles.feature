Feature: Roles
  As an admin
  I want to be able to manage roles

  Scenario: Admin can see the roles list
    When I log as an admin
    And  I visit roles list link
    Then I can see the roles list

  Scenario: User can't see the roles list
    When I log as an user
    And  I visit roles list link blindy
    Then I get an unauthorized error

  Scenario: Admin can see the users in a rol
    When I log as an admin
    And  I visit roles list link
    And  I click in admin list users link
    Then I can see users with admin rol





