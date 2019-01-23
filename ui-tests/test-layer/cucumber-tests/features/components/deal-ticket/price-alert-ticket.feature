@price-alert-ticket
Feature: Price Alert Ticket panel
  As a user
  I can open price alert ticket panel
  So all functionality should work fine for the panel

  Background:
    Given I am logged in to the application with default state

  @functional-smoke @regression @USD/JPY @price-alerts @set-price-alert-create-sell-gtt-alert @wt-1480-v9
  Scenario: Set Price Alert - Create Sell (GTT) Alert
    #1, 2
    Then the 'Watchlist' panel should be visible
    # will be changed to separate markets after 1.23
    And markets of 'Popular Markets' watchlist should be visible
    When I click on 'sell' in the 'USD/JPY' market
    Then the 'Deal ticket' panel should be visible
    And I switch to 'set alert' tab
    Then 'set alert' ticket type should be 'selected'
    And trade direction should be 'sell'
    #3
    When I fill 'alert price' with value '130'
    Then 'submit button' element should be enabled
    And 'submit button' element text should be 'Set Alert'
    #4
    And 'main good till dropdown' element text should be 'Good 'til canceled (GTC)'
    #5
    When I expand 'good till dropdown link' dropdown
    And I select 'GTT' from expanded dropdown
    Then the order ticket standard view panel should contain items:
      | itemName    |
      | date picker |
    And date picker input should be defined with '0' minutes more than now
    #6
    When I expand 'date picker' dropdown
    Then 'date picker' dropdown should be visible
    #7
    When I add to date/time picker '2' hours and click outside
    Then date picker input should be defined with '2' hours more than now
    Then 'submit button' element should be enabled
    And 'submit button' element text should be 'Set Alert'
    #8
    When I expand 'date picker' dropdown
    When I add to date/time picker '-3' hours and click outside
    When I click on 'submit' button
    Then 'failure' element text should be 'Alert set failed'
    And 'market name' element text should be 'USD/JPY'
    And 'set alert incorrect time' confirmation message should be correct
    Then 'main good till dropdown' element should be disabled
    Then 'alert price' element should be disabled
    Then 'date picker' element should be disabled
    #9
    And I click on 'ok' button
    Then failure message should not be displayed within panel
    Then 'main good till dropdown' element should be enabled
    Then 'alert price' element should be enabled
    Then 'date picker' element should be enabled
    #10
    When I expand 'date picker' dropdown
    When I add to date/time picker '3' hours and click outside
    And 'main good till dropdown' element text should be 'Good 'til time (GTT)'
    #11
    When I click on 'submit' button after waiting
    Then 'confirmation' element text should be 'Alert set'
    And 'market name' element text should be 'USD/JPY'
    And 'set alert' confirmation message should be correct
    #12
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
    #13
    Then the 'Positions And Orders' panel should be visible
    When I select 'Price Alerts' list
    Then the 'previously added' market should be present on the list
    And the 'previously added' market direction icon should be colored correctly
    And the 'previously added' market 'direction' cell should contain 'sell' data
    And the 'previously added' market 'trigger price' cell should contain '130.000' data
    And the 'previously added' alert current price should be correct
    And the 'previously added' alert distance away should be correct
    #  TODO: wait till developers add market ID to alerts
    And the 'previously added' alert 'date set' cell should contain date '0' minutes more than now
    And the 'previously added' alert 'expiry' cell should contain date '2' hours more than now
    When I hover 'previously added' market
    Then the 'current' market 'remove icon' should be visible
    #14 - requires mocks


#    =================================================================================================================================
#                                                    Functional smoke
#                                                            |
#                                                        Regression
#    =================================================================================================================================
