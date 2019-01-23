@positions
Feature: Positions
  As a user
  I can open Positions And Orders panel and manage Positions list
  So all functionality of Positions list should work fine

  Background:
    Given I am logged in to the application with default state

  @functional-smoke @regression @default-resize-window @open-positions-short @wt-1339-v15
  Scenario Outline: Open positions [short]
    #1, 2
    # after 1.23 Positions wiil be separate component
    # replace 'Positions And Orders' with 'Positions'
    Then the 'Positions And Orders' panel should be visible
    When I add position with parameters:
      | MarketName | <Market name> |
      | Direction  | <Direction>   |
      | Quantity   | <Quantity>    |
    And the 'previously added' market should be present on the list
    And the 'previously added' market columns should be visible:
      | position        |
      | unrealised      |
      | pip/point pl    |
      | opening price   |
      | current price   |
      | stop price      |
      | limit price     |
      | close           |
     #3
    And the 'previously added' market should be colored correctly
    # next step includes direction and quantity assertion
    And the 'previously added' market 'position' cell should contain 'correct' data
    # Next step could fail related with bug https://jira.gaincapital.com/browse/TPDWT-13054
    And the 'previously added' market 'unrealised' cell should contain 'correct' data
    And the 'previously added' market 'pip/point pl' cell should contain 'correct' data
    And the 'previously added' market 'opening price' should be correct
    And the 'previously added' market current price cell should change with time
    And the 'previously added' market 'stop price' cell should contain 'set' word
    And the 'previously added' market 'limit price' cell should contain 'set' word
    And the 'previously added' market 'close' cell should contain 'Close' word
    #4
    And the '1'st position 'unrealised' cell should be rounded correctly
    And the '1'st position 'pip/point pl' cell should be rounded correctly
    And the '1'st position 'opening price' cell should be rounded correctly
    And the '1'st position 'current price' cell should be rounded correctly
    #5
    When I add position with parameters:
      | MarketName | <Market name> |
      | Direction  | <Direction>   |
      | Quantity   | <Quantity>    |
    And I wait for '500'
    Then the 'previously added' market should be present on the list
    And the 'previously added' market should be displayed as 'multi'
    And the 'previously added' market 'stop price' cell should contain '' data
    And the 'previously added' market 'limit price' cell should contain '' data
    #6
    When I expand 'previously added' multi-market
    Then the 'previously added' multi-market should be 'expanded'
    And the 'previously added' market's sub-markets count should be '2'
    #7
    When I click on 'close' in the '1'st multi-market's '1'st sub-market
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'amend position'
    And 'close' radiobutton should be 'selected'
    And 'close quantity' input should be predefined with '1000'
    And close info message should be correct
    When I close 'Deal ticket' panel
    And I make 'Positions And Orders' panel active
    #8
    And I click on 'stop price' in the '1'st multi-market's '1'st sub-market
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'amend position'
    And 'edit' radiobutton should be 'selected'
    And 'submit button' element text should be 'Update Position'
    When I close 'Deal ticket' panel
    And I make 'Positions And Orders' panel active
    And I click on 'limit price' in the '1'st multi-market's '1'st sub-market
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'amend position'
    And 'edit' radiobutton should be 'selected'
    And 'submit button' element text should be 'Update Position'
    When I close 'Deal ticket' panel
    And I make 'Positions And Orders' panel active
    When I click on 'close' in the 'previously added' market
    Then the 'Deal ticket' panel should be visible
    When I click on 'submit' button
    When I click on 'ok' button after waiting
    #9
    When I add position with parameters:
      | MarketName | <Market name> |
      | Direction  | <Direction>   |
      | Quantity   | <Quantity>    |
    And I make 'Positions And Orders' panel active
    Then the 'previously added' market should be present on the list
    And I click on 'dropdown arrow' in the 'previously added' market
    Then the options from expanded dropdown should be:
      | Set Price Alert                            |
      | Amend Position                             |
      | Position details                           |
      | Market 360 Chart, news, market information |
      | Buy Trade                                  |
      | Sell Trade                                 |
      | Chart                                      |
    #10
    When I select 'Set price alert' in dropdown menu in 'previously added' market
    Then the 'Deal ticket' panel should be visible
    And 'set alert' ticket type should be 'selected'
    When I close 'Deal ticket' panel
    #11
    And I make 'Positions And Orders' panel active
    And I complete 'previously added' market dropdown with value 'Amend Position'
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'amend position'
    And 'edit' radiobutton should be 'selected'
    When I close 'Deal ticket' panel
    #12
    And I make 'Positions And Orders' panel active
    And I complete 'previously added' market dropdown with value 'Position details'
    Then the 'Details' panel should be visible
    And market name should be 'correct'
    And 'Opening Price' row should contain 'correct' data
    And 'Stop' row should contain 'Set' word
    And 'Limit' row should contain 'Set' word
    # https://jira.gaincapital.com/browse/TPDWT-12050 - sometimes Margin Requirement is still not set
    #And 'Margin Requirement' row should contain 'correct' data
    And 'Date opened' row should contain correct date
    And 'Order ID' row should contain correct ID for trade
    And 'Status' row should contain 'Open' word
    When I close 'Details' panel
    #12 Expiry Autoroll - UNSTABLE
    #When I click on Search input
    #Then Search modal should be visible
    #When I wait for markets loading
    #And I fill search field with value 'put Spread'
    #And I wait for markets loading
    #When I find opened market from the Search modal
    #And I click on 'ask price' in the 'current' market within Search Modal
    #And I remember min valid quantity for 'current' market
    #Then the 'Deal ticket' panel should be visible
    #And I click on 'advancedTicket' link
    #When I fill 'quantity' with value 'min valid+1'
    #And I check 'stop' checkbox
    #When I fill the '1'st normal stop linked order 'quantity' with value 'min valid+1'
    #And I fill the '1'st normal stop linked order 'price' with computed value 'sell*0.89' in the 'current market'
    #And I expand '1'st applicability dropdown
    #And I select 'Good 'til end of day (GTD)' from expanded dropdown
    #And I click on 'submit' button after waiting
    #When I click on 'ok' button after waiting
    #Then the 'Deal ticket' panel should be invisible
    #When I make 'Positions And Orders' panel active
    #Then the 'previously added' market should be present on the list
    #And I complete 'previously added' market dropdown with value 'Position details'
    #Then the 'Details' panel should be visible
    #And Expiry row should be set
    #And 'Auto Roll' row should contain 'OFF' data
    #When I close 'Details' panel
    #When I delete 'order' 'current market'
    #13
    And I make 'Positions And Orders' panel active
    And I complete '1'st market dropdown with value 'Market 360 chart, news, market information'
    Then '<Market name>' tab should be active
    #14
    When I switch to 'Default Workspace' workspace tab
    And the 'Positions And Orders' panel should be visible
    When I complete 'previously added' market dropdown with value 'Buy Trade'
    Then the 'Deal ticket' panel should be visible
    And 'trade' ticket type should be 'selected'
    And trade direction should be 'buy'
    And 'quantity' input should be active
    When I close 'Deal ticket' panel
    #15
    And I make 'Positions And Orders' panel active
    And I complete 'previously added' market dropdown with value 'Sell Trade'
    Then the 'Deal ticket' panel should be visible
    And 'trade' ticket type should be 'selected'
    And trade direction should be 'sell'
    And 'quantity' input should be active
    When I close 'Deal ticket' panel
    #16
    And I close 'Chart' panel
    And I make 'Positions And Orders' panel active
    And I complete 'previously added' market dropdown with value 'Chart'
    Then the 'Chart' panel should be visible
    And the header of 'Chart' panel is '<Market name>'
    When I close 'Chart' panel
    #17
    And I make 'Positions And Orders' panel active
    # "...Additional scrollbars do not appear, " is not automated
    When I resize panel with:
      | height | 100  |
    Then panel should be not scrolled vertically
    When I add position with parameters:
      | MarketName | <Market name> |
      | Direction  | <Direction>   |
      | Quantity   | <Quantity>    |
    Then the 'previously added' market should be present on the list
    When I add position with parameters:
      | MarketName | <Market name> |
      | Direction  | <Direction>   |
      | Quantity   | <Quantity>    |
    And I wait for '500'
    Then the 'previously added' market should be present on the list
    When I expand 'previously added' multi-market
    And I scroll to 'name' in the '1'st multi-market's '3'rd sub-market
    Then panel should be scrolled vertically
    When I resize panel with:
      | width  | 600  |
    Then panel should be not scrolled horizontally
    When I scroll to 'limit tab column' inside 'positions list' in the panel
    Then panel should be scrolled horizontally
    When I scroll to 'market name column' inside 'positions list' in the panel
    Then panel should be not scrolled horizontally

    Examples:
     | Market name  | Direction | Quantity  |
     | AUD/USD      | Buy       | 1000      |

