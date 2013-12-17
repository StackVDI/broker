Feature: Sign_in
  In order to allow users to use the app,
  As an user
  I want to be able to sign in

  Background:
    Given I am not logged in

  Scenario: User sign_in after admin approbation
    When I sign up with valid data
    Then I receive an email for confirmation
    When I open the email
    Then I should see "confirm" in the email body
    When I follow "confirm" in the email
    Then I should see a successful confirmation message
    When Admin approves me
    Then I sign in with valid data
    Then  I'm in root page

  Scenario: User logout
    When I sign up with valid data
    Then I receive an email for confirmation
    When I open the email
    Then I should see "confirm" in the email body
    When I follow "confirm" in the email
    Then I should see a successful confirmation message
    When Admin approves me
    Then I sign in with valid data
    When I click in logout
    Then I'm in the sign in page





