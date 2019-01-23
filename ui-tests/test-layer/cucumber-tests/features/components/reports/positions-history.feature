@positions-history
Feature: Positions History
  As a user
  I can open Positions History panel
  So all functionality of Positions History panel should work as described

  Background:
    Given I am logged in to the application with default state

  @functional-smoke @regression @default-resize-window @position-history-short @wt-1343-v9
  Scenario Outline: Position history [short]
    #1
    Then the 'Positions And Orders' panel should be visible
    When I add position with parameters:
      | MarketName | <Market1 name> |
      | Direction  | <Direction>    |
      | Quantity   | <Quantity>     |
    Then the 'previously added' market should be present on the list
    When I add position with parameters:
      | MarketName | <Market1 name> |
      | Direction  | <Direction>    |
      | Quantity   | <Quantity>     |
    And the 'previously added' market should be displayed as 'multi'
    And I delete 'Position' '<Market1 name>'
    And I wait for '2000'
    When I add new 'Reports' panel in 'Default Workspace' tab
    And I move panel to the 'top-right' corner
    Then the 'Reports' panel should be visible
    And I select 'Position History' list
    Then 'Position History' item should be active
    And 'Position History' list should be visible
    And the '1'st market 'name' cell should contain '<Market1 name>' word
    And the '2'nd market 'name' cell should contain '<Market1 name>' word
    #2
    When I make 'Positions And Orders' panel active
    And I select 'Positions' list
    When I add position with parameters:
      | MarketName | <Market2 name> |
      | Direction  | <Direction>    |
      | Quantity   | <Quantity>     |
    Then the 'previously added' market should be present on the list
    And I delete 'Position' '<Market2 name>'
    And I wait for '2000'
    When I make 'Reports' panel active
    Then the 'Reports' panel should be visible
    And I select 'Position History' list
    Then 'Position History' item should be active
    And 'Position History' list should be visible
    And 'Position History' panel table header should contain:
      | columnName     |
      | DATE/TIME      |
      | POSITION       |
      | POSITION PRICE |
      | REALISED P&L   |
    #3 "..All fields show accurate values and not rounded. - included values' assertion"
    And I get 'Position' History for '<Account type>'
    Then Position History '1'st table row with cell 'name' should contain correct 'MarketName' data
    And Position History '1'st table row with cell 'date' should contain correct 'ExecutedDateTimeUtc' data
    And Position History '1'st table row with cell 'quantity' should contain correct 'OriginalQuantity' data
    And Position History '1'st table row with cell 'price' should contain correct 'Price' data
    And Position History '1'st table row with cell 'realised profit/loss' should contain correct 'RealisedPnl' data
    #4
    When I hover '1'st position
    And I click on 'dropdown arrow' in the '1'st position
    Then the options from expanded dropdown should be:
      | Past position details                      |
      | Market 360 Chart, news, market information |
      | Buy Trade                                  |
      | Sell Trade                                 |
      | Chart                                      |
    #5
    When I select 'Past position details' in dropdown menu in '<Market2 name>' market
    Then the 'History Detail' panel should be visible
    And market name should be 'correct'
    And 'Order ID' row should contain correct 'OrderId' data form history
    And 'Currency' row should contain correct 'Currency' data form history
    And 'Date entered' row should contain correct 'ExecutedDateTimeUtc' data form history
    And 'Status' history row should contain 'Closed' word
    When I close panel
    #6
    When I make 'Reports' panel active
    And I select 'Position History' list
    When I complete '1'st market dropdown with value 'Market 360 Chart, news, market information'
    Then tabs count should be '3'
    And '<Market2 name>' tab should be active
    #7
    When I switch to 'Default Workspace' workspace tab
    Then 'Default Workspace' tab should be active
    When I make 'Reports' panel active
    And I select 'Position History' list
    When I complete '1'st market dropdown with value 'Buy Trade'
    Then the 'Deal ticket' panel should be visible
    And 'trade' ticket type should be 'selected'
    And trade direction should be 'buy'
    And 'quantity' input should be active
    When I close 'Deal ticket' panel
    #8
    When I make 'Reports' panel active
    And I select 'Position History' list
    And I complete '1'st market dropdown with value 'Sell Trade'
    Then the 'Deal ticket' panel should be visible
    And 'trade' ticket type should be 'selected'
    And trade direction should be 'sell'
    And 'quantity' input should be active
    When I close 'Deal ticket' panel
    And I make 'Reports' panel active
    And I move panel to the 'top-left' corner
    And I close 'Chart' panel
    #9
    When I make 'Reports' panel active
    And I select 'Position History' list
    When I complete '1'st market dropdown with value 'Chart'
    Then the 'Chart' panel should be visible
    And the header of 'Chart' panel is '<Market2 name>'
    When I close 'Chart' panel
    #10
    And I close 'Reports' panel
    When I add new 'Reports' panel in 'Default Workspace' tab
    And I move panel to the 'top-right' corner
    Then the 'Reports' panel should be visible
    And I am on the 'Position History' list
    # "...Additional scrollbars do not appear, " is not automated
    When I make 'Reports' panel active
    And I resize panel with:
      | height | 200  |
    Then panel should be not scrolled vertically
    When I scroll to '4'th 'market' in the panel
    Then panel should be scrolled vertically
    When I resize panel with:
      | width  | 600  |
    Then panel should be not scrolled horizontally
    When I scroll to 'realised p&l column' inside 'position history list' in the panel
    Then panel should be scrolled horizontally
    #11
    When I make 'Reports' panel active
    And I select 'More History' list
    Then 'More History' item should be active
    And 'More History' list should be visible

    Examples:
      | Market1 name  | Market2 name  | Direction | Quantity  | Account type |
      | AUD/USD       | EUR/CHF       | Buy       | 1000      | CFD          |

