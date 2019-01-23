@orders
Feature: Orders
  As a user
  I can open Positions And Orders panel and manage Orders list
  So all functionality of Orders list should work fine

  Background:
    Given I am logged in to the application with default state

  @functional-smoke @regression @default-resize-window @active-orders-short @wt-1340-v10
  Scenario: Active orders [short]
    #1
    # 'Positions And Orders' changes to 'Orders' after 1.23
    Then the 'Positions And Orders' panel should be visible
    When I select 'Orders' list
    Then 'Orders' item should be active
    #2
    When I add order with parameters:
      | MarketName | GBP/USD |
      | Direction  | Sell    |
      | Quantity   | 1000    |
      | Price      | 100     |
    Then the 'previously added' order should be present on the list
    #3
    And the 'previously added' market should be colored correctly
    # next step includes direction and quantity assertion
    And the 'previously added' order 'quantity' cell should contain 'correct' data
    And the 'previously added' order 'order price' cell should contain 'correct' data
    And the 'previously added' order current price cell should change with time
    And the 'previously added' order 'stop price' cell should contain 'set' word
    And the 'previously added' order 'limit price' cell should contain 'set' word
    And the 'previously added' order 'delete' cell should contain 'Delete' word
    #4
    And I add order with parameters:
      | MarketName | EUR/CHF |
      | Direction  | Sell    |
      | Quantity   | 1000    |
      | Price      | 100     |
    Then the 'previously added' order should be present on the list
    And orders should be sorted by market name in alphabetical order
    And I add order with parameters:
      | MarketName | AUD/USD |
      | Direction  | Sell    |
      | Quantity   | 1000    |
      | Price      | 100     |
    Then the 'previously added' order should be present on the list
    And orders should be sorted by market name in alphabetical order
    When I delete 'order' 'EUR/CHF'
    When I delete 'order' 'AUD/USD'
    #5
    And I make 'Positions And Orders' panel active
    And the '1'st order 'order price' cell should be rounded correctly
    And the '1'st order 'current price' cell should be rounded correctly
    #6
    When I add order with parameters:
      | MarketName | GBP/USD |
      | Direction  | Sell    |
      | Quantity   | 1000    |
      | Price      | 100     |
    Then '2' 'previously added' orders should be on the list
    When I delete 'order' 'GBP/USD'
    #7
    When I add order with parameters:
      | MarketName | GBP/USD |
      | Direction  | Buy     |
      | Quantity   | 1000    |
      | Price      | 100     |
    When I add order with parameters:
      | MarketName | GBP/USD |
      | Direction  | Buy     |
      | Quantity   | 1000    |
      | Price      | 100     |
    Then '2' 'previously added' orders should be on the list
    When I delete 'order' 'GBP/USD'
    #8
    When I add order with parameters:
      | MarketName | GBP/USD |
      | Direction  | Sell    |
      | Quantity   | 1000    |
      | Price      | 100     |
    When I add order with parameters:
      | MarketName | GBP/USD |
      | Direction  | Buy     |
      | Quantity   | 1000    |
      | Price      | 100     |
    Then '2' 'previously added' orders should be on the list
    When I delete 'order' 'GBP/USD'
     #9
    When I add order with parameters:
      | MarketName | GBP/USD   |
      | Direction  | Sell      |
      | Quantity   | 1000      |
      | Price      | 100       |
    Then the 'previously added' order should be present on the list
    And I make 'Watchlist' panel active
    And I expand 'Popular Markets' watchlist
    And I click on 'sell' in the 'current' market
    And I remember min valid quantity for 'current' market
    Then the 'Deal ticket' panel should be visible
    When I switch to 'order' tab
    # oco order
    When I fill main 'order price' with value 'current sell * 1.5'
    And I fill main 'quantity' with value 'min valid*1'
    Then 'submit button' element should be enabled
    When I click on 'oco' link
    Then 'submit button' element should be disabled
    When I click on 'oco sell label' element
    And I fill oco 'order price' with value 'current sell * 0.5'
    And I fill oco 'quantity' with value 'min valid*1'
    And 'submit button' element should be enabled
    When I click on 'submit' button
    Then 'oco order' confirmation message should be correct
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
    And the 'Positions And Orders' panel should be visible
    And I make 'Positions And Orders' panel active
    And I am on the 'Orders' list
    Then '3' 'current' orders should be on the list
    #10, 11
    When I click on 'delete' in the '1'st order
    And the '1'st market's order columns should be visible:
      | delete confirm |
      | delete cancel  |
    And I click on 'delete cancel' in the '1'st order
    Then '3' 'current' orders should be on the list
    And the 'current' order 'stop price' cell should contain 'set' word
    And the 'current' order 'limit price' cell should contain 'set' word
    And the 'current' order 'delete' cell should contain 'Delete' word
    #12
    When I click on 'delete' in the '1'st order
    And I click on 'delete confirm' in the '1'st order
    Then '2' 'current' orders should be on the list
    When I click on 'delete' in the '1'st order
    And I click on 'delete confirm' in the '1'st order
    Then '1' 'current' orders should be on the list
    When I click on 'delete' in the '1'st order
    And I click on 'delete confirm' in the '1'st order
    Then the 'current' market should be not present on the list
    #13
    When I add order with parameters:
      | MarketName | GBP/USD   |
      | Direction  | Sell      |
      | Quantity   | 1000      |
      | Price      | 100       |
    Then the 'previously added' order should be present on the list
    When I click on 'stop price' in the 'previously added' market
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'edit order'
    When I close 'Deal ticket' panel
    And I make 'Positions And Orders' panel active
    Then I am on the 'Orders' list
    When I click on 'limit price' in the 'previously added' market
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'edit order'
    When I close 'Deal ticket' panel
    #14
    And I make 'Positions And Orders' panel active
    Then I am on the 'Orders' list
    When I click on 'edit icon' in the 'previously added' market
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'edit order'
    When I close 'Deal ticket' panel
    #15
    And I make 'Positions And Orders' panel active
    Then I am on the 'Orders' list
    When I click on 'order price' in the 'previously added' market
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'edit order'
    When I close 'Deal ticket' panel
    #16
    And I make 'Positions And Orders' panel active
    Then I am on the 'Orders' list
    When I click on 'dropdown arrow' in the 'previously added' market
    Then the options from expanded dropdown should be:
      | Set Price Alert                            |
      | Edit Order                                 |
      | Order details                              |
      | Market 360 Chart, news, market information |
      | Buy Trade                                  |
      | Sell Trade                                 |
      | Chart                                      |
    #17
    When I select 'Set price alert' in dropdown menu in 'previously added' market
    Then the 'Deal ticket' panel should be visible
    And 'set alert' ticket type should be 'selected'
    When I close 'Deal ticket' panel
    #18
    And I make 'Positions And Orders' panel active
    Then I am on the 'Orders' list
    When I complete 'previously added' market dropdown with value 'Edit Order'
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'edit order'
    When I close 'Deal ticket' panel
    #19
    And I make 'Positions And Orders' panel active
    Then I am on the 'Orders' list
    When I complete 'previously added' market dropdown with value 'Order details'
    Then the 'Details' panel should be visible
    And market name should be 'correct'
    And 'Stop' row should contain 'Set' word
    And 'Limit' row should contain 'Set' word
    And 'Good 'til' row should contain 'Cancelled' word
    And 'Date changed' row should contain correct date
    And 'Order ID' row should contain correct ID
    And 'Status' row should contain 'Accepted' word
    And 'Currency' row should contain 'USD' word
    When I close 'Details' panel
    #19 Expiry option - UNSTABLE
    #When I click on Search input
    #Then Search modal should be visible
    #When I wait for markets loading
    #And I fill search field with value 'put Spread'
    #And I wait for markets loading
    #When I find opened market from the Search modal
    #And I click on 'ask price' in the 'current' market within Search Modal
    #And I remember min valid quantity for 'current' market
    #Then the 'Deal ticket' panel should be visible
    #When I switch to 'order' tab
    #And I click on 'advancedTicket' link
    #And I fill 'current market' price with value not between current prices on 'buy'
    #And I fill 'quantity' with value 'min valid+1'
    #And I expand 'good till dropdown link' dropdown
    #And I select 'GTD' from expanded dropdown
    #And I click on 'submit' button
    #When I click on 'ok' button
    #Then the 'Deal ticket' panel should be invisible
    #When I make 'Positions And Orders' panel active
    #And I select 'Orders' list
    #Then the 'previously added' market should be present on the list
    #And I complete 'previously added' market dropdown with value 'Order details'
    #Then the 'Details' panel should be visible
    #And Expiry row should be set
    # functionality is not implemented - https://jira.gaincapital.com/browse/TPDWT-16593
    # And 'Auto Roll' row should contain 'OFF' data
    #When I close 'Details' panel
    #When I delete 'order' 'current market'
    #20
    And I make 'Positions And Orders' panel active
    Then I am on the 'Orders' list
    And I complete '1'st market dropdown with value 'Market 360 chart, news, market information'
    Then 'GBP/USD' tab should be active
    #21
    When I switch to 'Default Workspace' workspace tab
    Then 'Default Workspace' tab should be active
    And the 'Positions And Orders' panel should be visible
    And I am on the 'Orders' list
    When I complete 'previously added' market dropdown with value 'Buy Trade'
    Then the 'Deal ticket' panel should be visible
    And 'trade' ticket type should be 'selected'
    And trade direction should be 'buy'
    And 'quantity' input should be active
    When I close 'Deal ticket' panel
    #22
    And I make 'Positions And Orders' panel active
    Then I am on the 'Orders' list
    When I complete 'previously added' market dropdown with value 'Sell Trade'
    Then the 'Deal ticket' panel should be visible
    And 'trade' ticket type should be 'selected'
    And trade direction should be 'sell'
    And 'quantity' input should be active
    When I close 'Deal ticket' panel
    #23
    And I close 'Chart' panel
    And I make 'Positions And Orders' panel active
    Then I am on the 'Orders' list
    When I complete 'previously added' market dropdown with value 'Chart'
    Then the 'Chart' panel should be visible
    And the header of 'Chart' panel is 'GBP/USD'
    When I close 'Chart' panel
    #24
    And I make 'Positions And Orders' panel active
    When I select 'Orders' list
    Then 'Orders' item should be active
    # "...Additional scrollbars do not appear, " is not automated
    When I resize panel with:
      | height | 100  |
    Then panel should be not scrolled vertically
    When I add order with parameters:
      | MarketName | GBP/USD   |
      | Direction  | Sell      |
      | Quantity   | 1000      |
      | Price      | 100       |
    Then the 'previously added' market should be present on the list
    When I add order with parameters:
      | MarketName | GBP/USD   |
      | Direction  | Sell      |
      | Quantity   | 1000      |
      | Price      | 100       |
    Then the 'previously added' market should be present on the list
    Then '3' 'previously added' orders should be on the list
    And I add order with parameters:
      | MarketName | EUR/CHF |
      | Direction  | Sell    |
      | Quantity   | 1000    |
      | Price      | 100     |
    Then the 'previously added' market should be present on the list
    And I add order with parameters:
      | MarketName | AUD/USD |
      | Direction  | Sell    |
      | Quantity   | 1000    |
      | Price      | 100     |
    Then the 'previously added' market should be present on the list
    When I scroll to '3'rd 'market' in the panel
    Then panel should be scrolled vertically
    When I resize panel with:
      | width  | 150  |
    Then panel should be not scrolled horizontally
    When I scroll to 'limit tab column' inside 'orders list' in the panel
    Then panel should be scrolled horizontally

