@order-history
Feature: Order History
  As a user
  I can open Order History panel
  So all functionality of Order history panel should work as described

  Background:
    Given I am logged in to the application with default state

  @functional-smoke @regression @default-resize-window @orders-history-short @wt-1344-v9
  Scenario Outline: Order history [short]
    #1
    # for triggering orders it's necessary some mocks
    Then the 'Positions And Orders' panel should be visible
    When I select 'Orders' list
    Then 'Orders' item should be active
    And I add order with parameters:
      | MarketName | <Market1 name> |
      | Direction  | <Direction>    |
      | Quantity   | <Quantity>     |
      | Price      | <Price>        |
    Then the 'previously added' order should be present on the list
    And I wait for '2000'
    And I add order with parameters:
      | MarketName | <Market1 name> |
      | Direction  | <Direction>    |
      | Quantity   | <Quantity>     |
      | Price      | <Price>        |
    Then '2' 'previously added' orders should be on the list
    And I delete 'Order' '<Market1 name>'
    And I wait for '2000'
    When I add new 'Reports' panel in 'Default Workspace' tab
    And I move panel to the 'top-right' corner
    Then the 'Reports' panel should be visible
    And I select 'Order History' list
    Then 'Order History' item should be active
    And 'Order History' list should be visible
    And the '1'st market 'name' cell should contain '<Market1 name>' word
    And the '2'nd market 'name' cell should contain '<Market1 name>' word
    #2
    When I make 'Positions And Orders' panel active
    And I select 'Orders' list
    And I add order with parameters:
      | MarketName | <Market2 name> |
      | Direction  | <Direction>    |
      | Quantity   | <Quantity>     |
      | Price      | <Price>        |
    Then the 'previously added' order should be present on the list
    And I delete 'Order' '<Market2 name>'
    And I wait for '2000'
    When I make 'Reports' panel active
    Then the 'Reports' panel should be visible
    And I select 'Order History' list
    Then 'Order History' item should be active
    And 'Order History' list should be visible
    Then 'Order History' panel table header should contain:
      | columnName  |
      | DATE/TIME   |
      | ORDER       |
      | ORDER PRICE |
      | GOOD 'TIL   |
      | STATUS      |
      | LAST EDIT   |
    #3 "..All fields show accurate values and not rounded. - included values' assertion"
    When I get 'Order' History for '<Account type>'
    Then Order History '1'st table row with cell 'name' should contain correct 'MarketName' data
    Then Order History '1'st table row with cell 'date' should contain correct 'CreatedDateTimeUtc' data
    Then Order History '1'st table row with cell 'quantity' should contain correct 'OriginalQuantity' data
    Then Order History '1'st table row with cell 'price' should contain correct 'TriggerPrice' data
    Then Order History '1'st table row with cell 'type' should contain correct 'OrderApplicabilityId' data
    Then Order History '1'st table row with cell 'status' should contain correct 'StatusId' data
    Then Order History '1'st table row with cell 'last-edit' should contain correct 'LastChangedDateTimeUtc' data
    #4
    When I switch off test execution in 'firefox'
    When I perform right click on 'name' in the '1'st market
    Then the options from expanded dropdown should be:
      | Past order details                         |
      | Market 360 Chart, news, market information |
      | Buy Trade                                  |
      | Sell Trade                                 |
      | Chart                                      |
    When I switch on test execution in 'firefox'
    And I select 'Position History' list
    And I select 'Order History' list
    And I hover '1'st position
    And I click on 'dropdown arrow' in the '1'st order
    Then the options from expanded dropdown should be:
      | Past order details                         |
      | Market 360 Chart, news, market information |
      | Buy Trade                                  |
      | Sell Trade                                 |
      | Chart                                      |
    #5
    When I select 'Past order details' in dropdown menu in '<Market2 name>' market
    Then the 'History Detail' panel should be visible
    And market name should be 'correct'
    Then 'Order ID' row should contain correct 'OrderId' data form history
    Then 'Currency' row should contain correct 'Currency' data form history
    Then 'Trade price' row should contain correct 'TriggerPrice' data form history
    When I close panel
    #6
    When I make 'Reports' panel active
    And I select 'Order History' list
    When I complete '1'st market dropdown with value 'Market 360 Chart, news, market information'
    Then tabs count should be '3'
    And '<Market2 name>' tab should be active
    #7
    When I switch to 'Default Workspace' workspace tab
    Then 'Default Workspace' tab should be active
    Then the 'Positions And Orders' panel should be visible
    And I make 'Positions And Orders' panel active
    When I make 'Reports' panel active
    And I select 'Order History' list
    When I complete '1'st market dropdown with value 'Buy Trade'
    Then the 'Deal ticket' panel should be visible
    And 'trade' ticket type should be 'selected'
    And trade direction should be 'buy'
    And 'quantity' input should be active
    When I close 'Deal ticket' panel
    #8
    When I make 'Reports' panel active
    And I select 'Order History' list
    When I complete '1'st market dropdown with value 'Sell Trade'
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
    And I select 'Order History' list
    When I complete '1'st market dropdown with value 'Chart'
    Then the 'Chart' panel should be visible
    And the header of 'Chart' panel is '<Market2 name>'
    When I close 'Chart' panel
    #10
    And I close 'Reports' panel
    When I add new 'Reports' panel in 'Default Workspace' tab
    And I move panel to the 'top-right' corner
    Then the 'Reports' panel should be visible
    And I am on the 'Order History' list
    # "...Additional scrollbars do not appear, " is not automated
    When I make 'Reports' panel active
    And I resize panel with:
      | height | 100  |
    Then panel should be not scrolled vertically
    When I scroll to '3'rd 'market' in the panel
    Then panel should be scrolled vertically
    When I resize panel with:
      | width  | 600  |
    Then panel should be not scrolled horizontally
    When I scroll to 'last edit column' inside 'order history list' in the panel
    Then panel should be scrolled horizontally

    Examples:
      | Market1 name  | Market2 name  | Direction | Quantity  | Price | Account type |
      | EUR/CHF       | AUD/USD       | Sell      | 1000      | 100   | CFD          |