#    =================================================================================================================================
#                                                    Functional smoke
#                                                            |
#                                                        Regression
#    =================================================================================================================================

  @AUD/USD @open-positions
  Scenario: Open positions
    Then the 'Positions And Orders' panel should be visible
    When I add position with parameters:
      | MarketName | AUD/USD |
      | Direction  | Buy     |
      | Quantity   | 1000    |
    Then the 'previously added' market should be present on the list
    And the 'previously added' market should be colored correctly
    And the 'previously added' market 'position' cell should contain 'correct' data
    And the 'previously added' market 'opening price' should be correct
    And the 'previously added' market current price cell should change with time
    And the 'previously added' market 'stop price' cell should contain 'set' word
    And the 'previously added' market 'limit price' cell should contain 'set' word
    And the 'previously added' market 'close' cell should contain 'Close' word
    When I close 'Positions And Orders' panel
    And I add new 'Positions And Orders' panel in 'Default Workspace' tab
    Then the 'Positions And Orders' panel should be visible
    And the 'previously added' market 'position' cell should contain 'correct' data
    And the 'previously added' market 'opening price' should be correct
    When I click on 'close' in the 'previously added' market
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'amend position'
    And 'close' radiobutton should be 'selected'
    And 'close quantity' input should be predefined with '1000'
    And close info message should be correct
    When I close 'Deal ticket' panel
    And I make 'Positions And Orders' panel active
    And I click on 'stop price' in the 'previously added' market
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'amend position'
    And 'edit' radiobutton should be 'selected'
    And 'submit button' element text should be 'Update Position'
    When I close 'Deal ticket' panel
    And I make 'Positions And Orders' panel active
    And I click on 'limit price' in the 'previously added' market
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'amend position'
    And 'edit' radiobutton should be 'selected'
    And 'submit button' element text should be 'Update Position'
    When I close 'Deal ticket' panel
    And I make 'Positions And Orders' panel active
    And I click on 'dropdown arrow' in the 'previously added' market
    Then the options from expanded dropdown should be:
      | Set Price Alert                            |
      | Amend Position                             |
      | Position details                           |
      | Market 360 Chart, news, market information |
      | Buy Trade                                  |
      | Sell Trade                                 |
      | Chart                                      |
    When I select 'Set price alert' in dropdown menu in 'previously added' market
    Then the 'Deal ticket' panel should be visible
    And 'set alert' ticket type should be 'selected'
    When I close 'Deal ticket' panel
    And I make 'Positions And Orders' panel active
    And I complete 'previously added' market dropdown with value 'Amend Position'
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'amend position'
    And 'close' radiobutton should be 'selected'
    When I close 'Deal ticket' panel
    And I make 'Positions And Orders' panel active
    And I complete 'previously added' market dropdown with value 'Position details'
    Then the 'Details' panel should be visible
    And market name should be 'correct'
    And 'Stop' row should contain 'Set' word
    And 'Limit' row should contain 'Set' word
    # https://jira.gaincapital.com/browse/TPDWT-12050
    # sometimes Margin Requirement is still not set
    And 'Margin Requirement' row should contain 'correct' data
    # Date is shown in 24H format
    # And 'Date opened' row should contain correct date
    And 'Order ID' row should contain correct ID for trade
    And 'Status' row should contain 'Open' word
    When I close 'Details' panel
    And I make 'Positions And Orders' panel active
    And I complete 'previously added' market dropdown with value 'Market 360 chart, news, market information'
    Then 'AUD/USD' tab should be active
    When I switch to 'Default Workspace' workspace tab
    Then 'Default Workspace' tab should be active
    And the 'Positions And Orders' panel should be visible
    When I complete 'previously added' market dropdown with value 'Buy Trade'
    Then the 'Deal ticket' panel should be visible
    And 'trade' ticket type should be 'selected'
    And trade direction should be 'buy'
    And 'quantity' input should be active
    When I close 'Deal ticket' panel
    And I make 'Positions And Orders' panel active
    And I complete 'previously added' market dropdown with value 'Sell Trade'
    Then the 'Deal ticket' panel should be visible
    And 'trade' ticket type should be 'selected'
    And trade direction should be 'sell'
    And 'quantity' input should be active
    When I close 'Deal ticket' panel
    And I close 'Chart' panel
    And I make 'Positions And Orders' panel active
    And I complete 'previously added' market dropdown with value 'Chart'
    Then the 'Chart' panel should be visible
    And the header of 'Chart' panel is 'AUD/USD'
    When I close 'Chart' panel
    And I make 'Positions And Orders' panel active
    And I add position with parameters:
      | MarketName | AUD/USD |
      | Direction  | Buy     |
      | Quantity   | 1000    |
    Then the 'previously added' market should be displayed as 'multi'
    And the 'previously added' market 'stop price' cell should contain '' word
    And the 'previously added' market 'limit price' cell should contain '' word
    When I expand 'previously added' multi-market
    Then the 'previously added' multi-market should be 'expanded'
    And the 'previously added' market's sub-markets count should be '2'

  @EUR/USD @positions-list-main-functionality @ignore
  Scenario: Positions list main functionality
    When I add new tab
    And I add new 'Positions And Orders' panel in 'New workspace 2' tab
    And I resize panel with:
      | height | 600  |
      | width  | 800  |
    And I add position with parameters:
      | MarketName | EUR/USD |
      | Direction  | Sell    |
      | Quantity   | 1000    |
    Then the 'previously added' market should be present on the list
    And the 'previously added' market should be 'black' when it is 'hovered'
    And the 'previously added' market should be 'white' when it is 'not hovered'
    And the 'previously added' market should be colored correctly
    And the 'previously added' market unrealised cell should be visible and colored correctly
    And the 'previously added' market 'position' cell should contain 'correct' data
    And the 'previously added' market 'opening price' should be correct
    And the 'previously added' market current price cell should change with time
    And the 'previously added' market 'stop price' cell should contain 'set' word
    And the 'previously added' market 'limit price' cell should contain 'set' word
    When I click on 'delete' in the 'EUR/USD' market
    Then the 'Deal ticket' panel should be visible
    And 'close' radiobutton should be 'selected'
    And 'close quantity' input should be predefined with '1000'
    And close info message should be correct
    When I click on 'submit' button
    Then 'confirmation' element text should be 'Trade Executed'
    And 'market name' element text should be 'EUR/USD'
    And confirmation message should be correct
    When I click on 'ok' button
    Then the 'Positions And Orders' panel should be visible
    And the 'previously added' market should be not present on the list

  @AUD/USD @positions-stop/limit-functionality @ignore
  Scenario: Positions Stop/Limit functionality
    Then the 'Positions And Orders' panel should be visible
    When I add position with parameters:
      | MarketName | AUD/USD |
      | Direction  | Buy     |
      | Quantity   | 1000    |
    Then the 'previously added' market should be present on the list
    And the 'previously added' market 'stop price' cell should contain 'set' word
    And the 'previously added' market 'limit price' cell should contain 'set' word
    When I click on 'stop price' in the 'previously added' market
    Then the 'Deal ticket' panel should be visible
    When I check 'Stop' checkbox
    And I fill the '1'st normal stop linked order 'price' with value 'sell*0.99'
    And I submit the form
    Then the 'Positions And Orders' panel should be visible
    And the 'previously added' market 'stop price' should contain correct data
    And the 'previously added' market 'limit price' cell should contain 'set' word
    When I click on 'limit price' in the 'previously added' market
    Then the 'Deal ticket' panel should be visible
    When I check 'Limit' checkbox
    And I uncheck 'Stop' checkbox
    And I fill the '2'nd limit linked order 'price' with value 'sell*1.01'
    And I submit the form
    Then the 'Positions And Orders' panel should be visible
    And the 'previously added' market 'stop price' cell should contain 'set' word
    And the 'previously added' market 'limit price' should contain correct data

  @EUR/USD @USD/JPY @positions-list-market-drop-down-menu @ignore
  Scenario: Positions list market Drop down menu
    Then the 'Positions And Orders' panel should be visible
    When I add position with parameters:
      | MarketName | EUR/USD |
      | Direction  | Sell    |
      | Quantity   | 1000    |
    Then the 'previously added' market should be present on the list
    When I add position with parameters:
      | MarketName | USD/JPY |
      | Direction  | Sell    |
      | Quantity   | 1000    |
    Then the 'previously added' market should be present on the list
    And I hover '1'st market
    Then the 'current' market 'dropdown arrow' should be visible
    When I click on 'dropdown arrow' in the 'current' market
    Then the options from expanded dropdown should be:
      | Set Price Alert                            |
      | Amend Position                             |
      | Position details                           |
      | Market 360 Chart, news, market information |
      | Buy Trade                                  |
      | Sell Trade                                 |
      | Chart                                      |
    When I select 'Amend Position' in dropdown menu in 'current' market
    Then the 'Deal ticket' panel should be visible
    When I close panel
    Then the 'Positions And Orders' panel should be visible
    When I complete 'current' market dropdown with value 'Market 360 chart, news, market information'
    Then tabs count should be '3'
    And 'EUR/USD' tab should be active
    When I switch to 'Default Workspace' workspace tab
    Then 'Default Workspace' tab should be active
    And the 'Positions And Orders' panel should be visible
    And I complete '2'nd market dropdown with value 'Market 360 chart, news, market information'
    Then 'USD/JPY' tab should be active

  @EUR/CHF @amalgamated-positions @ignore
  Scenario: Amalgamated positions
    Then the 'Positions And Orders' panel should be visible
    And I add position with parameters:
      | MarketName | EUR/CHF |
      | Direction  | Sell    |
      | Quantity   | 1000    |
    And I add position with parameters:
      | MarketName | EUR/CHF |
      | Direction  | Sell    |
      | Quantity   | 1000    |
    And I wait for '500'
    Then the 'previously added' market should be present on the list
    And the 'previously added' market should be displayed as 'multi'
    And the 'previously added' market 'position' cell should contain 'sell 2000' data
    When I expand 'previously added' multi-market
    Then the 'previously added' multi-market should be 'expanded'
    And the 'previously added' market's sub-markets count should be '2'
    And the 'previously added' market's sub-market 1 'unrealised' cell should contain 'GBP' data
    And the 'previously added' multi-market opening price should be average for opening prices of sub-markets
