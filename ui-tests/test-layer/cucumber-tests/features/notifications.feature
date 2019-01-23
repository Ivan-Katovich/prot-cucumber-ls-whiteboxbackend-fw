@notification
Feature: Notification
  As a user
  I can open Notification Modal Dialogue and get some information
  So all Notification functionality should work fine

  Background:
    Given I am logged in to the application with default state

  @quick @smoke @notification-main-dialogue
  Scenario: Notification main dialogue
    When I click on 'notifications' header element
    Then notification dialogue should be visible
    Then notification dialogue header should be 'Notifications'
    When I close notification dialogue
    Then notification dialogue should be invisible
    When I click on 'notifications' header element
    Then notification dialogue should be visible
    When I click on 'notifications' header element
    Then notification dialogue should be invisible
