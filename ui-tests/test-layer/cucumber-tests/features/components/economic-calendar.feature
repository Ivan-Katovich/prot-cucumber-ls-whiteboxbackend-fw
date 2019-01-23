@economic-calendar
Feature: Economic calendar panel
  As a user
  I can open economic calendar panel
  So all the panels parts should be loaded

  Background:
    Given I am logged in to the application with default state

  @quick @smoke @economic-calendar-on-new-tab
  Scenario: Economic calendar on new tab
    When I add new tab
    And I add new 'Economic Calendar' panel in '2'nd tab
    Then the panel should be visible
    Then all the panels parts should be loaded