#    And the 'previously added' market 'stop price' cell should contain 'multiple' word
#    And the 'previously added' market 'limit price' cell should contain 'multiple' word
    And the 'previously added' market's '1'st sub-market should be black when it is hovered and other sub-markets should be white
    And the 'previously added' market columns should be visible:
      | position        |
      | unrealised      |
      | opening price   |
      | current price   |
      | stop price      |
      | limit price     |
      | delete          |
    And the 'previously added' market's sub-markets columns should be visible:
      | position        |
      | unrealised      |
      | opening price   |
      | current price   |
      | stop price      |
      | limit price     |
      | delete          |
    And I add position with parameters:
      | MarketName | EUR/CHF |
      | Direction  | Sell    |
      | Quantity   | 2000    |
    And I wait for '500'
    Then the 'previously added' market 'position' cell should contain 'sell 4000' data
    And the 'previously added' market's sub-markets count should be '3'
    And the 'previously added' market's sub-market 1 'unrealised' cell should contain 'GBP' data
    And the 'previously added' multi-market opening price should be average for opening prices of sub-markets
    And I add position with parameters:
      | MarketName | EUR/CHF |
      | Direction  | Buy     |
      | Quantity   | 1000    |
    And I wait for '500'
    Then the 'previously added' market 'position' cell should contain 'sell 3000' data
    And the 'previously added' market's sub-markets count should be '2'
    And the 'previously added' market's sub-market 1 'unrealised' cell should contain 'GBP' data
    And the 'previously added' multi-market opening price should be average for opening prices of sub-markets
    And I add position with parameters:
      | MarketName | EUR/CHF |
      | Direction  | Buy     |
      | Quantity   | 4000    |
    And I wait for '500'
    Then the 'previously added' market 'position' cell should contain 'buy 1000' data
    And the 'previously added' market should be displayed as 'single'
    And the 'previously added' market's sub-markets count should be '0'
    And the 'previously added' market 'unrealised' cell should contain 'GBP' data
    And the 'previously added' multi-market opening price should be average for opening prices of sub-markets
    And I add position with parameters:
      |MarketName | EUR/CHF |
      |Direction  | Buy     |
      |Quantity   | 2000    |
    And I wait for '500'
    Then the 'previously added' market 'position' cell should contain 'buy 3000' data
    And the 'previously added' market should be displayed as 'multi'
    When I expand 'previously added' multi-market
    Then the 'previously added' market's sub-markets count should be '2'
    And the 'previously added' market's sub-market 1 'unrealised' cell should contain 'GBP' data
    And the 'previously added' multi-market opening price should be average for opening prices of sub-markets
    When I collapse 'previously added' multi-market
    Then the 'previously added' multi-market should be 'collapsed'
