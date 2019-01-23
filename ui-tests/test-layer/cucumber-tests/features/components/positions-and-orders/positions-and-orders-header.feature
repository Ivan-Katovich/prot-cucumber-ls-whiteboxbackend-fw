@positions-and-orders-header
Feature: Positions and Orders header
  As a user
  I can open Positions And Orders panel
  So all functionality of panel's header should work fine

  Background:
    Given I am logged in to the application with default state

  @quick @smoke @positions-and-orders-header-functionality
  Scenario: Positions and Orders Header functionality
    Then the 'Positions And Orders' panel should be visible
    And 'Positions' item should be active
    And 'Orders' item should be not active
    And 'Order History' item should be not active
    And 'Position History' item should be not active
    And 'Price Alerts' item should be not active
    And positions and orders panel header should contain items:
      | itemName         |
      | Positions        |
      | Orders           |
      | Position History |
      | Order History    |
      | Price Alerts     |
    And 'Positions' list should be visible
    When I select 'Orders' list
    Then 'Orders' item should be active
    And 'Positions' item should be not active
    And 'Order History' item should be not active
    And 'Position History' item should be not active
    And 'Price Alerts' item should be not active
    And 'Orders' list should be visible
    When I select 'Position History' list
    Then 'Orders' item should be not active
    And 'Positions' item should be not active
    And 'Order History' item should be not active
    And 'Position History' item should be active
    And 'Price Alerts' item should be not active
    And 'Position History' list should be visible
    When I select 'Order History' list
    Then 'Orders' item should be not active
    And 'Positions' item should be not active
    And 'Order History' item should be active
    And 'Position History' item should be not active
    And 'Price Alerts' item should be not active
    And 'Order History' list should be visible
    When I select 'Price Alerts' list
    Then 'Orders' item should be not active
    And 'Positions' item should be not active
    And 'Order History' item should be not active
    And 'Position History' item should be not active
    And 'Price Alerts' item should be active
    And 'Price Alerts' list should be visible
