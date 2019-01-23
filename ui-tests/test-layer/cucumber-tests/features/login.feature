@login
Feature: Login
  As a user
  I can login to Web Trader
  So all Login functionality should work fine

  Background:
    Given I am logged in to the application with default state

  @no-unidentified-version @version-check @wt-4-v1
  Scenario: Version check
    Then 'Default Workspace' tab should be active
    And application version from UI should be correct