#    =================================================================================================================================
#                                                    Functional smoke
#                                                            |
#                                                        Regression
#    =================================================================================================================================

  @EUR/USD @orders-history-list-main-functionality
  Scenario: Orders history list main functionality
    Then the 'Positions And Orders' panel should be visible
    When I add order with parameters:
      | MarketName | EUR/USD |
      | Direction  | Sell    |
      | Quantity   | 1000    |
      | Price      | 100     |
    And I select 'Orders' list
    Then the 'EUR/USD' order should be present on the list
    When I delete 'Order' 'EUR/USD'
    And I select 'Order History' list
    Then 'Order History' item should be active
    And 'Order History' list should be visible
    Then 'Order History' panel table header should contain:
      | columnName  |
      | DATE/TIME   |
      | ORDER       |
      | ORDER PRICE |
      | GOOD 'TIL   |
      | STATUS      |
      | LAST EDIT   |
    When I hover 'previously added' order
    When I click on 'dropdown arrow' in the 'current' order
    Then the options from expanded dropdown should be:
      | Past order details                         |
      | Market 360 Chart, news, market information |
      | Buy Trade                                  |
      | Sell Trade                                 |
      | Chart                                      |

    When I select 'Past order details' in dropdown menu in 'current' market
    Then the 'History Detail' panel should be visible
    When I close panel
    Then the 'Positions And Orders' panel should be visible
    And I am on the 'Order History' list
    When I complete 'previously added' market dropdown with value 'Market 360 Chart, news, market information'
    Then tabs count should be '3'
    And 'EUR/USD' tab should be active

  @EUR/USD @GBP/USD-DFT @order-history-data-check
  Scenario Outline: Order history data check
    Then the 'Positions And Orders' panel should be visible
    And I add order with parameters:
      | MarketName | <Market name> |
      | Direction  | <Direction>   |
      | Quantity   | <Quantity>    |
      | Price      | <Price>       |
    And I delete 'Order' '<Market name>'
    And I select 'Order History' list
    When I get 'Order' History for '<Account type>'
    Then Order History '1'st table row with cell 'name' should contain correct 'MarketName' data
    Then Order History '1'st table row with cell 'date' should contain correct 'CreatedDateTimeUtc' data
    Then Order History '1'st table row with cell 'quantity' should contain correct 'OriginalQuantity' data
    Then Order History '1'st table row with cell 'price' should contain correct 'TriggerPrice' data
    Then Order History '1'st table row with cell 'type' should contain correct 'OrderApplicabilityId' data
    Then Order History '1'st table row with cell 'status' should contain correct 'StatusId' data
    Then Order History '1'st table row with cell 'last-edit' should contain correct 'LastChangedDateTimeUtc' data
    And I complete '1'st market dropdown with value 'Past order details'
    Then the 'History Detail' panel should be visible
    And market name should be 'correct'
    Then 'Order ID' row should contain correct 'OrderId' data form history
    Then 'Currency' row should contain correct 'Currency' data form history
    Then 'Trade price' row should contain correct 'TriggerPrice' data form history

    Examples:
      | Market name    | Direction | Quantity  | Price | Account type |
      | GBP/USD DFT    | Sell      | 1         | 3     | DFT          |
      | EUR/USD        | Buy       | 1000      | 100   | CFD          |

