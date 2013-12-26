Feature: Cloud Servers Images
  In order to create master images from cloud servers to serve them to users
  As an admin
  I want to be able to create, update, delete images

  Background:
    Given I log as an admin
    And   I create a cloud server

  Scenario: Admin can create Images
    When I click in the cloud servers link
    And  I click in the images link of the first cloud server
    And  I add an Image
    Then I can see the new image in the image list

  Scenario: Admin can delete Images
    When I click in the cloud servers link
    And  I create an Image
    And  I click in the images link of the first cloud server
    And  I delete an Image
    Then I can't see the image in the image list

   Scenario: Admin can edit Images
    When I click in the cloud servers link
    And  I click in the images link of the first cloud server
    And  I add an Image
    And  I can see the new image in the image list
    Then I edit the image
    And I can see the edited image in the image list