#    =================================================================================================================================
#                                                    Functional smoke
#                                                            |
#                                                        Regression
#    =================================================================================================================================

  @EUR/USD @positions-history-list-main-functionality
  Scenario: Positions history list main functionality
    Then the 'Positions And Orders' panel should be visible
    When I add position with parameters:
      | MarketName | EUR/USD |
      | Direction  | Sell    |
      | Quantity   | 1000    |
    And I select 'Position History' list
    Then 'Position History' item should be active
    And I delete 'Position' 'EUR/USD'
    And 'Position History' list should be visible
    And 'Position History' panel table header should contain:
      | columnName     |
      | DATE/TIME      |
      | POSITION       |
      | POSITION PRICE |
      | REALISED P&L   |
    When I hover '2'nd position
    And I click on 'dropdown arrow' in the '2'nd position
    Then the options from expanded dropdown should be:
      | Past position details                      |
      | Market 360 Chart, news, market information |
      | Buy Trade                                  |
      | Sell Trade                                 |
      | Chart                                      |
    When I select 'Past position details' in dropdown menu in '2'nd market
    Then the 'History Detail' panel should be visible
    When I close panel
    Then the 'Positions And Orders' panel should be visible
    And I am on the 'Position History' list
    When I complete '2'nd market dropdown with value 'Market 360 Chart, news, market information'
    Then tabs count should be '3'
    And 'EUR/USD' tab should be active

  @EUR/USD @GBP/USD-DFT @position-history-data-check
  Scenario Outline: Position history data check
    Then the 'Positions And Orders' panel should be visible
    When I add position with parameters:
      | MarketName | <Market name> |
      | Direction  | <Direction>   |
      | Quantity   | <Quantity>    |
    And I select 'Position History' list
    Then 'Position History' item should be active
    And 'Position History' list should be visible
    And I delete 'Position' '<Market name>'
    And I wait for '2000'
    And I get 'Position' History for '<Account type>'
    Then Position History '1'st table row with cell 'name' should contain correct 'MarketName' data
    And Position History '1'st table row with cell 'date' should contain correct 'ExecutedDateTimeUtc' data
    And Position History '1'st table row with cell 'quantity' should contain correct 'OriginalQuantity' data
    And Position History '1'st table row with cell 'price' should contain correct 'Price' data
    And Position History '1'st table row with cell 'realised profit/loss' should contain correct 'RealisedPnl' data
    When I complete '1'st market dropdown with value 'Past position details'
    Then the 'History Detail' panel should be visible
    And market name should be 'correct'
    And 'Order ID' row should contain correct 'OrderId' data form history
    And 'Currency' row should contain correct 'Currency' data form history
    And 'Date entered' row should contain correct 'ExecutedDateTimeUtc' data form history
    And 'Status' history row should contain 'Closed' word

    Examples:
      | Market name     | Direction | Quantity  | Account type |
      | EUR/USD         | Buy       | 1000      | CFD          |
      | GBP/USD DFT     | Sell      | 1         | DFT          |
