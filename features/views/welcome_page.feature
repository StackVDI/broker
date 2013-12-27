Feature: Welcome page
  In order to launch virtual desktops
  As an user
  I have all the images of my group availables

  Background:
    Given I create a cloud server
    And   I create a image in the group 'primero'

  Scenario: User can see images of virtual desktop to launch
    When  I log as an user in the group 'primero'
    When  I'm in root page
    Then  I can see the image

