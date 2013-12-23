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
    And  I add a Image
    Then I can see the new image in the image list
 