#    =================================================================================================================================
#                                                    Functional smoke
#                                                            |
#                                                        Regression
#    =================================================================================================================================

  @GBP/USD @active-orders
  Scenario: Active orders
    Then the 'Positions And Orders' panel should be visible
    When I select 'Orders' list
    Then 'Orders' item should be active
    When I add order with parameters:
      | MarketName | GBP/USD |
      | Direction  | Buy     |
      | Quantity   | 1000    |
      | Price      | 100     |
    Then the 'previously added' order should be present on the list
    And the 'previously added' order 'quantity' cell should contain 'correct' data
    And the 'previously added' order 'order price' cell should contain 'correct' data
    And the 'previously added' order current price cell should change with time
    And the 'previously added' order 'stop price' cell should contain 'set' word
    And the 'previously added' order 'limit price' cell should contain 'set' word
    And the 'previously added' order 'delete' cell should contain 'Delete' word
    When I close 'Positions And Orders' panel
    And I add new 'Positions And Orders' panel in 'Default Workspace' tab
    And I select 'Orders' list
    Then the 'previously added' order should be present on the list
    And the 'previously added' order 'quantity' cell should contain 'correct' data
    And the 'previously added' order 'order price' cell should contain 'correct' data
    When I click on 'stop price' in the 'previously added' market
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'edit order'
    When I close 'Deal ticket' panel
    And I make 'Positions And Orders' panel active
    Then I am on the 'Orders' list
    When I click on 'limit price' in the 'previously added' market
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'edit order'
    When I close 'Deal ticket' panel
    And I make 'Positions And Orders' panel active
    Then I am on the 'Orders' list
    When I click on 'edit icon' in the 'previously added' market
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'edit order'
    When I close 'Deal ticket' panel
    And I make 'Positions And Orders' panel active
    Then I am on the 'Orders' list
    When I click on 'order price' in the 'previously added' market
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'edit order'
    When I close 'Deal ticket' panel
    And I make 'Positions And Orders' panel active
    Then I am on the 'Orders' list
    When I click on 'dropdown arrow' in the 'previously added' market
    Then the options from expanded dropdown should be:
      | Set Price Alert                            |
      | Edit Order                                 |
      | Order details                              |
      | Market 360 Chart, news, market information |
      | Buy Trade                                  |
      | Sell Trade                                 |
      | Chart                                      |
    When I select 'Set price alert' in dropdown menu in 'previously added' market
    Then the 'Deal ticket' panel should be visible
    And 'set alert' ticket type should be 'selected'
    When I close 'Deal ticket' panel
    And I make 'Positions And Orders' panel active
    Then I am on the 'Orders' list
    When I complete 'previously added' market dropdown with value 'Edit Order'
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'edit order'
    When I close 'Deal ticket' panel
    And I make 'Positions And Orders' panel active
    Then I am on the 'Orders' list
    When I complete 'previously added' market dropdown with value 'Order details'
    Then the 'Details' panel should be visible
    And market name should be 'correct'
    And 'Stop' row should contain 'Set' word
    And 'Limit' row should contain 'Set' word
    And 'Good 'til' row should contain 'Cancelled' word
    And 'Date changed' row should contain correct date
    And 'Order ID' row should contain correct ID
    And 'Status' row should contain 'Accepted' word
    And 'Currency' row should contain 'USD' word
    When I close 'Details' panel
    And I make 'Positions And Orders' panel active
    Then I am on the 'Orders' list
    When I complete 'previously added' market dropdown with value 'Market 360 chart, news, market information'
    Then 'GBP/USD' tab should be active
    When I switch to 'Default Workspace' workspace tab
    Then 'Default Workspace' tab should be active
    And the 'Positions And Orders' panel should be visible
    And I am on the 'Orders' list
    When I complete 'previously added' market dropdown with value 'Buy Trade'
    Then the 'Deal ticket' panel should be visible
    And 'trade' ticket type should be 'selected'
    And trade direction should be 'buy'
    And 'quantity' input should be active
    When I close 'Deal ticket' panel
    And I make 'Positions And Orders' panel active
    Then I am on the 'Orders' list
    When I complete 'previously added' market dropdown with value 'Sell Trade'
    Then the 'Deal ticket' panel should be visible
    And 'trade' ticket type should be 'selected'
    And trade direction should be 'sell'
    And 'quantity' input should be active
    When I close 'Deal ticket' panel
    And I close 'Chart' panel
    And I make 'Positions And Orders' panel active
    Then I am on the 'Orders' list
    When I complete 'previously added' market dropdown with value 'Chart'
    Then the 'Chart' panel should be visible
    And the header of 'Chart' panel is 'GBP/USD'
    When I close 'Chart' panel
    And I make 'Positions And Orders' panel active
    Then I am on the 'Orders' list
    And '1' 'previously added' order should be on the list
    When I add order with parameters:
      | MarketName | GBP/USD |
      | Direction  | Buy     |
      | Quantity   | 1000    |
      | Price      | 100     |
    Then '2' 'previously added' orders should be on the list
    When I add order with parameters:
      | MarketName | GBP/USD |
      | Direction  | Sell    |
      | Quantity   | 1000    |
      | Price      | 100     |
    Then '3' 'previously added' orders should be on the list
    When I add order with parameters:
      | MarketName | GBP/USD |
      | Direction  | Sell    |
      | Quantity   | 1000    |
      | Price      | 100     |
    Then '4' 'previously added' orders should be on the list
    When I click on 'delete' in the '1'st order
    And I click on 'delete cancel' in the '1'st order
    Then '4' 'previously added' orders should be on the list
    When I click on 'delete' in the '1'st order
    And I click on 'delete confirm' in the '1'st order
    Then '3' 'previously added' orders should be on the list
    # OCO order for the market tested in Place Sell/Buy OCO order with stop/limit - CFD/Spread markets

  @EUR/USD @orders-list-main-functionality @ignore
  Scenario: Orders list main functionality
    When I add new tab
    And I add new 'Positions And Orders' panel in 'New workspace 2' tab
    And I resize panel with:
      | height | 600 |
      | width  | 800 |
    And I select 'Orders' list
    And I add order with parameters:
      | MarketName | EUR/USD |
      | Direction  | Sell    |
      | Quantity   | 1000    |
      | Price      | 100     |
    Then the 'previously added' order should be present on the list
    And the 'previously added' order should be 'black' when it is 'hovered'
    And the 'previously added' order should be 'white' when it is 'not hovered'
    And the 'previously added' order should be colored correctly
    And the 'previously added' order 'quantity' cell should contain 'correct' data
    And the 'previously added' order 'order price' cell should contain 'correct' data
    And the 'previously added' order current price cell should change with time
    And the 'previously added' order 'stop price' cell should contain 'set' word
    And the 'previously added' order 'limit price' cell should contain 'set' word
    When I hover 'previously added' order
    Then the 'current' order 'dropdown arrow' should be visible
    When I click on 'dropdown arrow' in the 'current' order
    Then the options from expanded dropdown should be:
      | Edit Order                                 |
      | Set price alert                            |
      | Order details                              |
      | Market 360 Chart, news, market information |
    When I click on 'dropdown arrow' in the 'current' order
    When I complete 'previously added' order dropdown with value 'edit order'
    Then the 'Deal ticket' panel should be visible
    When I close panel
    And I make 'Positions And Orders' panel active
    Then I am on the 'Orders' list
    When I click on 'delete' in the 'previously added' order
    And I click on 'delete confirm' in the 'previously added' order
    And I make 'Positions And Orders' panel active
    And I am on the 'Orders' list
    Then the 'previously added' order should be not present on the list

  @GBP/USD @orders-details-panel @ignore
  Scenario: Orders details panel
    Then the 'Positions And Orders' panel should be visible
    When I select 'Orders' list
    And I add order with parameters:
      | MarketName | GBP/USD |
      | Direction  | Buy     |
      | Quantity   | 1000    |
      | Price      | 100     |
    Then the 'previously added' order should be present on the list
    When I complete 'previously added' market dropdown with value 'order details'
    Then the 'Details' panel should be visible
    And market name should be 'correct'
    And 'Stop' row should contain 'Set' word
    And 'Limit' row should contain 'Set' word
    And 'Good 'til' row should contain 'Cancelled' word
    And 'Date changed' row should contain correct date
    And 'Order ID' row should contain correct ID
    And 'Status' row should contain 'Accepted' word
    And 'Currency' row should contain 'USD' word
    When I click on the value of 'Stop' row
    Then the 'Deal ticket' panel should be visible
    When I close panel
    Then the 'Details' panel should be visible
    When I click on the value of 'Limit' row
    Then the 'Deal ticket' panel should be visible

  @EUR/USD @orders-stop/limit-functionality @ignore
  Scenario: Orders Stop/Limit functionality
    Then the 'Positions And Orders' panel should be visible
    And I select 'Orders' list
    And I add order with parameters:
      | MarketName | EUR/USD |
      | Direction  | Buy     |
      | Quantity   | 1000    |
      | Price      | 100     |
    Then the 'previously added' order should be present on the list
    When I click on 'stop price' in the 'previously added' market
    Then the 'Deal ticket' panel should be visible
    When I check 'Stop' checkbox
    And I fill the '1'st normal stop linked order 'price' with value 'sell*1.01' in the 'current market'
    And I submit the form
    Then the 'Positions And Orders' panel should be visible
    And I am on the 'Orders' list
    And the 'previously added' market 'stop price' should contain correct data
    And the 'previously added' market 'limit price' cell should contain 'set' word
    When I click on 'limit price' in the 'previously added' market
    Then the 'Deal ticket' panel should be visible
    When I check 'Limit' checkbox
    And I uncheck 'Stop' checkbox
    And I fill the '2'nd limit linked order 'price' with value '101' in the 'current market'
    And I submit the form
    Then the 'Positions And Orders' panel should be visible
    And I am on the 'Orders' list
    And the 'previously added' market 'stop price' cell should contain 'set' word
    And the 'previously added' market 'limit price' should contain correct data

  @EUR/CHF @amalgamated-orders @ignore
  Scenario: Amalgamated orders
    Then the 'Positions And Orders' panel should be visible
    And I select 'Orders' list
    And I add order with parameters:
      | MarketName | EUR/CHF |
      | Direction  | Buy     |
      | Quantity   | 1000    |
      | Price      | 100     |
    And I add order with parameters:
      | MarketName | EUR/CHF |
      | Direction  | Buy     |
      | Quantity   | 2000    |
      | Price      | 120     |
    And I wait for '500'
    Then the 'previously added' order should be present on the list
    And the 'previously added' market should be displayed as 'multi'
    When I expand 'previously added' multi-market
    Then the 'previously added' multi-market should be 'expanded'
    And the 'previously added' market's sub-markets count should be '2'
    And the 'previously added' market 'quantity' cell should contain 'buy 3000' data
    And the 'previously added' market 'stop price' cell should contain 'multiple' word
    And the 'previously added' market 'limit price' cell should contain 'multiple' word
    And the 'previously added' market's sub-market 1 'quantity' cell should contain 'buy 1000' data
    And the 'previously added' market's sub-market 2 'quantity' cell should contain 'buy 2000' data
    And the 'previously added' market's sub-market 1 'order price' cell should contain '100' data
    And the 'previously added' market's sub-market 2 'order price' cell should contain '120' data
    And the 'previously added' market's sub-market 1 'stop price' cell should contain 'Set' word
    And the 'previously added' market's sub-market 1 'limit price' cell should contain 'Set' word
    And the 'previously added' market's sub-market 2 'stop price' cell should contain 'Set' word
    And the 'previously added' market's sub-market 2 'limit price' cell should contain 'Set' word
    And I add order with parameters:
      | MarketName | EUR/CHF |
      | Direction  | Buy     |
      | Quantity   | 3000    |
      | Price      | 150     |
    And I wait for '500'
    Then the 'previously added' multi-market should be 'expanded'
    And the 'previously added' market's sub-markets count should be '3'
    And the 'previously added' market's sub-market 3 'quantity' cell should contain 'buy 3000' data
    And the 'previously added' market's sub-market 3 'order price' cell should contain '150' data
    And I add order with parameters:
      | MarketName | EUR/CHF |
      | Direction  | Sell    |
      | Quantity   | 4000    |
      | Price      | 160     |
    And I wait for '500'
    Then the 'previously added' multi-market should be 'expanded'
    And the 'previously added' market's sub-markets count should be '4'
    And the 'previously added' market's sub-market 4 'quantity' cell should contain 'sell 4000' data
    And the 'previously added' market's sub-market 4 'order price' cell should contain '160' data
    And the 'previously added' market 'quantity' cell should contain 'buy 2000' data
