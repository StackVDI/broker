Feature: Cloud Servers Images
  In order to create master images from cloud servers to serve them to users
  As an admin
  I want to be able to create, update, delete images

  Background:
    Given I log as an admin

  @wip
  Scenario: Admin can create Images
    When  I visit the images link
    And  I add a Image
    Then I can see the new image in the image list
 
