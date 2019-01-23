@market-statuses
Feature: Market statuses
  As a user
  I can open trade ticket fore markets with different statuses
  So all functionality should work fine

  Background:
    Given I am logged in to the application with default state

  @smoke @delete-watchlist @closed-market-dt-state
  Scenario: Closed market DT state
    Then the 'Watchlist' panel should be visible
    When I collapse 'Popular Markets' watchlist
    And I create 'market statuses' watchlist
    And I find market with 'closed' status
    And I type 'closed' name of market
    Then the 'market from dropdown' element should be visible on '1'nd watchlist
    When I add '1'st market from market dropdown
    Then the 'previously added' market is visible
    When I click on 'sell' in the 'previously added' market
    Then the 'Deal ticket' panel should be visible
    And 'order' ticket type should be 'selected'
    And 'quantity' input should be active
    When I switch to 'trade' tab
    Then 'market status title' element text should be 'Market Closed'
    And the trade ticket standard view panel should contain items:
      | itemName             |
      | closed icon          |
      | status description   |
      | create an order link |
    When I click on 'create an order link' element
    Then 'order' ticket type should be 'selected'
    And 'quantity' input should be active

  @smoke @delete-watchlist @phone-only-market-dt-state @ppe
  Scenario: Phone only market DT state
    Then the 'Watchlist' panel should be visible
    When I collapse 'Popular Markets' watchlist
    And I create 'market statuses' watchlist
    And I find market with 'phone only' status
    And I type 'phone only' name of market
    Then the 'market from dropdown' element should be visible on '1'nd watchlist
    When I add '1'st market from market dropdown
    Then the 'previously added' market is visible
    When I click on 'sell' in the 'previously added' market
    Then the 'Deal ticket' panel should be visible
    And 'order' ticket type should be 'selected'
    And 'market status title' element text should be 'Call 0845 355 0801'
    And the trade ticket standard view panel should contain items:
      | itemName           |
      | call to trade icon |
      | status description |
    When I switch to 'trade' tab
    Then 'market status title' element text should be 'Call 0845 355 0801'
    And the trade ticket standard view panel should contain items:
      | itemName           |
      | call to trade icon |
      | status description |


