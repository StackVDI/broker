Feature: Menu
  In order to have admin options
  As an admin user
  I have an admin menu

  Scenario: Admins can see the admin menu
    When I log as an admin
    When I'm in root page
    Then I can see the admin menu

  Scenario: Users can't see the admin menu
    When I log as an user
    When I'm in root page
    Then I can't see the admin menu
