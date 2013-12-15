Feature: Sign_up
  In order to allow users to use the app,
  As an user
  I want to be able to sign up

  Background:
    Given I am not logged in

  Scenario: User signs up with valid data
    When I sign up with valid data
    Then I receive an email for confirmation
    When I open the email
    Then I should see "confirm" in the email body
    When I follow "confirm" in the email
    Then I should see a successful confirmation message

  Scenario: User try to sign up with invalid email
    When I sign up with invalid email
    Then I get an email error message

  Scenario: User sign_up without confirmation
    When I sign up with valid data
    Then I sign in with valid data
    Then I should see an sign in error message
    And  I'm not logged in

  Scenario: User sign_up without admin approbation
    When I sign up with valid data
    Then I receive an email for confirmation
    When I open the email
    Then I should see "confirm" in the email body
    When I follow "confirm" in the email
    Then I should see a successful confirmation message
    Then I sign in with valid data
    Then I should see an sign in error message
    And  I'm not logged in


