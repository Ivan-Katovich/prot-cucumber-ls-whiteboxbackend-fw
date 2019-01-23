@tradeticket
Feature: Trade Ticket panel
  As a user
  I can open trade ticket panel
  So all functionality should work fine for the panel

  Background:
    Given I am logged in to the application with default state

  @functional-smoke @regression @one-click-trading-buy/sell-create/edit/close-spread-market @one-click-trading @wt-1510-v4
  Scenario Outline: One-Click Trading: Buy/Sell - Create/Edit/Close SPREAD Market
    #1
    When I enable one click trading
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I find <Market type> market
    And I click on 'buy' in the 'current' market
    And I remember min valid quantity for 'current' market
    And I remember max valid quantity for 'current' market
    Then the 'Deal ticket' panel should be visible
    #2
    # Then max allowed symbols in 'quantity' field should be '15'
    When I fill 'quantity' with value '<Quantity>'
    And I check 'stop' checkbox
    And I fill the '1'st normal stop linked order 'pips' with value '<Pips>' in the 'current market'
    And I check 'limit' checkbox
    And I fill the '2'nd limit linked order 'pips' with value '<Pips>' in the 'current market'
    And I click on 'submit' button
    And I click on 'ok' button
    And I make 'Positions And Orders' panel active
    Then the 'previously added' market should be present on the list
    #3
    When I make 'Watchlist' panel active
    And I fill 1-click 'quantity' with value '<Quantity>' for the 'current' market
    And I click on 'buy' in the 'current' market
    Then open trade confirmation message should be displayed correctly
    #4
    When I make 'Watchlist' panel active
    And I fill 1-click 'quantity' with value '<Quantity>' for the 'current' market
    And I fill 1-click 'quantity' with value '<New Quantity>' for the 'current' market
    And I click on 'buy' in the 'current' market
    When I make 'Positions And Orders' panel active
    Then the 'previously added' market should be present on the list
    And the 'previously added' market should be displayed as 'multi'
    When I expand 'previously added' multi-market
    Then the 'previously added' multi-market should be 'expanded'
    And the 'previously added' market's sub-markets count should be '3'
    #5
    When I make 'Watchlist' panel active
    When I fill 1-click 'quantity' with value '<Quantity>' for the 'current' market
    When I disable one click trading
    Then 1-click 'quantity' field should be removed
    When I enable one click trading
    Then 1-click 'quantity' field for the 'current' market should be filled with '<New Quantity>'
    #6
    When I make 'Positions And Orders' panel active
    And I click on 'dropdown arrow' in the 'current' multi-market's '1'st sub-market
    And I select 'Amend Position' in dropdown menu in 'current' market
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'amend position'
    #7
    When I fill 'close quantity' with value 'half of available'
    Then partially close info message should be correct
    And I click on 'submit' button
    Then 'confirmation' element text should be 'Trade executed'
    And partially close confirmation message should be correct
    When I click on 'ok' button
    #8
    And I make 'Positions And Orders' panel active
    And the 'Positions And Orders' panel should be visible
    And I click on 'dropdown arrow' in the 'current' multi-market's '1'st sub-market
    And I select 'Amend Position' in dropdown menu in 'current' market
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'amend position'
    And 'edit' radiobutton should be 'selected'
    When I fill the '1'st normal stop linked order 'pips' with value '<New Pips>' in the 'current market'
    And I fill the '2'nd limit linked order 'pips' with value '<New Pips>' in the 'current market'
    And I click on 'submit' button
    Then 'confirmation' element text should be 'Position updated'
    And 'confirmation message' element text should be 'Your order has been updated.'
    When I click on 'ok' button
    #9
    And I make 'Positions And Orders' panel active
    And I click on 'dropdown arrow' in the 'current' multi-market's '1'st sub-market
    And I select 'Amend Position' in dropdown menu in 'current' market
    Then the 'Deal ticket' panel should be visible
    When I click on 'closeRadio' button
    And I click on 'submit' button
    Then 'confirmation' element text should be 'Trade executed'
    Then close info message should be correct
    When I click on 'ok' button
    And I make 'Positions And Orders' panel active
    Then the 'previously added' market should be present on the list
    And the 'previously added' market's sub-markets count should be '2'

    Examples:
      | Market type | Quantity    | New Quantity | Pips | New Pips |
      | Spread      | min valid*2 | min valid*1  | 100  | 110      |

  @functional-smoke @regression @stop-price-validation @wt-148-v6
  Scenario: Stop Price Validation
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I click on 'buy' in the 'GBP/USD DFT' market
    Then the 'Deal ticket' panel should be visible
    When I remember min valid quantity for 'current' market
    And I fill 'quantity' with value 'min valid+1'
    And I check 'stop' checkbox
    And I fill the '1'st normal stop linked order 'price' with value 'sell*1.01' in the 'current market'
    Then 'buy' 'current market' main '1'st stop price validation should be correct and should not appear for '500'ms
    And the '1'st normal stop order 'price border' element should have red color
    And the '1'st normal stop order 'points border' element should have red color
    And the '1'st normal stop order 'p/l border' element should have red color
    And 'submit button' element text should be 'stop level too high'
    When I fill the '1'st normal stop linked order 'price' with value 'sell*0.99' in the 'current market'
    Then 'submit button' element text should be 'Place Trade'
    When I click on 'sell' label
    And I fill the '1'st normal stop linked order 'price' with value 'buy*0.99' in the 'current market'
    Then 'sell' 'current market' main '1'st stop price validation should be correct and should not appear for '500'ms
    And the '1'st normal stop order 'price border' element should have red color
    And the '1'st normal stop order 'points border' element should have red color
    And the '1'st normal stop order 'p/l border' element should have red color
    And 'submit button' element text should be 'stop level too low'
    When I fill the '1'st normal stop linked order 'price' with value 'buy*1.01' in the 'current market'
    Then 'submit button' element text should be 'Place Trade'
    When I close panel
    And I make 'Watchlist' panel active
    And I expand 'Popular Markets' watchlist
    And I click on 'sell' in the 'GBP/USD DFT' market
    Then the 'Deal ticket' panel should be visible
    When I fill 'quantity' with value 'min valid+1'
    And I check 'stop' checkbox
    And I fill the '1'st normal stop linked order 'price' with value 'buy*1.001' in the 'current market'
    Then 'submit button' element text should be 'Place Trade'
    When I modify the '1'st normal stop linked order filled 'price' by typing 'ARROW_DOWN' key until the price will be below 'buy*0.999' in the 'current market'
    And 'sell' 'current market' main '1'st stop price validation should be correct
    And the '1'st normal stop order 'price border' element should have red color
    And the '1'st normal stop order 'points border' element should have red color
    And the '1'st normal stop order 'p/l border' element should have red color
    And 'submit button' element text should be 'stop level too low'
    When I click on 'buy' label
    And I fill the '1'st normal stop linked order 'price' with value 'sell*0.999' in the 'current market'
    Then 'submit button' element text should be 'Place Trade'
    When I modify the '1'st normal stop linked order filled 'price' by typing 'ARROW_UP' key until the price will be above 'sell*1.001' in the 'current market'
    Then 'buy' 'current market' main '1'st stop price validation should be correct
    And the '1'st normal stop order 'price border' element should have red color
    And the '1'st normal stop order 'points border' element should have red color
    And the '1'st normal stop order 'p/l border' element should have red color
    And 'submit button' element text should be 'stop level too high'

  @functional-smoke @regression @limit-price-validation @wt-150-v6
  Scenario: Limit Price Validation
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I click on 'buy' in the 'GBP/USD DFT' market
    Then the 'Deal ticket' panel should be visible
    When I remember min valid quantity for 'current' market
    And I fill 'quantity' with value 'min valid+1'
    And I check 'Limit' checkbox
    And I fill the '2'nd limit linked order 'price' with value 'sell*0.99' in the 'current market'
    Then 'buy' 'current market' main '2'nd limit price validation should be correct and should not appear for '500'ms
    And the '2'nd limit order 'price border' element should have red color
    And the '2'nd limit order 'points border' element should have red color
    And the '2'nd limit order 'p/l border' element should have red color
    And 'submit button' element text should be 'limit level too low'
    When I fill the '2'nd limit linked order 'price' with value 'sell*1.01' in the 'current market'
    Then 'submit button' element text should be 'Place Trade'
    When I click on 'sell' label
    And I fill the '2'nd limit linked order 'price' with value 'buy*1.01' in the 'current market'
    Then 'sell' 'current market' main '2'nd limit price validation should be correct and should not appear for '500'ms
    And the '2'nd limit order 'price border' element should have red color
    And the '2'nd limit order 'points border' element should have red color
    And the '2'nd limit order 'p/l border' element should have red color
    And 'submit button' element text should be 'limit level too high'
    When I fill the '2'nd limit linked order 'price' with value 'buy*0.99' in the 'current market'
    Then 'submit button' element text should be 'Place Trade'
    When I close panel
    And I make 'Watchlist' panel active
    And I expand 'Popular Markets' watchlist
    And I click on 'sell' in the 'GBP/USD DFT' market
    Then the 'Deal ticket' panel should be visible
    When I fill 'quantity' with value 'min valid+1'
    And I check 'Limit' checkbox
    And I fill the '2'nd limit linked order 'price' with value 'buy*0.999' in the 'current market'
    Then 'submit button' element text should be 'Place Trade'
    When I modify the '2'nd limit linked order filled 'price' by typing 'ARROW_UP' key until the price will be above 'buy*1.001' in the 'current market'
    And 'sell' 'current market' main '2'nd limit price validation should be correct
    And the '2'nd limit order 'price border' element should have red color
    And the '2'nd limit order 'points border' element should have red color
    And the '2'nd limit order 'p/l border' element should have red color
    And 'submit button' element text should be 'limit level too high'
    When I click on 'buy' label
    And I fill the '2'nd limit linked order 'price' with value 'sell*1.001' in the 'current market'
    Then 'submit button' element text should be 'Place Trade'
    When I modify the '2'nd limit linked order filled 'price' by typing 'ARROW_DOWN' key until the price will be below 'sell*0.999' in the 'current market'
    Then 'buy' 'current market' main '2'nd limit price validation should be correct
    And the '2'nd limit order 'price border' element should have red color
    And the '2'nd limit order 'points border' element should have red color
    And the '2'nd limit order 'p/l border' element should have red color
    And 'submit button' element text should be 'limit level too low'


  @functional-smoke @regression @stop-and-limit-view @wt-152-v4
  Scenario: Stop and Limit view
    Then the 'Watchlist' panel should be visible
    And markets of 'Popular Markets' watchlist should be visible
    When I click on 'buy' in the 'USD/JPY' market
    Then the 'Deal ticket' panel should be visible
    And 'trade' ticket type should be 'selected'
    When I check 'stop' checkbox
    And I check 'limit' checkbox
    Then the '1'st normal stop order should contain fields:
      | itemName               |
      | checkbox               |
      | dropdown               |
      | price                  |
      | pips/points            |
      | p/l                    |
      | p/l currency indicator |
    And the '2'nd limit order should contain fields:
      | itemName               |
      | checkbox               |
      | label                  |
      | price                  |
      | pips/points            |
      | p/l                    |
      | p/l currency indicator |
    When I expand '1'st linked order types dropdown
    Then the options from expanded dropdown should be:
      | Stop |
      | Trailing |
    When I click on 'advancedTicket' link
    Then the '1'st normal stop order should contain fields:
      | itemName               |
      | checkbox               |
      | dropdown               |
      | quantity               |
      | price                  |
      | pips/points            |
      | p/l                    |
      | p/l currency indicator |
      | applicability          |
    And the '2'nd limit order should contain fields:
      | itemName               |
      | checkbox               |
      | label                  |
      | quantity               |
      | price                  |
      | pips/points            |
      | p/l                    |
      | p/l currency indicator |
      | applicability          |
    And the trade ticket standard view panel should contain items:
      | itemName             |
      | add stop limit dropdown link |
    When I switch to 'order' tab
    And I check 'stop' checkbox
    And I check 'limit' checkbox
    Then the '1'st normal stop order should contain fields:
      | itemName               |
      | checkbox               |
      | dropdown               |
      | price                  |
      | pips/points            |
      | p/l                    |
      | p/l currency indicator |
    And the '2'nd limit order should contain fields:
      | itemName               |
      | checkbox               |
      | label                  |
      | price                  |
      | pips/points            |
      | p/l                    |
      | p/l currency indicator |
    When I expand '1'st linked order types dropdown
    Then the options from expanded dropdown should be:
      | Stop |
      | Trailing |
    When I click on 'advancedTicket' link
    Then the '1'st normal stop order should contain fields:
      | itemName               |
      | checkbox               |
      | dropdown               |
      | quantity               |
      | price                  |
      | pips/points            |
      | p/l                    |
      | p/l currency indicator |
      | applicability          |
    And the '2'nd limit order should contain fields:
      | itemName               |
      | checkbox               |
      | label                  |
      | quantity               |
      | price                  |
      | pips/points            |
      | p/l                    |
      | p/l currency indicator |
      | applicability          |
    And the trade ticket standard view panel should contain items:
      | itemName                     |
      | add stop limit dropdown link |


  @functional-smoke @regression @hedge-buy-sell @wt-127-v2 @debug
  Scenario Outline: Hedge - Buy/Sell
    And I add position with parameters:
      | MarketName       | <Market name> |
      | Direction        | <Direction>   |
      | Quantity         | <Start qty>   |
      | PositionMethodId | 1             |
    Then the 'Positions And Orders' panel should be visible
    Then the 'previously added' market should be present on the list
    Then the 'previously added' market 'position' cell should contain '<Direction> <Start qty>' data
    And I add position with parameters:
      | MarketName       | <Market name>        |
      | Direction        | <Opposite direction> |
      | Quantity         | <Low qty>            |
      | PositionMethodId | 1                    |
    Then the 'Positions And Orders' panel should be visible
    Then '1' 'previously added' order should be on the list
    Then the 'previously added' market 'position' cell should contain '<Direction> <First result qty>' data
    And I add position with parameters:
      | MarketName       | <Market name>        |
      | Direction        | <Opposite direction> |
      | Quantity         | <High qty>           |
      | PositionMethodId | 2                    |
    Then the 'Positions And Orders' panel should be visible
    Then '2' 'previously added' orders should be on the list
    Then the '1'st market 'position' cell should contain '<Direction> <First result qty>' data
    Then the '2'nd market 'position' cell should contain '<Opposite direction> <High qty>' data
    And I add position with parameters:
      | MarketName       | <Market name>        |
      | Direction        | <Opposite direction> |
      | Quantity         | <Low qty>            |
      | PositionMethodId | 1                    |
    Then the 'Positions And Orders' panel should be visible
    Then '2' 'previously added' orders should be on the list
    Then the '1'st market 'position' cell should contain '<Direction> <Second result qty>' data
    Then the '2'nd market 'position' cell should contain '<Opposite direction> <High qty>' data
    And I add position with parameters:
      | MarketName       | <Market name>        |
      | Direction        | <Opposite direction> |
      | Quantity         | <High qty>           |
      | PositionMethodId | 2                    |
    Then the 'Positions And Orders' panel should be visible
    Then '2' 'previously added' orders should be on the list
    Then the '1'st market 'position' cell should contain '<Direction> <Second result qty>' data
    And the '2'nd market 'position' cell should contain '<Opposite direction> <Amalgamated qty>' data
    When I expand '2'nd multi-market
    Then the '2'nd market's sub-markets count should be '2'
    And the '2'nd market's sub-market 1 'position' cell should contain '<Opposite direction> <High qty>' data
    And the '2'nd market's sub-market 2 'position' cell should contain '<Opposite direction> <High qty>' data

    Examples:
      | Market name | Start qty | Low qty | High qty | Direction | Opposite direction | First result qty | Second result qty | Amalgamated qty |
      | USD/JPY     | 4000      | 1000    | 2000     | buy       | sell               | 3000             | 2000              | 4000            |
      | GBP/USD DFT | 2         | 0.5     | 1        | sell      | buy                | 1.5              | 1                 | 2               |

  @functional-smoke @regression @additional-stops-and-limits-can-be-removed @wt-160-v2
  Scenario: Additional Stops and Limits can be removed
    #1
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I find Normal market with 'AllowGuaranteedOrders' property is 'true' in watchlist
    And I click on 'buy' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    When I remember min valid quantity for 'current' market
    And I fill 'quantity' with value 'min valid+1'
    #2
    And I check 'stop' checkbox
    And I fill the '1'st normal stop linked order 'price' with value 'buy*0.9' in the 'current market'
    When I store data from the '1'st normal stop linked order
    And I check 'limit' checkbox
    When I fill the '2'nd limit linked order 'price' with value 'buy*1.1' in the 'current market'
    When I store data from the '2'nd limit linked order
    And 'submit button' element should be enabled
    #3
    When I click on 'advancedTicket' link
    And the trade ticket advanced view panel should contain items:
      | itemName                     |
      | add stop limit dropdown link |
    Then the '1'st normal stop order should contain fields:
      | itemName      |
      | checkbox      |
      | dropdown      |
      | quantity      |
      | price         |
      | pips/points   |
      | p/l           |
      | applicability |
    Then 'GTC' option should be selected in '1'st applicability dropdown
    And the '2'nd limit order should contain fields:
      | itemName      |
      | checkbox      |
      | label         |
      | quantity      |
      | price         |
      | pips/points   |
      | p/l           |
      | applicability |
    Then 'GTC' option should be selected in '2'nd applicability dropdown
     #4
    When I expand 'add stop limit dropdown link' dropdown
    Then the options from expanded dropdown should be:
      | normal stop     |
      | trailing stop   |
      | guaranteed stop |
      | limit           |
    When I select 'Normal stop' from expanded dropdown
    Then the '3'rd normal stop order should contain fields:
      | itemName      |
      | trash icon    |
      | dropdown      |
      | quantity      |
      | price         |
      | pips/points   |
      | p/l           |
      | applicability |
    #5
    When I expand 'add stop limit dropdown link' dropdown
    And I select 'Limit' from expanded dropdown
    Then the '4'th limit order should contain fields:
      | itemName      |
      | trash icon    |
      | label         |
      | quantity      |
      | price         |
      | pips/points   |
      | p/l           |
      | applicability |
    #6
    When I expand 'add stop limit dropdown link' dropdown
    And I select 'Trailing stop' from expanded dropdown
    Then the '5'th trailing stop order should contain fields:
      | itemName      |
      | trash icon    |
      | dropdown      |
      | quantity      |
      | pips/points   |
      | applicability |
    #7
    When I expand 'add stop limit dropdown link' dropdown
    And I select 'Guaranteed stop' from expanded dropdown
    Then the '6'th guaranteed stop order should contain fields:
      | itemName      |
      | trash icon    |
      | dropdown      |
      | quantity      |
      | pips/points   |
      | applicability |
    And the number of linked orders should be '6'
    #8
    When I uncheck 'stop' checkbox
    And I uncheck 'limit' checkbox
    Then the '1'st normal stop linked order 'quantity' element should be disabled
    And the '1'st normal stop linked order 'price' element should be disabled
    And the '1'st normal stop linked order 'pips/points' element should be disabled
    And the '1'st normal stop linked order 'p/l' element should be disabled
    And the '2'st normal stop linked order 'quantity' element should be disabled
    And the '2'st normal stop linked order 'price' element should be disabled
    And the '2'st normal stop linked order 'pips/points' element should be disabled
    And the '2'st normal stop linked order 'p/l' element should be disabled
    #9
    When I remove '6'th guaranteed stop order
    Then the number of linked orders should be '5'
    When I remove '5'th trailing stop order
    Then the number of linked orders should be '4'
    When I remove '4'th limit order
    Then the number of linked orders should be '3'
    When I remove '3'rd normal stop order
    Then the number of linked orders should be '2'

  @functional-smoke @regression @applicability-good-till-time-for-linked-orders @wt-157-v7 @debug
  Scenario: Applicability - Good Till Time for Linked orders
    #1
    Then the 'Watchlist' panel should be visible
    # Popular Markets changed after 1.23
    And markets of 'Popular Markets' watchlist should be visible
    And I find any market
    And I click on 'buy' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    #2
    When I remember min valid quantity for 'current' market
    When I click on 'advancedTicket' link
    And I move panel to the 'top-right' corner
    And I fill 'quantity' with value 'min valid*1'
    Then 'submit button' element should be enabled
    And 'submit button' element text should be 'Place Trade'
    #3
    When I check 'stop' checkbox
    And I fill the '1'st normal stop linked order 'quantity' with value 'min valid*1' in the 'current market'
    And I fill the '1'st normal stop linked order 'price' with value 'sell*0.9' in the 'current market'
    Then the '1'st normal stop linked order 'pips/points' input should be autopopulated
    And the '1'st normal stop linked order 'p/l' input should be autopopulated
    When I check 'limit' checkbox
    And I fill the '2'nd limit linked order 'quantity' with value 'min valid*1' in the 'current market'
    And I fill the '2'nd limit linked order 'price' with value 'buy*1.1' in the 'current market'
    Then the '2'nd limit linked order 'pips/points' input should be autopopulated
    And the '2'nd limit linked order 'p/l' input should be autopopulated
    #4
    When I expand '1'st applicability dropdown
    And I select 'Good 'til time (GTT)' from expanded dropdown
    Then 'GTT' option should be selected in '1'st applicability dropdown
    And the '1'st normal stop order should contain fields:
      | itemName      |
      | date picker   |
    And the '1'st normal stop linked order date picker input should be defined with '0' minutes more than now

    When I expand '2'nd applicability dropdown
    And I select 'Good 'til time (GTT)' from expanded dropdown
    Then 'GTT' option should be selected in '2'nd applicability dropdown
    And the '2'nd limit order should contain fields:
      | itemName      |
      | date picker   |
    And the '2'nd limit linked order date picker input should be defined with '0' minutes more than now
    #5
    When I uncheck 'stop' checkbox
    And I check 'stop' checkbox
    And I expand '1'st applicability dropdown
    And I select 'Good 'til time (GTT)' from expanded dropdown
    And I uncheck 'stop' checkbox
    Then the '1'st normal stop linked order 'price' element should be disabled
    And the '1'st normal stop linked order 'pips/points' element should be disabled
    And the '1'st normal stop linked order 'p/l' element should be disabled
    And the '1'st normal stop linked order 'price' element background should be grey
    And the '1'st normal stop linked order 'pips/points' element background should be grey
    And the '1'st normal stop linked order 'p/l' element background should be grey
    And the '1'st normal stop linked order 'applicability container' element background should be grey
    Then 'GTC' option should be selected in '1'st applicability dropdown
    When I uncheck 'limit' checkbox
    And I check 'limit' checkbox
    And I expand '2'st applicability dropdown
    And I select 'Good 'til time (GTT)' from expanded dropdown
    And I uncheck 'limit' checkbox
    Then the '2'nd limit linked order 'price' element should be disabled
    And the '2'nd limit linked order 'pips/points' element should be disabled
    And the '2'nd limit linked order 'p/l' element should be disabled
    And the '2'nd limit linked order 'price' element background should be grey
    And the '2'nd limit linked order 'pips/points' element background should be grey
    And the '2'nd limit linked order 'p/l' element background should be grey
    And the '2'nd limit linked order 'applicability container' element background should be grey
    Then 'GTC' option should be selected in '2'nd applicability dropdown
    #6
    When I check 'stop' checkbox
    And I fill the '1'st normal stop linked order 'quantity' with value 'min valid*1' in the 'current market'
    And I fill the '1'st normal stop linked order 'price' with value 'sell*0.9' in the 'current market'
    Then the '1'st normal stop linked order 'pips/points' input should be autopopulated
    And the '1'st normal stop linked order 'p/l' input should be autopopulated
    When I expand '1'st applicability dropdown
    And I select 'Good 'til time (GTT)' from expanded dropdown
    Then 'GTT' option should be selected in '1'st applicability dropdown
    And the '1'st normal stop order should contain fields:
      | itemName      |
      | date picker   |
    When I check 'limit' checkbox
    And I fill the '2'nd limit linked order 'quantity' with value 'min valid*1' in the 'current market'
    And I fill the '2'nd limit linked order 'price' with value 'buy*1.1' in the 'current market'
    Then the '2'nd limit linked order 'pips/points' input should be autopopulated
    And the '2'nd limit linked order 'p/l' input should be autopopulated
    When I expand '2'nd applicability dropdown
    And I select 'Good 'til time (GTT)' from expanded dropdown
    Then 'GTT' option should be selected in '2'nd applicability dropdown
    And the '2'nd limit order should contain fields:
      | itemName      |
      | date picker   |
    #7
    When I expand '1'st date picker dropdown
    Then 'date picker' dropdown should be visible
    #8, 9
    And the '1'st normal stop linked order date picker input should be defined with '0' minutes more than now
    And 'previous month' should not be visible inside date/time picker
    And 'current day-1' should not be visible inside date/time picker
    When I add to date/time picker '2' hours and click outside
    Then the '1'st normal stop linked order date picker input should be defined with '2' hours more than now
    When I expand '2'nd date picker dropdown
    Then 'date picker' dropdown should be visible
    And the '2'nd limit linked order date picker input should be defined with '0' minutes more than now
    And 'previous month' should not be visible inside date/time picker
    And 'current day-1' should not be visible inside date/time picker
    And I click on 'minute up arrow' in date/time picker '2' times
    And I click on 'minute down arrow' in date/time picker '2' time and click outside
    Then the '2'nd limit linked order date picker input should be defined with '0' minutes more than now
    When I expand '2'nd date picker dropdown
    And I add to date/time picker '3' hours and click outside
    Then the '2'nd normal stop linked order date picker input should be defined with '3' hours more than now
    When I expand '2'nd date picker dropdown
    And I click on 'hour up arrow' in date/time picker '3' times
    And I click on 'hour down arrow' in date/time picker '1' time and click outside
    Then the '2'nd normal stop linked order date picker input should be defined with '5' hours more than now
    #10
    When I click on 'submit' button
    And I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
    #11, 12
    Then the 'Positions And Orders' panel should be visible
    And the 'previously added' market should be present on the list
    And the 'previously added' market 'stop price' cell should contain 'correct' data
    And the 'previously added' market 'limit price' cell should contain 'correct' data
    #13, 14 requires mocks
    # post
    # check the option of applicability dropdowns
    When I complete 'previously added' market dropdown with value 'Amend Position'
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'amend position'
    And 'GTT' option should be selected in '1'st applicability dropdown
    And the '1'st normal stop linked order date picker input should be defined with '2' hours more than now
    And 'GTT' option should be selected in '2'nd applicability dropdown
    And the '2'nd normal stop linked order date picker input should be defined with '5' hours more than now

#    =================================================================================================================================
#                                                    Functional smoke
#                                                            |
#                                                        Regression
#    =================================================================================================================================


  @regression @trade-ticket-standard-view @wt-142-v12
  Scenario: Trade Ticket - Standard View
    #1
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I find CFD market
    And I click on 'buy' in the 'current' market
    And I remember min valid quantity for 'current' market
    Then the 'Deal ticket' panel should be visible
    And 'trade' ticket type should be 'selected'
    And trade direction should be 'buy'
    And cursor is placed in the 'quantity' field
    #2
    And the trade ticket standard view panel should contain items:
      | itemName        |
      | trade label     |
      | order label     |
      | set alert label |
      | close label     |
    #3
    And 'market info' element text should be 'current market'
    #4
    And 'sell' price should change with time
    And 'buy' price should change with time
    And the trade ticket standard view panel should contain items:
      | itemName  |
      | buy tick  |
      | sell tick |
    #5
    # current prices are permanently streamed, checking the SAME prices in DT and other components will be unstable
    And the number of decimal places in sell price button is correct for 'current market'
    And the number of decimal places in buy price button is correct for 'current market'
    #6
    And 'sell' price should change with time
    And 'buy' price should change with time
    And 'sell' tick should be correct color
    And 'buy' tick should be correct color
    #7
    And margin calculator should contain nothing
    # necessary for 'submit' button to become colored (mentioned in test-case in 16 step)
    And I fill 'quantity' with value 'min valid+1'
    When I click on 'sell' label
    Then the 'sell' button should be 'red' when it is 'clicked'
    And the 'submit' button should be 'red'
    #8
    When I click on 'buy' label
    Then the 'buy' button should be 'blue' when it is 'clicked'
    And the 'submit' button should be 'blue'
    #9
    And 'current market' 'quantity' placeholder should be correct
    #10
    And the '1'st normal stop order should contain fields:
      | itemName    |
      | checkbox    |
      | dropdown    |
      | price       |
      | pips/points |
      | p/l         |
    And the '1'st normal stop linked order 'price' placeholder should be correct
    And the '1'st normal stop linked order 'pips/points' placeholder should be correct
    And the '1'st normal stop linked order 'p/l' placeholder should be correct
    And the 'current market' '1'st normal stop linked order p/l currency sign should be correct
    And the main '1'st normal stop linked order 'price' element background should be grey
    And the main '1'st normal stop linked order 'pips/points' element background should be grey
    And the main '1'st normal stop linked order 'p/l' element background should be grey
    # steps 11 and 12 will be below
    #13
    Then the main '1'st normal stop linked order 'price' element should be disabled
    And the main '1'st normal stop linked order 'pips/points' element should be disabled
    And the main '1'st normal stop linked order 'p/l' element should be disabled
    When I check main 'stop' checkbox
    Then the main '1'st normal stop linked order 'price' element should be enabled
    And the main '1'st normal stop linked order 'pips/points' element should be enabled
    And the main '1'st normal stop linked order 'p/l' element should be enabled
    And the main '1'st normal stop linked order 'price' element background should be white
    And the main '1'st normal stop linked order 'pips/points' element background should be white
    And the main '1'st normal stop linked order 'p/l' element background should be white
    #11
    And I expand '1'st linked order types dropdown
    Then the options from expanded dropdown should be:
      | Stop     |
      | Trailing |
    And I select 'trailing' from expanded dropdown
    And the '1'st trailing stop order should contain fields:
      | itemName    |
      | checkbox    |
      | dropdown    |
      | pips/points |
    And I expand '1'st linked order types dropdown
    And I select 'stop' from expanded dropdown
    When I uncheck main 'stop' checkbox
    #12
    And the '2'nd limit order should contain fields:
      | itemName    |
      | checkbox    |
      | label       |
      | price       |
      | pips/points |
      | p/l         |
    And the '2'nd limit linked order 'price' placeholder should be correct
    And the '2'nd limit linked order 'pips/points' placeholder should be correct
    And the '2'nd limit linked order 'p/l' placeholder should be correct
    And the 'current market' '2'nd limit linked order p/l currency sign should be correct
    And the main '2'nd limit linked order 'price' element background should be grey
    And the main '2'nd limit linked order 'pips/points' element background should be grey
    And the main '2'nd limit linked order 'p/l' element background should be grey
    #13 - look above
    #14
    Then the trade ticket standard view panel should contain items:
      | itemName                       |
      | advanced ticket link           |
      | advanced ticket double chevron |
      | hedging status                 |
    #15
    And 'hedging status' element text should be 'Hedging is OFF'
    #16, 17
    # filling quantity is done in 7 step
    Then 'submit button' element should be enabled
    And 'submit button' element text should be 'Place Trade'
    And margin calculator should contain correct information
    When I clear 'quantity' field
    And 'submit button' element should be disabled
    And 'submit button' element text should be 'Choose quantity'
    And margin calculator should contain nothing
    #18
    Then the main '1'st normal stop linked order 'price' element should be disabled
    And the main '1'st normal stop linked order 'pips/points' element should be disabled
    And the main '1'st normal stop linked order 'p/l' element should be disabled
    Then the main '2'nd limit linked order 'price' element should be disabled
    And the main '2'nd limit linked order 'pips/points' element should be disabled
    And the main '2'nd limit linked order 'p/l' element should be disabled
    When I click on the '1'st normal stop linked order 'pips/points border' field
    Then the 'stop' checkbox is checked
    Then the main '1'st normal stop linked order 'price' element should be enabled
    And the main '1'st normal stop linked order 'pips/points' element should be enabled
    And the main '1'st normal stop linked order 'p/l' element should be enabled
    When I click on the '2'nd limit linked order 'pips/points border' field
    Then the 'limit' checkbox is checked
    Then the main '2'nd limit linked order 'price' element should be enabled
    And the main '2'nd limit linked order 'pips/points' element should be enabled
    And the main '2'nd limit linked order 'p/l' element should be enabled
    #19
    When I close panel
    Then the 'Deal ticket' panel should be invisible

  @regression @open-buy/sell-position-with-stop-and-limit-cfd/spread-market @wt-115-v17 @wt-118-v11
  Scenario Outline: Open Buy/Sell Position with Stop and Limit CFD/Spread market
    #1
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I find <Market type> market
    And I click on '<Direction>' in the 'current' market
    And I remember min valid quantity for 'current' market
    Then the 'Deal ticket' panel should be visible
    And 'trade' ticket type should be 'selected'
    And trade direction should be '<Direction>'
    And cursor is placed in the 'quantity' field
    #2
    When I fill 'quantity' with value 'min valid+1'
    Then 'submit button' element text should be 'Place Trade'
    #3
    Then the main '1'st normal stop linked order 'price' element should be disabled
    And the main '1'st normal stop linked order 'pips/points' element should be disabled
    And the main '1'st normal stop linked order 'p/l' element should be disabled
    When I check main 'stop' checkbox
    Then the main '1'st normal stop linked order 'price' element should be enabled
    And the main '1'st normal stop linked order 'pips/points' element should be enabled
    And the main '1'st normal stop linked order 'p/l' element should be enabled
    #4
    When I fill the '1'st normal stop linked order 'price' with value '<Direction>*<Stop Multiplier>' in the 'current market'
    Then 'submit button' element text should be 'Place Trade'
    Then the '1'st normal stop linked order 'pips/points' input should be autopopulated
    And the '1'st normal stop linked order 'p/l' input should be autopopulated
    #5
    Then the main '2'nd limit linked order 'price' element should be disabled
    And the main '2'nd limit linked order 'pips/points' element should be disabled
    And the main '2'nd limit linked order 'p/l' element should be disabled
    When I check main 'limit' checkbox
    Then the main '2'nd limit linked order 'price' element should be enabled
    And the main '2'nd limit linked order 'pips/points' element should be enabled
    And the main '2'nd limit linked order 'p/l' element should be enabled
    #6
    When I fill the '2'nd limit linked order 'price' with value '<Direction>*<Limit Multiplier>' in the 'current market'
    Then 'submit button' element text should be 'Place Trade'
    And the '2'nd limit linked order 'pips/points' input should be autopopulated
    And the '2'nd limit linked order 'p/l' input should be autopopulated
    #7
    And 'sell' price should change with time
    And 'buy' price should change with time
    And the '1'st normal stop linked order 'p/l' input should be autopopulated
    And the '2'nd limit linked order 'p/l' input should be autopopulated
    #8, 9
    When I click on the '1'st normal stop linked order 'pips/points border' field
    When I clear the main '1'st normal stop linked order 'pips/points' input field
    Then the '1'st normal stop linked order 'price' input should be blank
    And the '1'st normal stop linked order 'pips/points' input should be blank
    And the '1'st normal stop linked order 'p/l' input should be blank
    And 'quantity' input value is 'correct'
    When I click on the '2'nd limit linked order 'pips/points border' field
    When I clear the main '2'nd limit linked order 'pips/points' input field
    Then the '2'nd limit linked order 'price' input should be blank
    And the '2'nd limit linked order 'pips/points' input should be blank
    And the '2'nd limit linked order 'p/l' input should be blank
    And 'quantity' input value is 'correct'
    #10
    When I fill the '1'st normal stop linked order 'price' with value '<Direction>*<Stop Multiplier>' in the 'current market'
    Then the '1'st normal stop linked order 'price' input should be autopopulated
    And the '1'st normal stop linked order 'pips/points' input should be autopopulated
    And the '1'st normal stop linked order 'p/l' input should be autopopulated
    When I uncheck main 'stop' checkbox
    Then the '1'st normal stop linked order 'price' input should be blank
    And the '1'st normal stop linked order 'pips/points' input should be blank
    And the '1'st normal stop linked order 'p/l' input should be blank
    Then the main '1'st normal stop linked order 'price' element should be disabled
    And the main '1'st normal stop linked order 'pips/points' element should be disabled
    And the main '1'st normal stop linked order 'p/l' element should be disabled
    And I fill the '2'nd limit linked order 'price' with value '<Direction>*<Limit Multiplier>' in the 'current market'
    Then the '2'nd limit linked order 'price' input should be autopopulated
    And the '2'nd limit linked order 'pips/points' input should be autopopulated
    And the '2'nd limit linked order 'p/l' input should be autopopulated
    When I uncheck main 'limit' checkbox
    Then the '2'nd limit linked order 'price' input should be blank
    And the '2'nd limit linked order 'pips/points' input should be blank
    And the '2'nd limit linked order 'p/l' input should be blank
    Then the main '2'nd limit linked order 'price' element should be disabled
    And the main '2'nd limit linked order 'pips/points' element should be disabled
    And the main '2'nd limit linked order 'p/l' element should be disabled
    When I check main 'stop' checkbox
    And I expand '1'st linked order types dropdown
    And I select 'trailing' from expanded dropdown
    And the '1'st trailing stop order should contain fields:
      | itemName    |
      | checkbox    |
      | dropdown    |
      | pips/points |
    When I uncheck main 'stop' checkbox
    And the '1'st trailing stop order should contain fields:
      | itemName    |
      | checkbox    |
      | dropdown    |
      | pips/points |
    When I check main 'stop' checkbox
    And I expand '1'st linked order types dropdown
    And I select 'stop' from expanded dropdown
    #11
    When I fill the '1'st normal stop linked order 'price' with value '<Direction>*<Stop Multiplier>' in the 'current market'
    When I modify the '1'st normal stop linked order filled 'price' by typing '<Arrow type>' key until the price will be <State> '<OppDirection>*0.999' in the 'current market'
    And '<Direction>' 'current market' main '1'st stop price validation should be correct
    And the '1'st normal stop order 'price border' element should have red color
    And the '1'st normal stop order 'points border' element should have red color
    And the '1'st normal stop order 'p/l border' element should have red color
    #12
    When I fill the '1'st normal stop linked order 'price' with value '<Direction>*<Stop Multiplier>' in the 'current market'
    And I check main 'limit' checkbox
    And I fill the '2'nd limit linked order 'price' with value '<Direction>*<Limit Multiplier>' in the 'current market'
    And I store data from the main '1'st normal stop linked order
    And I store data from the main '2'nd limit linked order
    And I click on 'submit' button
    # Opened Issue: https://jira.gaincapital.com/browse/TPDWT-20962
    #And the trade ticket standard view panel should contain items:
    #  | itemName  |
    #  | buy tick  |
    #  | sell tick |
    # as assertion that <Direction> button is enabled, it has no grey color
    Then the '<Direction>' button should be '<Color>'
    Then 'confirmation' element text should be 'Trade executed'
    And 'market name' element text should be 'current market'
    And open <Direction> 'current market' trade confirmation message should be correct
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
    And I make 'Positions And Orders' panel active
    And the 'previously added' market should be present on the list
    #17 - suitable to proceed with these steps
    And the 'previously added' market should be colored correctly
    # next step includes direction and quantity assertion
    And the 'previously added' market 'position' cell should contain 'correct' data
    And the previously added market stop price cell should contain previously set linked order data
    And the previously added market limit price cell should contain previously set linked order data
    #18
    And I complete 'previously added' market dropdown with value 'Amend Position'
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'amend position'
    Then the '1'st normal stop linked order 'price' input should be autopopulated
    And the main '1'st normal stop linked order 'price' input should be 'correct'
    And the main '2'nd limit linked order 'price' input should be 'correct'
    When I close 'Deal ticket' panel
    #13
    And trading account ID in activeorder responce should be the same as <Market type> account in ClientAndTradingAccount responce
    #14 - step moved to separate test - because it's unstable
    #15
    When I make 'Watchlist' panel active
    When I expand 'Popular Markets' watchlist
    And I click on '<Direction>' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    And 'trade' ticket type should be 'selected'
    And trade direction should be '<Direction>'
    Then max allowed symbols in 'quantity' field should be '15'
    When I clear 'quantity' field
    And I check main 'stop' checkbox
    And I check main 'limit' checkbox
    And max allowed symbols in the '1'st normal stop linked order 'price' should be '15'
    When I clear the '1'st normal stop linked order 'price' input field
    And max allowed symbols in the '2'nd limit linked order 'price' should be '15'
    When I clear the '2'nd limit linked order 'price' input field
    And I uncheck main 'stop' checkbox
    And I uncheck main 'limit' checkbox
    #16 - step moved to separate test - because it's unstable
    #19
    # for wt-115-v-17
    When I fill 'quantity' with value 'min valid+1'
    Then 'submit button' element text should be 'Place Trade'
    And I click on 'submit' button
    Then the main '1'st normal stop linked order 'price' element should be disabled
    And the main '1'st normal stop linked order 'pips/points' element should be disabled
    And the main '1'st normal stop linked order 'p/l' element should be disabled
    Then the main '2'nd limit linked order 'price' element should be disabled
    And the main '2'nd limit linked order 'pips/points' element should be disabled
    And the main '2'nd limit linked order 'p/l' element should be disabled
    When I click on the '1'st normal stop linked order 'pips/points border' field
    When I click on the '2'nd limit linked order 'pips/points border' field
    #Then the 'stop' checkbox is unchecked
    #Then the 'limit' checkbox is unchecked
    Then the main '1'st normal stop linked order 'price' element should be disabled
    And the main '1'st normal stop linked order 'pips/points' element should be disabled
    And the main '1'st normal stop linked order 'p/l' element should be disabled
    Then the main '2'nd limit linked order 'price' element should be disabled
    And the main '2'nd limit linked order 'pips/points' element should be disabled
    And the main '2'nd limit linked order 'p/l' element should be disabled
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible

    Examples:
      |Market type|Direction|Color|Stop Multiplier|Limit Multiplier|OppDirection|Arrow type|State|
      |CFD        |buy      |blue |0.89           |1.01            |sell        |ARROW_UP  |above|
      |Spread     |sell     |red  |1.001          |0.99            |buy         |ARROW_DOWN|below|

  @regression @open-buy/sell-position-with-stop-and-limit-cfd/spread-market @wt-115-v17-step14 @wt-118-v11-step14
  Scenario Outline: Open Buy/Sell Position with Stop and Limit CFD/Spread market - step 14
    #14 - market, which price contains zeroes, as demicals (price is almost not streamed)
    # - UNSTABLE STEP: use exact market 'Enel DFT' id = 400615704
    When I click on Search input
    Then Search modal should be visible
    When I wait for markets loading
    And I fill search field with value 'Enel DFT'
    And I wait for markets loading
    When I click on '<Direction in Search>' in the '1'st market within search modal
    And I remember min valid quantity for 'current' market
    Then the 'Deal ticket' panel should be visible
    When I fill 'quantity' with value 'min valid+1'
    Then 'submit button' element text should be 'Place Trade'
    And I click on 'submit' button
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
    And I make 'Positions And Orders' panel active
    And the 'previously added' market should be present on the list
    # Next step could fail related with bug https://jira.gaincapital.com/browse/TPDWT-20027
    #And the '1'st position 'unrealised' cell should be rounded correctly
    And the '1'st position 'pip/point pl' cell should be rounded correctly
    And the '1'st position 'opening price' cell should be rounded correctly
    And the '1'st position 'current price' cell should be rounded correctly

    Examples:
      |Direction in Search|
      |ask price          |
      |bid price          |

  @regression @open-buy/sell-position-with-stop-and-limit-cfd/spread-market @wt-115-v17-step16
  Scenario: Open Buy/Sell Position with Stop and Limit CFD/Spread market - step 16
    #16 - market, which price without demical places
    When I click on Search input
    Then Search modal should be visible
    When I wait for markets loading
    And I fill search field with value 'germany'
    And I wait for markets loading
    And I find Normal market with 'PriceDecimalPlaces' property is '0' in search modal
    And I remember min valid quantity for 'current' market
    And I click on 'ask price' in the 'current' market within search modal
    Then the 'Deal ticket' panel should be visible
    When I fill 'quantity' with value 'min valid+1'
    And I click on 'submit' button
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
    And I make 'Positions And Orders' panel active
    And the 'previously added' market should be present on the list
    # Next step could fail related with bug https://jira.gaincapital.com/browse/TPDWT-20027
    #And the '1'st position 'unrealised' cell should be rounded correctly
    And the '1'st position 'pip/point pl' cell should be rounded correctly
    And the '1'st position 'opening price' cell should be rounded correctly
    And the '1'st position 'current price' cell should be rounded correctly

  @regression @amend-buy/sell-position-attached-stop-and-limit-orders-cfd/spread-market @wt-116-v12 @wt-119-v10 @bug
  Scenario Outline: Amend Buy/Sell Position Attached Stop and Limit Orders - CFD/SPREAD Market
    #1
    And I add position with parameters:
      | MarketName | <Market name> |
      | Direction  | <Direction>   |
      | Quantity   | <Quantity>    |
      | StopPrice  | <Stop price>  |
      | LimitPrice | <Limit price> |
    Then the 'Positions And Orders' panel should be visible
    Then the '<Market name>' market should be present on the list
    And I complete 'previously added' market dropdown with value 'Amend Position'
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'amend position'
    And the trade ticket standard view panel should not contain items:
      | itemName  |
      | buy tick  |
      | sell tick |
    And the 'buy' button should be 'grey'
    And the 'sell' button should be 'grey'
    And the trade ticket standard view panel should contain items:
      | itemName   |
      | buy label  |
      | sell label |
    And '<OppDirection>' price should change with time
    And '<Direction>' price should change with time
    And 'market info' element text should be 'current market'
    And current simple position information should be correct
    Then 'edit' radiobutton should be 'selected'
    And 'submit button' element text should be 'Update Position'
    Then the edit ticket standard view panel should contain items:
      | itemName      |
      | close section |
      | edit section  |
    When I close 'Deal ticket' panel
    Then the 'Deal ticket' panel should be invisible
    When I make 'Positions And Orders' panel active
    Then the 'previously added' market should be present on the list
    When I click on 'close' in the '<Market name>' market
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'amend position'
    And 'close' radiobutton should be 'selected'
    And 'submit button' element text should be 'Close Position'
    #2, 3
    When I click on 'editRadio' button
    # https://jira.gaincapital.com/browse/TPDWT-20387 after fixing 2 next steps can be deleted
    When I click on 'panel label' element
    Then 'edit' radiobutton should be 'selected'
    Then the edit ticket standard view panel should contain items:
      | itemName     |
      | edit section |
    And the '1'st normal stop order should contain fields:
      | itemName      |
      | checkbox      |
      | price         |
      | pips/points   |
      | p/l           |
    And the '2'nd limit order should contain fields:
      | itemName    |
      | checkbox    |
      | price       |
      | pips/points |
      | p/l         |
    Then the edit ticket standard view panel should contain items:
      | itemName                       |
      | advanced ticket link           |
      | advanced ticket double chevron |
    Then the edit ticket standard view panel should not contain items:
      | itemName       |
      | hedging status |
    And 'submit button' element text should be 'Update Position'
    And 'submit button' element should be disabled
    #4 filling new price
    And I uncheck main 'limit' checkbox
    When I fill the '1'st normal stop linked order 'price' with value '<Direction>*<Stop Multiplier>' in the 'current market'
    And the '1'st normal stop linked order 'pips/points' input should be autopopulated
    And the '1'st normal stop linked order 'p/l' input should be autopopulated
    And I check main 'limit' checkbox
    And I fill the '2'nd limit linked order 'price' with value '<Direction>*<Limit Multiplier>' in the 'current market'
    And the '2'nd limit linked order 'pips/points' input should be autopopulated
    And the '2'nd limit linked order 'p/l' input should be autopopulated
    And 'submit button' element should be enabled
    #5 filling new P/L
    Then I store data from the main '1'st normal stop linked order
    # for inputs clearing
    And I uncheck main 'stop' checkbox
    And I check main 'stop' checkbox
    Then the '1'st normal stop linked order 'pips/points' input should be blank
    And the '1'st normal stop linked order 'price' input should be blank
    And the '1'st normal stop linked order 'p/l' input should be blank
    And I fill the '1'st normal stop linked order 'p/l' with value '<P/L>' in the 'current market'
    Then the main '1'st normal stop linked order 'pips/points' input should be changed
    And the main '1'st normal stop linked order 'price' input should be changed
    Then I store data from the main '2'nd limit linked order
    And I uncheck main 'limit' checkbox
    And I check main 'limit' checkbox
    Then the '2'nd limit linked order 'pips/points' input should be blank
    And the '2'nd limit linked order 'price' input should be blank
    And the '2'nd limit linked order 'p/l' input should be blank
    And I fill the '2'nd limit linked order 'p/l' with value '<P/L>' in the 'current market'
    Then the main '2'nd limit linked order 'pips/points' input should be changed
    And the main '2'nd limit linked order 'price' input should be changed
    #6 filling new pips/points
    Then I store data from the main '1'st normal stop linked order
    And I uncheck main 'stop' checkbox
    And I check main 'stop' checkbox
    Then the '1'st normal stop linked order 'pips/points' input should be blank
    And the '1'st normal stop linked order 'price' input should be blank
    And the '1'st normal stop linked order 'p/l' input should be blank
    And I fill the '1'st normal stop linked order 'pips/points' with value '<Pips/Points>' in the 'current market'
    Then the main '1'st normal stop linked order 'price' input should be changed
    And the main '1'st normal stop linked order 'p/l' input should be changed
    Then I store data from the main '2'nd limit linked order
    And I uncheck main 'limit' checkbox
    And I check main 'limit' checkbox
    Then the '2'nd limit linked order 'pips/points' input should be blank
    And the '2'nd limit linked order 'price' input should be blank
    And the '2'nd limit linked order 'p/l' input should be blank
    And I fill the '2'nd limit linked order 'pips/points' with value '<Pips/Points>' in the 'current market'
    Then the main '2'nd limit linked order 'price' input should be changed
    And the main '2'nd limit linked order 'p/l' input should be changed
    #7
    And '<OppDirection>' price should change with time
    And '<Direction>' price should change with time
    And the '1'st normal stop linked order 'p/l' input should be autopopulated
    Then the '2'nd limit linked order 'p/l' input should be autopopulated
    #8
    When I click on 'submit' button
    Then 'confirmation' element text should be 'Position updated'
    And 'market name' element text should be '<Market name>'
    # text of confirmation message is not correspond as in manual test-case, Amar does not confirm this text
    And 'confirmation message' element text should be 'Your order has been updated.'
    #9
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
    #10
    And the 'Positions And Orders' panel should be visible
    And the 'previously added' market should be present on the list
    And I complete 'previously added' market dropdown with value 'Amend Position'
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'amend position'
    And 'submit button' element text should be 'Update Position'
    And the 'submit' button should be 'grey'
    And 'submit button' element should be disabled
    #11
    And I click on 'advancedTicket' link
    When I expand '1'st applicability dropdown
    And I select 'Good 'til end of day (GTD)' from expanded dropdown
    When I expand '2'nd applicability dropdown
    And I select 'Good 'til end of day (GTD)' from expanded dropdown
    Then 'standard ticket link' element should be disabled
    When I click on 'submit' button
    Then 'confirmation' element text should be 'Position updated'
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
    When I make 'Positions And Orders' panel active
    And I complete 'previously added' market dropdown with value 'Amend Position'
    Then the 'Deal ticket' panel should be visible
    Then 'GTD' option should be selected in '1'st applicability dropdown
    Then 'GTD' option should be selected in '2'nd applicability dropdown
    And I uncheck 'stop' checkbox
    And I uncheck 'limit' checkbox
    And I wait for '1000'
    Then 'GTC' option should be selected in '1'st applicability dropdown
    Then 'GTC' option should be selected in '2'nd applicability dropdown
    When I click on 'standardTicket' link
    #for trailing stop
    #And I check 'stop' checkbox
    #And I wait for '1000'
    #And I expand '1'st linked order types dropdown
    #And I select 'trailing' from expanded dropdown
    #And I click on 'advancedTicket' link
    #When I expand '1'st applicability dropdown
    #And I select 'Good 'til end of day (GTD)' from expanded dropdown
    #And I uncheck 'stop' checkbox
    #And I wait for '1000'
    #Then 'GTC' option should be selected in '1'st applicability dropdown
    #When I click on 'standardTicket' link
    #And I check 'stop' checkbox
    #And I expand '1'st linked order types dropdown
    #And I select 'stop' from expanded dropdown
    #When I uncheck 'stop' checkbox
    #12
    When I click on 'submit' button
    Then 'confirmation' element text should be 'Position updated'
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
    When I make 'Positions And Orders' panel active
    And the 'previously added' market 'stop price' cell should contain 'set' word
    And the 'previously added' market 'limit price' cell should contain 'set' word

    Examples:
      |Market name |Direction|OppDirection|Quantity|Stop price|Limit price|Stop Multiplier|Limit Multiplier|Pips/Points|P/L |
      |USD/JPY     |buy      |sell        |1000    |90        |140        |0.89           |1.01            |100        |-100|
      |GBP/USD DFT |sell     |buy         |2       |1.8       |1          |1.001          |0.99            |100        |-100|

  @regression @partially-close-buy/sell-position-cfd/spread-market @wt-620-v6 @wt-621-v5
  Scenario Outline: Partially Close Buy/Sell Position - CFD/SPREAD Market
     # @wt-621-v5 first step is implemented like in @wt-620-v6 (Amend position ticket is opened through the Close button)
     #1, 2
    And I add position with parameters:
      | MarketName | <Market name> |
      | Direction  | <Direction>   |
      | Quantity   | <Quantity>    |
      | StopPrice  | <Stop price>  |
      | LimitPrice | <Limit price> |
    Then the 'Positions And Orders' panel should be visible
    Then the '<Market name>' market should be present on the list
    When I click on 'close' in the '<Market name>' market
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'amend position'
    Then the edit ticket standard view panel should not contain items:
      | itemName  |
      | buy tick  |
      | sell tick |
    And the 'buy' button should be 'grey'
    And the 'sell' button should be 'grey'
    Then the edit ticket standard view panel should contain items:
      | itemName   |
      | buy label  |
      | sell label |
    And '<OppDirection>' price should change with time
    And '<Direction>' price should change with time
    And 'market info' element text should be 'current market'
    And current simple position information should be correct
    Then 'close' radiobutton should be 'selected'
    And cursor is placed in the 'close quantity' field
    And 'close quantity' input should be predefined with '<Quantity>'
    And 'max available quantity info' element text should be 'of <QuantityUI>'
    #https://jira.gaincapital.com/browse/TPDWT-14948 - ticket for future implementation number format in this message
    And close info message should be correct
    And 'submit button' element text should be 'Close Position'
    And 'submit button' element should be enabled
    Then the edit ticket standard view panel should contain items:
      | itemName      |
      | close section |
      | edit section  |
    Then 'edit' radiobutton should be 'not selected'
    #3
    When I click on 'editRadio' button
    # https://jira.gaincapital.com/browse/TPDWT-20387 after fixing next step can be deleted
    When I click on 'panel label' element
    Then 'edit' radiobutton should be 'selected'
    Then the edit ticket standard view panel should contain items:
      | itemName |
      | orders   |
    #4
    When I click on 'closeRadio' button
    # https://jira.gaincapital.com/browse/TPDWT-20387 after fixing next step can be deleted
    When I click on 'panel label' element
    Then 'close' radiobutton should be 'selected'
    Then the edit ticket standard view panel should not contain items:
      | itemName |
      | orders   |
    When I fill 'close quantity' with value '<Close quantity>'
    # number in close info hangs. this click is workaround
    # When I click on 'panel label' element
    Then partially close info message should be correct
    #5
    And 'submit button' element should be enabled
    When I click on 'submit' button
    Then 'confirmation' element text should be 'Trade Executed'
    And 'market name' element text should be '<Market name>'
    And partially close confirmation message should be correct
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
    #6
    When I make 'Positions And Orders' panel active
    Then the 'previously added' market 'position' cell should contain 'updated' data

    Examples:
      |Market name |Direction|Quantity|QuantityUI|Close quantity|Stop price|Limit price|OppDirection|
      |USD/JPY     |buy      |2000    |2,000     |1000          |90        |140        |sell        |
      |GBP/USD DFT |sell     |2       |2         |1             |1.8       |1          |buy         |

  @regression @close-full-buy/sell-position-with-stop-and-limit-cfd/spread-market @wt-117-v7 @wt-120-v4
  Scenario Outline: Close Full Buy/Sell Position with Stop and Limit - CFD/SPREAD Market
   #1
    And I add position with parameters:
      | MarketName | <Market name> |
      | Direction  | <Direction>   |
      | Quantity   | <Quantity>    |
      | StopPrice  | <Stop price>  |
      | LimitPrice | <Limit price> |
    Then the 'Positions And Orders' panel should be visible
    Then the '<Market name>' market should be present on the list
    When I click on 'close' in the '<Market name>' market
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'amend position'
    Then the edit ticket standard view panel should not contain items:
      | itemName  |
      | buy tick  |
      | sell tick |
    And the 'buy' button should be 'grey'
    And the 'sell' button should be 'grey'
    And 'market info' element text should be 'current market'
    Then the edit ticket standard view panel should contain items:
      | itemName   |
      | buy label  |
      | sell label |
    And '<OppDirection>' price should change with time
    And '<Direction>' price should change with time
    And current simple position information should be correct
    Then the edit ticket standard view panel should contain items:
      | itemName      |
      | close section |
      | edit section  |
    Then 'close' radiobutton should be 'selected'
    Then 'edit' radiobutton should be 'not selected'
    And 'submit button' element text should be 'Close Position'
    And 'submit button' element should be enabled
    #2
    And cursor is placed in the 'close quantity' field
    And 'close quantity' input should be predefined with '<Quantity>'
    And 'max available quantity info' element text should be 'of <QuantityUI>'
    #https://jira.gaincapital.com/browse/TPDWT-14948 - ticket for future implementation number format in this message
    And close info message should be correct
    #3
    When I click on 'editRadio' button
    Then 'edit' radiobutton should be 'selected'
    Then the edit ticket standard view panel should contain items:
      | itemName |
      | orders   |
    #4
    Then the 'stop' checkbox is checked
    Then the main '1'st normal stop linked order 'price' element should be enabled
    And the main '1'st normal stop linked order 'pips/points' element should be enabled
    And the main '1'st normal stop linked order 'p/l' element should be enabled
    And I uncheck main 'stop' checkbox
    And I check main 'stop' checkbox
    And 'submit button' element text should be 'Choose stop and limit levels'
    And 'submit button' element should be disabled
    #5
    When I click on 'closeRadio' button
    And I wait for '1000'
    Then 'close' radiobutton should be 'selected'
    Then the edit ticket standard view panel should not contain items:
      | itemName |
      | orders   |
    Then 'close' radiobutton should be 'selected'
    And cursor is placed in the 'close quantity' field
    #6
    When I fill 'close quantity' with value '<Quantity>'
    # When I click on 'panel label' element
    Then close info message should be correct
    And 'submit button' element text should be 'Close Position'
    And 'submit button' element should be enabled
    #7,8
    When I click on 'submit' button
    Then 'confirmation' element text should be 'Trade Executed'
    And 'market name' element text should be '<Market name>'
    And confirmation message should be correct
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
    #9
    When I make 'Positions And Orders' panel active
    Then the 'previously added' market should be not present on the list

    Examples:
      |Market name |Direction|Quantity|QuantityUI|Stop price|Limit price|OppDirection|
      |USD/JPY     |buy      |1000    |1,000     |90        |140        |sell        |
      |GBP/USD DFT |sell     |2       |2         |1.8       |1          |buy         |


  @regression @one-click-trading @one-click-trading-buy/sell-create/edit/close-cfd-market @wt-111-v6
  Scenario Outline: One-Click Trading: Buy/Sell - Create/Edit/Close CFD Market
    #1
    When I enable one click trading
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I find <Market type> market
    And I click on 'buy' in the 'current' market
    And I remember min valid quantity for 'current' market
    And I remember max valid quantity for 'current' market
    Then the 'Deal ticket' panel should be visible
    #2
    Then max allowed symbols in 'quantity' field should be '15'
    When I fill 'quantity' with value '<Quantity>'
    And I check 'stop' checkbox
    And I fill the '1'st normal stop linked order 'pips' with value '<Pips>' in the 'current market'
    And I check 'limit' checkbox
    And I fill the '2'nd limit linked order 'pips' with value '<Pips>' in the 'current market'
    And I click on 'submit' button
    And I click on 'ok' button
    And I make 'Positions And Orders' panel active
    Then the 'previously added' market should be present on the list
    #3
    When I make 'Watchlist' panel active
    And I fill 1-click 'quantity' with value '<Quantity>' for the 'current' market
    And I click on 'buy' in the 'current' market
    Then open trade confirmation message should be displayed correctly
    #4
    When I make 'Watchlist' panel active
    And I fill 1-click 'quantity' with value '<Quantity>' for the 'current' market
    And I fill 1-click 'quantity' with value '<New Quantity>' for the 'current' market
    And I click on 'buy' in the 'current' market
    When I make 'Positions And Orders' panel active
    Then the 'previously added' market should be present on the list
    And the 'previously added' market should be displayed as 'multi'
    When I expand 'previously added' multi-market
    Then the 'previously added' multi-market should be 'expanded'
    And the 'previously added' market's sub-markets count should be '3'
    #5
    When I make 'Watchlist' panel active
    When I fill 1-click 'quantity' with value '<Quantity>' for the 'current' market
    When I disable one click trading
    Then 1-click 'quantity' field should be removed
    When I enable one click trading
    Then 1-click 'quantity' field for the 'current' market should be filled with '<New Quantity>'
    #6
    When I make 'Positions And Orders' panel active
    And I click on 'dropdown arrow' in the 'current' multi-market's '1'st sub-market
    And I select 'Amend Position' in dropdown menu in 'current' market
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'amend position'
    #7
    When I fill 'close quantity' with value 'half of available'
    Then partially close info message should be correct
    And I click on 'submit' button
    Then 'confirmation' element text should be 'Trade executed'
    And partially close confirmation message should be correct
    When I click on 'ok' button
    #8
    And I make 'Positions And Orders' panel active
    And the 'Positions And Orders' panel should be visible
    And I click on 'dropdown arrow' in the 'current' multi-market's '1'st sub-market
    And I select 'Amend Position' in dropdown menu in 'current' market
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'amend position'
    And 'edit' radiobutton should be 'selected'
    When I fill the '1'st normal stop linked order 'pips' with value '<New Pips>' in the 'current market'
    And I fill the '2'nd limit linked order 'pips' with value '<New Pips>' in the 'current market'
    And I click on 'submit' button
    Then 'confirmation' element text should be 'Position updated'
    And 'confirmation message' element text should be 'Your order has been updated.'
    When I click on 'ok' button
    #9
    And I make 'Positions And Orders' panel active
    And I click on 'dropdown arrow' in the 'current' multi-market's '1'st sub-market
    And I select 'Amend Position' in dropdown menu in 'current' market
    Then the 'Deal ticket' panel should be visible
    When I click on 'closeRadio' button
    And I click on 'submit' button
    Then 'confirmation' element text should be 'Trade executed'
    Then close info message should be correct
    When I click on 'ok' button
    And I make 'Positions And Orders' panel active
    Then the 'previously added' market should be present on the list
    And the 'previously added' market's sub-markets count should be '2'

    Examples:
      | Market type | Quantity    | New Quantity | Pips | New Pips |
      | CFD         | min valid*2 | min valid*1  | 100  | 110      |

  @regression @one-click-trading @one-click-trading-quantity-validation @wt-1508-v4 @bug
  Scenario: One-Click Trading: Quantity Validation
    #1
    When I enable one click trading
    And I make 'Watchlist' panel active
    And I expand 'Popular Markets' watchlist
    And I find any market
    And I remember all quantity sizes for 'current' market
    Then 1-click 'quantity' field for the 'current' market should be filled with ''
    #2
    When I hover 'current' market
    Then 1-click 'quantity' field placeholder for the 'current' market should be filled with min 'WebMinSize'
    #3
    When I click on 1-click 'quantity' in the 'current' market
    And I find any new market
    And I hover 'new' market
    Then 1-click 'quantity' field placeholder for the 'current' market should be filled with min 'WebMinSize'
    When I remember all quantity sizes for 'new' market
    Then 1-click 'quantity' field placeholder for the 'new' market should be filled with min 'WebMinSize'
    #4
    When I remember min valid quantity for 'current' market
    And I remember max valid quantity for 'current' market
    And I remember all quantity sizes for 'current' market
    And I fill 1-click 'quantity' with value 'min valid*1' for the 'current' market
    And I click on 'buy' in the 'current' market
    Then open trade confirmation message should be displayed correctly
    When I make 'Positions And Orders' panel active
    Then the 'previously added' market should be present on the list
    #5
    When I make 'Watchlist' panel active
    And I expand 'Popular Markets' watchlist
    And I hover 'current' market
    And I fill 1-click 'quantity' with value 'min valid-1' for the 'current' market
    Then 'confirmation message' in watchlist panel should be displayed in '500'ms
    And text of 'confirmation message' in watchlist panel should be 'Too low. Minimum WebMinSize'
    And 1-click 'quantity border' for the 'current' market should have red color
    When I hover 'new' market
    Then 'confirmation message' in watchlist panel should not be displayed
    And 1-click 'quantity border' for the 'current' market should have red color
    When I hover 'current' market
    Then text of 'confirmation message' in watchlist panel should be 'Too low. Minimum WebMinSize'
    And 1-click 'quantity border' for the 'current' market should have red color
    #6
    When I find market with same 'MaxLongSize' and 'MaxShortSize'
    And I fill 1-click 'quantity' with value 'min valid+1' for the 'current' market
    Then 'confirmation message' in watchlist panel should not be displayed
    And 1-click 'quantity border' for the 'current' market should have grey color
    #7
    When I click on 'buy' in the 'current' market
    And I make 'Positions And Orders' panel active
    Then the 'previously added' market should be present on the list
    And the 'previously added' market 'quantity' cell should contain '2min valid+1' data
    #8
    When I make 'Watchlist' panel active
    And I expand 'Popular Markets' watchlist
    And I hover 'current' market
    And I fill 1-click 'quantity' with value 'max valid+1' for the 'current' market
    Then 'confirmation message' in watchlist panel should be displayed in '500'ms
    And text of 'confirmation message' in watchlist panel should be 'Too high. Maximum MaxLongSize'
    And 1-click 'quantity border' for the 'current' market should have red color
    When I hover 'new' market
    Then 'confirmation message' in watchlist panel should not be displayed
    And 1-click 'quantity border' for the 'current' market should have red color
    When I hover 'current' market
    Then text of 'confirmation message' in watchlist panel should be 'Too high. Maximum MaxLongSize'
    And 1-click 'quantity border' for the 'current' market should have red color
    #9
    When I find market with different 'MaxLongSize' and 'MaxShortSize'
    And I hover 'current' market
    And I fill 1-click 'quantity' with value 'min valid+1' for the 'current' market
    Then 'confirmation message' in watchlist panel should not be displayed
    When I hover 'new' market
    Then 1-click 'quantity border' for the 'current' market should have grey color
    And 1-click 'buy hover container' for the 'current' market should have blue color
    And 1-click 'sell hover container' for the 'current' market should have red color
    #10
    # Step 10 cannot be implemented because automation couldn't run through citrix
    # In futher steps automation should use market with different MaxLongSize and MaxShortSize
    # so, after each PPE refresh someone should change those properties for any market from Popular Watchlist
    #11
    When I hover 'current' market
    And I fill 1-click 'quantity' with value 'max sizeProperty+1' for the 'current' market
    # should fail due https://jira.gaincapital.com/browse/TPDWT-20908
    Then 'confirmation message' in watchlist panel should not be displayed
    And 1-click 'quantity border' for the 'current' market should have grey color
    #12
    When I click on 'buy' in the 'current' market
    Then 'confirmation message' in watchlist panel should be displayed in '500'ms
    And text of 'confirmation message' in watchlist panel should be 'Too high. Maximum MaxLongSize'
    And 1-click 'quantity border' for the 'current' market should have red color
    When I hover 'new' market
    Then 'confirmation message' in watchlist panel should not be displayed
    And 1-click 'quantity border' for the 'current' market should have red color
    When I hover 'current' market
    Then text of 'confirmation message' in watchlist panel should be 'Too high. Maximum MaxLongSize'
    And 1-click 'quantity border' for the 'current' market should have red color
    #13
    When I fill 1-click 'quantity' with value 'MaxShortSize+1' for the 'current' market
    # different MaxShortSize and MaxLongSize workflow is working incorrectly
    # TODO: check this after fix for https://jira.gaincapital.com/browse/TPDWT-20908
    And I click on 'buy' in the 'current' market
    Then 'confirmation message' in watchlist panel should not be displayed
    And 1-click 'quantity border' for the 'current' market should have grey color
    When I make 'Positions And Orders' panel active
    Then the 'previously added' market should be present on the list
    And the 'previously added' market should be displayed as 'multi'
    When I expand 'previously added' multi-market
    Then the 'previously added' multi-market should be 'expanded'
    And the 'previously added' market's sub-markets count should be '2'
    #14
    When I make 'Watchlist' panel active
    And I expand 'Popular Markets' watchlist
    And I hover 'current' market
    And I click on 'sell' in the 'current' market
    Then 'confirmation message' in watchlist panel should be displayed in '500'ms
    And text of 'confirmation message' in watchlist panel should be 'Too high. Maximum MaxLongSize'
    When I make 'Positions And Orders' panel active
    And the 'previously added' market's sub-markets count should be '2'
    #15
    When I make 'Watchlist' panel active
    And I fill 1-click 'quantity' with value 'MaxShortSize-1' for the 'current' market
    And I click on 'sell' in the 'current' market
    And I make 'Positions And Orders' panel active
    Then the 'previously added' market should be present on the list
    And the 'previously added' market should be displayed as 'single'
    #16
    When I make 'Watchlist' panel active
    And I fill 1-click 'quantity' with value 'MaxShortSize+1' for the 'current' market
    And I click on 'buy' in the 'current' market
    And I make 'Positions And Orders' panel active
    Then the 'previously added' market should be present on the list
    And the 'previously added' market should be displayed as 'multi'
    When I expand 'previously added' multi-market
    Then the 'previously added' multi-market should be 'expanded'
    And the 'previously added' market's sub-markets count should be '2'
    #17
    When I make 'Watchlist' panel active
    And I expand 'Popular Markets' watchlist
    And I hover 'current' market
    And I fill 1-click 'quantity' with value '0' for the 'current' market
    Then 'confirmation message' in watchlist panel should be displayed in '500'ms
    And text of 'confirmation message' in watchlist panel should be 'Too low. Minimum WebMinSize'
    And 1-click 'quantity border' for the 'current' market should have red color
    When I hover 'new' market
    Then 'confirmation message' in watchlist panel should not be displayed
    And 1-click 'quantity border' for the 'current' market should have red color
    When I hover 'current' market
    Then text of 'confirmation message' in watchlist panel should be 'Too low. Minimum WebMinSize'
    And 1-click 'quantity border' for the 'current' market should have red color
    # Steps 18-20 contains server error validation that appers for some specific markets(not FX?)
    # so, for now, it not implemented.
    #18
    # When I fill 1-click 'quantity' with value '1.11111' for the 'current' market
    # And I click on 'sell' in the 'current' market
    # Then 'server validation error' in watchlist panel should be displayed
    #19
    # When I click on 'sell' in the 'current' market
    # Then 'server validation error' in watchlist panel should be displayed
    # When I click on 'buy' in the 'current' market
    # Then 'server validation error' in watchlist panel should be displayed
    # When I click on 'sell' in the 'current' market
    # Then 'server validation error' in watchlist panel should be displayed
    #20
    # When I click on 'sell' in the 'current' market
    # Then 'server validation error' in watchlist panel should be displayed
    # When I click on 'live chat' link in 'server validation error'
    # 'live chat' validation
    # When I click on 'email us' link in 'server validation error'
    # 'email us' validation
    # When I click on 'buy' in the 'current' market
    # Then 'server validation error' in watchlist panel should be displayed
    # When I click on 'live chat' link in 'server validation error'
    # 'live chat' validation
    # When I click on 'email us' link in 'server validation error'
    # 'email us' validation
    # When I click on 'sell' in the 'current' market
    # Then 'server validation error' in watchlist panel should be displayed
    # When I click on 'live chat' link in 'server validation error'
    # 'live chat' validation
    # When I click on 'email us' link in 'server validation error'
    # 'email us' validation
    #21
    When I fill 1-click 'quantity' with value 'min valid' for the 'current' market
    And I click on 'buy' in the 'current' market
    And I make 'Positions And Orders' panel active
    Then the 'previously added' market should be present on the list
    And the 'previously added' market's sub-markets count should be '3'
    And I disable one click trading


  @regression @one-click-trading @delete-watchlist @qty-fied-for-1CT @wt-1558-v2
  Scenario: QTY field for 1CT
    #pre
    When I make 'Watchlist' panel active
    And I create 'Test' watchlist
    And I type 'commonwealth bank of australia' name of market in 'Test' watchlist
    Then the 'market from dropdown' element should be visible on 'Test' watchlist
    When I add '1'st market from market dropdown
    Then the 'previously added' market is visible
    When I type 'telstra corp' name of market in 'Test' watchlist
    Then the 'market from dropdown' element should be visible on 'Test' watchlist
    When I add '1'st market from market dropdown
    Then the 'previously added' market is visible
    When I type 'apple inc' name of market in 'Test' watchlist
    Then the 'market from dropdown' element should be visible on 'Test' watchlist
    When I add '1'st market from market dropdown
    Then the 'previously added' market is visible
    When I type 'aud/usd' name of market in 'Test' watchlist
    Then the 'market from dropdown' element should be visible on 'Test' watchlist
    When I add '1'st market from market dropdown
    Then the 'previously added' market is visible
    When I type 'gbp/jpy' name of market in 'Test' watchlist
    Then the 'market from dropdown' element should be visible on 'Test' watchlist
    When I add '1'st market from market dropdown
    And I remember all quantity sizes for 'current' market
    Then the 'previously added' market is visible
    #1
    When I enable one click trading
    Then One click trading board should be ON
    When I make 'Watchlist' panel active
    And 1-click 'quantity' for all markets from 'Test' watchlist should be displayed according to market status
    #2
    When I click on 1-click 'quantity' in the 'current' market
    Then 1-click 'quantity' field placeholder for the 'current' market should be filled with min 'WebMinSize'
    #3
    When I refresh current page
    And I expand 'test' watchlist
    Then One click trading board should be ON
    And 1-click 'quantity' for all markets from 'Test' watchlist should be displayed according to market status
    #4
    When I disable one click trading
    Then One click trading board should be OFF
    #5
    When I switch to 'Browse markets' workspace tab
    Then 'Browse markets' tab should be active
    When I select 'Popular' market category
    And I select 'Popular Australia' filter tab
    Then 'Popular Australia' markets filter tab should be active
    When I enable one click trading
    Then 1-click 'quantity' for all present on browse tab markets should be displayed according to market status
    #6
    When I click on 'quantity' in the '1'st market on browse tab
    And I remember all quantity sizes for 'current' market
    Then 1-click 'quantity' field placeholder for the 'current' market on browse tab should be filled with min 'WebMinSize'
    #7
    When I refresh current page
    And I select 'Popular' market category
    And I select 'Popular Australia' filter tab
    Then 1-click 'quantity' for all present on browse tab markets should be displayed according to market status
    #8
    When I click on Search input
    Then Search modal should be visible
    And 1-click 'quantity' for all markets on search modal should be displayed according to market status
    #9
    And I click on 'quantity' in the '1'st market within search modal
    And I remember all quantity sizes for 'current' market
    Then 1-click 'quantity' field placeholder for the 'current' found market should be filled with min 'WebMinSize'

  # necessary available market Japan 225 CFD (400155751) with QTY 70 and streaming prices
  @regression @Japan-225-CFD @close-buy/sell-position-with-qty-lower-than-the-market-minimum-size @wt-1279-v2 @ignore
  Scenario Outline: Close Buy/Sell Position with QTY LOWER than the market minimum size
    #position creation contains 1-6 steps
    When I click on Search input
    Then Search modal should be visible
    When I wait for markets loading
    And I fill search field with value 'germany'
    And I wait for markets loading
    When I find Normal market with 'MinDistance' property is '0' in search modal
    And I remember min valid quantity for 'current' market
    And I close Search input
    And I add position with parameters:
      | MarketName    | <Market name>    |
      | Direction     | <Direction>      |
      | Quantity      | <Quantity>       |
      | StopPrice     | <Stop price>     |
      | LimitPrice    | <Limit price>    |
      | StopQuantity  | <Stop quantity>  |
      | LimitQuantity | <Limit quantity> |
    Then the 'Positions And Orders' panel should be visible
    And the '<Market name>' market should be present on the list
    #7 step - in automation implementation stop/limit prices = current streamed price
    # so stop or limit order triggered
    And the 'previously added' market position cell should contain '<Direction> <Left quantity>' direction and quantity
    #8,9
    When I click on 'delete' in the '<Market name>' market
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'amend position'
    And 'close quantity' element should be disabled
    And 'submit button' element text should be 'Close Position'
    And 'submit button' element should be enabled
    #10
    When I click on 'submit' button
    And I make 'Positions And Orders' panel active
    Then the 'previously added' market should be not present on the list
    #11
    When I add position with parameters:
      | MarketName | <Market name>   |
      | Direction  | <Direction>     |
      | Quantity   | <Stop quantity> |
    Then the 'Positions And Orders' panel should be visible
    And the '<Market name>' market should be present on the list
    And the 'previously added' market position cell should contain '<Direction> <Stop quantity>' direction and quantity
    #12, 13
    When I click on 'delete' in the '<Market name>' market
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'amend position'
    And 'close quantity' element should be enabled
    And 'submit button' element should be enabled
    When I click on 'submit' button
    And I make 'Positions And Orders' panel active
    Then the 'previously added' market should be not present on the list
    #14
    When I add position with parameters:
      | MarketName | <Market name> |
      | Direction  | <Direction>   |
      | Quantity   | <Quantity>    |
    Then the 'Positions And Orders' panel should be visible
    And the '<Market name>' market should be present on the list
    And the 'previously added' market position cell should contain '<Direction> <Quantity>' direction and quantity
    #15, 16
    When I click on 'delete' in the '<Market name>' market
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'amend position'
    And 'close quantity' element should be enabled
    And 'submit button' element should be enabled
    When I click on 'submit' button
    And I make 'Positions And Orders' panel active
    Then the 'previously added' market should be not present on the list

    Examples:
      | Market name      | Quantity        | Stop quantity | Limit quantity | Left quantity   | Stop price | Limit price | Direction |
      | current market   | min valid * 1.5 | min valid     | min valid      | min valid * 0.5 | sell       | buy         | buy       |
      | Japan 225 CFD    | 100             | 70            | 70             | 30              | buy        | sell        | sell      |

  @regression @amend-and-position-details-ticket-are-closed-if-the-position-is-removed @wt-1310-v1
  Scenario Outline: Amend and position details ticket are closed if the position is removed
    #1
    And I add position with parameters:
      | MarketName | <Market name> |
      | Direction  | <Direction>   |
      | Quantity   | <Quantity>    |
    Then the 'Positions And Orders' panel should be visible
    And the '<Market name>' market should be present on the list
    And I complete 'previously added' market dropdown with value 'Amend Position'
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'amend position'
    #2
    And I make 'Positions And Orders' panel active
    And I complete 'previously added' market dropdown with value 'Position details'
    Then the 'Details' panel should be visible
    #3
    When I delete 'position' '<Market name>'
    Then the 'Positions And Orders' panel should be visible
    Then the '<Market name>' market should be not present on the list
    Then the 'Deal ticket' panel should be invisible
    Then the 'Details' panel should be invisible
    #4-6 - for triggerring order - necessary mocks

    Examples:
      | Market name | Quantity | Direction |
      | USD/JPY     | 1000     | buy       |
      | GBP/USD DFT | 2        | sell      |

  @regression @pip-value-and-margin-text-is-removed-when-values-are-not-being-returned-from-API @wt-1147-v5
  Scenario Outline: PIP Value and Margin text is removed when values are not being returned from API
    #1
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I find <Market type> market
    And I click on '<Direction>' in the 'current' market
    And I remember max valid quantity for 'current' market
    And I remember min valid quantity for 'current' market
    Then the 'Deal ticket' panel should be visible
    And 'sell' price should change with time
    And 'buy' price should change with time
    And the trade ticket standard view panel should contain items:
      | itemName  |
      | buy tick  |
      | sell tick |
    #2
    When I fill 'quantity' with value 'min valid+1'
    When I wait for '300'
    Then 'submit button' element should be enabled
    Then 'submit button' element text should be 'Place Trade'
    And margin calculator should contain correct information
    #3
    When I fill 'quantity' with value 'min valid*0.5'
    Then 'submit button' element should be disabled
    Then 'submit button' element text should be 'Quantity too low'
    And margin calculator should contain nothing
    #4
    When I clear 'quantity' field
    Then 'submit button' element should be disabled
    Then 'submit button' element text should be 'Choose quantity'
    And margin calculator should contain nothing
    #5
    When I fill 'quantity' with value 'max valid+1'
    Then 'submit button' element should be disabled
    Then 'submit button' element text should be 'Quantity too high'
    And margin calculator should contain nothing
    #6
    When I fill 'quantity' with value 'min valid+1'
    When I wait for '300'
    Then 'submit button' element should be enabled
    Then 'submit button' element text should be 'Place Trade'
    And margin calculator should contain correct information

    Examples:
      |Market type| Direction |
      | CFD       | buy       |
      | Spread    | sell      |

  @regression @default-resize-window @confirmation-DT-when-DT-is-moved-at-the-bottom-of-the-page @wt-1641-v1
  Scenario: Confirmation DT when DT is moved at the bottom of the page
    #1-3
    When I resize window with:
      | height | 1000 |
      | width  | 1500 |
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I find CFD market
    And I click on 'buy' in the 'current' market
    And I remember min valid quantity for 'current' market
    Then the 'Deal ticket' panel should be visible
    When I move panel to the 'bottom of the page'
    When I fill 'quantity' with value 'min valid+1'
    Then 'submit button' element should be enabled
    Then 'submit button' element text should be 'Place Trade'
    When I click on 'submit' button
    Then the 'Deal ticket' panel should be visible
    Then 'confirmation' element text should be 'Trade executed'
    When I click on 'ok' button
    #4
    When I make 'Watchlist' panel active
    When I expand 'Popular Markets' watchlist
    And I click on 'buy' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    When I switch to 'order' tab
    Then 'order' ticket type should be 'selected'
    #5, 6
    When I move panel to the 'bottom of the page'
    When I fill 'quantity' with value 'min valid+1'
    When I fill 'current market' main price with value not between current prices on 'buy'
    Then 'submit button' element should be enabled
    Then 'submit button' element text should be 'Place Order'
    When I click on 'submit' button
    Then the 'Deal ticket' panel should be visible
    Then 'confirmation' element text should be 'Order placed'
    When I click on 'ok' button
    #7, 8
    When I make 'Watchlist' panel active
    When I expand 'Popular Markets' watchlist
    And I click on 'buy' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    When I move panel to the 'bottom-right' corner
    When I switch to 'order' tab
    Then 'order' ticket type should be 'selected'
    When I click on 'oco' link
    #9
    When I fill main 'quantity' with value 'min valid+1'
    When I fill 'current market' main price with value not between current prices on 'buy'
    When I fill oco 'quantity' with value 'min valid+1'
    And I fill oco 'order price' with value 'valid order price'
    #10
    Then 'submit button' element should be enabled
    Then 'submit button' element text should be 'Place Order'
    When I click on 'submit' button
    Then the 'Deal ticket' panel should be visible
    Then 'confirmation' element text should be 'Order placed'
    When I click on 'ok' button

  @regression @stop/limit-trade-quantity-must-be-lwer-than-max-qty-allowed-for-the-market @wt-1295-v4 @wt-1297-v4
  Scenario Outline: Stop/Limit Trade quantity must be lower than max qty allowed for the market
    #1
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I find <Market type> market
    And I click on '<Direction>' in the 'current' market
    And I remember max valid quantity for 'current' market
    And I remember min valid quantity for 'current' market
    Then the 'Deal ticket' panel should be visible
    When I fill 'quantity' with value 'max valid+1'
    # fails due - https://jira.gaincapital.com/browse/TPDWT-13826
    #Then the main order 'quantity border' field should have red color
    Then 'current market' order 'max quantity' validation should be correct and should not appear for '500'ms
    Then 'submit button' element should be disabled
    Then 'submit button' element text should be 'Quantity too high'
    #2
    When I click on 'advancedTicket' link
    Then 'current market' order 'max quantity' validation should be correct
    Then the '1'st normal stop order should contain fields:
      | itemName      |
      | checkbox      |
      | dropdown      |
      | quantity      |
      | price         |
      | pips/points   |
      | p/l           |
      | applicability |
    And the '2'nd limit order should contain fields:
      | itemName      |
      | checkbox      |
      | label         |
      | quantity      |
      | price         |
      | pips/points   |
      | p/l           |
      | applicability |
    Then the main '1'st normal stop linked order 'quantity' input should be 'max valid+1'
    And the main '2'nd limit linked order 'quantity' input should be 'max valid+1'
    #3
    When I check main '<StopType>' checkbox
    And the main '<Number>'st <StopType> max quantity validation should be correct for 'current market' and should not appear for '500'ms
    Then the main '<Number>'st normal stop order 'quantity border' field should have red color
    And the main '<Number>'st normal stop linked order 'quantity' element should be enabled
    And the main '<Number>'st normal stop linked order 'price' element should be enabled
    And the main '<Number>'st normal stop linked order 'pips/points' element should be enabled
    And the main '<Number>'st normal stop linked order 'p/l' element should be enabled
    Then the main '<Number>'st normal stop linked order 'quantity' input should be 'max valid+1'
    Then the main '<Number>'st normal stop order 'quantity border' field should have red color
    Then 'submit button' element should be disabled
    Then 'submit button' element text should be 'Quantity too high'
    #4
    When I click on '<OppDirection>' label
    Then 'current market' order 'max quantity' validation should be correct
    And the main '<Number>'st <StopType> max quantity validation should be correct for 'current market'
    Then the main '<Number>'st normal stop order 'quantity border' field should have red color
    #5
    When I fill 'quantity' with value 'min valid+1'
    Then 'quantity' field validation should be cleared
    When I fill the main '<Number>'st normal stop linked order 'quantity' with value 'min valid+1' in the 'current market'
    Then the main '<Number>'st <StopType> max quantity validation should be cleared

    Examples:
      |Market type |Direction|OppDirection|StopType|Number|
      |CFD         |buy      |sell        |stop    |1     |
      |Spread      |sell     |buy         |limit   |2     |

  @regression @quantity-validation-for-0-stop-and-limit-value @wt-1139-v5
  Scenario: Quantity validation for 0 stop/limit value
    #1
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I find CFD market with available Guaranteed stop in watchlist
    And I click on 'sell' in the 'current' market
    #2
    And I remember min valid quantity for 'current' market
    And I remember max valid quantity for 'current' market
    Then the 'Deal ticket' panel should be visible
    When I fill 'quantity' with value 'max valid+1'
    #3
    When I click on 'advancedTicket' link
    Then the '1'st normal stop order should contain fields:
      | itemName      |
      | checkbox      |
      | dropdown      |
      | quantity      |
      | price         |
      | pips/points   |
      | p/l           |
      | applicability |
    #4
    When I check 'stop' checkbox
    When I fill the '1'st normal stop linked order 'price' with value 'sell*1.01' in the 'current market'
    And I fill the '1'st normal stop linked order 'quantity' with value '0' in the 'current market'
    Then the '1'st normal stop linked order 'min quantity' validation should be correct and should not appear for '500'ms
    Then 'submit button' element should be disabled
    When I uncheck 'stop' checkbox
    #5
    When I check 'limit' checkbox
    When I fill the '2'nd limit linked order 'price' with value 'sell*1.01' in the 'current market'
    And I fill the '2'nd limit linked order 'quantity' with value '0' in the 'current market'
    Then the '2'nd limit linked order 'min quantity' validation should be correct and should not appear for '500'ms
    Then 'submit button' element should be disabled
    When I uncheck 'limit' checkbox
    #6
    When I check 'stop' checkbox
    And I expand '1'st linked order types dropdown
    And I select 'trailing' from expanded dropdown
    And I fill the '1'st trailing stop linked order 'pips/points' with value '1000' in the 'current market'
    And I fill the '1'st trailing stop linked order 'quantity' with value '0' in the 'current market'
    Then the '1'st trailing stop linked order 'min quantity' validation should be correct and should not appear for '500'ms
    Then 'submit button' element should be disabled
    #7
    When I uncheck 'stop' checkbox
    When I check 'stop' checkbox
    And I expand '1'st linked order types dropdown
    And I select 'guaranteed' from expanded dropdown
    And I fill the '1'st guaranteed stop linked order 'pips/points' with value '1000' in the 'current market'
    And I fill the '1'st guaranteed stop linked order 'quantity' with value '0' in the 'current market'
    Then the '1'st guaranteed stop linked order 'min quantity' validation should be correct and should not appear for '500'ms
    Then 'submit button' element should be disabled
    #8 ORDER tab advancedTicket mode
    And I switch to 'order' tab
    Then 'order' ticket type should be 'selected'
    When I click on 'buy' label
     #9
    When I fill 'quantity' with value 'min valid+1'
    When I fill 'current market' price with value not between current prices on 'buy'
    Then 'submit button' element should be enabled
    Then 'submit button' element text should be 'Place Order'
    #10
    When I click on 'advancedTicket' link
    Then the '1'st normal stop order should contain fields:
      | itemName      |
      | checkbox      |
      | dropdown      |
      | quantity      |
      | price         |
      | pips/points   |
      | p/l           |
      | applicability |
    #11
    When I check 'stop' checkbox
    When I fill the '1'st normal stop linked order 'price' with value 'sell*1.01' in the 'current market'
    And I fill the '1'st normal stop linked order 'quantity' with value '0' in the 'current market'
    Then the '1'st normal stop linked order 'min quantity' validation should be correct and should not appear for '500'ms
    Then 'submit button' element should be disabled
    When I uncheck 'stop' checkbox
    #12
    When I check 'limit' checkbox
    When I fill the '2'nd limit linked order 'price' with value 'sell*1.01' in the 'current market'
    And I fill the '2'nd limit linked order 'quantity' with value '0' in the 'current market'
    Then the '2'nd limit linked order 'min quantity' validation should be correct and should not appear for '500'ms
    Then 'submit button' element should be disabled
    When I uncheck 'limit' checkbox
    #13
    When I check 'stop' checkbox
    And I expand '1'st linked order types dropdown
    And I select 'trailing' from expanded dropdown
    And I fill the '1'st trailing stop linked order 'pips/points' with value '1000' in the 'current market'
    And I fill the '1'st trailing stop linked order 'quantity' with value '0' in the 'current market'
    Then the '1'st trailing stop linked order 'min quantity' validation should be correct and should not appear for '500'ms
    Then 'submit button' element should be disabled
    And I expand '1'st linked order types dropdown
    And I select 'stop' from expanded dropdown
    When I uncheck 'stop' checkbox
    And I click on 'standardTicket' link
    #14, 15 go to OCO, works on MAIN
    When I click on 'oco' link
    When I fill main 'quantity' with value 'min valid+1'
    And I fill 'current market' main price with value not between current prices on 'buy'
    Then 'submit button' element text should be 'Choose quantity'
    #16
    When I click on main 'advancedTicket' link
    Then the main '1'st normal stop order should contain fields:
      | itemName      |
      | checkbox      |
      | dropdown      |
      | quantity      |
      | price         |
      | pips/points   |
      | p/l           |
      | applicability |
    #17
    When I check main 'stop' checkbox
    And I fill the main '1'st normal stop linked order 'price' with value 'sell*1.01' in the 'current market'
    And I fill the main '1'st normal stop linked order 'quantity' with value '0' in the 'current market'
    Then the main '1'st normal stop linked order 'min quantity' validation should be correct and should not appear for '500'ms
    Then 'submit button' element should be disabled
    When I uncheck main 'stop' checkbox
    #18
    When I check main 'limit' checkbox
    And I fill the main '2'nd limit linked order 'price' with value 'sell*1.01' in the 'current market'
    And I fill the main '2'nd limit linked order 'quantity' with value '0' in the 'current market'
    Then the main '2'nd limit linked order 'min quantity' validation should be correct and should not appear for '500'ms
    Then 'submit button' element should be disabled
    When I uncheck main 'limit' checkbox
    #19
    When I check main 'stop' checkbox
    And I expand main '1'st linked order types dropdown
    And I select 'trailing' from expanded dropdown
    And I fill the main '1'st trailing stop linked order 'pips/points' with value '1000' in the 'current market'
    And I fill the main '1'st trailing stop linked order 'quantity' with value '0' in the 'current market'
    Then the main '1'st trailing stop linked order 'min quantity' validation should be correct and should not appear for '500'ms
    Then 'submit button' element should be disabled
    When I uncheck main 'stop' checkbox
    #20 works on OCO advancedTicket mode
    When I click on oco 'buy' label
    When I fill oco 'quantity' with value 'min valid+1'
    # in this case necessary to fill based on sell price
    And I fill 'current market' oco price with value not between current prices on 'sell'
    Then 'submit button' element text should be 'Place Order'
    #21
    When I click on oco 'advancedTicket' link
    Then the oco '1'st normal stop order should contain fields:
      | itemName      |
      | checkbox      |
      | dropdown      |
      | quantity      |
      | price         |
      | pips/points   |
      | p/l           |
      | applicability |
    #22
    When I check oco 'stop' checkbox
    And I fill the oco '1'st normal stop linked order 'price' with value 'sell*1.01' in the 'current market'
    And I fill the oco '1'st normal stop linked order 'quantity' with value '0' in the 'current market'
    Then the oco '1'st normal stop linked order 'min quantity' validation should be correct and should not appear for '500'ms
    Then 'submit button' element should be disabled
    When I uncheck oco 'stop' checkbox
    #23
    When I check oco 'limit' checkbox
    And I fill the oco '2'nd limit linked order 'price' with value 'sell*1.01' in the 'current market'
    And I fill the oco '2'nd limit linked order 'quantity' with value '0' in the 'current market'
    Then the oco '2'nd limit linked order 'min quantity' validation should be correct and should not appear for '500'ms
    Then 'submit button' element should be disabled
    When I uncheck oco 'limit' checkbox
    #24
    When I check oco 'stop' checkbox
    And I expand oco '1'st linked order types dropdown
    And I select 'trailing' from expanded dropdown
    And I fill the oco '1'st trailing stop linked order 'pips/points' with value '1000' in the 'current market'
    And I fill the oco '1'st trailing stop linked order 'quantity' with value '0' in the 'current market'
    Then the oco '1'st trailing stop linked order 'min quantity' validation should be correct and should not appear for '500'ms
    Then 'submit button' element should be disabled

  @regression @price-validation-for-0-stop-and-limit-value @wt-1702-v5
  Scenario: Price validation for 0 stop/limit value
    #1
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I find CFD market with available Guaranteed stop in watchlist
    And I click on 'sell' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    And trade direction should be 'sell'
    And I remember min valid quantity for 'current' market
    When I switch to 'order' tab
    Then 'order' ticket type should be 'selected'
    #2
    When I fill 'quantity' with value 'min valid+1'
    When I fill 'current market' price with value not between current prices on 'buy'
    Then 'submit button' element should be enabled
    Then 'submit button' element text should be 'Place Order'
    #3
    When I check 'stop' checkbox
    And I fill the '1'st normal stop linked order 'price' with value '0' in the 'current market'
    And 'sell' 'current market' main '1'st stop price validation should be correct and should not appear for '500'ms
    And the '1'st normal stop order 'price border' element should have red color
    And the '1'st normal stop order 'pips/points border' element should have red color
    And the '1'st normal stop order 'p/l border' element should have red color
    Then 'submit button' element should be disabled
    Then 'submit button' element text should be 'Enter valid stop price'
    #4
    When I check 'limit' checkbox
    And I fill the '2'nd limit linked order 'price' with value '0' in the 'current market'
    And 'sell' 'current market' main '2'nd limit price validation should be correct and should not appear for '500'ms
    And the '2'nd limit order 'price border' element should have red color
    And the '2'nd limit order 'pips/points border' element should have red color
    And the '2'nd limit order 'p/l border' element should have red color
    Then 'submit button' element should be disabled
    Then 'submit button' element text should be 'Enter valid stop price'
    #5
    When I uncheck 'stop' checkbox
    And 'sell' 'current market' main '2'nd limit price validation should be correct
    And the '2'nd limit order 'price border' element should have red color
    And the '2'nd limit order 'pips/points border' element should have red color
    And the '2'nd limit order 'p/l border' element should have red color
    Then 'submit button' element should be disabled
    Then 'submit button' element text should be 'Enter valid limit price'
    #6
    When I uncheck 'limit' checkbox
    Then 'submit button' element should be enabled
    Then 'submit button' element text should be 'Place Order'
    When I close panel
    Then the 'Deal ticket' panel should be invisible
    #7
    When I make 'Watchlist' panel active
    When I expand 'Popular Markets' watchlist
    And I click on 'buy' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    And trade direction should be 'buy'
    And 'trade' ticket type should be 'selected'
    #8
    When I fill 'quantity' with value 'min valid+1'
    Then 'submit button' element should be enabled
    Then 'submit button' element text should be 'Place Trade'
    #9
    When I check 'limit' checkbox
    And I fill the '2'nd limit linked order 'price' with value '0' in the 'current market'
    And 'buy' 'current market' main '2'nd limit price validation should be correct and should not appear for '500'ms
    And the '2'nd limit order 'price border' element should have red color
    And the '2'nd limit order 'pips/points border' element should have red color
    And the '2'nd limit order 'p/l border' element should have red color
    Then 'submit button' element should be disabled
    Then 'submit button' element text should be 'Enter valid limit price'
    #10
    When I check 'stop' checkbox
    And I fill the '1'st normal stop linked order 'price' with value '0' in the 'current market'
    And 'buy' 'current market' main '1'st stop price validation should be correct and should not appear for '500'ms
    And the '1'st normal stop order 'price border' element should have red color
    And the '1'st normal stop order 'pips/points border' element should have red color
    And the '1'st normal stop order 'p/l border' element should have red color
    Then 'submit button' element should be disabled
    Then 'submit button' element text should be 'Enter valid stop price'
    #11
    When I uncheck 'limit' checkbox
    And 'buy' 'current market' main '1'st stop price validation should be correct
    And the '1'st normal stop order 'price border' element should have red color
    And the '1'st normal stop order 'pips/points border' element should have red color
    And the '1'st normal stop order 'p/l border' element should have red color
    Then 'submit button' element should be disabled
    Then 'submit button' element text should be 'Enter valid stop price'
    #12
    When I uncheck 'stop' checkbox
    Then 'submit button' element should be enabled
    Then 'submit button' element text should be 'Place Trade'
    #13
    When I check 'stop' checkbox
    And I expand '1'st linked order types dropdown
    And I select 'guaranteed' from expanded dropdown
    And I fill the '1'st guaranteed stop linked order 'price' with value '0' in the 'current market'
    And 'buy' 'current market' main '1'st stop price validation should be correct and should not appear for '500'ms
    And the '1'st guaranteed stop order 'price border' element should have red color
    And the '1'st guaranteed stop order 'pips/points border' element should have red color
    And the '1'st guaranteed stop order 'p/l border' element should have red color
    Then 'submit button' element should be disabled
    Then 'submit button' element text should be 'Enter valid guaranteed-stop price'
    And I expand '1'st linked order types dropdown
    And I select 'stop' from expanded dropdown
    #14 works on OCO
    And I switch to 'order' tab
    When I click on 'oco' link
    And the 'oco' order area should contain items:
      | itemName             |
      | sell label           |
      | buy label            |
      | order price          |
      | quantity             |
      | advanced ticket link |
      | good till dropdown   |
    #15 opened OCO, works on MAIN part
    When I fill main 'quantity' with value 'min valid+1'
    And I fill 'current market' main price with value not between current prices on 'buy'
    Then 'submit button' element text should be 'Choose quantity'
    #16
    When I check main 'stop' checkbox
    And I fill the main '1'st normal stop linked order 'price' with value 'sell*1.01' in the 'current market'
    And I fill main 'order price' with value 'stop price*0.995'
    And 'buy' 'current market' main '1'st stop price validation should be correct and should not appear for '500'ms
    #17
    When I clear main 'order price' field
    Then 'submit button' element text should be 'Enter a Price'
    Then the main '1'st stop price validation should be cleared
    When I clear main 'quantity' field
    When I uncheck main 'stop' checkbox
    #18 opened OCO, works on OCO part
    When I fill oco 'quantity' with value 'min valid+1'
    And I fill 'current market' oco price with value not between current prices on 'buy'
    Then 'submit button' element text should be 'Choose quantity'
    #19
    When I check oco 'stop' checkbox
    Then the oco '1'st normal stop linked order 'price' element should be enabled
    And the oco '1'st normal stop linked order 'pips/points' element should be enabled
    And the oco '1'st normal stop linked order 'p/l' element should be enabled
    #20, 21
    And I fill the oco '1'st normal stop linked order 'price' with value 'sell*0.89' in the 'current market'
    And I fill oco 'order price' with value 'oco stop price*0.995'
    And 'buy' 'current market' oco '1'st stop price validation should be correct and should not appear for '500'ms
    When I uncheck oco 'stop' checkbox
    #22 actions on the MAIN part
    When I fill main 'quantity' with value 'min valid+1'
    When I clear oco 'order price' field
    Then 'submit button' element text should be 'Enter a Price'
    Then the oco '1'st stop price validation should be cleared
    #23
    And I fill 'current market' main price with value not between current prices on 'buy'
    And I fill 'current market' oco price with value not between current prices on 'sell'
    Then 'submit button' element should be enabled
    Then 'submit button' element text should be 'Place Order'
    #24
    When I check main 'limit' checkbox
    Then the main '2'nd limit linked order 'price' element should be enabled
    And the main '2'nd limit linked order 'pips/points' element should be enabled
    And the main '2'nd limit linked order 'p/l' element should be enabled
    #25
    And I fill the main '2'nd limit linked order 'price' with value 'buy*1.01' in the 'current market'
    Then 'submit button' element should be enabled
    Then 'submit button' element text should be 'Place Order'
    #26
    And I fill main 'order price' with value 'limit price*1.02'
    And 'buy' 'current market' main '2'nd limit price validation should be correct and should not appear for '500'ms
    #27
    When I clear main 'order price' field
    Then 'submit button' element text should be 'Enter a Price'
    Then the main '2'nd stop price validation should be cleared
    When I uncheck main 'limit' checkbox
    #28, 29 actions on the OCO part
    And I fill 'current market' main price with value not between current prices on 'buy'
    # quantity and order price on MAIN should be filled, for submit button able to show "Enter valid ... price"
    And I fill 'current market' oco price with value not between current prices on 'sell'
    When I check oco 'limit' checkbox
    Then the oco '2'nd limit linked order 'price' element should be enabled
    And the oco '2'nd limit linked order 'pips/points' element should be enabled
    And the oco '2'nd limit linked order 'p/l' element should be enabled
    #30
    And I fill the oco '2'nd limit linked order 'price' with value 'buy*1.01' in the 'current market'
    Then 'submit button' element should be enabled
    Then 'submit button' element text should be 'Place Order'
    #31
    And I fill oco 'order price' with value 'oco limit price*1.02'
    And 'buy' 'current market' oco '2'nd limit price validation should be correct and should not appear for '500'ms
    #32
    When I clear oco 'order price' field
    Then 'submit button' element text should be 'Enter a Price'
    Then the oco '2'nd stop price validation should be cleared

  @regression @trailing-stop @wt-176-v4
  Scenario: Trailing Stop
    #1
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I find CFD market
    And I click on 'sell' in the 'current' market
    And I remember min valid quantity for 'current' market
    Then the 'Deal ticket' panel should be visible
    #2
    When I fill 'quantity' with value 'min valid+1'
    When I check 'stop' checkbox
    And I fill the '1'st normal stop linked order 'price' with value 'buy*1.01' in the 'current market'
    When I check 'limit' checkbox
    And I fill the '2'nd limit linked order 'price' with value 'sell*0.99' in the 'current market'
    Then 'submit button' element should be enabled
    Then 'submit button' element text should be 'Place Trade'
    When I uncheck 'limit' checkbox
    #3
    And I expand '1'st linked order types dropdown
    And I select 'trailing' from expanded dropdown
    And the '1'st trailing stop order should contain fields:
      | itemName    |
      | checkbox    |
      | dropdown    |
      | pips/points |
    Then the '1'st trailing stop linked order 'pips/points' input should be autopopulated
    #4
    And I fill the '1'st trailing stop linked order 'pips/points' with value '1000' in the 'current market'
    Then 'submit button' element should be enabled
    Then 'submit button' element text should be 'Place Trade'
    #5
    When I click on 'submit' button
    Then 'confirmation' element text should be 'Trade Executed'
    And 'market name' element text should be 'current market'
    And open sell confirmation message should be displayed correctly
    Then open 'current market' sell attached trailing stop order confirmation message should be displayed correctly
    #6
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
    #7
    And I make 'Positions And Orders' panel active
    Then the 'previously added' market should be present on the list
    And the 'previously added' market should be colored correctly
    #8
    And the 'previously added' market 'stop price' cell should contain 'correct' data
    And the 'previously added' market 'limit price' cell should contain 'set' word
    # set trailing stop price updates rare - assertion skipped
    #9-12 not implemented - necessary mocks

  @regression @guaranteed-stop @wt-177-v5
  Scenario: Guaranteed Stop
    #1
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I find CFD market with available Guaranteed stop in watchlist
    And I click on 'sell' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    And trade direction should be 'sell'
    And I remember min valid quantity for 'current' market
    #2, 3
    When I fill 'quantity' with value 'min valid+1'
    Then 'submit button' element should be enabled
    Then 'submit button' element text should be 'Place Trade'
    #4
    Then the '1'st normal stop order should contain fields:
      | itemName               |
      | checkbox               |
      | dropdown               |
      | price                  |
      | pips/points            |
      | p/l                    |
      | p/l currency indicator |
    When I check 'stop' checkbox
    When I expand '1'st linked order types dropdown
    Then the options from expanded dropdown should be:
      | Stop       |
      | Trailing   |
      | Guaranteed |
    And I select 'guaranteed' from expanded dropdown
    Then the '1'st guaranteed stop order should contain fields:
      | itemName               |
      | checkbox               |
      | dropdown               |
      | price                  |
      | pips/points            |
      | p/l                    |
      | p/l currency indicator |
    #5
    And I fill the '1'st guaranteed stop linked order 'price' with value 'buy*1.5' in the 'current market'
    Then the '1'st guaranteed stop linked order 'pips/points' input should be autopopulated
    And the '1'st guaranteed stop linked order 'p/l' input should be autopopulated
    Then 'submit button' element should be enabled
    Then 'submit button' element text should be 'Place Trade'
    #6
    When I click on 'submit' button
    Then 'confirmation' element text should be 'Trade Executed'
    And 'market name' element text should be 'current market'
    And open sell confirmation message should be displayed correctly
    Then open 'current market' sell attached guaranteed order confirmation message should be displayed correctly
    #7
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
    #8
    And I make 'Positions And Orders' panel active
    Then the 'previously added' market should be present on the list
    And the 'previously added' market should be colored correctly
    #9
    And the 'previously added' market 'stop price' cell should contain 'correct' data
    And the 'previously added' market 'limit price' cell should contain 'set' word
    #10-11 not implemented - necessary mocks

  @regression @guaranteed-stop-tootip-message @wt-1294-v2
  Scenario: Guaranteed Stop tooltip message
    #1, 2
    When I click on Search input
    Then Search modal should be visible
    When I wait for markets loading
    And I fill search field with value 'Germany'
    And I wait for markets loading
    And I find any market with available Guaranteed stop and '1'st message type in search modal
    And I click on 'bid price' in the 'current' market within search modal
    Then the 'Deal ticket' panel should be visible
    And trade direction should be 'sell'
    Then 'trade' ticket type should be 'selected'
    #3
    When I check 'stop' checkbox
    And I expand '1'st linked order types dropdown
    Then the options from expanded dropdown should be:
      | Stop       |
      | Trailing   |
      | Guaranteed |
    And guaranteed tooltip message should be correct for the current market
    When I close panel
    Then the 'Deal ticket' panel should be invisible
    #4
    When I click on Search input
    Then Search modal should be visible
    When I wait for markets loading
    And I fill search field with value 'Germany CFD'
    And I wait for markets loading
    And I find any market with available Guaranteed stop and '2'nd message type in search modal
    And I click on 'ask price' in the 'current' market within search modal
    Then the 'Deal ticket' panel should be visible
    And trade direction should be 'buy'
    Then 'trade' ticket type should be 'selected'
    #5, 6
    When I click on 'advancedTicket' link
    When I expand add stop limit dropdown
    Then the options from expanded dropdown should be:
      | normal stop     |
      | trailing stop   |
      | guaranteed stop |
      | limit           |
    And guaranteed tooltip message should be correct for the current market
    When I close panel
    Then the 'Deal ticket' panel should be invisible

  @regression @auto-populated-fields-pips/points/price/pl @wt-154-v6
  Scenario Outline: Auto-populated fields - Points Away, Price, Estimated P/L
    #1
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I find <Market type> market with available Guaranteed stop in watchlist
    And I remember min valid quantity for 'current' market
    And I click on '<Direction>' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    And trade direction should be '<Direction>'
    And I remember min valid quantity for 'current' market
    Then the 'stop' checkbox is unchecked
    Then the '1'st normal stop linked order 'price' element should be disabled
    And the '1'st normal stop linked order 'pips/points' element should be disabled
    And the '1'st normal stop linked order 'p/l' element should be disabled
    Then the 'limit' checkbox is unchecked
    Then the '2'nd limit linked order 'price' element should be disabled
    And the '2'nd limit linked order 'pips/points' element should be disabled
    And the '2'nd limit linked order 'p/l' element should be disabled
    #2
    When I fill 'quantity' with value '<Quantity>'
    Then 'submit button' element should be enabled
    And 'submit button' element text should be 'Place Trade'
    #3
    And I check 'stop' checkbox
    Then I store data from the main '1'st normal stop linked order
    And I fill the '1'st normal stop linked order 'pips/points' with value '<Pips/Points>' in the 'current market'
    Then the main '1'st normal stop linked order 'price' input should be changed
    And the main '1'st normal stop linked order 'p/l' input should be changed

    When I check 'limit' checkbox
    Then I store data from the main '2'nd limit linked order
    And I fill the '2'nd limit linked order 'pips/points' with value '<Pips/Points>' in the 'current market'
    Then the main '2'nd limit linked order 'price' input should be changed
    And the main '2'nd limit linked order 'p/l' input should be changed
    #4
    When I clear the '1'st normal stop linked order 'pips/points' input field
    Then the '1'st normal stop linked order 'pips/points' input should be blank
    And the '1'st normal stop linked order 'price' input should be blank
    And the '1'st normal stop linked order 'p/l' input should be blank
    When I clear the '2'nd limit linked order 'pips/points' input field
    Then the '2'nd limit linked order 'pips/points' input should be blank
    And the '2'nd limit linked order 'price' input should be blank
    And the '2'nd limit linked order 'p/l' input should be blank
    And 'quantity' input value is 'correct'
    #5
    Then I store data from the main '1'st normal stop linked order
    When I fill the '1'st normal stop linked order 'price' with value '<Stop price>' in the 'current market'
    Then the main '1'st normal stop linked order 'pips/points' input should be changed
    And the main '1'st normal stop linked order 'p/l' input should be changed
    Then I store data from the main '2'nd limit linked order
    When I fill the '2'nd limit linked order 'price' with value '<Limit price>' in the 'current market'
    Then the main '2'nd limit linked order 'pips/points' input should be changed
    And the main '2'nd limit linked order 'p/l' input should be changed
    #6
    When I clear the '1'st normal stop linked order 'price' input field
    Then the '1'st normal stop linked order 'pips/points' input should be blank
    And the '1'st normal stop linked order 'price' input should be blank
    And the '1'st normal stop linked order 'p/l' input should be blank
    When I clear the '2'nd limit linked order 'price' input field
    Then the '2'nd limit linked order 'pips/points' input should be blank
    And the '2'nd limit linked order 'price' input should be blank
    And the '2'nd limit linked order 'p/l' input should be blank
    And 'quantity' input value is 'correct'
    #7
    Then I store data from the main '1'st normal stop linked order
    When I fill the '1'st normal stop linked order 'p/l' with value '<Loss>' in the 'current market'
    Then the main '1'st normal stop linked order 'pips/points' input should be changed
    And the main '1'st normal stop linked order 'price' input should be changed
    Then I store data from the main '2'nd limit linked order
    When I fill the '2'nd limit linked order 'p/l' with value '<Profit>' in the 'current market'
    Then the main '2'nd limit linked order 'pips/points' input should be changed
    And the main '2'nd limit linked order 'price' input should be changed
    #8
    Then I store data from the main '1'st normal stop linked order
    And I store data from the main '2'nd limit linked order
    And I fill 'quantity' with value '<Quantity 2>'
    And the main '1'st normal stop linked order 'price' input should be changed
    Then the main '1'st normal stop linked order 'pips/points' input should be changed
    And the main '2'nd limit linked order 'price' input should be changed
    And the main '2'nd limit linked order 'pips/points' input should be changed
    And I uncheck 'limit' checkbox
    #9 guaranteed stop
    And I expand '1'st linked order types dropdown
    And I select 'guaranteed' from expanded dropdown
    # pips/points: fill new - delete
    Then I store data from the main '1'st guaranteed stop linked order
    And I fill the '1'st guaranteed stop linked order 'pips/points' with value '<Pips/Points>' in the 'current market'
    Then the main '1'st guaranteed stop linked order 'price' input should be changed
    And the main '1'st guaranteed stop linked order 'p/l' input should be changed
    When I clear the '1'st guaranteed stop linked order 'pips/points' input field
    Then the '1'st guaranteed stop linked order 'pips/points' input should be blank
    And the '1'st guaranteed stop linked order 'price' input should be blank
    And the '1'st guaranteed stop linked order 'p/l' input should be blank
    And 'quantity' input value is 'correct'
    # price: fill new - delete
    Then I store data from the main '1'st guaranteed stop linked order
    When I fill the '1'st guaranteed stop linked order 'price' with value '<Stop price>' in the 'current market'
    Then the main '1'st guaranteed stop linked order 'pips/points' input should be changed
    And the main '1'st guaranteed stop linked order 'p/l' input should be changed
    When I clear the '1'st guaranteed stop linked order 'price' input field
    Then the '1'st guaranteed stop linked order 'pips/points' input should be blank
    And the '1'st guaranteed stop linked order 'price' input should be blank
    And the '1'st guaranteed stop linked order 'p/l' input should be blank
    And 'quantity' input value is 'correct'
    #pl: fill new - delete
    Then I store data from the main '1'st guaranteed stop linked order
    When I fill the '1'st guaranteed stop linked order 'p/l' with value '<Loss>' in the 'current market'
    Then the main '1'st guaranteed stop linked order 'pips/points' input should be changed
    And the main '1'st guaranteed stop linked order 'price' input should be changed
    When I clear the '1'st guaranteed stop linked order 'p/l' input field
    Then the '1'st guaranteed stop linked order 'pips/points' input should be blank
    And the '1'st guaranteed stop linked order 'price' input should be blank
    And the '1'st guaranteed stop linked order 'p/l' input should be blank
    And 'quantity' input value is 'correct'
    #10 trailing stop
    When I fill 'quantity' with value '<Quantity>'
    And I expand '1'st linked order types dropdown
    And I select 'trailing' from expanded dropdown
    And I fill the '1'st trailing stop linked order 'pips/points' with value '<Pips/Points>' in the 'current market'
    Then 'submit button' element should be enabled
    And 'submit button' element text should be 'Place Trade'
    When I click on 'submit' button
    Then 'confirmation' element text should be 'Trade executed'
    And open sell confirmation message should be displayed correctly
    Then open 'current market' <Direction> attached trailing stop order confirmation message should be displayed correctly
    #11-20 the second line of the table on SELL direction
    #21
    When I close panel
    Then the 'Deal ticket' panel should be invisible
    When I make 'Watchlist' panel active
    When I expand 'Popular Markets' watchlist
    And I click on '<Direction>' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    When I fill 'quantity' with value '<Quantity>'
    And I check 'stop' checkbox
    When I fill the '1'st normal stop linked order 'price' with value '<Long value>' in the 'current market'
    Then the '1'st normal stop linked order 'pips/points' input should be autopopulated
    And the '1'st normal stop linked order 'p/l' input should be autopopulated
    And  I fill the '1'st normal stop linked order 'pips/points' with value '<Long value>' in the 'current market'
    And the '1'st normal stop linked order 'price' input should be autopopulated
    And the '1'st normal stop linked order 'p/l' input should be autopopulated
    And  I fill the '1'st normal stop linked order 'p/l' with value '<Long value>' in the 'current market'
    Then the '1'st normal stop linked order 'pips/points' input should be autopopulated
    And the '1'st normal stop linked order 'price' input should be autopopulated
    #21
    Then I store data from the main '1'st normal stop linked order
    And I fill 'quantity' with value '<Quantity 2>'
    Then the '1'st normal stop linked order 'pips/points' input should be autopopulated
    And the '1'st normal stop linked order 'price' input should be autopopulated
    And the '1'st normal stop linked order 'price' input should be changed
    Then the '1'st normal stop linked order 'pips/points' input should be changed

    Examples:
      | Market type    | Quantity    | Direction | Pips/Points | Stop price | Limit price | Loss  | Profit | Quantity 2  | Long value             |
      | CFD            | min valid*1 | buy       | 100         | buy*0.9    | buy*1.1     | -1000 | 1000   | min valid*2 | 1111111111111111111111 |
      | Spread         | min valid*1 | sell      | 100         | sell*1.14  | sell*0.91   | -300  | 300    | min valid*2 | 1111111111111111111111 |


  @regression @up-down-arrow-points-control @wt-1266-v4
  Scenario: Up/Down arrow points control
    #1
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I find any market with available Guaranteed stop in watchlist
    And I click on 'sell' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    And trade direction should be 'sell'
    And I remember min valid quantity for 'current' market
    When I fill 'quantity' with value 'min valid+1'
    And I check 'stop' checkbox
    Then the '1'st normal stop linked order 'price' element should be enabled
    And the '1'st normal stop linked order 'pips/points' element should be enabled
    And the '1'st normal stop linked order 'p/l' element should be enabled
    And I check 'limit' checkbox
    Then the '2'nd limit linked order 'price' element should be enabled
    And the '2'nd limit linked order 'pips/points' element should be enabled
    And the '2'nd limit linked order 'p/l' element should be enabled
    #2,3, 7
      # normal stop
    Then I store data from the '1'st normal stop linked order
    When I click on the '1'st normal stop linked order 'pips/points border' field
    And I modify the '1'st normal stop linked order 'pips/points' by typing 'ARROW_UP' key until the value will be equal '1.0'
    And the '1'st normal stop linked order 'price' input should be changed
    Then the '1'st normal stop linked order 'p/l' input should be changed
    Then I store data from the '1'st normal stop linked order
    When I click on the '1'st normal stop linked order 'pips/points border' field
    And I modify the '1'st normal stop linked order 'pips/points' by typing 'ARROW_DOWN' key until the value will be equal '0.0'
    And the '1'st normal stop linked order 'price' input should be changed
    Then the '1'st normal stop linked order 'p/l' input should be changed
    Then the '1'st normal stop linked order 'p/l' input should be '0'
    And I modify the '1'st normal stop linked order 'pips/points' by typing 'ARROW_DOWN' key '3' times
    Then the '1'st normal stop linked order 'pips/points' input should be '0.0'
    Then the '1'st normal stop linked order 'p/l' input should be '0'
      # limit stop
    Then I store data from the '2'nd limit linked order
    When I click on the '2'nd limit linked order 'pips/points border' field
    And I modify the '2'nd limit linked order 'pips/points' by typing 'ARROW_UP' key until the value will be equal '1.0'
    And the '2'nd limit linked order 'price' input should be changed
    Then the '2'nd limit linked order 'p/l' input should be changed
    Then I store data from the '2'nd limit linked order
    When I click on the '2'nd limit linked order 'pips/points border' field
    And I modify the '2'nd limit linked order 'pips/points' by typing 'ARROW_DOWN' key until the value will be equal '0.0'
    And the '2'nd limit linked order 'price' input should be changed
    Then the '2'nd limit linked order 'p/l' input should be changed
    Then the '2'nd limit linked order 'p/l' input should be '0'
    And I modify the '2'nd limit linked order 'pips/points' by typing 'ARROW_DOWN' key '3' times
    Then the '2'nd limit linked order 'pips/points' input should be '0.0'
    Then the '2'nd limit linked order 'p/l' input should be '0'
    #4 step will be later
    #5
    And I modify the '1'st normal stop linked order 'pips/points' by typing 'ARROW_UP' key until the value will be equal '1.0'
    And I modify the '2'nd limit linked order 'pips/points' by typing 'ARROW_UP' key until the value will be equal '1.0'
    Then I store data from the '1'st normal stop linked order
    And I store data from the '2'nd limit linked order
    And I modify 'quantity' by typing 'ARROW_UP' key until the value will be equal 'min valid+4'
    Then the '1'st normal stop linked order 'p/l' input should be changed
    Then the '2'nd limit linked order 'p/l' input should be changed
    Then I store data from the '1'st normal stop linked order
    And I store data from the '2'nd limit linked order
    And I modify 'quantity' by typing 'ARROW_DOWN' key until the value will be equal 'min valid+1'
    Then the '1'st normal stop linked order 'p/l' input should be changed
    Then the '2'nd limit linked order 'p/l' input should be changed
    #8
    When I clear 'quantity' field
    And I modify 'quantity' by typing 'ARROW_UP' key until the value will be equal '1'
    Then I store data from the '1'st normal stop linked order
    And I store data from the '2'nd limit linked order
    And I modify 'quantity' by typing 'ARROW_DOWN' key until the value will be equal '0'
    Then the '1'st normal stop linked order 'p/l' input should be changed
    And the '2'nd limit linked order 'p/l' input should be changed
    And the '1'st normal stop linked order 'p/l' input should be '0'
    And the '2'nd limit linked order 'p/l' input should be '0'
    And I modify 'quantity' by typing 'ARROW_DOWN' key '3' times
    #Then the 'quantity' input should be '0'
    And the '1'st normal stop linked order 'p/l' input should be '0'
    And the '2'nd limit linked order 'p/l' input should be '0'

    #6 guaranteed stop
    When I fill 'quantity' with value 'min valid+1'
    And I expand '1'st linked order types dropdown
    And I select 'guaranteed' from expanded dropdown
    And I uncheck 'stop' checkbox
    And I check 'stop' checkbox
    Then I store data from the main '1'st guaranteed stop linked order
    When I click on the '1'st guaranteed stop linked order 'pips/points border' field
    And I modify the '1'st guaranteed stop linked order 'pips/points' by typing 'ARROW_UP' key until the value will be equal '1.0'
    And the '1'st guaranteed stop linked order 'price' input should be changed
    Then the '1'st guaranteed stop linked order 'p/l' input should be changed
    Then I store data from the '1'st guaranteed stop linked order
    When I click on the '1'st guaranteed stop linked order 'pips/points border' field
    And I modify the '1'st guaranteed stop linked order 'pips/points' by typing 'ARROW_DOWN' key until the value will be equal '0.0'
    And the '1'st guaranteed stop linked order 'price' input should be changed
    Then the '1'st guaranteed stop linked order 'p/l' input should be changed
      # trailing stop
    And I expand '1'st linked order types dropdown
    And I select 'trailing' from expanded dropdown
    When I click on the '1'st trailing stop linked order 'pips/points border' field
    And I modify the '1'st trailing stop linked order 'pips/points' by typing 'ARROW_UP' key until the value will be equal '1.0'
    When I click on the '1'st trailing stop linked order 'pips/points border' field
    And I modify the '1'st trailing stop linked order 'pips/points' by typing 'ARROW_DOWN' key until the value will be equal '0.0'
    #4 all stops on OCO
    When I switch to 'order' tab
    Then 'order' ticket type should be 'selected'
    When I click on 'oco' link
    When I fill oco 'quantity' with value 'min valid+1'
      # normal stop
    When I check oco 'stop' checkbox
    Then I store data from the oco '1'st normal stop linked order
    When I click on the '1'st oco normal stop linked order 'pips/points border' field
    And I modify the '1'st oco normal stop linked order 'pips/points' by typing 'ARROW_UP' key until the value will be equal '1.0'
    And the oco '1'st normal stop linked order 'price' input should be changed
    Then the oco '1'st normal stop linked order 'p/l' input should be changed
    Then I store data from the oco '1'st normal stop linked order
    When I click on the '1'st oco normal stop linked order 'pips/points border' field
    And I modify the '1'st oco normal stop linked order 'pips/points' by typing 'ARROW_DOWN' key until the value will be equal '0.0'
    And the oco '1'st normal stop linked order 'price' input should be changed
    Then the oco '1'st normal stop linked order 'p/l' input should be changed
      # limit stop
    Then I store data from the oco '2'nd limit linked order
    When I click on the '2'nd oco limit linked order 'pips/points border' field
    And I modify the '2'nd oco limit linked order 'pips/points' by typing 'ARROW_UP' key until the value will be equal '1.0'
    And the oco '2'nd limit linked order 'price' input should be changed
    Then the oco '2'nd limit linked order 'p/l' input should be changed
    Then I store data from the oco '2'nd limit linked order
    When I click on the '2'nd oco limit linked order 'pips/points border' field
    And I modify the '2'nd oco limit linked order 'pips/points' by typing 'ARROW_DOWN' key until the value will be equal '0.0'
    And the oco '2'nd limit linked order 'price' input should be changed
    Then the oco '2'nd limit linked order 'p/l' input should be changed
      # trailing stop
    And I expand oco '1'st linked order types dropdown
    And I select 'trailing' from expanded dropdown
    When I click on the '1'st oco trailing stop linked order 'pips/points border' field
    And I modify the '1'st oco trailing stop linked order 'pips/points' by typing 'ARROW_UP' key until the value will be equal '1.0'
    When I click on the '1'st oco trailing stop linked order 'pips/points border' field
    And I modify the '1'st oco trailing stop linked order 'pips/points' by typing 'ARROW_DOWN' key until the value will be equal '0.0'

  @regression @stops-and-limits-points-away-precision @wt-1434-v7
  Scenario Outline: Stops and Limits Points Away Precision
    #1
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I find <Market type> market with available Guaranteed stop in watchlist
    And I click on '<Direction>' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    And trade direction should be '<Direction>'
    And I remember min valid quantity for 'current' market
    When I fill 'quantity' with value 'min valid+1'
    And I check 'stop' checkbox
    Then the '1'st normal stop linked order 'price' element should be enabled
    And the '1'st normal stop linked order 'pips/points' element should be enabled
    And the '1'st normal stop linked order 'p/l' element should be enabled
    And I check 'limit' checkbox
    Then the '2'nd limit linked order 'price' element should be enabled
    And the '2'nd limit linked order 'pips/points' element should be enabled
    And the '2'nd limit linked order 'p/l' element should be enabled
    #2
    When I fill the '1'st normal stop linked order 'price' with value '<Stop price>' in the 'current market'
    Then the '1'st normal stop linked order 'pips/points' input should be autopopulated
    Then the '1'st normal stop linked order 'pips/points' input should be rounded correctly
    When I fill the '2'nd limit linked order 'price' with value '<Limit price>' in the 'current market'
    Then the '2'nd limit linked order 'pips/points' input should be autopopulated
    Then the '2'nd limit linked order 'pips/points' input should be rounded correctly
    And I click on 'submit' button
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
    #3 (2-4 steps - repeate) DT-order-tab
    When I make 'Watchlist' panel active
    And I expand 'Popular Markets' watchlist
    And I click on '<Direction>' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    When I switch to 'order' tab
    Then 'order' ticket type should be 'selected'
    When I fill 'quantity' with value 'min valid+1'
    And I fill 'current market' price with value not between current prices on '<Direction>'
    And I check 'stop' checkbox
    Then the '1'st normal stop linked order 'price' element should be enabled
    And the '1'st normal stop linked order 'pips/points' element should be enabled
    And the '1'st normal stop linked order 'p/l' element should be enabled
    And I check 'limit' checkbox
    Then the '2'nd limit linked order 'price' element should be enabled
    And the '2'nd limit linked order 'pips/points' element should be enabled
    And the '2'nd limit linked order 'p/l' element should be enabled
    When I fill the '1'st normal stop linked order 'price' with value '<Stop price>' in the 'current market'
    Then the '1'st normal stop linked order 'pips/points' input should be autopopulated
    Then the '1'st normal stop linked order 'pips/points' input should be rounded correctly
    When I fill the '2'nd limit linked order 'price' with value '<Limit price>' in the 'current market'
    Then the '2'nd limit linked order 'pips/points' input should be autopopulated
    Then the '2'nd limit linked order 'pips/points' input should be rounded correctly
    And I click on 'submit' button
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
    And I make 'Positions And Orders' panel active
    When I select 'Orders' list
    Then 'Orders' item should be active
    Then the 'previously added' order should be present on the list
    #4
    Then I am on the 'Orders' list
    When I complete 'previously added' market dropdown with value 'Edit Order'
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'edit order'
    When I fill the '1'st normal stop linked order 'price' with value '<New Stop price>' in the 'current market'
    Then the '1'st normal stop linked order 'pips/points' input should be autopopulated
    Then the '1'st normal stop linked order 'pips/points' input should be rounded correctly
    When I fill the '2'nd limit linked order 'price' with value '<New Limit price>' in the 'current market'
    Then the '2'nd limit linked order 'pips/points' input should be autopopulated
    Then the '2'nd limit linked order 'pips/points' input should be rounded correctly
    When I close panel
    #5
    And I make 'Positions And Orders' panel active
    Then I am on the 'Positions' list
    When I complete 'previously added' market dropdown with value 'Amend Position'
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'amend position'
    When I fill the '1'st normal stop linked order 'price' with value '<New Stop price>' in the 'current market'
    Then the '1'st normal stop linked order 'pips/points' input should be autopopulated
    Then the '1'st normal stop linked order 'pips/points' input should be rounded correctly
    When I fill the '2'nd limit linked order 'price' with value '<New Limit price>' in the 'current market'
    Then the '2'nd limit linked order 'pips/points' input should be autopopulated
    Then the '2'nd limit linked order 'pips/points' input should be rounded correctly
    When I close panel
    #6
    When I make 'Watchlist' panel active
    And I expand 'Popular Markets' watchlist
    And I click on '<Direction>' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    When I switch to 'order' tab
    Then 'order' ticket type should be 'selected'
    When I click on 'oco' link
    When I fill oco 'quantity' with value 'min valid+1'
    When I check oco 'stop' checkbox
    Then the oco '1'st normal stop linked order 'price' element should be enabled
    And the oco '1'st normal stop linked order 'pips/points' element should be enabled
    And the oco '1'st normal stop linked order 'p/l' element should be enabled
    When I check oco 'limit' checkbox
    Then the oco '2'nd limit linked order 'price' element should be enabled
    And the oco '2'nd limit linked order 'pips/points' element should be enabled
    And the oco '2'nd limit linked order 'p/l' element should be enabled
    When I fill the oco '1'st normal stop linked order 'price' with value '<New Stop price>' in the 'current market'
    Then the oco '1'st normal stop linked order 'pips/points' input should be autopopulated
    Then the oco '1'st normal stop linked order 'pips/points' input should be rounded correctly
    When I fill the oco '2'nd limit linked order 'price' with value '<New Limit price>' in the 'current market'
    Then the oco '2'nd limit linked order 'pips/points' input should be autopopulated
    Then the oco '2'nd limit linked order 'pips/points' input should be rounded correctly
    #7
    When I click on 'advancedTicket' link
    Then the oco '1'st normal stop linked order 'pips/points' input should be rounded correctly
    Then the oco '2'nd limit linked order 'pips/points' input should be rounded correctly
    #8
    When I click on 'standardTicket' link
    And I expand oco '1'st linked order types dropdown
    And I select 'trailing' from expanded dropdown
    Then the oco '1'st trailing stop linked order 'pips/points' input should be autopopulated
    Then the oco '1'st trailing stop linked order 'pips/points' input should be rounded correctly
    When I close panel
    #9
    When I make 'Watchlist' panel active
    And I expand 'Popular Markets' watchlist
    And I click on '<Direction>' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    When I check 'stop' checkbox
    And I fill the '1'st normal stop linked order 'pips/points' with value '<Pips/Points1>' in the 'current market'
    Then the '1'st normal stop linked order 'price' input should be autopopulated
    Then the '1'st normal stop linked order 'p/l' input should be autopopulated
    Then the '1'st normal stop linked order 'pips/points' input should be rounded correctly
    Then the '1'st stop pips/points validation should be cleared
    When I check 'limit' checkbox
    And I fill the '2'nd limit linked order 'pips/points' with value '<Pips/Points1>' in the 'current market'
    Then the '2'nd limit linked order 'price' input should be autopopulated
    Then the '2'nd limit linked order 'p/l' input should be autopopulated
    Then the '2'nd limit linked order 'pips/points' input should be rounded correctly
    Then the '2'nd limit pips/points validation should be cleared
    #10
    And I fill the '1'st normal stop linked order 'pips/points' with value '<Pips/Points2>' in the 'current market'
    Then the '1'st normal stop linked order 'price' input should be autopopulated
    Then the '1'st normal stop linked order 'p/l' input should be autopopulated
    When I click on '<Direction>' label
    Then the '1'st normal stop linked order 'pips/points' input should be rounded correctly
    And I fill the '2'nd limit linked order 'pips/points' with value '<Pips/Points2>' in the 'current market'
    Then the '2'nd limit linked order 'price' input should be autopopulated
    Then the '2'nd limit linked order 'p/l' input should be autopopulated
    When I click on '<Direction>' label
    Then the '2'nd limit linked order 'pips/points' input should be rounded correctly
    #11
    Then I store data from the main '1'st normal stop linked order
    When I modify the '1'st normal stop linked order 'pips/points' by typing 'ARROW_UP' key '1' time
    Then the '1'st normal stop linked order 'pips/points' input should be 'pips/points+1'
    Then I store data from the main '2'nd limit linked order
    When I modify the '2'nd limit linked order 'pips/points' by typing 'ARROW_UP' key '1' time
    Then the '2'nd limit linked order 'pips/points' input should be 'pips/points+1'
    #12
    Then I store data from the main '1'st normal stop linked order
    When I modify the '1'st normal stop linked order 'pips/points' by typing 'ARROW_DOWN' key '1' time
    Then the '1'st normal stop linked order 'pips/points' input should be 'pips/points-1'
    Then I store data from the main '2'nd limit linked order
    When I modify the '2'nd limit linked order 'pips/points' by typing 'ARROW_DOWN' key '1' time
    Then the '2'nd limit linked order 'pips/points' input should be 'pips/points-1'
    #13 DELETING 1 demical
    When I wait for '10000'
    When I modify the '1'st normal stop linked order 'pips/points' by typing 'BACK_SPACE' key '1' time
    Then the '1'st normal stop linked order 'price' input should be autopopulated
    Then the '1'st normal stop linked order 'p/l' input should be autopopulated
    When I click on '<Direction>' label
    Then the '1'st normal stop linked order 'pips/points' input should be rounded correctly
    When I modify the '2'nd limit linked order 'pips/points' by typing 'BACK_SPACE' key '1' time
    Then the '2'nd limit linked order 'price' input should be autopopulated
    Then the '2'nd limit linked order 'p/l' input should be autopopulated
    When I click on '<Direction>' label
    Then the '2'nd limit linked order 'pips/points' input should be rounded correctly
    #14 Carpetright CFD - is not always opened and has streamed prices
    And I fill the '1'st normal stop linked order 'pips/points' with value '0.8' in the 'current market'
    Then the '1'st normal stop linked order 'price' input should be autopopulated
    Then the '1'st normal stop linked order 'p/l' input should be autopopulated
    And I fill the '2'nd limit linked order 'pips/points' with value '0.8' in the 'current market'
    Then the '2'nd limit linked order 'price' input should be autopopulated
    Then the '2'nd limit linked order 'p/l' input should be autopopulated
    #15
    When I store data from the main '1'st normal stop linked order
    And I modify the '1'st normal stop linked order 'pips/points' by typing 'ARROW_UP' key until the value will be equal '3.8'
    Then the '1'st normal stop linked order 'price' input should be changed
    When I store data from the '2'nd limit linked order
    And I modify the '2'nd limit linked order 'pips/points' by typing 'ARROW_UP' key until the value will be equal '3.8'
    Then the '2'st limit linked order 'price' input should be changed
    #16 skipped - EU Stock 50 CFD - is not always opened and has streamed prices

    Examples:
      | Market type | Direction | Stop price | New Stop price | Limit price | New Limit price | Pips/Points1 | Pips/Points2 |
      | CFD         | buy       | buy*0.9    | buy*0.8        | buy*1.1     | buy*1.2         | 100.999999   | 100          |
      | Spread      | sell      | sell*1.1   | sell*1.2       | sell*0.9    | sell*0.8        | 100.999999   | 100          |

  @regression @last-0-digits-for-stop-and-limit @wt-1569-v3
  Scenario: Last 0 digits for Stops/Limits in Confirmation modal and Positions and Orders
    #1
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I click on 'buy' in the 'AUD/USD' market
    Then the 'Deal ticket' panel should be visible
    And I remember min valid quantity for 'current' market
    When I fill 'quantity' with value 'min valid+1'
    #2
    And I check 'stop' checkbox
    Then the '1'st normal stop linked order 'price' element should be enabled
    And the '1'st normal stop linked order 'pips/points' element should be enabled
    And the '1'st normal stop linked order 'p/l' element should be enabled
    And I check 'limit' checkbox
    Then the '2'nd limit linked order 'price' element should be enabled
    And the '2'nd limit linked order 'pips/points' element should be enabled
    And the '2'nd limit linked order 'p/l' element should be enabled
    When I fill the '1'st normal stop linked order 'price' with value '0.70000' in the 'current market'
    When I fill the '2'nd limit linked order 'price' with value '0.86000' in the 'current market'
    Then the '1'st normal stop linked order 'price' input should be '0.70000'
    Then the '2'nd limit linked order 'price' input should be '0.86000'
    Then I store data from the '1'st normal stop linked order
    Then I store data from the '2'nd limit linked order
    #3
    And I click on 'submit' button
    Then 'confirmation' element text should be 'Trade executed'
    And 'market name' element text should be 'current market'
    And open buy 'current market' trade confirmation message should be correct
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
    #5
    And I make 'Positions And Orders' panel active
    Then the 'previously added' order should be present on the list
    And the 'previously added' market 'stop price' cell should contain 'correct' data
    And the 'previously added' market 'limit price' cell should contain 'correct' data
    #4
    Then I am on the 'Positions' list
    When I complete 'previously added' market dropdown with value 'Amend Position'
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'amend position'
    And the '1'st normal stop linked order 'price' input should be 'correct'
    And the '2'nd limit linked order 'price' input should be 'correct'
    When I close 'Deal ticket' panel
    And I delete 'position' 'AUD/USD'
    #6, 7
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I click on 'sell' in the 'AUD/USD' market
    Then the 'Deal ticket' panel should be visible
    And I remember min valid quantity for 'current' market
    When I switch to 'order' tab
    Then 'order' ticket type should be 'selected'
    When I fill 'quantity' with value 'min valid*5'
    And I fill 'order price' with value '0.69000'
    Then 'submit button' element should be enabled
    And 'submit button' element text should be 'Place Order'
    #8
    When I click on 'advancedTicket' link
    And I check 'stop' checkbox
    When I fill the '1'st normal stop linked order 'quantity' with value 'min valid*1' in the 'current market'
    And I fill the '1'st normal stop linked order 'price' with value '0.70000' in the 'current market'
    Then the '1'st normal stop linked order 'price' input should be '0.70000'
    Then I store data from the '1'st normal stop linked order

    And I check 'limit' checkbox
    When I fill the '2'nd limit linked order 'quantity' with value 'min valid*1' in the 'current market'
    When I fill the '2'nd limit linked order 'price' with value '0.67000' in the 'current market'
    Then the '2'nd limit linked order 'price' input should be '0.67000'
    Then I store data from the '2'nd limit linked order

    When I expand add stop limit dropdown
    And I select 'Stop' from expanded dropdown
    Then the number of linked orders should be '3'
    When I fill the '3'rd normal stop linked order 'quantity' with value 'min valid*1' in the 'current market'
    And I fill the '3'rd normal stop linked order 'price' with value '0.70000' in the 'current market'
    Then the '3'rd normal stop linked order 'price' input should be '0.70000'
    Then I store data from the '3'rd normal stop linked order

    When I expand add stop limit dropdown
    And I select 'Limit' from expanded dropdown
    Then the number of linked orders should be '4'
    When I fill the '4'th limit linked order 'quantity' with value 'min valid*1' in the 'current market'
    And I fill the '4'th limit linked order 'price' with value '0.67000' in the 'current market'
    Then the '4'th limit linked order 'price' input should be '0.67000'
    Then I store data from the '4'th limit linked order

    When I expand add stop limit dropdown
    And I select 'Trailing' from expanded dropdown
    Then the number of linked orders should be '5'
    When I fill the '5'th trailing stop linked order 'quantity' with value 'min valid*1' in the 'current market'
    When I fill the '5'th trailing stop linked order 'pips/points' with value '100' in the 'current market'
    Then I store data from the '5'th trailing stop linked order

    Then 'submit button' element should be enabled
    And 'submit button' element text should be 'Place Order'
    #10
    When I click on 'submit' button
    Then 'confirmation' element text should be 'Order placed'
    And 'market name' element text should be 'current market'
    And the '1'st normal stop linked order confirmation message should be correct
    And the '2'nd limit linked order confirmation message should be correct
    And the '3'rd normal stop linked order confirmation message should be correct
    And the '4'th limit linked order confirmation message should be correct
    And the '5'th trailing stop linked order confirmation message should be correct
    When I click on 'ok' button
    #11
    Then I make 'Positions And Orders' panel active
    Then I am on the 'Orders' list
    Then the 'previously added' order should be present on the list
    And the 'previously added' market 'stop price' cell should contain 'multiple' word
    And the 'previously added' market 'limit price' cell should contain 'multiple' word
    #12, 13
    When I click on 'stop price' in the '1'st order
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'edit order'
    And the '1'st normal stop linked order 'price' input should be 'correct'
    And the '2'nd limit linked order 'price' input should be 'correct'
    And the '3'rd normal stop linked order 'price' input should be 'correct'
    And the '4'th limit linked order 'price' input should be 'correct'
    When I close 'Deal ticket' panel
    #13
    Then I make 'Positions And Orders' panel active
    Then I am on the 'Orders' list
    When I complete 'previously added' order dropdown with value 'Edit Order'
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'edit order'
    And the '1'st normal stop linked order 'price' input should be 'correct'
    And the '2'nd limit linked order 'price' input should be 'correct'
    And the '3'rd normal stop linked order 'price' input should be 'correct'
    And the '4'th limit linked order 'price' input should be 'correct'
    When I close 'Deal ticket' panel
    And I delete 'order' 'AUD/USD'
    When I clean memory object
    #14
    # OCO works on MAIN part DT
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I click on 'sell' in the 'AUD/USD' market
    Then the 'Deal ticket' panel should be visible
    And I remember min valid quantity for 'current' market
    When I switch to 'order' tab
    Then 'order' ticket type should be 'selected'
    When I click on 'oco' link
    When I fill main 'quantity' with value 'min valid*5'
    And I fill main 'order price' with value '0.7100'
    When I click on main 'advancedTicket' link
    And I check main 'stop' checkbox
    When I fill the main '1'st normal stop linked order 'quantity' with value 'min valid*1' in the 'current market'
    And I fill the main '1'st normal stop linked order 'price' with value '0.72000' in the 'current market'
    Then the main '1'st normal stop linked order 'price' input should be '0.72000'
    Then I store data from the main '1'st normal stop linked order
    And I check main 'limit' checkbox
    When I fill the main '2'nd limit linked order 'quantity' with value 'min valid*1' in the 'current market'
    When I fill the main '2'nd limit linked order 'price' with value '0.70000' in the 'current market'
    Then the main '2'nd limit linked order 'price' input should be '0.70000'
    Then I store data from the main '2'nd limit linked order
    When I expand main add stop limit dropdown
    And I select 'Stop' from expanded dropdown
    Then the number of main linked orders should be '3'
    When I fill the main '3'rd normal stop linked order 'quantity' with value 'min valid*1' in the 'current market'
    And I fill the main '3'rd normal stop linked order 'price' with value '0.72000' in the 'current market'
    Then the main '3'rd normal stop linked order 'price' input should be '0.72000'
    Then I store data from the main '3'rd normal stop linked order
    When I expand main add stop limit dropdown
    And I select 'Limit' from expanded dropdown
    Then the number of main linked orders should be '4'
    When I fill the main '4'th limit linked order 'quantity' with value 'min valid*1' in the 'current market'
    And I fill the main '4'th limit linked order 'price' with value '0.70000' in the 'current market'
    Then the main '4'th limit linked order 'price' input should be '0.70000'
    Then I store data from the main '4'th limit linked order
    When I expand main add stop limit dropdown
    And I select 'Trailing' from expanded dropdown
    Then the number of main linked orders should be '5'
    When I fill the main '5'th trailing stop linked order 'quantity' with value 'min valid*1' in the 'current market'
    When I fill the main '5'th trailing stop linked order 'pips/points' with value '100' in the 'current market'
    Then I store data from the main '5'th trailing stop linked order
    #OCO works on OCO part DT
    When I fill oco 'quantity' with value 'min valid*5'
    And I fill oco 'order price' with value '0.74000'

    When I click on oco 'advancedTicket' link
    And I check oco 'stop' checkbox
    When I fill the oco '1'st normal stop linked order 'quantity' with value 'min valid*1' in the 'current market'
    And I fill the oco '1'st normal stop linked order 'price' with value '0.75000' in the 'current market'
    Then the oco '1'st normal stop linked order 'price' input should be '0.75000'
    Then I store data from the oco '1'st normal stop linked order
    And I check oco 'limit' checkbox
    When I fill the oco '2'nd limit linked order 'quantity' with value 'min valid*1' in the 'current market'
    When I fill the oco '2'nd limit linked order 'price' with value '0.69000' in the 'current market'
    Then the oco '2'nd limit linked order 'price' input should be '0.69000'
    Then I store data from the oco '2'nd limit linked order
    When I expand oco add stop limit dropdown
    And I select 'Stop' from expanded dropdown
    Then the number of oco linked orders should be '3'
    When I fill the oco '3'rd normal stop linked order 'quantity' with value 'min valid*1' in the 'current market'
    And I fill the oco '3'rd normal stop linked order 'price' with value '0.75000' in the 'current market'
    Then the oco '3'rd normal stop linked order 'price' input should be '0.75000'
    Then I store data from the oco '3'rd normal stop linked order
    When I expand oco add stop limit dropdown
    And I select 'Limit' from expanded dropdown
    Then the number of oco linked orders should be '4'
    When I fill the oco '4'th limit linked order 'quantity' with value 'min valid*1' in the 'current market'
    And I fill the oco '4'th limit linked order 'price' with value '0.69000' in the 'current market'
    Then the oco '4'th limit linked order 'price' input should be '0.69000'
    Then I store data from the oco '4'th limit linked order
    When I expand oco add stop limit dropdown
    And I select 'Trailing' from expanded dropdown
    Then the number of oco linked orders should be '5'
    When I fill the oco '5'th trailing stop linked order 'quantity' with value 'min valid*1' in the 'current market'
    When I fill the oco '5'th trailing stop linked order 'pips/points' with value '100' in the 'current market'
    Then I store data from the oco '5'th trailing stop linked order
    Then 'submit button' element should be enabled
    And 'submit button' element text should be 'Place Order'
    When I click on 'submit' button
    Then 'confirmation' element text should be 'Order placed'
    And 'market name' element text should be 'current market'
    And the main '1'st normal stop linked order confirmation message should be correct
    And the main '2'nd limit linked order confirmation message should be correct
    And the main '3'rd normal stop linked order confirmation message should be correct
    And the main '4'th limit linked order confirmation message should be correct
    And the main '5'th trailing stop linked order confirmation message should be correct
    And the oco '1'st normal stop linked order confirmation message should be correct
    And the oco '2'nd limit linked order confirmation message should be correct
    And the oco '3'rd normal stop linked order confirmation message should be correct
    And the oco '4'th limit linked order confirmation message should be correct
    And the oco '5'th trailing stop linked order confirmation message should be correct
    When I click on 'ok' button
    #
    Then I make 'Positions And Orders' panel active
    Then I am on the 'Orders' list
    Then the 'previously added' order should be present on the list
    And the 'previously added' market 'stop price' cell should contain 'multiple' word
    And the 'previously added' market 'limit price' cell should contain 'multiple' word
    #
    When I click on 'stop price' in the '1'st order
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'edit order'
    And the main '1'st normal stop linked order 'price' input should be 'correct'
    And the main '2'nd limit linked order 'price' input should be 'correct'
    And the main '3'rd normal stop linked order 'price' input should be 'correct'
    And the main '4'th limit linked order 'price' input should be 'correct'
    And the oco '1'st normal stop linked order 'price' input should be 'correct'
    And the oco '2'nd limit linked order 'price' input should be 'correct'
    And the oco '3'rd normal stop linked order 'price' input should be 'correct'
    And the oco '4'th limit linked order 'price' input should be 'correct'
    When I close 'Deal ticket' panel
    And I delete 'order' 'AUD/USD'
    #16, 17 - reqires mocks, because implementation is very unstable without mocks

  @regression @select-and-focus-into-stop-and-limit-field-when-clicking @wt-1625-v1
  Scenario: Select/Focus into Stop/Limit field when clicking any stop or limit field
    #1
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I find any market
    And I click on 'sell' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    And trade direction should be 'sell'
    And I remember min valid quantity for 'current' market
    When I fill 'quantity' with value 'min valid+1'
    #2
    Then the 'stop' checkbox is unchecked
    Then the 'limit' checkbox is unchecked
    When I click on the '1'st normal stop linked order 'pips/points border' field
    Then the 'stop' checkbox is checked
    Then the '1'st normal stop linked order 'price' element should be enabled
    And the '1'st normal stop linked order 'pips/points' element should be enabled
    And the '1'st normal stop linked order 'p/l' element should be enabled
    And the '1'st normal stop linked order 'pips/points' field should be focused
    Then I store data from the '1'st normal stop linked order
    And I modify the '1'st normal stop linked order 'pips/points' by typing 'ARROW_UP' key '1' times
    Then the '1'st normal stop linked order 'pips/points' input should be '1.0'
    And the '1'st normal stop linked order 'price' input should be changed
    Then the '1'st normal stop linked order 'p/l' input should be changed
    When I click on the '2'nd limit linked order 'pips/points border' field
    Then the 'limit' checkbox is checked
    Then the '2'nd limit linked order 'price' element should be enabled
    And the '2'nd limit linked order 'pips/points' element should be enabled
    And the '2'nd limit linked order 'p/l' element should be enabled
    And the '2'nd limit linked order 'pips/points' field should be focused
    Then I store data from the '2'nd limit linked order
    And I modify the '2'nd limit linked order 'pips/points' by typing 'ARROW_UP' key '1' times
    Then the '2'nd limit linked order 'pips/points' input should be '1.0'
    And the '2'nd limit linked order 'price' input should be changed
    Then the '2'nd limit linked order 'p/l' input should be changed
    When I uncheck 'stop' checkbox
    And I uncheck 'limit' checkbox
    And I click on 'submit' button
    And I click on 'ok' button
    #3
    When I make 'Positions And Orders' panel active
    And I am on the 'Positions' list
    Then the 'previously added' market should be present on the list
    #4 Amend Position stops and limits
    When I complete 'previously added' market dropdown with value 'Amend Position'
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'amend position'
    Then the 'stop' checkbox is unchecked
    Then the 'limit' checkbox is unchecked
    When I click on the '1'st normal stop linked order 'pips/points border' field
    Then the 'stop' checkbox is checked
    Then the '1'st normal stop linked order 'price' element should be enabled
    And the '1'st normal stop linked order 'pips/points' element should be enabled
    And the '1'st normal stop linked order 'p/l' element should be enabled
    And the '1'st normal stop linked order 'pips/points' field should be focused
    Then I store data from the '1'st normal stop linked order
    And I modify the '1'st normal stop linked order 'pips/points' by typing 'ARROW_UP' key '1' times
    Then the '1'st normal stop linked order 'pips/points' input should be '1.0'
    And the '1'st normal stop linked order 'price' input should be changed
    Then the '1'st normal stop linked order 'p/l' input should be changed
    When I click on the '2'nd limit linked order 'pips/points border' field
    Then the 'limit' checkbox is checked
    Then the '2'nd limit linked order 'price' element should be enabled
    And the '2'nd limit linked order 'pips/points' element should be enabled
    And the '2'nd limit linked order 'p/l' element should be enabled
    And the '2'nd limit linked order 'pips/points' field should be focused
    Then I store data from the '2'nd limit linked order
    And I modify the '2'nd limit linked order 'pips/points' by typing 'ARROW_UP' key '1' times
    Then the '2'nd limit linked order 'pips/points' input should be '1.0'
    And the '2'nd limit linked order 'price' input should be changed
    Then the '2'nd limit linked order 'p/l' input should be changed
    When I close 'Deal ticket' panel
    #5
    When I add order with parameters:
      | MarketName | EUR/USD |
      | Direction  | Buy     |
      | Quantity   | 1000    |
      | Price      | 100     |
    And I make 'Positions And Orders' panel active
    And I select 'Orders' list
    Then the 'previously added' order should be present on the list
    #6 Edit order stops and limits
    When I complete 'previously added' order dropdown with value 'Edit Order'
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'edit order'
    Then the 'stop' checkbox is unchecked
    Then the 'limit' checkbox is unchecked
    When I click on the '1'st normal stop linked order 'pips/points border' field
    Then the 'stop' checkbox is checked
    Then the '1'st normal stop linked order 'price' element should be enabled
    And the '1'st normal stop linked order 'pips/points' element should be enabled
    And the '1'st normal stop linked order 'p/l' element should be enabled
    And the '1'st normal stop linked order 'pips/points' field should be focused
    Then I store data from the '1'st normal stop linked order
    And I modify the '1'st normal stop linked order 'pips/points' by typing 'ARROW_UP' key '1' times
    Then the '1'st normal stop linked order 'pips/points' input should be '1.0'
    And the '1'st normal stop linked order 'price' input should be changed
    Then the '1'st normal stop linked order 'p/l' input should be changed
    When I click on the '2'nd limit linked order 'pips/points border' field
    Then the 'limit' checkbox is checked
    Then the '2'nd limit linked order 'price' element should be enabled
    And the '2'nd limit linked order 'pips/points' element should be enabled
    And the '2'nd limit linked order 'p/l' element should be enabled
    And the '2'nd limit linked order 'pips/points' field should be focused
    Then I store data from the '2'nd limit linked order
    And I modify the '2'nd limit linked order 'pips/points' by typing 'ARROW_UP' key '1' times
    Then the '2'nd limit linked order 'pips/points' input should be '1.0'
    And the '2'nd limit linked order 'price' input should be changed
    Then the '2'nd limit linked order 'p/l' input should be changed
    When I close 'Deal ticket' panel
    #7 on advanced ticket
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I find any market
    And I click on 'sell' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    And trade direction should be 'sell'
    And I remember min valid quantity for 'current' market
    #8, 9
    When I click on 'advancedTicket' link
    And the '1'st normal stop order should contain fields:
      | itemName      |
      | checkbox      |
      | dropdown      |
      | quantity      |
      | price         |
      | pips/points   |
      | p/l           |
      | applicability |
    When I expand 'add stop limit dropdown link' dropdown
    Then the options from expanded dropdown should be:
      | Normal stop   |
      | Trailing stop |
      | Limit         |
    #10, 11
    When I check 'stop' checkbox
    When I expand '1'st linked order types dropdown
    Then the options from expanded dropdown should be:
      | Stop     |
      | Trailing |
    And I select 'Stop' from expanded dropdown
    Then the '1'st normal stop linked order 'price' element should be enabled
    And the '1'st normal stop linked order 'pips/points' element should be enabled
    And the '1'st normal stop linked order 'p/l' element should be enabled
    And the '1'st normal stop linked order 'price' field should be not focused
    And the '1'st normal stop linked order 'pips/points' field should be not focused
    And the '1'st normal stop linked order 'p/l' field should be not focused

  @regression @relogin-for-currencies-test @relogin-default-user @stop-and-limit-currency-codes @wt-1498-v1
  Scenario Outline: Stop and Limit Currency codes
    #1
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I find <Market type> market with available Guaranteed stop in watchlist
    And I click on 'sell' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    And trade direction should be 'sell'
    And I remember min valid quantity for 'current' market
    And I fill 'quantity' with value 'min valid+1'
    Then the 'current market' '1'st normal stop linked order p/l currency sign should be correct
    And the 'current market' '2'nd limit linked order p/l currency sign should be correct
    #2
    When I check 'stop' checkbox
    And I fill the '1'st normal stop linked order 'pips/points' with value '100' in the 'current market'
    Then the '1'st normal stop linked order 'price' input should be autopopulated
    And the '1'st normal stop linked order 'p/l' input should be autopopulated
    And the '1'st normal stop linked order 'p/l' element color should be red
    And I check 'limit' checkbox
    And I fill the '2'nd limit linked order 'pips/points' with value '100' in the 'current market'
    Then the '2'nd limit linked order 'price' input should be autopopulated
    And the '2'nd limit linked order 'p/l' input should be autopopulated
    And the '2'nd limit linked order 'p/l' element color should be blue
    #3
    When I fill the '1'st normal stop linked order 'p/l' with value '111111111111111111111111111' in the 'current market'
    Then the '1'st normal stop order should contain fields:
      | itemName               |
      | p/l currency indicator |
      | p/l                    |
    When I fill the '2'nd limit linked order 'p/l' with value '111111111111111111111111111' in the 'current market'
    And the '2'nd limit order should contain fields:
      | itemName               |
      | p/l currency indicator |
      | p/l                    |
    #4
    When I click on 'advancedTicket' link
    And I uncheck 'stop' checkbox
    And I uncheck 'limit' checkbox
    When I expand add stop limit dropdown
    And I select 'Stop' from expanded dropdown
    Then the number of linked orders should be '3'
    When I fill the '3'rd normal stop linked order 'quantity' with value 'min valid*1' in the 'current market'
    When I fill the '3'rd normal stop linked order 'pips/points' with value '100' in the 'current market'
    Then the '3'rd normal stop linked order 'price' input should be autopopulated
    And the '3'rd normal stop linked order 'p/l' input should be autopopulated
    And the '3'rd normal stop linked order 'p/l' element color should be red
    When I expand add stop limit dropdown
    And I select 'Limit' from expanded dropdown
    Then the number of linked orders should be '4'
    When I fill the '4'th limit linked order 'quantity' with value 'min valid*1' in the 'current market'
    And I fill the '4'th limit linked order 'pips/points' with value '100' in the 'current market'
    Then the '4'th limit linked order 'price' input should be autopopulated
    And the '4'th limit linked order 'p/l' input should be autopopulated
    And the '4'th limit linked order 'p/l' element color should be blue
    When I expand add stop limit dropdown
    And I select 'Guaranteed' from expanded dropdown
    Then the number of linked orders should be '5'
    When I fill the '5'th guaranteed stop linked order 'quantity' with value 'min valid*1' in the 'current market'
    When I fill the '5'th guaranteed stop linked order 'pips/points' with value '100' in the 'current market'
    Then the '5'th guaranteed stop linked order 'price' input should be autopopulated
    And the '5'th guaranteed stop linked order 'p/l' input should be autopopulated
    And the '5'th guaranteed stop linked order 'p/l' element color should be red
    When I fill the '3'rd normal stop linked order 'p/l' with value '111111111111111111111111111' in the 'current market'
    Then the '3'rd normal stop order should contain fields:
      | itemName               |
      | p/l currency indicator |
      | p/l                    |
    When I fill the '4'th limit linked order 'p/l' with value '111111111111111111111111111' in the 'current market'
    Then the '4'th limit order should contain fields:
      | itemName               |
      | p/l currency indicator |
      | p/l                    |
    When I fill the '5'th guaranteed stop linked order 'p/l' with value '111111111111111111111111111' in the 'current market'
    Then the '5'th guaranteed stop order should contain fields:
      | itemName               |
      | p/l currency indicator |
      | p/l                    |
    When I close panel
    Then the 'Deal ticket' panel should be invisible
    #5-8 steps within table on Spread market

    Examples:
      | Market type |
      | CFD         |
      | Spread      |

  # necessary available market Microsoft Corp CFD (id=133515) and with available Guaranteed stop
  @regression @Microsoft-Corp-CFD @stop-values-after-error @wt-1253-v3
  Scenario: Stop values after server error
    #1, 2
    When I click on Search input
    Then Search modal should be visible
    When I wait for markets loading
    Then Search modal element 'result header' should be visible
    And I fill search field with value 'Microsoft Corp CFD'
    And I wait for markets loading
    When I click on 'buy on browse' in the '1'st market within search modal
    Then the 'Deal ticket' panel should be visible
    When I fill 'quantity' with value '1000'
    Then 'submit button' element text should be 'Place Trade'
    #3, 4
    When I click on 'advancedTicket' link
    And I expand add stop limit dropdown
    And I select 'Guaranteed stop' from expanded dropdown
    And I fill the '3'rd guaranteed stop linked order 'quantity' with value '1000' in the 'current market'
    And I fill the '3'rd guaranteed stop linked order 'pips/points' with value '100' in the 'current market'
    Then I store data from the '3'rd guaranteed stop linked order
    Then 'submit button' element should be enabled
    And 'submit button' element text should be 'Place Trade'
    When I click on 'submit' button
    And 'ticket failure' element text should be 'Trade not filled'
    And 'error message' element text should be 'The Quantity entered exceeds the maximum allowed for guaranteed orders in this market.'
    #5
    When I click on 'ok' button
    Then 'submit button' element text should be 'Place Trade'
    And I fill the '3'rd guaranteed stop linked order 'quantity' with value '2000' in the 'current market'
    #Then the '3'rd guaranteed stop linked order 'price' input should be changed
    And the '3'rd guaranteed stop linked order 'p/l' input should be changed
    And the '3'rd guaranteed stop linked order 'pips/points' input should be '100.0'
    When I close panel

  @regression @edit-amalgamated-buy-position @wt-1022-v3
  Scenario: Edit Amalgamated Buy Position
    #pre
    And I add position with parameters:
      | MarketName | USD/JPY (per 0.01) CFD |
      | Direction  | buy                    |
      | Quantity   | 500                    |
    And I add position with parameters:
      | MarketName | USD/JPY (per 0.01) CFD |
      | Direction  | buy                    |
      | Quantity   | 400                    |
    And I add position with parameters:
      | MarketName | USD/JPY (per 0.01) CFD |
      | Direction  | buy                    |
      | Quantity   | 300                    |
    And I add position with parameters:
      | MarketName | USD/JPY (per 0.01) CFD |
      | Direction  | buy                    |
      | Quantity   | 200                    |
    And I add position with parameters:
      | MarketName | USD/JPY (per 0.01) CFD |
      | Direction  | buy                    |
      | Quantity   | 100                    |
    Then the 'Positions And Orders' panel should be visible
    And the 'previously added' market should be present on the list
    And the 'previously added' market should be displayed as 'multi'
    #1
    And the 'previously added' market position cell should contain 'buy 1500' direction and quantity
    When I click on 'delete' in the 'USD/JPY (per 0.01) CFD' market
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'close positions'
    And cursor is placed in the 'close quantity' field
    And the trade ticket standard view panel should contain items:
      | itemName      |
      | close section |
    And 'close label' element text should be 'close'
    And the trade ticket standard view panel should not contain items:
      | itemName     |
      | edit section |
    And amalgamated position close info message should be correct
    And 'submit button' element text should be 'Close Multiple Positions'
    #2
    When I fill 'quantity' with value '600'
    Then amalgamated position close info message should be correct
    And 'submit button' element text should be 'Reduce Position'
    #3
    When I click on 'submit' button
    Then 'confirmation' element text should be 'Trade executed'
    Then '2' confirmation messages about close amalgamated positions should be displayed
    #4
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
    And the 'Positions And Orders' panel should be visible
    When I expand 'previously added' multi-market
    Then the 'previously added' multi-market should be 'expanded'
    And the 'previously added' market's sub-markets count should be '4'
    And the 'previously added' market's sub-market 1 'position' cell should contain 'buy 300' data
    And the 'previously added' market's sub-market 2 'position' cell should contain 'buy 300' data
    And the 'previously added' market's sub-market 3 'position' cell should contain 'buy 200' data
    And the 'previously added' market's sub-market 4 'position' cell should contain 'buy 100' data


  @regression @close-amalgamated-buy-position @wt-1316-v5
  Scenario: Close Amalgamated Buy Position
    #pre
    And I add position with parameters:
      | MarketName | USD/JPY (per 0.01) CFD |
      | Direction  | buy                    |
      | Quantity   | 600                    |
    And I add position with parameters:
      | MarketName | USD/JPY (per 0.01) CFD |
      | Direction  | buy                    |
      | Quantity   | 200                    |
    And I add position with parameters:
      | MarketName | USD/JPY (per 0.01) CFD |
      | Direction  | buy                    |
      | Quantity   | 100                    |
    #1
    Then the 'Positions And Orders' panel should be visible
    And the 'previously added' market should be present on the list
    And the 'previously added' market should be displayed as 'multi'
    #2
    When I click on 'delete' in the 'USD/JPY (per 0.01) CFD' market
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'close positions'
    And 'close quantity' input should be predefined with '900'
    When I close 'Deal ticket' panel
    #3
    And the 'Positions And Orders' panel should be visible
    When I expand 'previously added' multi-market
    And I click on 'delete' in the 'current' multi-market's '1'st sub-market
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'amend position'
    And 'close quantity' input should be predefined with '600'
    When I close 'Deal ticket' panel
    #4#5
    And the 'Positions And Orders' panel should be visible
    When I click on 'delete' in the 'USD/JPY (per 0.01) CFD' market
    Then the 'Deal ticket' panel should be visible
    And cursor is placed in the 'close quantity' field
#    And 'close quantity' input should be active
    # OPENED issue: https://jira.gaincapital.com/browse/TPDWT-16845
    # And current amalgamated position information should be correct
    And 'close quantity' input should be predefined with '900'
    And 'ticket label' element text should be 'close positions'
    And amalgamated position close info message should be correct
    And 'submit button' element text should be 'Close Multiple Positions'
    #6
    When I fill 'quantity' with value '300'
    Then amalgamated position close info message should be correct
    When I click on 'submit' button
    Then 'confirmation' element text should be 'Trade executed'
    Then '1' confirmation messages about close amalgamated positions should be displayed
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
    And the 'Positions And Orders' panel should be visible
    When I expand 'previously added' multi-market
    Then the 'previously added' multi-market should be 'expanded'
    And the 'previously added' market's sub-markets count should be '3'
    And the 'previously added' market's sub-market 1 'position' cell should contain 'buy 300' data
    And the 'previously added' market's sub-market 2 'position' cell should contain 'buy 200' data
    And the 'previously added' market's sub-market 3 'position' cell should contain 'buy 100' data
    #7
    When I click on 'delete' in the 'USD/JPY (per 0.01) CFD' market
    Then the 'Deal ticket' panel should be visible
    When I fill 'quantity' with value '125'
    Then amalgamated position close info message should be correct
    When I click on 'submit' button
    When I click on 'ok' button after waiting
    Then the 'Deal ticket' panel should be invisible
    And the 'Positions And Orders' panel should be visible
    And the 'previously added' market's sub-markets count should be '3'
    And the 'previously added' market's sub-market 1 'position' cell should contain 'buy 175' data
    And the 'previously added' market's sub-market 2 'position' cell should contain 'buy 200' data
    And the 'previously added' market's sub-market 3 'position' cell should contain 'buy 100' data
    #8
    When I click on 'delete' in the 'USD/JPY (per 0.01) CFD' market
    Then the 'Deal ticket' panel should be visible
    When I fill 'quantity' with value '500'
    Then 'submit button' element text should be 'Quantity too high'
    And 'submit button' element should be disabled
    #9
    When I fill 'quantity' with value '450'
    Then amalgamated position close info message should be correct after changing
    And I click on 'submit' button after waiting
    Then 'ticket failure' element text should be 'Trade not filled'
    # https://jira.gaincapital.com/browse/TPDWT-16854
    And 'error message' element text should be 'The Quantity entered is below the minimum allowed for the market.'
    When I click on 'ok' button
    #10
    When I fill 'quantity' with value '475'
    And I click on 'submit' button after waiting
    Then 'confirmation' element text should be 'Trade executed'
    Then '3' confirmation messages about close amalgamated positions should be displayed
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
    And the 'Positions And Orders' panel should be visible
    And the 'previously added' market should be not present on the list

  @regression @add-multiple-stops-and-limits @wt-159-v2
  Scenario: Add multiple stops and limits
    #1
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I find any market with available Guaranteed stop in watchlist
    And I click on 'buy' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    And I remember min valid quantity for 'current' market
    #2
    When I fill 'quantity' with value 'min valid+1'
    And I check 'stop' checkbox
    And I fill the '1'st normal stop linked order 'price' with value 'buy*0.9' in the 'current market'
    Then the '1'st normal stop linked order 'pips/points' input should be autopopulated
    And the '1'st normal stop linked order 'p/l' input should be autopopulated
    When I store data from the '1'st normal stop linked order
    And I check 'limit' checkbox
    When I fill the '2'nd limit linked order 'price' with value 'buy*1.1' in the 'current market'
    Then the '2'nd limit linked order 'pips/points' input should be autopopulated
    And the '2'nd limit linked order 'p/l' input should be autopopulated
    When I store data from the '2'nd limit linked order
    Then 'submit button' element should be enabled
    And 'submit button' element text should be 'Place Trade'
    #3
    When I click on 'advancedTicket' link
    When I fill 'quantity' with value 'min valid*10'
    Then the order ticket advanced view panel should contain items:
      | itemName                     |
      | add stop limit dropdown link |
    And the '1'st normal stop linked order 'quantity' input should be 'min valid+1'
    And 'GTC' option should be selected in '1'st applicability dropdown
    And the '2'nd limit linked order 'quantity' input should be 'min valid+1'
    And 'GTC' option should be selected in '2'nd applicability dropdown
    #4
    When I expand add stop limit dropdown
    And I select 'Limit' from expanded dropdown
    Then the number of linked orders should be '3'
    #5
    And I fill the '3'rd limit linked order 'quantity' with value 'min valid+1' in the 'current market'
    And I fill the '3'rd limit linked order 'price' with value 'buy*1.1' in the 'current market'
    Then the '3'rd limit linked order 'pips/points' input should be autopopulated
    And the '3'rd limit linked order 'p/l' input should be autopopulated
    When I store data from the '3'rd limit linked order
    Then 'submit button' element should be enabled
    And 'submit button' element text should be 'Place Trade'
    #6
    When I expand add stop limit dropdown
    And I select 'Trailing' from expanded dropdown
    Then the number of linked orders should be '4'
    And the '4'th trailing stop order should contain fields:
      | itemName         |
      | trash icon       |
      | dropdown         |
      | quantity         |
      | pips/points away |
      | applicability    |
    #7
    And I fill the '4'th trailing stop linked order 'quantity' with value 'min valid+1' in the 'current market'
    And I fill the '4'th trailing stop linked order 'pips/points away' with value '100' in the 'current market'
    Then 'submit button' element should be enabled
    And 'submit button' element text should be 'Place Trade'
    #8
    When I expand add stop limit dropdown
    And I select 'Guaranteed' from expanded dropdown
    Then the number of linked orders should be '5'
    #9
    And I fill the '5'th guaranteed stop linked order 'quantity' with value 'min valid+1' in the 'current market'
    And I fill the '5'th guaranteed stop linked order 'price' with value 'sell*0.89' in the 'current market'
    Then the '5'th guaranteed stop linked order 'pips/points' input should be autopopulated
    And the '5'th guaranteed stop linked order 'p/l' input should be autopopulated
    Then 'submit button' element should be enabled
    And 'submit button' element text should be 'Place Trade'
    #10
    When I expand '4'th linked order types dropdown
    And I select 'guaranteed' from expanded dropdown
    Then the number of linked orders should be '5'
    And the '4'th guaranteed stop order should contain fields:
      | itemName      |
      | quantity      |
      | price         |
      | pips/points   |
      | p/l           |
      | applicability |
    #11
    And I fill the '4'th guaranteed stop linked order 'quantity' with value 'min valid+1' in the 'current market'
    And I fill the '4'th guaranteed stop linked order 'price' with value 'sell*0.89' in the 'current market'
    Then the '4'th guaranteed stop linked order 'pips/points' input should be autopopulated
    And the '4'th guaranteed stop linked order 'p/l' input should be autopopulated
    When I store data from the '4'th guaranteed stop linked order
    Then 'submit button' element should be enabled
    And 'submit button' element text should be 'Place Trade'
    #12
    When I expand '5'th linked order types dropdown
    And I select 'trailing' from expanded dropdown
    Then the number of linked orders should be '5'
    And the '5'th trailing stop order should contain fields:
      | itemName         |
      | quantity         |
      | pips/points away |
      | applicability    |
    #13
    And I fill the '5'th trailing stop linked order 'quantity' with value 'min valid+1' in the 'current market'
    And I fill the '5'th trailing stop linked order 'pips/points away' with value '100' in the 'current market'
    When I store data from the '5'th trailing stop linked order
    Then 'submit button' element should be enabled
    And 'submit button' element text should be 'Place Trade'
    #14
    And I click on 'submit' button after waiting
    And the '1'st normal stop linked order confirmation message should be correct
    And the '2'nd limit linked order confirmation message should be correct

    #3th limit stop - displayed as 4th attached confirmation????
    #And the '3'th limit linked order confirmation message should be correct
    #4th quaranteed stop - displayed as 3th attached confirmation????
    #And the '4'th guaranteed stop linked order confirmation message should be correct

    And the '5'th trailing stop linked order confirmation message should be correct
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
    #15
    Then I make 'Positions And Orders' panel active
    Then I am on the 'Positions' list
    Then the 'previously added' order should be present on the list
    And the 'previously added' market 'stop price' cell should contain 'multiple' word
    And the 'previously added' market 'limit price' cell should contain 'multiple' word

    When I complete 'previously added' order dropdown with value 'Amend Position'
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'amend position'
    And the '1'st normal stop linked order 'price' input should be 'correct'
    And the '2'nd limit linked order 'price' input should be 'correct'
    #And the '3'th limit linked order 'price' input should be 'correct'
    #And the '4'th guaranteed stop linked order 'price' input should be 'correct'
    And the '5'th trailing stop linked order 'pips/points' input should be 'pips/points*1'
    #16
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I find any market with available Guaranteed stop in watchlist
    And I click on 'buy' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    And I remember min valid quantity for 'current' market
    And I click on 'advancedTicket' link
    And I fill 'quantity' with value 'min valid*10'
    And I check 'stop' checkbox
    And I fill the '1'st normal stop linked order 'quantity' with value 'min valid+1' in the 'current market'
    And I fill the '1'st normal stop linked order 'price' with value 'buy*0.9' in the 'current market'
    Then the '1'st normal stop linked order 'pips/points' input should be autopopulated
    And the '1'st normal stop linked order 'p/l' input should be autopopulated
    When I clear the '1'st normal stop linked order 'pips/points' input field
    Then the '1'st normal stop linked order 'pips/points' input should be blank
    And the '1'st normal stop linked order 'price' input should be blank
    And the '1'st normal stop linked order 'p/l' input should be blank
    And the '1'st normal stop linked order 'quantity' input should be 'min valid+1'

    And I check 'limit' checkbox
    And I fill the '2'nd limit linked order 'quantity' with value 'min valid+1' in the 'current market'
    When I fill the '2'nd limit linked order 'price' with value 'buy*1.1' in the 'current market'
    Then the '2'nd limit linked order 'pips/points' input should be autopopulated
    And the '2'nd limit linked order 'p/l' input should be autopopulated
    When I clear the '2'nd limit linked order 'pips/points' input field
    Then the '2'nd limit linked order 'pips/points' input should be blank
    And the '2'nd limit linked order 'price' input should be blank
    And the '2'nd limit linked order 'p/l' input should be blank
    And the '2'nd limit linked order 'quantity' input should be 'min valid+1'
    #17
    And I fill the '1'st normal stop linked order 'quantity' with value 'min valid+1' in the 'current market'
    And I fill the '1'st normal stop linked order 'price' with value 'buy*0.9' in the 'current market'
    Then the '1'st normal stop linked order 'pips/points' input should be autopopulated
    And the '1'st normal stop linked order 'p/l' input should be autopopulated
    When I clear the '1'st normal stop linked order 'p/l' input field
    Then the '1'st normal stop linked order 'pips/points' input should be blank
    And the '1'st normal stop linked order 'price' input should be blank
    And the '1'st normal stop linked order 'p/l' input should be blank
    And the '1'st normal stop linked order 'quantity' input should be 'min valid+1'

    And I fill the '2'nd limit linked order 'quantity' with value 'min valid+1' in the 'current market'
    When I fill the '2'nd limit linked order 'price' with value 'buy*1.1' in the 'current market'
    Then the '2'nd limit linked order 'pips/points' input should be autopopulated
    And the '2'nd limit linked order 'p/l' input should be autopopulated
    When I clear the '2'nd limit linked order 'p/l' input field
    Then the '2'nd limit linked order 'pips/points' input should be blank
    And the '2'nd limit linked order 'price' input should be blank
    And the '2'nd limit linked order 'p/l' input should be blank
    And the '2'nd limit linked order 'quantity' input should be 'min valid+1'

  @regression @edit-position-with-multiple-stops-and-limits @wt-1024-v3
  Scenario: Edit Position with multiple stops and limits
    #1 Alena P. will change the 1st step, about opening DT in Edit mode
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I find CFD market with available Guaranteed stop in watchlist
    And I click on 'buy' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    When I remember min valid quantity for 'current' market
    And I fill 'quantity' with value 'min valid+1'
    And I check 'stop' checkbox
    And I fill the '1'st normal stop linked order 'price' with value 'buy*0.9' in the 'current market'
    When I store data from the '1'st normal stop linked order
    And I check 'limit' checkbox
    When I fill the '2'nd limit linked order 'price' with value 'buy*1.1' in the 'current market'
    When I store data from the '2'nd limit linked order
    And I click on 'submit' button
    When I click on 'ok' button
    Then the 'Positions And Orders' panel should be visible
    And the 'previously added' market should be present on the list
    And I complete 'previously added' market dropdown with value 'Amend Position'
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'amend position'
    And 'market info' element text should be 'current market'
    And current simple position information should be correct
    Then 'edit' radiobutton should be 'selected'
    #2, 3
    And the '1'st normal stop order should contain fields:
      | itemName      |
      | checkbox      |
      | price         |
      | pips/points   |
      | p/l           |
    And the '2'nd limit order should contain fields:
      | itemName    |
      | checkbox    |
      | price       |
      | pips/points |
      | p/l         |
    And the '1'st normal stop linked order 'price' input should be 'correct'
    And the '1'st normal stop linked order 'p/l' input should be autopopulated
    And the '2'nd limit linked order 'price' input should be 'correct'
    And the '2'nd limit linked order 'p/l' input should be autopopulated
    Then 'submit button' element should be disabled
    And 'submit button' element text should be 'Update Position'
    #4
    And I click on 'advancedTicket' link
    And the '1'st normal stop order should contain fields:
      | itemName      |
      | quantity      |
      | applicability |
    And the '2'nd limit order should contain fields:
      | itemName      |
      | quantity      |
      | applicability |
    # https://jira.gaincapital.com/browse/TPDWT-1884 - Hedge toggle is removed from Edit DT
    And the trade ticket advanced view panel should contain items:
      | itemName                     |
      | add stop limit dropdown link |
    Then 'standard ticket link' element should be enabled
    #5
    When I expand '1'st applicability dropdown
    And I select 'Good 'til end of day (GTD)' from expanded dropdown
    Then 'standard ticket link' element should be disabled
    #6 fields should be cleared - https://jira.gaincapital.com/browse/TPDWT-10531
    When I uncheck 'stop' checkbox
    Then the '1'st normal stop linked order 'quantity' input should be blank
    And the '1'st normal stop linked order 'price' input should be blank
    And the '1'st normal stop linked order 'pips/points' input should be blank
    And the '1'st normal stop linked order 'p/l' input should be blank
    Then 'GTC' option should be selected in '1'st applicability dropdown
    And the '1'st normal stop linked order 'quantity' element background should be grey
    And the '1'st normal stop linked order 'price' element background should be grey
    And the '1'st normal stop linked order 'pips/points' element background should be grey
    And the '1'st normal stop linked order 'p/l' element background should be grey
    And the '1'st normal stop linked order 'applicability container' element background should be grey
    When I uncheck 'limit' checkbox
    Then the '2'nd limit linked order 'quantity' input should be blank
    And the '2'nd limit linked order 'price' input should be blank
    And the '2'nd limit linked order 'pips/points' input should be blank
    And the '2'nd limit linked order 'p/l' input should be blank
    Then 'GTC' option should be selected in '2'nd applicability dropdown
    And the '2'nd limit linked order 'quantity' element background should be grey
    And the '2'nd limit linked order 'price' element background should be grey
    And the '2'nd limit linked order 'pips/points' element background should be grey
    And the '2'nd limit linked order 'p/l' element background should be grey
    And the '2'nd limit linked order 'applicability container' element background should be grey
    When I click on 'submit' button
    And correct confirmation message about removing '2' linked orders should be displayed
    When I click on 'ok' button
    When I delete 'position' 'current market'
    And I make 'Positions And Orders' panel active
    And the 'current' market should be not present on the list
    #7
    When I make 'Watchlist' panel active
    When I expand 'Popular Markets' watchlist
    And I click on 'buy' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    And I fill 'quantity' with value 'min valid+1'
    And I check 'stop' checkbox
    And I fill the '1'st normal stop linked order 'price' with value 'buy*0.9' in the 'current market'
    When I store data from the '1'st normal stop linked order
    And I check 'limit' checkbox
    When I fill the '2'nd limit linked order 'price' with value 'buy*1.1' in the 'current market'
    When I store data from the '2'nd limit linked order
    And I click on 'advancedTicket' link
    And I fill 'quantity' with value 'min valid*5'
    And I expand add stop limit dropdown
    And I select 'Stop' from expanded dropdown
    And I fill the '3'rd normal stop linked order 'quantity' with value 'min valid+1' in the 'current market'
    And I fill the '3'rd normal stop linked order 'price' with value 'buy*0.9' in the 'current market'
    When I store data from the '3'rd normal stop linked order
    And I click on 'submit' button
    And I click on 'ok' button

    Then the 'Positions And Orders' panel should be visible
    And the 'previously added' market should be present on the list
    And I complete 'previously added' market dropdown with value 'Amend Position'
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'amend position'
    When I remove '3'rd normal stop order
    And the '3'rd normal stop order should not contain fields:
      | itemName      |
      | trash icon    |
      | dropdown      |
      | quantity      |
      | price         |
      | pips/points   |
      | p/l           |
      | applicability |
    And the '3'rd normal stop order should contain fields:
      | itemName    |
      | undo button |
    And 'delete message' element text should be 'Changes will take effect once you click "Update Position" below'
    #8
    When I click on the '3'rd normal stop linked order 'undo button' element
    And the '3'rd normal stop order should contain fields:
      | itemName      |
      | trash icon    |
      | dropdown      |
      | quantity      |
      | price         |
      | pips/points   |
      | p/l           |
      | applicability |
    # after click Undo - order has blank fields
    Then the '3'rd normal stop linked order 'price' input should be blank
    And the '3'rd normal stop linked order 'pips/points' input should be blank
    And the '3'rd normal stop linked order 'p/l' input should be blank
    When I fill the '3'rd normal stop linked order 'quantity' with value 'min valid+1' in the 'current market'
    And I fill the '3'rd normal stop linked order 'price' with value 'buy*0.8' in the 'current market'
    Then the '3'rd normal stop linked order 'pips/points' input should be autopopulated
    And the '3'rd normal stop linked order 'p/l' input should be autopopulated
    #9
    When I click on 'submit' button
    And 'confirmation message' element text should be 'Your order has been updated.'
    And I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible

  @regression @edit-order-with-multiple-stops-and-limits @wt-1448-v2
  Scenario: Edit Order with multiple stops and limits
    #1
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I find CFD market with available Guaranteed stop in watchlist
    And I click on 'buy' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    When I remember min valid quantity for 'current' market
    When I switch to 'order' tab
    When I fill 'quantity' with value 'min valid+1'
    When I fill 'current market' price with value not between current prices on 'buy'
    And I check 'stop' checkbox
    And I fill the '1'st normal stop linked order 'price' with value 'buy*0.9' in the 'current market'
    When I store data from the '1'st normal stop linked order
    And I check 'limit' checkbox
    When I fill the '2'nd limit linked order 'price' with value 'buy*1.1' in the 'current market'
    When I store data from the '2'nd limit linked order
    And I click on 'submit' button
    When I click on 'ok' button

    Then the 'Positions And Orders' panel should be visible
    And I am on the 'Orders' list
    And the 'previously added' order should be present on the list
    And I complete 'previously added' market dropdown with value 'Edit Order'
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'edit order'
    And 'market info' element text should be 'current market'
    And the trade ticket standard view panel should contain items:
      | itemName   |
      | buy label  |
      | sell label |
    And 'buy' price should change with time
    And 'sell' price should change with time
    # current position information is not displayed in opened DT
    And the '1'st normal stop order should contain fields:
      | itemName      |
      | checkbox      |
      | price         |
      | pips/points   |
      | p/l           |
    And the '2'nd limit order should contain fields:
      | itemName    |
      | checkbox    |
      | price       |
      | pips/points |
      | p/l         |
    And 'submit button' element should be disabled
    And 'submit button' element text should be 'Update Order'
    #2
    And the '1'st normal stop linked order 'price' input should be 'correct'
    And the '1'st normal stop linked order 'p/l' input should be autopopulated
    And the '2'nd limit linked order 'price' input should be 'correct'
    And the '2'nd limit linked order 'p/l' input should be autopopulated
    #3
    When 'buy' price should change with time
    And 'sell' price should change with time
    Then the '1'st normal stop linked order 'p/l' input should be autopopulated
    And the '2'nd limit linked order 'p/l' input should be autopopulated
    #4
    When I click on 'advancedTicket' link
    Then the '1'st normal stop order should contain fields:
      | itemName      |
      | quantity      |
      | applicability |
    And the '2'nd limit order should contain fields:
      | itemName      |
      | quantity      |
      | applicability |
    # https://jira.gaincapital.com/browse/TPDWT-1884 - Hedge toggle is removed from Edit DT
    And the trade ticket advanced view panel should contain items:
      | itemName                     |
      | add stop limit dropdown link |
    Then 'standard ticket link' element should be enabled
    #5
    When I expand '1'st applicability dropdown
    And I select 'Good 'til end of day (GTD)' from expanded dropdown
    Then 'standard ticket link' element should be disabled
    #6 fields should be cleared - https://jira.gaincapital.com/browse/TPDWT-10531
    When I uncheck 'stop' checkbox
    Then the '1'st normal stop linked order 'quantity' input should be blank
    And the '1'st normal stop linked order 'price' input should be blank
    And the '1'st normal stop linked order 'pips/points' input should be blank
    And the '1'st normal stop linked order 'p/l' input should be blank
    Then 'GTC' option should be selected in '1'st applicability dropdown
    And the '1'st normal stop linked order 'quantity' element background should be grey
    And the '1'st normal stop linked order 'price' element background should be grey
    And the '1'st normal stop linked order 'pips/points' element background should be grey
    And the '1'st normal stop linked order 'p/l' element background should be grey
    And the '1'st normal stop linked order 'applicability container' element background should be grey
    When I uncheck 'limit' checkbox
    Then the '2'nd limit linked order 'quantity' input should be blank
    And the '2'nd limit linked order 'price' input should be blank
    And the '2'nd limit linked order 'pips/points' input should be blank
    And the '2'nd limit linked order 'p/l' input should be blank
    Then 'GTC' option should be selected in '2'nd applicability dropdown
    And the '2'nd limit linked order 'quantity' element background should be grey
    And the '2'nd limit linked order 'price' element background should be grey
    And the '2'nd limit linked order 'pips/points' element background should be grey
    And the '2'nd limit linked order 'p/l' element background should be grey
    And the '2'nd limit linked order 'applicability container' element background should be grey
    When I click on 'submit' button
    And correct confirmation message about removing '2' linked orders should be displayed
    When I click on 'ok' button
    When I delete 'order' 'current market'
    Then the 'Positions And Orders' panel should be visible
    And I am on the 'Orders' list
    And the 'current' market should be not present on the list
    #7
    When I make 'Watchlist' panel active
    When I expand 'Popular Markets' watchlist
    And I click on 'buy' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    When I switch to 'order' tab
    When I fill 'quantity' with value 'min valid+1'
    When I fill 'current market' price with value not between current prices on 'buy'
    And I check 'stop' checkbox
    And I fill the '1'st normal stop linked order 'price' with value 'buy*0.9' in the 'current market'
    When I store data from the '1'st normal stop linked order
    And I check 'limit' checkbox
    When I fill the '2'nd limit linked order 'price' with value 'buy*1.1' in the 'current market'
    When I store data from the '2'nd limit linked order
    And I click on 'advancedTicket' link
    And I fill 'quantity' with value 'min valid*5'
    And I expand add stop limit dropdown
    And I select 'Stop' from expanded dropdown
    And I fill the '3'rd normal stop linked order 'quantity' with value 'min valid+1' in the 'current market'
    And I fill the '3'rd normal stop linked order 'price' with value 'buy*0.9' in the 'current market'
    When I store data from the '3'rd normal stop linked order
    And I click on 'submit' button
    And I click on 'ok' button
    Then the 'Positions And Orders' panel should be visible
    And I am on the 'Orders' list
    And the 'previously added' market should be present on the list
    And I complete 'previously added' market dropdown with value 'Edit Order'
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'edit order'
    When I remove '3'rd normal stop order
    And the '3'rd normal stop order should not contain fields:
      | itemName      |
      | trash icon    |
      | dropdown      |
      | quantity      |
      | price         |
      | pips/points   |
      | p/l           |
      | applicability |
    And the '3'rd normal stop order should contain fields:
      | itemName    |
      | undo button |
    And 'delete message' element text should be 'Changes will take effect once you click "Update Order" below'
    #8
    When I click on the '3'rd normal stop linked order 'undo button' element
    And the '3'rd normal stop order should contain fields:
      | itemName      |
      | trash icon    |
      | dropdown      |
      | quantity      |
      | price         |
      | pips/points   |
      | p/l           |
      | applicability |
    # after click Undo - order has blank fields
    Then the '3'rd normal stop linked order 'price' input should be blank
    And the '3'rd normal stop linked order 'pips/points' input should be blank
    And the '3'rd normal stop linked order 'p/l' input should be blank
    When I fill the '3'rd normal stop linked order 'quantity' with value 'min valid+1' in the 'current market'
    And I fill the '3'rd normal stop linked order 'price' with value 'buy*0.8' in the 'current market'
    Then the '3'rd normal stop linked order 'pips/points' input should be autopopulated
    And the '3'rd normal stop linked order 'p/l' input should be autopopulated
    #9
    When I click on 'submit' button
    And 'confirmation message' element text should be 'Your order has been updated.'
    And I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible

  @regression @multiple-stops-and-limit-error-buy-trade @wt-137-v2
  Scenario: Multiple stops and limit error - Buy trade
    #1
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I click on 'buy' in the '1'st market
    Then the 'Deal ticket' panel should be visible
    When I remember min valid quantity for 'current' market
    When I fill 'quantity' with value 'min valid+1'
    When I click on 'advancedTicket' link
    #2
    When I expand add stop limit dropdown
    And I select 'Stop' from expanded dropdown
    Then the '3'rd normal stop order should contain fields:
      | itemName      |
      | trash icon    |
      | dropdown      |
      | quantity      |
      | price         |
      | pips/points   |
      | p/l           |
      | applicability |
    Then the number of linked orders should be '3'
    #3
    When I fill the '3'rd normal stop linked order 'quantity' with value 'min valid+1' in the 'current market'
    And I fill the '3'rd normal stop linked order 'price' with value 'sell*1.1' in the 'current market'
    Then 'buy' 'current market' '3'rd stop price validation should be correct
    And the '3'rd normal stop order 'price border' element should have red color
    And the '3'rd normal stop order 'points border' element should have red color
    And the '3'rd normal stop order 'p/l border' element should have red color
    And 'submit button' element text should be 'stop level too high'
    #4
    When I fill the '3'rd normal stop linked order 'price' with value 'sell*0.99' in the 'current market'
    Then 'submit button' element should be enabled
    And 'submit button' element text should be 'Place Trade'
    #5
    When I expand add stop limit dropdown
    And I select 'Limit' from expanded dropdown
    Then the '4'th limit order should contain fields:
      | itemName      |
      | trash icon    |
      | dropdown      |
      | quantity      |
      | price         |
      | pips/points   |
      | p/l           |
      | applicability |
    Then the number of linked orders should be '4'
    #6
    When I fill the '4'th limit linked order 'quantity' with value 'min valid+1' in the 'current market'
    And I fill the '4'th limit linked order 'price' with value 'buy*0.9' in the 'current market'
    Then 'buy' 'current market' '4'th limit price validation should be correct
    And the '4'th limit order 'price border' element should have red color
    And the '4'th limit order 'points border' element should have red color
    And the '4'th limit order 'p/l border' element should have red color
    And 'submit button' element text should be 'limit level too low'
    #7
    When I fill the '4'th limit linked order 'price' with value 'buy*1.1' in the 'current market'
    Then 'submit button' element should be enabled
    And 'submit button' element text should be 'Place Trade'

  @regression @multiple-stops-and-limit-quantity-error-sell-trade @wt-139-v2
  Scenario: Multiple stops and limit quantity error - Sell trade
    #1
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I click on 'sell' in the '1'st market
    Then the 'Deal ticket' panel should be visible
    And trade direction should be 'sell'
    #2
    When I remember min valid quantity for 'current' market
    And I fill 'quantity' with value 'min valid+10'
    Then 'submit button' element should be enabled
    And 'submit button' element text should be 'Place Trade'
    #3
    When I click on 'advancedTicket' link
    When I expand add stop limit dropdown
    And I select 'Stop' from expanded dropdown
    Then the '3'rd normal stop order should contain fields:
      | itemName      |
      | trash icon    |
      | dropdown      |
      | quantity      |
      | price         |
      | pips/points   |
      | p/l           |
      | applicability |
    Then the number of linked orders should be '3'
    #4
    When I fill the '3'rd normal stop linked order 'quantity' with value 'min valid+20' in the 'current market'
    Then the '3'rd stop max quantity validation should be correct
    And the '3'rd normal stop order 'quantity border' element should have red color
    And the '3'rd normal stop order 'pips/points border' element should have grey color
    And the '3'rd normal stop order 'p/l border' element should have grey color
    Then 'submit button' element should be disabled
    And 'submit button' element text should be 'stops quantity too high'
    #5
    When I fill the '3'rd normal stop linked order 'price' with value 'buy*1.1' in the 'current market'
    And I fill the '3'rd normal stop linked order 'quantity' with value 'min valid+2' in the 'current market'
    Then 'submit button' element should be enabled
    And 'submit button' element text should be 'Place Trade'
    #6
    When I expand add stop limit dropdown
    And I select 'Limit' from expanded dropdown
    Then the '4'th limit order should contain fields:
      | itemName      |
      | trash icon    |
      | dropdown      |
      | quantity      |
      | price         |
      | pips/points   |
      | p/l           |
      | applicability |
    Then the number of linked orders should be '4'
    #7
    When I fill the '4'th limit linked order 'quantity' with value 'min valid+20' in the 'current market'
    Then the '4'th limit max quantity validation should be correct
    And the '4'th limit order 'quantity border' element should have red color
    And the '4'th limit order 'pips/points border' element should have grey color
    And the '4'th limit order 'p/l border' element should have grey color
    Then 'submit button' element should be disabled
    And 'submit button' element text should be 'limits quantity too high'
    #8
    When I fill the '4'th limit linked order 'price' with value 'sell*0.99' in the 'current market'
    And I fill the '4'th limit linked order 'quantity' with value 'min valid+2' in the 'current market'
    Then 'submit button' element should be enabled
    And 'submit button' element text should be 'Place Trade'

  @regression @applicability-multiple-stops-and-limits @wt-161-v2
  Scenario: Applicability - Multiple Stops and Limits
    #1
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I click on 'sell' in the '1'st market
    Then the 'Deal ticket' panel should be visible
    And trade direction should be 'sell'
    When I remember min valid quantity for 'current' market
    And I fill 'quantity' with value 'min valid*1'
    #2
    When I click on 'advancedTicket' link
    And I fill 'quantity' with value 'min valid*5'
    When I expand add stop limit dropdown
    And I select 'Stop' from expanded dropdown
    Then the '3'rd normal stop order should contain fields:
      | itemName      |
      | trash icon    |
      | dropdown      |
      | quantity      |
      | price         |
      | pips/points   |
      | p/l           |
      | applicability |
    Then the number of linked orders should be '3'
    #3
    When I expand '3'rd applicability dropdown
    And I select 'Good 'til end of day (GTD)' from expanded dropdown
    Then 'GTD' option should be selected in '3'rd applicability dropdown
    #4
    When I expand add stop limit dropdown
    And I select 'Limit' from expanded dropdown
    Then the '4'th limit order should contain fields:
      | itemName      |
      | trash icon    |
      | dropdown      |
      | quantity      |
      | price         |
      | pips/points   |
      | p/l           |
      | applicability |
    Then the number of linked orders should be '4'
    #5
    When I expand '4'th applicability dropdown
    And I select 'Good 'til end of day (GTD)' from expanded dropdown
    Then 'GTD' option should be selected in '4'th applicability dropdown
    #6
    When I expand add stop limit dropdown
    And I select 'Trailing' from expanded dropdown
    Then the '5'th trailing stop order should contain fields:
      | itemName      |
      | trash icon    |
      | dropdown      |
      | quantity      |
      | pips/points   |
      | applicability |
    Then the number of linked orders should be '5'
    #7
    When I expand '5'th applicability dropdown
    Then the options from expanded dropdown should be:
      |Good 'til canceled (GTC)|
      |Good 'til end of day (GTD)|
      |Good 'til time (GTT) Select a specific date and time|
    And I select 'Good 'til time (GTT)' from expanded dropdown
    Then 'GTT' option should be selected in '5'nd applicability dropdown
    And the '5'nd trailing stop order should contain fields:
      | itemName      |
      | date picker   |
    When I expand '5'th date picker dropdown
    Then 'date picker' dropdown should be visible
    #8
    When I add to date/time picker '2' hours and click outside
    Then the '5'th trailing stop linked order date picker input should be defined with '2' hours more than now
    #9
    When I fill the '3'rd normal stop linked order 'price' with value 'buy*1.1' in the 'current market'
    And I fill the '3'rd normal stop linked order 'quantity' with value 'min valid+1' in the 'current market'
    When I fill the '4'rd limit linked order 'price' with value 'sell*0.99' in the 'current market'
    And I fill the '4'rd limit linked order 'quantity' with value 'min valid+1' in the 'current market'
    When I fill the '5'th trailing stop linked order 'pips/points' with value '100' in the 'current market'
    And I fill the '5'th trailing stop linked order 'quantity' with value 'min valid+1' in the 'current market'
    Then 'submit button' element should be enabled
    And 'submit button' element text should be 'Place Trade'
    And I click on 'submit' button
    And I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
    #10
    Then I make 'Positions And Orders' panel active
    Then I am on the 'Positions' list
    Then the 'previously added' position should be present on the list
    #11
    Then I am on the 'Orders' list
    # there is no order on Orders list
    Then the 'previously added' order should be not present on the list
    # 12, 13, 14, 15 requires mocks

  @regression @sell-and-buy-button-hover-state @wt-81-v4
  Scenario Outline: Sell/Buy Button - Hover State
    #1
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I click on '<Direction>' in the '1'st market
    Then the 'Deal ticket' panel should be visible
    And I remember min valid quantity for 'current' market
    And trade direction should be '<Direction>'
    And I fill 'quantity' with value 'min valid+1'
    And the '<Direction>' button should be '<Button color>'
    And the 'submit' button should be '<Button color>'
    #2
    And the 'submit' button should be '<Hovered button color>' when it is 'hovered'
    #3
    When I switch to 'order' tab
    And the '<Direction>' button should be '<Button color>'
    And the 'submit' button should be 'grey'
    #4
    When I fill 'quantity' with value 'min valid+1'
    When I fill 'current market' main price with value not between current prices on 'buy'
    Then 'submit button' element text should be 'Place Order'
    And the 'submit' button should be '<Button color>'
    #5
    And the 'submit' button should be '<Hovered button color>' when it is 'hovered'
    When I close 'Deal ticket' panel
    Then the 'Deal ticket' panel should be invisible
    # red = #de4559, darkRed= #960014
    # buy = #2c7cb3 in app, BUT in manual TC blue = #157db1
    # darkBlue = #0f587d

    Examples:
      | Direction | Button color | Hovered button color |
      | sell      | red          | darkRed              |
      | buy       | blue         | darkBlue             |

  @regression @sell-and-buy-button-hover-state @wt-865-v10
  Scenario: Advanced Mode View
    #1
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I click on 'buy' in the '1'st market
    Then the 'Deal ticket' panel should be visible
    And I remember min valid quantity for 'current' market
    #2, 3
    When I click on 'advancedTicket' link
    Then the '1'st normal stop order should contain fields:
      | itemName      |
      | quantity      |
      | applicability |
    And  'GTC' option should be selected in '1'st applicability dropdown
    And the '2'nd limit order should contain fields:
      | itemName      |
      | quantity      |
      | applicability |
    And  'GTC' option should be selected in '2'nd applicability dropdown
    #4
    And the trade ticket advanced view panel should contain items:
      | itemName                     |
      | add stop limit dropdown link |
    #5
    When I click on 'quantity' element
    Then the trade 'quantity' field should have no color
    #6, 7
    When the trade ticket advanced view panel should contain items:
      | itemName          |
      | hedging toggle    |
      | hedging info icon |
    And I hover main order 'hedging info icon' element
    Then trade ticket 'hedging tooltip' element is visible
    And I click on 'quantity' element
    #8
    And the trade ticket advanced view panel should contain items:
      | itemName                     |
      | standard ticket link         |
      | standard ticket double arrows|
    #9
    When I click on 'standardTicket' link
    And the trade ticket advanced view panel should contain items:
      | itemName             |
      | advanced ticket link |
    #10
    When I check 'stop' checkbox
    And  I check 'limit' checkbox
    And I click on 'advancedTicket' link
    Then the '1'st normal stop order should contain fields:
      | itemName      |
      | quantity      |
      | applicability |
    # Checkbox style corresponds to the design, Placeholder's letters' color - are not checked
    Then 'standard ticket link' element should be enabled
    #11
    When I fill the '1'st normal stop linked order 'quantity' with value 'min valid+1' in the 'current market'
    Then 'standard ticket link' element should be disabled
    When I clear the '1'st normal stop linked order 'quantity' input field
    Then 'standard ticket link' element should be enabled
    When I fill the '2'nd limit linked order 'quantity' with value 'min valid+1' in the 'current market'
    Then 'standard ticket link' element should be disabled
    When I clear the '2'nd limit linked order 'quantity' input field
    Then 'standard ticket link' element should be enabled
    #12
    When I expand '1'st applicability dropdown
    And I select 'Good 'til end of day (GTD)' from expanded dropdown
    Then 'standard ticket link' element should be disabled
    When I uncheck 'stop' checkbox
    Then 'standard ticket link' element should be enabled
    When I expand '2'nd applicability dropdown
    And I select 'Good 'til end of day (GTD)' from expanded dropdown
    Then 'standard ticket link' element should be disabled
    When I uncheck 'limit' checkbox
    Then 'standard ticket link' element should be enabled
    #13
    When I expand add stop limit dropdown
    And I select 'Limit' from expanded dropdown
    Then the number of linked orders should be '3'
    Then 'standard ticket link' element should be disabled
    #14
    # UNSTABLE without mocks
    # https://jira.gaincapital.com/browse/TPDWT-15110

  @regression @pips-instead-of-points-for-fx-markets @wt-1708-v1
  Scenario Outline:  PIPs instead of Points for FX markets
    #1, 2
    When I click on Search input
    Then Search modal should be visible
    When I wait for markets loading
    And I fill search field with value '<Search word>'
    And I wait for markets loading
    And I find Normal market with 'MarketUnderlyingType' property <Property flag> 'FX' in search modal
    And I click on '<Direction>' in the 'current' market within search modal
    Then the 'Deal ticket' panel should be visible
    And I switch to '<Tab>' tab
    #3
    And the '1'st normal stop linked order 'pips/points' placeholder should be correct
    And the '2'nd limit linked order 'pips/points' placeholder should be correct
    When I click on 'advancedTicket' link
    Then the '1'st normal stop linked order 'pips/points' placeholder should be correct
    And the '2'nd limit linked order 'pips/points' placeholder should be correct
    #4
    When I expand add stop limit dropdown
    And I select 'Stop' from expanded dropdown
    Then the number of linked orders should be '3'
    And the '3'rd normal stop linked order 'pips/points' placeholder should be correct
    When I expand add stop limit dropdown
    And I select 'Limit' from expanded dropdown
    Then the number of linked orders should be '4'
    And the '4'th limit linked order 'pips/points' placeholder should be correct

    Examples:
      | Search word | Property flag | Tab   | Direction |
      | AUD/USD     | is            | trade | bid price |
      | Gas         | is not        | order | ask price |

  @regression @use-save-display-last-traded-quantity-per-market @wt-1557-v1
  Scenario: Use/save/display last traded quantity per market
    # TA reset ClientPreferences after login for account
    #1, 2
    When I click on Search input
    Then Search modal should be visible
    When I wait for markets loading
    And I fill search field with value 'GBP/USD DFT'
    And I wait for markets loading
    And I find opened market from the Search modal
    And I click on 'ask price' in the 'current' market within search modal
    Then the 'Deal ticket' panel should be visible
    #7
    And quantity field in 'deal ticket' component should be not predefined with value from ClientPreference responce
    When I click on 'advancedTicket' link
    Then 'stop price' input should be predefined with ''
    And 'limit price' input should be predefined with ''
    When I switch to 'order' tab
    Then quantity field in 'deal ticket' component should be predefined with value from ClientPreference responce
    When I click on 'advancedTicket' link
    Then 'stop price' input should be predefined with ''
    And 'limit price' input should be predefined with ''
    When I close panel

    When I enable one click trading
    #Wathclist
    When I make 'Watchlist' panel active
    And I expand 'Popular Markets' watchlist
    And I hover 'current' market
    Then 1-click 'quantity' field for the 'current' market should be filled with ''
    #Browse tab
    When I switch to 'Browse markets' workspace tab
    Then 'Browse markets' tab should be active
    When I select 'Popular' market category
    And I select 'Popular UK' filter tab
    Then 1-click 'quantity' field for the 'current' market on browse tab should be filled with ''
    #Search modal
    When I click on Search input
    Then Search modal should be visible
    When I wait for markets loading
    And I fill search field with value 'current market'
    And I wait for markets loading
    Then 1-click 'quantity' field for the 'current' found market should be filled with ''
    #3 /save request does not checked, but /get request is called
    When I switch to 'Default Workspace' workspace tab
    And I disable one click trading
    When I make 'Watchlist' panel active
    And I expand 'Popular Markets' watchlist
    And I click on 'buy' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    When I remember min valid quantity for 'current' market
    And I fill 'quantity' with value 'min valid+1'
    And I click on 'submit' button
    And I click on 'ok' button
    When I make 'Watchlist' panel active
    And I expand 'Popular Markets' watchlist
    And I click on 'buy' in the 'current' market
    #Deal ticket
    Then the 'Deal ticket' panel should be visible
    And quantity field in 'deal ticket' component should be predefined with value from ClientPreference responce and be equal 'min valid+1'
    When I click on 'advancedTicket' link
    And the '1'st normal stop linked order 'quantity' input should be 'clientPreference quantity'
    And the '2'nd limit linked order 'quantity' input should be 'clientPreference quantity'
    When I switch to 'order' tab
    Then quantity field in 'deal ticket' component should be predefined with value from ClientPreference responce
    When I click on 'advancedTicket' link
    And the '1'st normal stop linked order 'quantity' input should be 'clientPreference quantity'
    And the '2'nd limit linked order 'quantity' input should be 'clientPreference quantity'
    When I close panel
    #4
    When I enable one click trading
    #Wathclist
    When I make 'Watchlist' panel active
    And I expand 'Popular Markets' watchlist
    And I hover 'current' market
    Then 1-click 'quantity' field for the 'current' market should be filled with 'clientPreference quantity'
    #Browse tab
    When I switch to 'Browse markets' workspace tab
    Then 'Browse markets' tab should be active
    When I select 'Popular' market category
    And I select 'Popular UK' filter tab
    Then 1-click 'quantity' field for the 'current' market on browse tab should be filled with 'clientPreference quantity'
    #Search modal
    When I click on Search input
    Then Search modal should be visible
    When I wait for markets loading
    And I fill search field with value 'current market'
    And I wait for markets loading
    Then 1-click 'quantity' field for the 'current' found market should be filled with 'clientPreference quantity'
    #4 /save request does not checked, but /get request is called
    #6
    When I delete 'position' 'current market'
    When I switch to 'Default Workspace' workspace tab
    And I disable one click trading
    When I make 'Watchlist' panel active
    And I expand 'Popular Markets' watchlist
    And I click on 'buy' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    And I fill 'quantity' with value 'min valid+3'
    And I click on 'submit' button
    And I click on 'ok' button
    When I make 'Watchlist' panel active
    And I expand 'Popular Markets' watchlist
    And I click on 'buy' in the 'current' market
    #Deal ticket
    Then the 'Deal ticket' panel should be visible
    And quantity field in 'deal ticket' component should be predefined with value from ClientPreference responce and be equal 'min valid+3'
    When I click on 'advancedTicket' link
    And the '1'st normal stop linked order 'quantity' input should be 'clientPreference quantity'
    And the '2'nd limit linked order 'quantity' input should be 'clientPreference quantity'
    When I switch to 'order' tab
    Then quantity field in 'deal ticket' component should be predefined with value from ClientPreference responce
    When I click on 'advancedTicket' link
    And the '1'st normal stop linked order 'quantity' input should be 'clientPreference quantity'
    And the '2'nd limit linked order 'quantity' input should be 'clientPreference quantity'
    When I enable one click trading
    #Wathclist
    When I make 'Watchlist' panel active
    And I expand 'Popular Markets' watchlist
    And I hover 'current' market
    Then 1-click 'quantity' field for the 'current' market should be filled with 'clientPreference quantity'
    #Browse tab
    When I switch to 'Browse markets' workspace tab
    Then 'Browse markets' tab should be active
    When I select 'Popular' market category
    And I select 'Popular UK' filter tab
    Then 1-click 'quantity' field for the 'current' market on browse tab should be filled with 'clientPreference quantity'
    #Search modal
    When I click on Search input
    Then Search modal should be visible
    When I wait for markets loading
    And I fill search field with value 'current market'
    And I wait for markets loading
    Then 1-click 'quantity' field for the 'current' found market should be filled with 'clientPreference quantity'
    #10
    When I switch to 'Default Workspace' workspace tab
    Then the 'Positions And Orders' panel should be visible
    Then the 'previously added' market should be present on the list
    And I complete 'previously added' market dropdown with value 'Amend Position'
    Then the 'Deal ticket' panel should be visible
    And I fill 'quantity' with value 'min valid+1'
    And I click on 'submit' button
    When I click on 'ok' button
    And I disable one click trading
    When I make 'Watchlist' panel active
    And I expand 'Popular Markets' watchlist
    And I click on 'buy' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    And quantity field in 'deal ticket' component should be predefined with value from ClientPreference responce and be equal 'min valid+3'

    When I make 'Positions And Orders' panel active
    Then the 'previously added' market should be present on the list
    When I click on 'close' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    When I fill 'close quantity' with value 'min valid'
    And I click on 'submit' button
    When I click on 'ok' button
    When I make 'Watchlist' panel active
    And I expand 'Popular Markets' watchlist
    And I click on 'buy' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    And quantity field in 'deal ticket' component should be predefined with value from ClientPreference responce and be equal 'min valid+3'
    #11-12 Quote

  @regression @DT-background-placement @wt-1292-v1
  Scenario: DT background placement
    #1
    When I add new tab
    And I expand dropdown in 'New workspace 2' tab
    When I add new 'Watchlist' panel in 'current' tab
    Then 'Watchlist' panel is disabled in 'current' tab
    And the 'Watchlist' panel should be visible
    #2
    And I make 'Watchlist' panel active
    And I expand 'Popular Markets' watchlist
    And I find any market
    And I click on 'buy' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    #3
    When I add new 'News feed' panel in 'current' tab
    Then 'News feed' panel is disabled in 'current' tab
    And the 'News feed' panel should be visible
    When I add new 'Economic Calendar' panel in 'current' tab
    Then 'Economic Calendar' panel is disabled in 'current' tab
    And the 'Economic Calendar' panel should be visible
    When I add new 'Positions And Orders' panel in 'current' tab
    Then 'Positions And Orders' panel is disabled in 'current' tab
    And the 'Positions And Orders' panel should be visible
    #4
    And I make 'Watchlist' panel active
    And I move panel to the 'bottom-left' corner
    And I expand 'Popular Markets' watchlist
    And I click on 'buy' in the 'current' market
    When I remember min valid quantity for 'current' market
    Then the 'Deal ticket' panel should be visible
    And I fill 'quantity' with value 'min valid+1'
    When I click on 'submit' button
    And I click on 'ok' button
    And I make 'Positions And Orders' panel active
    And I move panel to the 'top-right' corner
    Then the 'previously added' market should be present on the list
    #5
    And I complete 'previously added' position dropdown with value 'Buy Trade'
    Then the 'Deal ticket' panel should be visible
    #6
    And I fill 'quantity' with value 'min valid+1'
    Then 'submit button' element should be enabled
    And 'submit button' element text should be 'Place Trade'
    #7
    When I make 'Positions And Orders' panel active
    Then the 'Positions And Orders' panel should be visible
    And 'submit button' element should be disabled on the not active DT panel
    And 'submit button' element text should be 'Place Trade'
    #8
    When I make 'Deal ticket' panel active
    And I move panel to the 'bottom-right' corner
    When I make 'Deal ticket' panel active
    Then the 'Deal ticket' panel should be visible
    And 'submit button' element should be enabled
    And 'submit button' element text should be 'Place Trade'

  @regression @price-alerts @comma-separator @wt-1604-v1
  Scenario: Comma separator
    #1
    When I click on Search input
    Then Search modal should be visible
    When I wait for markets loading
    And I fill search field with value 'GBP/USD DFT'
    And I wait for markets loading
    And I find opened market from the Search modal
    And I click on 'bid price' in the 'current' market within search modal
    And I remember min valid quantity for 'current' market
    Then the 'Deal ticket' panel should be visible
    And 'trade' ticket type should be 'selected'
    When I check 'stop' checkbox
    Then the '1'st normal stop linked order 'price' element should be enabled
    And the '1'st normal stop linked order 'pips/points' element should be enabled
    And the '1'st normal stop linked order 'p/l' element should be enabled
    When I check 'limit' checkbox
    Then the '2'nd limit linked order 'price' element should be enabled
    And the '2'nd limit linked order 'pips/points' element should be enabled
    And the '2'nd limit linked order 'p/l' element should be enabled
    #2, 3
    Then filled value '1000' in 'quantity' field should be processed correctly
    And filled value '1000' in the '1'st normal stop linked order 'price' should be processed correctly
    And filled value '1000' in the '2'nd limit linked order 'price' should be processed correctly
    And filled value '1000000' in 'quantity' field should be processed correctly
    And filled value '1000000' in the '1'st normal stop linked order 'price' should be processed correctly
    And filled value '1000000' in the '2'nd limit linked order 'price' should be processed correctly

    When I click on 'advancedTicket' link
    And filled value '1111' in the '1'st normal stop linked order 'quantity' should be processed correctly
    And filled value '1111' in the '2'nd limit linked order 'quantity' should be processed correctly
    And filled value '2222' in the '1'st normal stop linked order 'p/l' should be processed correctly
    And filled value '2222' in the '2'nd limit linked order 'p/l' should be processed correctly
    And filled value '1111111' in the '1'st normal stop linked order 'quantity' should be processed correctly
    And filled value '1111111' in the '2'nd limit linked order 'quantity' should be processed correctly
    And filled value '2222222' in the '1'st normal stop linked order 'p/l' should be processed correctly
    And filled value '2222222' in the '2'nd limit linked order 'p/l' should be processed correctly
    And I close panel
    #4, 5 with quantity
    When I add position with parameters:
      | MarketName | AUD/USD |
      | Direction  | buy     |
      | Quantity   | 2000    |
    Then the 'Positions And Orders' panel should be visible
    And the 'previously added' market should be present on the list
    And the 'previously added' market 'position' cell should contain 'correct' data

    And I complete 'AUD/USD' market dropdown with value 'Amend Position'
    Then the 'Deal ticket' panel should be visible
    # https://jira.gaincapital.com/browse/TPDWT-13054
    #And current simple position information should be correct
    And 'close quantity' input should be predefined with '2,000'
    And 'max available quantity info' element text should be 'of 2,000'
    #6
    When I fill 'close quantity' with value '1000'
    Then partially close info message should be correct
    When I click on 'submit' button
    When I click on 'ok' button
    Then the 'Positions And Orders' panel should be visible
    And the 'previously added' market should be present on the list
    And the 'previously added' market 'position' cell should contain 'updated' data
    When I delete 'position' 'current market'
    #4, 5 with stop price
    And I add position with parameters:
      | MarketName | GBP/USD DFT |
      | Direction  | sell        |
      | Quantity   | 1           |
      | StopPrice  | 1000        |
    Then the 'Positions And Orders' panel should be visible
    And the 'previously added' market should be present on the list
    #And the 'previously added' market 'stop price' cell should contain 'correct' data
    And the previously added market stop price cell should contain previously set linked order data

    And I complete 'previously added' market dropdown with value 'Amend Position'
    Then the 'Deal ticket' panel should be visible
    # https://jira.gaincapital.com/browse/TPDWT-13054
    #And current simple position information should be correct
    And the '1'st normal stop linked order 'price' input should be 'correct'
    When I click on 'advancedTicket' link
    And filled value '1111' in the '1'st normal stop linked order 'quantity' should be processed correctly
    And filled value '2222' in the '1'st normal stop linked order 'price' should be processed correctly
    And filled value '3333' in the '1'st normal stop linked order 'p/l' should be processed correctly
    And I check 'Limit' checkbox
    And filled value '1111' in the '2'nd limit linked order 'quantity' should be processed correctly
    And filled value '2222' in the '2'nd limit linked order 'price' should be processed correctly
    And filled value '3333' in the '2'nd limit linked order 'p/l' should be processed correctly
    When I close panel
    When I delete 'position' 'current market'
    Then the 'Positions And Orders' panel should be visible
    And the 'previously added' market should be not present on the list
    #7
    When I click on Search input
    Then Search modal should be visible
    When I wait for markets loading
    And I fill search field with value 'GBP/USD DFT'
    And I wait for markets loading
    And I find opened market from the Search modal
    And I click on 'bid price' in the 'current' market within search modal
    And I remember min valid quantity for 'current' market
    Then the 'Deal ticket' panel should be visible
    When I switch to 'order' tab
    And I check 'stop' checkbox
    And I check 'limit' checkbox
    #8, 9
    Then filled value '1000' in 'order price' field should be processed correctly
    And filled value '1000' in 'quantity' field should be processed correctly
    And filled value '1000' in the '1'st normal stop linked order 'price' should be processed correctly
    And filled value '1000' in the '2'nd limit linked order 'price' should be processed correctly
    And filled value '1000000' in 'order price' field should be processed correctly
    And filled value '1000000' in 'quantity' field should be processed correctly
    And filled value '1000000' in the '1'st normal stop linked order 'price' should be processed correctly
    And filled value '1000000' in the '2'nd limit linked order 'price' should be processed correctly

    When I click on 'advancedTicket' link
    And filled value '1111' in the '1'st normal stop linked order 'quantity' should be processed correctly
    And filled value '1111' in the '2'nd limit linked order 'quantity' should be processed correctly
    And filled value '2222' in the '1'st normal stop linked order 'p/l' should be processed correctly
    And filled value '2222' in the '2'nd limit linked order 'p/l' should be processed correctly
    And filled value '1111111' in the '1'st normal stop linked order 'quantity' should be processed correctly
    And filled value '1111111' in the '2'nd limit linked order 'quantity' should be processed correctly
    And filled value '2222222' in the '1'st normal stop linked order 'p/l' should be processed correctly
    And filled value '2222222' in the '2'nd limit linked order 'p/l' should be processed correctly
    And I close panel
    #10
    And I add order with parameters:
      | MarketName | AUD/USD |
      | Direction  | sell    |
      | Quantity   | 2000    |
      | Price      | 1000    |
    Then the 'Positions And Orders' panel should be visible
    Then I am on the 'Orders' list
    And the 'previously added' order should be present on the list
    And the 'previously added' order 'quantity' cell should contain 'correct' data
    And the 'previously added' order 'order price' cell should contain 'correct' data
    #11
    And I complete 'previously added' market dropdown with value 'Edit Order'
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'edit order'
    # https://jira.gaincapital.com/browse/TPDWT-13054
    #And current simple position information should be correct
    And 'order price' input should be predefined with '1,000.00000'
    And 'quantity' input should be predefined with '2,000'

    And I check 'stop' checkbox
    And I check 'limit' checkbox
    And filled value '1000000' in 'order price' field should be processed correctly
    And filled value '1000000' in 'quantity' field should be processed correctly
    And filled value '1000000' in the '1'st normal stop linked order 'price' should be processed correctly
    And filled value '1000000' in the '2'nd limit linked order 'price' should be processed correctly
    When I click on 'advancedTicket' link
    And filled value '1111111' in the '1'st normal stop linked order 'quantity' should be processed correctly
    And filled value '1111111' in the '2'nd limit linked order 'quantity' should be processed correctly
    And filled value '2222222' in the '1'st normal stop linked order 'p/l' should be processed correctly
    And filled value '2222222' in the '2'nd limit linked order 'p/l' should be processed correctly
    And I uncheck 'stop' checkbox
    And I uncheck 'limit' checkbox
    #12
    When I fill 'quantity' with value '1000'
    When I fill 'order price' with value '2000'
    When I click on 'submit' button
    When I click on 'ok' button
    Then the 'Positions And Orders' panel should be visible
    Then I am on the 'Orders' list
    And the 'previously added' order 'quantity' cell should contain 'correct' data
    And the 'previously added' order 'order price' cell should contain 'correct' data
    When I delete 'position' 'current market'
    #13
    When I click on Search input
    Then Search modal should be visible
    When I wait for markets loading
    And I fill search field with value 'GBP/USD DFT'
    And I wait for markets loading
    And I find opened market from the Search modal
    And I click on 'bid price' in the 'current' market within search modal
    Then the 'Deal ticket' panel should be visible
    And I switch to 'set alert' tab
    Then 'set alert' ticket type should be 'selected'
    #14, 15
    And filled value '1000' in 'alert price' field should be processed correctly
    And filled value '1000000' in 'alert price' field should be processed correctly
    #16
    When I fill 'alert price' with value '1000'
    When I click on 'submit' button
    When I click on 'ok' button
    Then the 'Positions And Orders' panel should be visible
    When I select 'Price Alerts' list
    Then the 'previously added' market should be present on the list
    And the 'previously added' market 'trigger price' cell should contain '1,000.00000' data
    #17
    And I complete 'previously added' market dropdown with value 'Edit Price Alert'
    Then the 'Deal ticket' panel should be visible
    Then 'set alert' ticket type should be 'selected'
    And 'alert price' input should be predefined with '1,000.00000'
    #18
    When I fill 'alert price' with value '2000'
    When I click on 'submit' button
    When I click on 'ok' button
    Then the 'Positions And Orders' panel should be visible
    When I select 'Price Alerts' list
    Then the 'previously added' market should be present on the list
    And the 'previously added' market 'trigger price' cell should contain '2,000.00000' data

  @regression @margin-calculator @wt-164-v4
  Scenario Outline: Margin Calculator
    #1
    When I click on Search input
    Then Search modal should be visible
    When I wait for markets loading
    And I fill search field with value '<Search word>'
    And I wait for markets loading
    And I find Normal market with 'MarketUnderlyingType' property <Property flag> 'FX' in search modal
    And I click on '<Direction>' in the 'current' market within search modal
    And I remember min valid quantity for 'current' market
    And I remember max valid quantity for 'current' market
    Then the 'Deal ticket' panel should be visible
    #2
    When I fill 'quantity' with value 'min valid+1'
    And margin calculator should contain correct information
    And I store data from margin calculator
    #3
    When I fill 'quantity' with value 'max valid*0.5'
    Then Margin calculator 'risks' value should be changed
    Then Margin calculator 'margin' value should be changed
    Then Margin calculator 'details' value should be changed
    #4, 5
    # /newtradeorder request assetion is not implemented
    # for Rejected Trade margin info will be showed after 1.23
    # https://jira.gaincapital.com/browse/TPDWT-21035
    When I fill 'quantity' with value 'max valid'
    And margin calculator should contain correct information
    Then Margin calculator 'risks' value should be changed
    Then Margin calculator 'margin' value should be changed
    Then Margin calculator 'details' value should be changed
    And trade ticket 'red triangle' element is visible
    #6
    And I hover main order 'red triangle' element
    And trade ticket 'margin tooltip' element is visible
    And 'margin tooltip' element text should be 'Your current total position does not cover the funds required to place this trade.'
    When I click on '<Label>' label
    And trade ticket 'margin tooltip' element is not visible
    #7
    When I click on 'submit' button
    And 'ticket failure' element text should be 'Trade not filled'
    And 'error message' element text should be 'Your current total position does not cover the funds required to place this trade.'
    #8-13 through table

    Examples:
      | Search word               | Property flag | Direction | Label |
      | USD/JPY                   | is            | ask price | buy   |
      | Gold (per 0.1) CFD        | is not        | bid price | sell  |


  @regression @position/order-hedgin-state-view @wt-1471-v2 @debug
  Scenario: Position/Order Hedging State view
  #1
    When I make 'Watchlist' panel active
    And I expand 'Popular Markets' watchlist
    And I find any market
    And I click on 'buy' in the 'current' market
    Then the 'Deal ticket' panel should be visible
  #2
    And 'hedging status' element text should be 'Hedging is OFF'
  #3
    When I click on 'advancedTicket' link
    Then 'hedge toggle' element should be disabled
    Then 'hedging status' in deal ticket panel should not be displayed
  #4
    When I click on 'hedge toggle' element
    Then 'hedge toggle' element should be enabled
  #5
    When I click on 'standardTicket' link
    Then 'hedging status' element text should be 'Hedging is ON'
    When I close panel
  #6
    And I add position with parameters:
      | MarketName       | USD/JPY (per 0.01) CFD |
      | Direction        | buy                    |
      | Quantity         | 500                    |
      | PositionMethodId | 1                      |
    And I add position with parameters:
      | MarketName       | USD/JPY (per 0.01) CFD |
      | Direction        | sell                    |
      | Quantity         | 500                    |
      | PositionMethodId | 2                      |
    And I make 'Positions and Orders' panel active
    And I select 'Positions' list
    Then '2' 'previously added' markets should be on the list
  #7
    When I complete '2'nd market dropdown with value 'Amend Position'
    Then the 'Deal ticket' panel should be visible
  #8
    Then 'hedging status' in deal ticket panel should not be displayed
  #9
    When I click on 'advancedTicket' link
    Then 'hedging toggle' in deal ticket panel should not be displayed
    And 'hedging status' in deal ticket panel should not be displayed
    When I close panel
  #10
    And I add order with parameters:
      | MarketName       | USD/JPY |
      | Direction        | Sell    |
      | Quantity         | 1000    |
      | Price            | 114     |
      | PositionMethodId | 1       |
    And I add order with parameters:
      | MarketName       | USD/JPY |
      | Direction        | Buy    |
      | Quantity         | 1000    |
      | Price            | 114     |
      | PositionMethodId | 2       |
    When I make 'Positions And Orders' panel active
    And I select 'Orders' list
    Then '2' 'previously added' orders should be on the list
    When I complete '2'nd market dropdown with value 'edit order'
    Then the 'Deal ticket' panel should be visible
  #11
    Then 'hedging status' element text should be 'Hedging is ON'
  #12
    When I click on 'advancedTicket' link
    Then 'hedging toggle' in deal ticket panel should not be displayed
    And 'hedging status' element text should be 'Hedging is ON'


  @regression @oco-order-hedging-state-view @wt-1473-v1 @debug
  Scenario: OCO Order Hedging State view
  #1
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I find any market
    And I click on 'buy' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    And I switch to 'order' tab
    Then 'order' ticket type should be 'selected'
  #2
    When I click on 'oco' link
    Then the 'oco' order area should contain items:
      | itemName             |
      | sell label           |
      | buy label            |
      | order price          |
      | quantity             |
      | advanced ticket link |
      | good till dropdown   |
  #3
    And 'hedging status' element text should be 'Hedging is OFF'
  #4
    And oco 'hedging status' element text should be 'Hedging is OFF'
  #5
    When I click on 'advancedTicket' link
    Then 'hedge toggle' element should be disabled
    And 'hedging status' in deal ticket panel should not be displayed
  #6
    When I click on oco 'advancedTicket' link
    Then oco 'hedging toggle' in deal ticket panel should not be displayed
    And oco 'hedging status' element text should be 'Hedging is OFF'
  #7
    When I click on 'hedge toggle' element
    Then 'hedge toggle' element should be enabled
    And oco 'hedging status' element text should be 'Hedging is ON'
  #8
    When I click on 'standardTicket' link
    And 'hedging status' element text should be 'Hedging is ON'
  #9
    When I click on oco 'standardTicket' link
    And oco 'hedging status' element text should be 'Hedging is ON'
  #10
    When I remember min valid quantity for 'current' market
    And I fill 'quantity' with value 'min valid'
    And I fill 'order price' with value 'valid order price'
    And I fill oco 'quantity' with value 'min valid'
    And I fill oco 'order price' with value 'current sell * 0.99'
    And I click on 'oco sell label' element
    And I click on 'submit' button
    And I click on 'ok' button
  #11
    When I make 'Positions And Orders' panel active
    And I select 'Orders' list
    Then '2' 'previously added' orders should be on the list
    When I complete '1'st market dropdown with value 'edit order'
    Then the 'Deal ticket' panel should be visible
  #12
    And 'hedging status' element text should be 'Hedging is ON'
    And oco 'hedging status' element text should be 'Hedging is ON'
  #13
    When I click on 'advancedTicket' link
    Then 'hedging toggle' in deal ticket panel should not be displayed
    When I click on oco 'advancedTicket' link
    Then oco 'hedging toggle' in deal ticket panel should not be displayed
    And 'hedging status' element text should be 'Hedging is ON'
    And oco 'hedging status' element text should be 'Hedging is ON'


  @regression @changing-hedge-by-default-setting-in-different-applications @wt-1706-v3 @ignore
  Scenario: Changing 'Hedge by default' setting in different applications
  # Not implemented. mocks required.


  @regression @1ct-hedging @wt-1746-v1 @debug
  Scenario: 1-CT hedging
  #1
    When I add position with parameters:
      | MarketName       | AUD/USD  |
      | Direction        | sell     |
      | Quantity         | 5000     |
      | PositionMethodId | 1        |
    And I make 'Positions and Orders' panel active
    And I select 'Positions' list
    Then the 'previously added' position should be present on the list
  #2
    When I enable one click trading
    And I click on 'user account' header element
    And I go to my account page
    And I go to 'settings' section
    And I click 'toggle' in platform settings section
    Then the hedge is on
  #3
    When I switch to 'Default Workspace' workspace tab
    And I make 'Watchlist' panel active
    And I expand 'Popular Markets' watchlist
    And I fill 1-click 'quantity' with value '1000' for the 'current' market
    And I click on 'buy' in the 'current' market
    And I make 'Positions and Orders' panel active
    And I select 'Positions' list
    Then '2' 'previously added' markets should be on the list
    And the '1'st market position cell should contain 'sell 5000' direction and quantity
    And the '2'nd market position cell should contain 'buy 1000' direction and quantity
  #4
    When I switch to 'My Account' workspace tab
    And I go to 'settings' section
    And I click 'toggle' in platform settings section
    Then the hedge is off
  #5
    When I switch to 'Default Workspace' workspace tab
    And I make 'Watchlist' panel active
    And I expand 'Popular Markets' watchlist
    And I fill 1-click 'quantity' with value '1000' for the 'current' market
    And I click on 'buy' in the 'current' market
    And I make 'Positions and Orders' panel active
    And I select 'Positions' list
    Then '2' 'previously added' market should be on the list
    And the '1'st market position cell should contain 'sell 4000' direction and quantity
    And the '2'nd market position cell should contain 'buy 1000' direction and quantity
    When I delete 'Position' 'current market'
    Then the 'Positions And Orders' panel should be visible
    And the 'previously added' market should be not present on the list
  #6
    When I make 'Watchlist' panel active
    And I expand 'Popular Markets' watchlist
    And I remember min valid quantity for 'EUR/GBP DFT' market
    And I fill 1-click 'quantity' with value '5' for the 'EUR/GBP DFT' market
    And I click on 'buy' in the 'EUR/GBP DFT' market
    And I make 'Positions and Orders' panel active
    And I select 'Positions' list
    Then '1' 'previously added' market should be on the list
  #7
    When I switch to 'My Account' workspace tab
    And I go to 'settings' section
    And I click 'toggle' in platform settings section
    Then the hedge is on
    When I switch to 'Default Workspace' workspace tab
    When I make 'Watchlist' panel active
    And I expand 'Popular Markets' watchlist
    And I remember min valid quantity for 'EUR/GBP DFT' market
    And I fill 1-click 'quantity' with value '1' for the 'EUR/GBP DFT' market
    And I click on 'sell' in the 'EUR/GBP DFT' market
    And I make 'Positions and Orders' panel active
    And I select 'Positions' list
    Then '2' 'previously added' markets should be on the list
    And the '1'st market position cell should contain 'buy 5' direction and quantity
    And the '2'nd market position cell should contain 'sell 1' direction and quantity
  #8
    When I switch to 'My Account' workspace tab
    And I go to 'settings' section
    And I click 'toggle' in platform settings section
    Then the hedge is off
    When I switch to 'Default Workspace' workspace tab
    When I make 'Watchlist' panel active
    And I expand 'Popular Markets' watchlist
    And I remember min valid quantity for 'EUR/GBP DFT' market
    And I fill 1-click 'quantity' with value '1' for the 'EUR/GBP DFT' market
    And I click on 'sell' in the 'EUR/GBP DFT' market
    And I make 'Positions and Orders' panel active
    And I select 'Positions' list
    Then '2' 'previously added' market should be on the list
    And the '1'st market position cell should contain 'buy 4' direction and quantity
    And the '2'nd market position cell should contain 'sell 1' direction and quantity


  @regression @applicability-good-till-cancelled @wt-155-v2 @debug
  Scenario: Applicability - Good Till Cancelled
  #1
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I find any market
    And I click on 'buy' in the 'current' market
    Then the 'Deal ticket' panel should be visible
  #2
    When I remember min valid quantity for 'current' market
    And I fill 'quantity' with value 'min valid'
    Then 'submit button' element should be enabled
  #3
    When I check 'stop' checkbox
    And I fill the '1'st normal stop linked order 'price' with value 'valid stop price' in the 'current market'
    Then the '1'st normal stop linked order 'pips/points' input should be autopopulated
    And the '1'st normal stop linked order 'p/l' input should be autopopulated
    When I check 'limit' checkbox
    And I fill the '2'nd limit linked order 'price' with value 'valid limit price' in the 'current market'
    Then the '2'nd limit linked order 'pips/points' input should be autopopulated
    And the '2'nd limit linked order 'p/l' input should be autopopulated
  #4
    When I click on 'advancedTicket' link
    And I expand '1'st applicability dropdown
    And I select 'Good 'til canceled (GTC)' from expanded dropdown
    Then 'GTC' option should be selected in '1'st applicability dropdown
  #5
    When I click on 'submit' button
    Then 'confirmation' element text should be 'Trade executed'
    And open buy 'current market' trade confirmation message should be correct
  #6
    When I click on 'ok' button
    And I make 'Positions and Orders' panel active
    And I select 'Positions' list
    Then the 'previously added' position should be present on the list
    And the 'previously added' order 'quantity' cell should contain 'min valid*1' data
    And the 'previously added' order 'stop price' cell should contain 'correct' data
    And the 'previously added' order 'limit price' cell should contain 'correct' data
  # post
  # check the option of applicability dropdowns
    When I complete 'previously added' market dropdown with value 'Amend Position'
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'amend position'
    When I click on 'advancedTicket' link
    Then 'GTC' option should be selected in '1'st applicability dropdown
    And 'GTC' option should be selected in '2'nd applicability dropdown
  #7
  # Step 7: not implemented. That functionality haven't implemented yet.
  # When I select 'Orders' list
  # Then '2' 'previously added' orders should be on the list
  #8
  # Step 8: not implemented. Mocks required
  #9
  # Step 9: not implemented. That functionality haven't implemented yet.
  #10
  # Step 10: not implemented. Mocks required


  @regression @applicability-good-till-end-of-day @wt-156-v2 @debug
  Scenario: Applicability - Good Till End of Day
  #1
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I find any market
    And I click on 'buy' in the 'current' market
    Then the 'Deal ticket' panel should be visible
  #2
    When I remember min valid quantity for 'current' market
    And I fill 'quantity' with value 'min valid'
    Then 'submit button' element should be enabled
  #3
    When I check 'stop' checkbox
    And I fill the '1'st normal stop linked order 'price' with value 'valid stop price' in the 'current market'
    Then the '1'st normal stop linked order 'pips/points' input should be autopopulated
    And the '1'st normal stop linked order 'p/l' input should be autopopulated
    When I check 'limit' checkbox
    And I fill the '2'nd limit linked order 'price' with value 'valid limit price' in the 'current market'
    Then the '2'nd limit linked order 'pips/points' input should be autopopulated
    And the '2'nd limit linked order 'p/l' input should be autopopulated
  #4
    When I click on 'advancedTicket' link
    And I expand '1'st applicability dropdown
    And I select 'Good 'til end of day (GTD)' from expanded dropdown
    Then 'GTD' option should be selected in '1'st applicability dropdown
  #5
    When I click on 'submit' button
    Then 'confirmation' element text should be 'Trade executed'
    And open buy 'current market' trade confirmation message should be correct
  #6
    When I click on 'ok' button
    And I make 'Positions and Orders' panel active
    And I select 'Positions' list
    Then the 'previously added' position should be present on the list
    And the 'previously added' order 'quantity' cell should contain 'min valid*1' data
    And the 'previously added' order 'stop price' cell should contain 'correct' data
    And the 'previously added' order 'limit price' cell should contain 'correct' data
  # post
  # check the option of applicability dropdowns
    When I complete 'previously added' market dropdown with value 'Amend Position'
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'amend position'
    And 'GTD' option should be selected in '1'st applicability dropdown
    And 'GTC' option should be selected in '2'nd applicability dropdown
  #7
  # Step 7: not implemented. That functionality haven't implemented yet.
  # When I select 'Orders' list
  # Then '2' 'previously added' orders should be on the list
  #8
  # Step 8: not implemented. Mocks required
  #9
  # Step 9: not implemented. Mocks required


  @regression @applicability-default-value-is-GTC @wt-158-v1 @debug
  Scenario: Applicability - Default value is GTC
  #1
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I find any market
    And I click on 'buy' in the 'current' market
    Then the 'Deal ticket' panel should be visible
  #2
    When I click on 'advancedTicket' link
    Then 'GTC' option should be selected in '1'st applicability dropdown
    And 'GTC' option should be selected in '2'nd applicability dropdown
  #3
    When I expand add stop limit dropdown
    And I select 'Normal stop' from expanded dropdown
    When I expand add stop limit dropdown
    And I select 'Trailing stop' from expanded dropdown
    When I expand add stop limit dropdown
    And I select 'Limit' from expanded dropdown
    Then 'GTC' option should be selected in '3'rd applicability dropdown
    And 'GTC' option should be selected in '4'th applicability dropdown
    And 'GTC' option should be selected in '5'th applicability dropdown


  @regression @red-card-KVP-Online_Chat_URL @wt-1153-v3 @ignore
  Scenario: Red Card - KVP Online_Chat_URL
  # Not implemented. Mocks required.


  @regression @red-card-KVP-contactus_customerservicesemail @wt-1154-v1 @ignore
  Scenario: Red Card - KVP contactus_customerservicesemail
  # Not implemented. Mocks required.


  @regression @trade-ticket @wt-1156-v2 @ignore
  Scenario: Trade ticket
  #1
    Then the 'Watchlist' panel should be visible
    And markets of 'Popular Markets' watchlist should be visible
    When I find market with at least '1' decimal places
    And I click on 'buy' in the 'current' market
    Then the 'Deal ticket' panel should be visible
  #2
    When I check 'stop' checkbox
    Then the '1'st normal stop linked order 'price' element should be enabled
    And the '1'st normal stop linked order 'pips/points' element should be enabled
    And the '1'st normal stop linked order 'p/l' element should be enabled
  #3
    When I fill the '1'st normal stop linked order 'price' with value '1000.1' in the 'current market'
    Then the '1'st normal stop linked order 'price' should be filled with '1000.1'
  #4
    When I modify the '1'st normal stop linked order 'price' value by adding '11' at the end
    Then the '1'st normal stop linked order 'price' should be filled with '1000.111'
  #5
    When I modify the '1'st normal stop linked order 'price' value by adding '11' at the start
    Then the '1'st normal stop linked order 'price' should be filled with '111000.111'
  #6
    When I select the '1'st normal stop linked order 'price' value first '1' symbol and replace it with '2'
    Then the '1'st normal stop linked order 'price' should be filled with '211000.111'
  #7
  #8
  #9
  #10
  #11
  #12
  #13
  #14
  #15
  #16
  #17


  @regression @order-ticket @wt-1162-v2 @ignore
  Scenario: Order ticket
  #1
  #2
  #3
  #4
  #5
  #6
  #7
  #8
  #9
  #10
  #11
  #12
  #13
  #14
  #15
  #16
  #17
  #18


  @regression @oco-ticket @wt-1163-v2 @ignore
  Scenario: OCO ticket
  #1
  #2
  #3
  #4
  #5
  #6
  #7
  #8
  #9
  #10
  #11
  #12
  #13
  #14
  #15
  #16
  #17
  #18
  #19


  @regression @amend-position @wt-1164-v2 @ignore
  Scenario: Amend position
  #1
  #2
  #3
  #4
  #5
  #6
  #7
  #8
  #9
  #10
  #11
  #12
  #13
  #14
  #15
  #16
  #17
  #18


  @regression @edit-oco @wt-1165-v2 @ignore
  Scenario: Edit OCO
  #1
  #2
  #3
  #4
  #5
  #6
  #7
  #8
  #9
  #10
  #11
  #12
  #13
  #14
  #15
  #16
  #17
  #18
  #19


  @regression @decimal-places-restrictions @wt-1317-v2 @ignore
  Scenario: Decimal places restrictions
  #1
  #2
  #3
  #4
  #5


  @regression @decimal-places-displaying @wt-1643-v2 @ignore
  Scenario: Decimal places displaying
  #1
  #2
  #3
  #4
  #5
  #6
  #7
  #8
  #9


  @regression @market-price-fast-changing @wt-1658-v1 @ignore
  Scenario: Market price fast changing
  #1
  #2
  #3
  #4


  @quick @smoke @USD/JPY @GBP/USD-DFT @trade-ticket-standard-view-open-buy/sell-position-with-stop-and-limit-cfd/spread-market @wt-142 @wt-115
  Scenario Outline: Trade Ticket Standard View - Open Buy/Sell position with stop and limit - CFD/Spread market
    When I add new tab
    And I add new 'Watchlist' panel in 'New workspace 2' tab
    And I resize panel with:
      | height | 600  |
      | width  | 1000 |
    And I expand 'Popular Markets' watchlist
    And I click on '<Direction>' in the '<Market name>' market
    Then the 'Deal ticket' panel should be visible
    When I close panel
    Then the 'Deal ticket' panel should be invisible
    When I add new 'Watchlist' panel in 'New workspace 2' tab
    And I expand 'Popular Markets' watchlist
    And I click on '<Direction>' in the '<Market name>' market
    Then the 'Deal ticket' panel should be visible
    And 'trade' ticket type should be 'selected'
    And 'trade label' element text should be 'trade'
    And 'order label' element text should be 'order'
    And 'set alert label' element text should be 'set alert'
    And 'market info' element text should be '<Market name>'
    And the number of decimal places in <Direction> price button is correct for '<Market name>'
    And the number of decimal places in <OppDirection> price button is correct for '<Market name>'
    And '<OppDirection>' price should change with time
    And '<Direction>' price should change with time
    And the number of decimal places in <Direction> price button is correct for '<Market name>'
    And the number of decimal places in <OppDirection> price button is correct for '<Market name>'
    And '<Market name>' 'quantity' placeholder should be correct
    And cursor is placed in the 'quantity' field
    And the '1'st normal stop linked order 'price' placeholder should be correct
    And the '1'st normal stop linked order 'pips/points' placeholder should be correct
    And the '1'st normal stop linked order 'p/l' placeholder should be correct
    # OPENED ISSUES: https://jira.gaincapital.com/browse/TPDWT-16713
    #                https://jira.gaincapital.com/browse/TPDWT-15622
    And the '<Market name>' '1'st normal stop linked order p/l currency sign should be correct
    And the '1'st normal stop order should contain fields:
      | itemName   |
      | checkbox   |
      | dropdown   |
      | price      |
      | pips/points|
      | p/l        |
    And the '2'nd limit order should contain fields:
      | itemName |
      | checkbox |
      | label    |
      | price    |
      | pips/points|
      | p/l      |
    And the trade ticket standard view panel should contain items:
      | itemName             |
      | advanced ticket link |
    And 'hedging status' element text should be 'Hedging is OFF'
    And 'submit button' element should be disabled
    And 'submit button' element text should be 'Choose quantity'
    When I click on '<OppDirection>' label
    Then the '<OppDirection>' button should be '<Opposite color>' when it is 'clicked'
    When I click on '<Direction>' label
    Then the '<Direction>' button should be '<Color>' when it is 'clicked'
    When I fill 'quantity' with value '<Quantity>'
    Then 'submit button' element should be enabled
    And 'submit button' element text should be 'Place Trade'
    When I check 'stop' checkbox
    And I fill the '1'st normal stop linked order 'price' with value '<Stop price>' in the 'current market'
    Then the '1'st normal stop linked order 'pips/points' input should be autopopulated
    And the '1'st normal stop linked order 'p/l' input should be autopopulated
    And the '1'st normal stop linked order 'p/l' value should change with time
    And the '1'st normal stop linked order 'p/l' input should be autopopulated
    When I clear the '1'st normal stop linked order 'pips/points' input field
    Then the '1'st normal stop linked order 'pips/points' input should be blank
    And the '1'st normal stop linked order 'price' input should be blank
    And the '1'st normal stop linked order 'p/l' input should be blank
    And 'quantity' input value is 'correct'
    When I check 'limit' checkbox
    And I fill the '2'nd limit linked order 'price' with value '<Limit price>' in the 'current market'
    Then the '2'nd limit linked order 'pips/points' input should be autopopulated
    And the '2'nd limit linked order 'p/l' input should be autopopulated
    And the '2'nd limit linked order 'p/l' value should change with time
    And the '2'nd limit linked order 'p/l' input should be autopopulated
    When I clear the '2'nd limit linked order 'pips/points' input field
    Then the '2'nd limit linked order 'pips/points' input should be blank
    And the '2'nd limit linked order 'price' input should be blank
    And the '2'nd limit linked order 'p/l' input should be blank
    And 'quantity' input value is 'correct'
    When I fill the '1'st normal stop linked order 'price' with value '<Stop price>' in the 'current market'
    And I fill the '2'nd limit linked order 'price' with value '<Limit price>' in the 'current market'
    And I click on 'submit' button
    Then 'confirmation' element text should be 'Trade executed'
    And 'market name' element text should be '<Market name>'
    And open <Direction> '<Market name>' trade confirmation message should be correct
    When I click on 'ok' button
    And I add new 'Positions And Orders' panel in 'current' tab
    And I resize panel with:
      | height | 600  |
      | width  | 800  |
    Then the 'previously added' market should be present on the list

    Examples:
      | Market name | Quantity | Stop price | Limit price | Direction | OppDirection | Color | Opposite color |
      | USD/JPY     | 1000     | 90         | 140         | buy       | sell         | blue  | red            |
      | GBP/USD DFT | 2        | 1.8        | 1           | sell      | buy          | red   | blue           |

  @quick @smoke @USD/JPY @GBP/USD-DFT @partially-close-buy/sell-position-cfd/spread-market
  Scenario Outline: Partially Close Buy/Sell Position - CFD/Spread market
    And I add position with parameters:
      | MarketName | <Market name> |
      | Direction  | <Direction>   |
      | Quantity   | <Quantity>    |
    Then the 'Positions And Orders' panel should be visible
    Then the 'previously added' market should be present on the list
    When I click on 'close' in the '<Market name>' market
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'amend position'
    And 'market info' element text should be '<Market name>'
    And 'sell' price should change with time
    And 'buy' price should change with time
    # OPENED issue: https://jira.gaincapital.com/browse/TPDWT-16845
    # And current simple position information should be correct
    And 'close' radiobutton should be 'selected'
    And 'close quantity' input should be predefined with '<Quantity>'
    # https://jira.gaincapital.com/browse/TPDWT-14948 - ticket for future implementation number format in this message
    # And close info message should be correct
    And 'submit button' element should be enabled
    When I fill 'close quantity' with value '<Close quantity>'
    Then partially close info message should be correct
    When I click on 'submit' button
    Then 'confirmation' element text should be 'Trade Executed'
    And 'market name' element text should be '<Market name>'
    And partially close confirmation message should be correct
    When I make 'Positions And Orders' panel active
    Then the 'previously added' market 'position' cell should contain 'updated' data

    Examples:
      | Market name | Quantity | Close quantity | Direction |
      | USD/JPY     | 2000     | 1000           | buy       |
      | GBP/USD DFT | 2        | 1              | sell      |

  @quick @smoke @USD/JPY @GBP/USD-DFT @amend-buy/sell-position-cfd/spread-market @wt-116
  Scenario Outline: Amend Buy/Sell Position - CFD/Spread Market
    And I add position with parameters:
      | MarketName | <Market name> |
      | Direction  | <Direction>   |
      | Quantity   | <Quantity>    |
      | StopPrice  | <Stop price>  |
      | LimitPrice | <Limit price> |
    Then the 'Positions And Orders' panel should be visible
    Then the '<Market name>' market should be present on the list
    When I hover 'Previously added' market
    And I click on 'dropdown arrow' in the '<Market name>' market
    And I select 'Amend Position' in dropdown menu in '<Market name>' market
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'amend position'
    And 'close' radiobutton should be 'selected'
    When I click on 'editRadio' button
    Then 'edit' radiobutton should be 'selected'
    When I fill the '1'st normal stop linked order 'price' with value '<New stop price>' in the 'current market'
    Then the '1'st normal stop linked order 'p/l' input should be autopopulated
    And '<Opposite direction>' price should change with time
    And '<Direction>' price should change with time
    And the '1'st normal stop linked order 'p/l' input should be autopopulated
    When I fill the '2'nd limit linked order 'price' with value '<New limit price>' in the 'current market'
    Then the '2'nd limit linked order 'p/l' input should be autopopulated
    And '<Opposite direction>' price should change with time
    And '<Direction>' price should change with time
    And the '2'nd limit linked order 'p/l' input should be autopopulated
    When I click on 'submit' button
    Then 'confirmation' element text should be 'Position updated'
    And 'market name' element text should be '<Market name>'
    And 'confirmation message' element text should be 'Your order has been updated.'
    When I click on 'ok' button
    And I make 'Positions And Orders' panel active
    Then the 'previously added' market 'stop price' should contain correct data
    And the 'previously added' market 'limit price' should contain correct data

    Examples:
      | Market name | Quantity | Stop price | Limit price | New stop price | New limit price | Direction | Opposite direction |
      | USD/JPY     | 1000     | 90         | 140         | 85             | 145             | buy       | sell               |
      | GBP/USD DFT | 2        | 1.8        | 1           | 1.9            | 0.9             | sell      | buy                |

  @quick @smoke @USD/JPY @GBP/USD-DFT @fully-close-buy/sell-position-cfd/spread-market
  Scenario Outline: Fully Close Buy/Sell Position - CFD/Spread Market
    And I add position with parameters:
      | MarketName | <Market name> |
      | Direction  | <Direction>   |
      | Quantity   | <Quantity>    |
    Then the 'Positions And Orders' panel should be visible
    Then the 'previously added' market should be present on the list
    When I click on 'delete' in the '<Market name>' market
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'amend position'
    And 'market info' element text should be '<Market name>'
    And 'sell' price should change with time
    And 'buy' price should change with time
    # OPENED issue: https://jira.gaincapital.com/browse/TPDWT-16845
    # And current simple position information should be correct
    And 'close' radiobutton should be 'selected'
    And 'close quantity' input should be predefined with '<Quantity>'
    And close info message should be correct
    And 'submit button' element should be enabled
    And close info message should be correct
    When I click on 'submit' button
    Then 'confirmation' element text should be 'Trade Executed'
    And 'market name' element text should be '<Market name>'
    And confirmation message should be correct
    When I make 'Positions And Orders' panel active
    Then the 'previously added' market should be not present on the list

    Examples:
      | Market name | Quantity | Direction |
      | USD/JPY     | 1000     | buy       |
      | GBP/USD DFT | 2        | sell      |

  @Japan-225-CFD @close-buy/sell-position-with-qty-lower-than-the-market-minimum-size @wt-1279 @wt-1281 @ignore
  Scenario Outline: Close Buy/Sell Position with QTY LOWER than the market minimum size
    And I add position with parameters:
      | MarketName    | <Market name>    |
      | Direction     | <Direction>      |
      | Quantity      | <Quantity>       |
      | StopPrice     | <Stop price>     |
      | LimitPrice    | <Limit price>    |
      | StopQuantity  | <Stop quantity>  |
      | LimitQuantity | <Limit quantity> |
    Then the 'Positions And Orders' panel should be visible
    And the '<Market name>' market should be present on the list
    And the 'previously added' market position cell should contain '<Direction> <Left quantity>' direction and quantity
    When I click on 'delete' in the '<Market name>' market
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'amend position'
    And 'close quantity' element should be disabled
    And 'submit button' element should be enabled
    When I click on 'submit' button
    And I make 'Positions And Orders' panel active
    Then the 'previously added' market should be not present on the list
    When I add position with parameters:
      | MarketName | <Market name>   |
      | Direction  | <Direction>     |
      | Quantity   | <Stop quantity> |
    Then the 'Positions And Orders' panel should be visible
    And the '<Market name>' market should be present on the list
    And the 'previously added' market position cell should contain '<Direction> <Stop quantity>' direction and quantity
    When I click on 'delete' in the '<Market name>' market
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'amend position'
    And 'close quantity' element should be enabled
    And 'submit button' element should be enabled
    When I click on 'submit' button
    And I make 'Positions And Orders' panel active
    Then the 'previously added' market should be not present on the list
    When I add position with parameters:
      | MarketName | <Market name> |
      | Direction  | <Direction>   |
      | Quantity   | <Quantity>    |
    Then the 'Positions And Orders' panel should be visible
    And the '<Market name>' market should be present on the list
    And the 'previously added' market position cell should contain '<Direction> <Quantity>' direction and quantity
    When I click on 'delete' in the '<Market name>' market
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'amend position'
    And 'close quantity' element should be enabled
    And 'submit button' element should be enabled
    When I click on 'submit' button
    And I make 'Positions And Orders' panel active
    Then the 'previously added' market should be not present on the list

    Examples:
      | Market name      | Quantity | Stop quantity | Limit quantity | Left quantity | Stop price | Limit price | Direction |
      | Japan 225 CFD    | 100      | 70            | 70             | 30            | sell       | buy         | buy       |
      | Japan 225 CFD    | 100      | 70            | 70             | 30            | buy        | sell        | sell      |
      # | Ethereum ($) DFT | 0.4      | 0.39          | 0.39           | 0.01          | sell       | buy         | buy       |
      # | Ethereum ($) DFT | 0.4      | 0.39          | 0.39           | 0.01          | buy        | sell        | sell      |

  @smoke @amend-position-ticket-is-closed-if-the-position-is-removed @wt-1310
  Scenario Outline: Amend position ticket is closed if the position is removed
    And I add position with parameters:
      | MarketName | <Market name> |
      | Direction  | <Direction>   |
      | Quantity   | <Quantity>    |
    Then the 'Positions And Orders' panel should be visible
    And the '<Market name>' market should be present on the list
    When I click on 'delete' in the '<Market name>' market
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'amend position'
    When I delete 'position' '<Market name>'
    Then the 'Positions And Orders' panel should be visible
    Then the '<Market name>' market should be not present on the list
    Then the 'Deal ticket' panel should be invisible

    Examples:
      | Market name | Quantity | Direction |
      | USD/JPY     | 1000     | buy       |
      | GBP/USD DFT | 2        | sell      |

  @smoke @position-details-tickets-are-closed-if-the-position-is-removed @wt-1310
  Scenario Outline: Position details ticket is closed if the position is removed
    And I add position with parameters:
      | MarketName | <Market name> |
      | Direction  | <Direction>   |
      | Quantity   | <Quantity>    |
    Then the 'Positions And Orders' panel should be visible
    And the '<Market name>' market should be present on the list
    When I hover '1'st market
    Then the 'current' market 'dropdown arrow' should be visible
    When I click on 'dropdown arrow' in the 'current' market
    And I select 'Position details' in dropdown menu in 'current' market
    Then the 'details' panel should be visible
    When I delete 'position' '<Market name>'
    Then the 'Positions And Orders' panel should be visible
    Then the '<Market name>' market should be not present on the list
    Then the 'details' panel should be invisible

    Examples:
      | Market name | Quantity | Direction |
      | USD/JPY     | 1000     | buy       |
      | GBP/USD DFT | 2        | sell      |

  @USD/JPY @trade-auto-populated-fields @currency-convertion-test
  Scenario Outline: Trade auto-populated fields
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I click on '<Direction>' in the '<Market name>' market
    Then the 'Deal ticket' panel should be visible
    When I fill 'quantity' with value '<Quantity>'
    And I check 'stop' checkbox
    Then I store data from the main '1'st normal stop linked order
    And I fill the '1'st normal stop linked order 'pips/points' with value '<Points>' in the 'current market'
    Then the main '1'st normal stop linked order 'price' input should be changed
    And the main '1'st normal stop linked order 'p/l' input should be changed
    When I clear the '1'st normal stop linked order 'pips/points' input field
    Then the '1'st normal stop linked order 'pips/points' input should be blank
    And the '1'st normal stop linked order 'price' input should be blank
    And the '1'st normal stop linked order 'p/l' input should be blank
    Then I store data from the main '1'st normal stop linked order
    When I fill the '1'st normal stop linked order 'price' with value '<Stop price>' in the 'current market'
    Then the main '1'st normal stop linked order 'pips/points' input should be changed
    And the main '1'st normal stop linked order 'p/l' input should be changed
    When I clear the '1'st normal stop linked order 'price' input field
    Then the '1'st normal stop linked order 'pips/points' input should be blank
    And the '1'st normal stop linked order 'price' input should be blank
    And the '1'st normal stop linked order 'p/l' input should be blank
    Then I store data from the main '1'st normal stop linked order
    When I fill the '1'st normal stop linked order 'p/l' with value '<Loss>' in the 'current market'
    Then the main '1'st normal stop linked order 'pips/points' input should be changed
    And the main '1'st normal stop linked order 'price' input should be changed
    When I check 'limit' checkbox
    Then I store data from the main '2'nd limit linked order
    And I fill the '2'nd limit linked order 'pips/points' with value '<Points>' in the 'current market'
    Then the main '2'nd limit linked order 'price' input should be changed
    And the main '2'nd limit linked order 'p/l' input should be changed
    When I clear the '2'nd limit linked order 'pips/points' input field
    Then the '2'nd limit linked order 'pips/points' input should be blank
    And the '2'nd limit linked order 'price' input should be blank
    And the '2'nd limit linked order 'p/l' input should be blank
    Then I store data from the main '2'nd limit linked order
    When I fill the '2'nd limit linked order 'price' with value '<Limit price>' in the 'current market'
    Then the main '2'nd limit linked order 'pips/points' input should be changed
    And the main '2'nd limit linked order 'p/l' input should be changed
    When I clear the '2'nd limit linked order 'price' input field
    Then the '2'nd limit linked order 'pips/points' input should be blank
    And the '2'nd limit linked order 'price' input should be blank
    And the '2'nd limit linked order 'p/l' input should be blank
    Then I store data from the main '2'nd limit linked order
    When I fill the '2'nd limit linked order 'p/l' with value '<Profit>' in the 'current market'
    Then the main '2'nd limit linked order 'pips/points' input should be changed
    And the main '2'nd limit linked order 'price' input should be changed
    Then I store data from the main '1'st normal stop linked order
    Then I store data from the main '2'nd limit linked order
    When I fill 'quantity' with value '<Quantity 2>'
    Then the main '1'st normal stop linked order 'pips/points' input should be changed
    And the main '1'st normal stop linked order 'price' input should be changed
    And the main '2'nd limit linked order 'pips/points' input should be changed
    And the main '2'nd limit linked order 'price' input should be changed
    When I fill 'quantity' with value '<Quantity>'
    And I expand '1'st linked order types dropdown
    And I select 'trailing' from expanded dropdown
    And I fill the '1'st normal stop linked order 'pips/points away' with value '<Points>' in the 'current market'
    And I uncheck 'limit' checkbox
    And I click on 'submit' button
    Then open '<Market name>' <Direction> attached trailing stop order confirmation message should be displayed correctly

    Examples:
      | Market name    | Quantity | Direction | Points | Stop price | Limit price | Loss  | Profit | Quantity 2 |
      | USD/JPY        | 1000     | buy       | 100    | 90         | 120         | -100  | 100    | 2000       |

  @smoke @guaranteed-stop @trade-auto-populated-fields @wt-154 @ignore
  Scenario Outline: Trade auto-populated fields
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
#    And I find <Market type> market with available Guaranteed stop
    And I remember min valid quantity for 'current' market
    And I click on '<Direction>' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    When I fill 'quantity' with value '<Quantity>'
    And I check 'stop' checkbox
    Then I store data from the main '1'st normal stop linked order
    And I fill the '1'st normal stop linked order 'pips/points' with value '<Points>' in the 'current market'
    Then the main '1'st normal stop linked order 'price' input should be changed
    And the main '1'st normal stop linked order 'p/l' input should be changed
    When I clear the '1'st normal stop linked order 'pips/points' input field
    Then the '1'st normal stop linked order 'pips/points' input should be blank
    And the '1'st normal stop linked order 'price' input should be blank
    And the '1'st normal stop linked order 'p/l' input should be blank
    Then I store data from the main '1'st normal stop linked order
    When I fill the '1'st normal stop linked order 'price' with value '<Stop price>' in the 'current market'
    Then the main '1'st normal stop linked order 'pips/points' input should be changed
    And the main '1'st normal stop linked order 'p/l' input should be changed
    When I clear the '1'st normal stop linked order 'price' input field
    Then the '1'st normal stop linked order 'pips/points' input should be blank
    And the '1'st normal stop linked order 'price' input should be blank
    And the '1'st normal stop linked order 'p/l' input should be blank
    Then I store data from the main '1'st normal stop linked order
    When I fill the '1'st normal stop linked order 'p/l' with value '<Loss>' in the 'current market'
    Then the main '1'st normal stop linked order 'pips/points' input should be changed
    And the main '1'st normal stop linked order 'price' input should be changed
    When I check 'limit' checkbox
    Then I store data from the main '2'nd limit linked order
    And I fill the '2'nd limit linked order 'pips/points' with value '<Points>' in the 'current market'
    Then the main '2'nd limit linked order 'price' input should be changed
    And the main '2'nd limit linked order 'p/l' input should be changed
    When I clear the '2'nd limit linked order 'pips/points' input field
    Then the '2'nd limit linked order 'pips/points' input should be blank
    And the '2'nd limit linked order 'price' input should be blank
    And the '2'nd limit linked order 'p/l' input should be blank
    Then I store data from the main '2'nd limit linked order
    When I fill the '2'nd limit linked order 'price' with value '<Limit price>' in the 'current market'
    Then the main '2'nd limit linked order 'pips/points' input should be changed
    And the main '2'nd limit linked order 'p/l' input should be changed
    When I clear the '2'nd limit linked order 'price' input field
    Then the '2'nd limit linked order 'pips/points' input should be blank
    And the '2'nd limit linked order 'price' input should be blank
    And the '2'nd limit linked order 'p/l' input should be blank
    Then I store data from the main '2'nd limit linked order
    When I fill the '2'nd limit linked order 'p/l' with value '<Profit>' in the 'current market'
    Then the main '2'nd limit linked order 'pips/points' input should be changed
    And the main '2'nd limit linked order 'price' input should be changed
    And I expand '1'st linked order types dropdown
    And I select 'guaranteed' from expanded dropdown
    Then I store data from the main '1'st normal stop linked order
    And I fill the '1'st guaranteed stop linked order 'pips/points' with value '<Points>' in the 'current market'
    Then the main '1'st normal stop linked order 'price' input should be changed
    And the main '1'st normal stop linked order 'p/l' input should be changed
    When I clear the '1'st guaranteed stop linked order 'pips/points' input field
    Then the '1'st guaranteed stop linked order 'pips/points' input should be blank
    And the '1'st guaranteed stop linked order 'price' input should be blank
    And the '1'st guaranteed stop linked order 'p/l' input should be blank
    Then I store data from the main '1'st normal stop linked order
    When I fill the '1'st guaranteed stop linked order 'price' with value '<Stop price>' in the 'current market'
    Then the main '1'st normal stop linked order 'pips/points' input should be changed
    And the main '1'st normal stop linked order 'p/l' input should be changed
    When I clear the '1'st normal stop linked order 'price' input field
    Then the '1'st normal stop linked order 'pips/points' input should be blank
    And the '1'st normal stop linked order 'price' input should be blank
    And the '1'st normal stop linked order 'p/l' input should be blank
    Then I store data from the main '1'st normal stop linked order
    When I fill the '1'st normal stop linked order 'p/l' with value '<Loss>' in the 'current market'
    Then the main '1'st normal stop linked order 'pips/points' input should be changed
    And the main '1'st normal stop linked order 'price' input should be changed
    Then I store data from the main '1'st normal stop linked order
    Then I store data from the main '2'nd limit linked order
    When I fill 'quantity' with value '<Quantity 2>'
    Then the main '1'st normal stop linked order 'pips/points' input should be changed
    And the main '1'st normal stop linked order 'price' input should be changed
    And the main '2'nd limit linked order 'pips/points' input should be changed
    And the main '2'nd limit linked order 'price' input should be changed
    When I fill 'quantity' with value '<Quantity>'
    And I expand '1'st linked order types dropdown
    And I select 'trailing' from expanded dropdown
    And I fill the '1'st normal stop linked order 'pips/points away' with value '<Points>' in the 'current market'
    And I uncheck 'limit' checkbox
    And I click on 'submit' button
    Then open '<Market name>' <Direction> attached trailing stop order confirmation message should be displayed correctly

    Examples:
      | Market type    | Quantity    | Direction | Points | Stop price | Limit price | Loss  | Profit | Quantity 2  |
      | CFD            | min valid*1 | buy       | 100    | buy*0.9    | buy*1.1     | -1000 | 1000   | min valid*2 |
      | Spread         | min valid*1 | sell      | 100    | sell*1.14  | sell*0.91   | -300  | 300    | min valid*2 |

  @smoke @USD/JPY @trade-ticket-advanced-view @wt-865
  Scenario: Trade Ticket Advanced View
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I click on 'buy' in the 'USD/JPY' market
    Then the 'Deal ticket' panel should be visible
    And the trade ticket standard view panel should contain items:
      |itemName            |
      |advanced ticket link|
    When I click on 'advancedTicket' link
    Then 'market info' element text should be 'USD/JPY'
    And 'sell' price should change with time
    And 'buy' price should change with time
    And 'USD/JPY' 'quantity' placeholder should be correct
    And the '1'st normal stop order should contain fields:
      | itemName      |
      | checkbox      |
      | dropdown      |
      | quantity      |
      | price         |
      | pips/points   |
      | p/l           |
      | applicability |
    And the '2'nd limit order should contain fields:
      | itemName      |
      | checkbox      |
      | label         |
      | quantity      |
      | price         |
      | pips/points   |
      | p/l           |
      | applicability |
    And the order ticket advanced view panel should contain items:
      | itemName                     |
      | quantity                     |
      | add stop limit dropdown link |
      | hedging toggle               |
      | hedging info icon            |
      | standard ticket link         |
    When I hover main order 'hedging info icon' element
    Then trade ticket 'hedging tooltip' element is visible
    When I click on 'standardTicket' link
    Then the trade ticket standard view panel should not contain items:
      | itemName                     |
      | add stop limit dropdown link |
      | hedging toggle               |
      | hedging info icon            |
      | standard ticket link         |
    When I check 'stop' checkbox
    And I check 'limit' checkbox
    And I click on 'advancedTicket' link
    Then the 'stop' checkbox is checked
    And the 'limit' checkbox is checked
    When I fill the '1'st normal stop linked order 'quantity' with value '1000' in the 'current market'
    Then 'standard ticket link' element should be disabled
    When I clear the '1'st normal stop linked order 'quantity' input field
    Then 'standard ticket link' element should be enabled
    When I fill the '2'nd limit linked order 'quantity' with value '1000' in the 'current market'
    Then 'standard ticket link' element should be disabled
    When I clear the '2'nd limit linked order 'quantity' input field
    Then 'standard ticket link' element should be enabled
    When I expand '1'st applicability dropdown
    And I select 'Good 'til end of day (GTD)' from expanded dropdown
    Then 'standard ticket link' element should be disabled
    When I expand '1'st applicability dropdown
    And I select 'Good 'til time (GTT)' from expanded dropdown
    Then 'standard ticket link' element should be disabled
    When I expand '1'st applicability dropdown
    And I select 'Good 'til canceled (GTC)' from expanded dropdown
    Then 'standard ticket link' element should be enabled

  @quick @smoke @GBP/USD-DFT @place-sell-trade-with-multiple-linked-orders-spread-market
  Scenario: Place sell trade with multiple linked orders - Spread market
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    # And I click on 'sell' in the 'GBP/USD DFT' market
    And I find market with available Guaranteed stop
    And I click on 'sell' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    When I click on 'advancedTicket' link
    And I expand add stop limit dropdown
    Then add a stop or limit dropdown from trade tab contains correct items
    And I select 'Guaranteed stop' from expanded dropdown
    Then 'standard ticket link' element should be disabled
    And the number of linked orders should be '3'
    And the '3'rd guaranteed stop order should contain fields:
      | itemName      |
      | trash icon    |
      | dropdown      |
      | quantity      |
      | price         |
      | pips/points   |
      | p/l           |
      | applicability |
    When I expand add stop limit dropdown
    And I select 'Limit' from expanded dropdown
    Then the number of linked orders should be '4'
    And the '4'th limit order should contain fields:
      | itemName      |
      | trash icon    |
      | label         |
      | quantity      |
      | price         |
      | pips/points   |
      | p/l           |
      | applicability |
    When I remember min valid quantity for 'current' market
    And I fill 'quantity' with value 'min valid*5'
    And I check 'stop' checkbox
    And I fill the '1'st normal stop linked order 'quantity' with value 'min valid*0.5' in the 'current market'
    Then 'stop validation' element text should be 'correct'
    And 'submit button' element should be disabled
    And 'submit button' element text should be 'Quantity too low'
    When I fill the '1'st normal stop linked order 'quantity' with value 'min valid*1' in the 'current market'
    And I fill the '1'st normal stop linked order 'price' with value 'sell*1.01' in the 'current market'
    Then the '1'st normal stop linked order 'pips/points' input should be autopopulated
    And the '1'st normal stop linked order 'p/l' input should be autopopulated
    When I check 'limit' checkbox
    And I fill the '2'nd limit linked order 'quantity' with value 'min valid*0.5' in the 'current market'
    Then 'limit validation' element text should be 'correct'
    And 'submit button' element should be disabled
    And 'submit button' element text should be 'Quantity too low'
    And I fill the '2'nd limit linked order 'quantity' with value 'min valid*1' in the 'current market'
    And I fill the '2'nd limit linked order 'price' with value 'sell*0.99' in the 'current market'
    Then the '2'nd limit linked order 'pips/points' input should be autopopulated
    And the '2'nd limit linked order 'p/l' input should be autopopulated
    When I fill the '3'rd guaranteed stop linked order 'quantity' with value 'min valid*1' in the 'current market'
    And I fill the '3'rd guaranteed stop linked order 'price' with value 'sell*1.01' in the 'current market'
    Then the '3'rd guaranteed stop linked order 'pips/points' input should be autopopulated
    And the '3'rd guaranteed stop linked order 'p/l' input should be autopopulated
    When I fill the '4'th limit linked order 'quantity' with value 'min valid*1' in the 'current market'
    And I fill the '4'th limit linked order 'price' with value 'sell*0.99' in the 'current market'
    Then the '4'th limit linked order 'pips/points' input should be autopopulated
    And the '4'th limit linked order 'p/l' input should be autopopulated
    When I click on 'submit' button
    Then 'confirmation' element text should be 'Trade executed'
    And 'market name' element text should be 'current market'
    When I click on 'ok' button
    Then the 'Positions And Orders' panel should be visible
    Then the 'previously added' market should be present on the list
    And the 'previously added' market 'stop price' cell should contain 'multiple' word
    And the 'previously added' market 'limit price' cell should contain 'multiple' word

  @smoke @USD/JPY @trade-ticket-advanced-view-multiple-stops-limits-applicability
  Scenario: Trade Ticket Advanced View - Multiple Stops Limits - Applicability
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I click on 'buy' in the 'USD/JPY' market
    Then the 'Deal ticket' panel should be visible
    When I click on 'advancedTicket' link
    And I check 'stop' checkbox
    Then 'GTC' option should be selected in '1'st applicability dropdown
    When I expand '1'st applicability dropdown
    Then the options from expanded dropdown should be:
      |Good 'til canceled (GTC)|
      |Good 'til end of day (GTD)|
      |Good 'til time (GTT) Select a specific date and time|
    And 'submit button' element should be disabled
    And 'submit button' element text should be 'Choose quantity'
    When I fill 'quantity' with value '2000'
    And I fill the '1'st normal stop linked order 'quantity' with value '1000' in the 'current market'
    Then 'submit button' element should be disabled
    And 'submit button' element text should be 'Choose stop and limit levels'
    When I fill the '1'st normal stop linked order 'price' with value '100' in the 'current market'
    Then the '1'st normal stop linked order 'pips/points' input should be autopopulated
    And the '1'st normal stop linked order 'p/l' input should be autopopulated
    And 'submit button' element should be enabled
    When I check 'limit' checkbox
    Then 'submit button' element should be disabled
    And 'submit button' element text should be 'Choose quantity'
    When I expand '2'nd applicability dropdown
    And I select 'Good 'til time (GTT)' from expanded dropdown
    Then 'GTT' option should be selected in '2'nd applicability dropdown
    And the '2'nd limit order should contain fields:
      | itemName      |
      | date picker   |
    When I fill the '2'nd limit linked order 'quantity' with value '1000' in the 'current market'
    Then 'submit button' element should be disabled
    And 'submit button' element text should be 'Choose stop and limit levels'
    When I fill the '2'nd limit linked order 'price' with value '120' in the 'current market'
    Then the '2'nd limit linked order 'pips/points' input should be autopopulated
    And the '2'nd limit linked order 'p/l' input should be autopopulated
    When I expand '2'nd date picker dropdown
    And I add to date/time picker '2' hours
    And 'submit button' element should be enabled
    When I expand add stop limit dropdown
    And I select 'Trailing stop' from expanded dropdown
    And I fill the '3'rd trailing stop linked order 'quantity' with value '1000' in the 'current market'
    And I fill the '3'rd trailing stop linked order 'pips/points away' with value '30' in the 'current market'
    And I expand '3'rd applicability dropdown
    And I select 'Good 'til end of day (GTD)' from expanded dropdown
    Then 'GTD' option should be selected in '3'rd applicability dropdown
    And 'submit button' element should be enabled
    When I click on 'submit' button
    Then 'confirmation' element text should be 'Trade executed'
    When I click on 'ok' button
    Then the 'Positions And Orders' panel should be visible
    Then the 'previously added' market should be present on the list
    When I click on 'stop price' in the 'USD/JPY' market
    Then the 'Deal ticket' panel should be visible
    And 'GTC' option should be selected in '1'st applicability dropdown
    And 'GTT' option should be selected in '2'nd applicability dropdown
    And 'GTD' option should be selected in '3'rd applicability dropdown

  @smoke @quick @trade-error-handling-missing-quantity-invalid-quantity-stop/limit-price-buy/sell-cfd/spread
  Scenario Outline: Trade Error Handling - Missing Quantity, Invalid Quantity - Stop/Limit Price - Buy/Sell CFD/Spread
    Then the 'Watchlist' panel should be visible
    And I expand 'Popular Markets' watchlist
    And I click on '<Direction>' in the '<Market name>' market
    Then the 'Deal ticket' panel should be visible
    And 'submit button' element should be disabled
    And 'submit button' element text should be 'Choose quantity'
    When I remember max valid quantity for 'current' market
    And I remember min valid quantity for 'current' market
    When I fill 'quantity' with value 'min valid+1'
    Then 'submit button' element should be enabled
    And 'submit button' element text should be 'Place Trade'
    When I clear 'quantity' field
    Then 'submit button' element should be disabled
    And 'submit button' element text should be 'Choose quantity'
    When I fill 'quantity' with value 'min valid-0.01'
    Then '<Market name>' order 'min quantity' validation should be correct
    And 'submit button' element text should be 'Quantity too low'
    When I fill 'quantity' with value 'max valid+1'
    Then '<Market name>' order 'max quantity' validation should be correct
    And 'submit button' element text should be 'Quantity too high'
    When I fill 'quantity' with value 'min valid+1'
    And I check 'stop' checkbox
    Then 'submit button' element should be disabled
    And 'submit button' element text should be 'Choose stop and limit levels'
    When I fill the '1'st normal stop linked order 'price' with value '<Stop price>' in the 'current market'
    Then '<Direction>' '<Market name>' '1'st stop price validation should be correct
    And 'submit button' element should be disabled
    And 'submit button' element text should be '<Submit btn Stop txt>'
    When I uncheck 'stop' checkbox
    And I check 'limit' checkbox
    Then 'submit button' element should be disabled
    And 'submit button' element text should be 'Choose stop and limit levels'
    When I fill the '2'nd limit linked order 'price' with value '<Limit price>' in the 'current market'
    Then '<Direction>' '<Market name>' '2'nd limit price validation should be correct
    And 'submit button' element should be disabled
    And 'submit button' element text should be '<Submit btn Limit txt>'

    Examples:
      | Market name | Direction | Stop price | Limit price | Submit btn Stop txt | Submit btn Limit txt |
      | USD/JPY     | buy       | 150        | 90          | stop level too high | limit level too low  |
      | GBP/USD DFT | sell      | 1          | 5           | stop level too low  | limit level too high |

  @smoke @quick @validation @trade-error-handling-multiple-stop/limit-quantity-buy/sell-cfd/spread
  Scenario Outline: Trade Error Handling - Multiple Stop/Limit Quantity - Buy/Sell CFD/Spread
    Then the 'Watchlist' panel should be visible
    And I expand 'Popular Markets' watchlist
    And I click on '<Direction>' in the '<Market name>' market
    Then the 'Deal ticket' panel should be visible
    And 'submit button' element should be disabled
    And 'submit button' element text should be 'Choose quantity'
    When I fill 'quantity' with value '<Quantity>'
    Then 'submit button' element should be enabled
    And 'submit button' element text should be 'Place Trade'
    When I click on 'advancedTicket' link
    And I check 'stop' checkbox
    Then 'submit button' element should be disabled
    And 'submit button' element text should be 'Choose stop and limit levels'
    When I fill the '1'st normal stop linked order 'quantity' with value '<1st stop quantity>' in the 'current market'
    And I check 'limit' checkbox
    And I fill the '2'nd limit linked order 'quantity' with value '<2nd limit quantity>' in the 'current market'
    When I expand add stop limit dropdown
    And I select 'Normal stop' from expanded dropdown
    And I fill the '3'rd normal stop linked order 'quantity' with value '<3rd stop quantity>' in the 'current market'
    Then the '3'rd stop max quantity validation should be correct
    When I expand add stop limit dropdown
    And I select 'Limit' from expanded dropdown
    And I fill the '4'th limit linked order 'quantity' with value '<4th limit quantity>' in the 'current market'
    Then the '4'th limit max quantity validation should be correct

    Examples:
      | Market name | Direction | Quantity | 1st stop quantity | 2nd limit quantity | 3rd stop quantity | 4th limit quantity |
      | USD/JPY     | buy       | 2500     | 1000              | 1100               | 1600              | 1700               |
      | GBP/USD DFT | sell      | 10       | 3                 | 4                  | 8                 | 10                 |

  @smoke @validation @stop/limit-fields-border-validation @wt-1254
  Scenario: Stop/Limit fields border validation
    # REQUIREMENTS: TestLink testcase wt-1508
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I find market with available Guaranteed stop
    And I click on 'buy' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    When I click on 'advancedTicket' link
    And I check 'stop' checkbox
    Then the '1'st normal stop order 'quantity border' element should have red color
    When I check 'limit' checkbox
    Then the '2'nd limit order 'quantity border' element should have red color
    When I remember max valid quantity for 'current' market
    # fill invalid general quantity (> max valid quantity)
    And I fill 'quantity' with value 'max valid*1.5'
    Then 'current market' order 'max quantity' validation should be correct
    # fill valid stop quantity (max valid quantity<  <general quantity)
    When I fill the '1'st normal stop linked order 'quantity' with value 'max valid*1.2' in the 'current market'
    # fill valid general quantity, set stop quantity became invalid
    And I fill 'quantity' with value 'max valid*0.5'
    Then the order 'quantity' field should have no color
    And the '1'st normal stop order 'quantity border' element should have red color
    # OPENED issue: https://jira.gaincapital.com/browse/TPDWT-15115
    # temporary commented
    # And the '1'st stop max quantity validation should be correct
    # fill invalid stop price
    When I fill the '1'st normal stop linked order 'price' with value 'buy*1.01' in the 'current market'
    Then the '1'st normal stop order 'quantity border' element should have red color
    And the '1'st normal stop order 'price border' element should have red color
    And the '1'st normal stop order 'points border' element should have red color
    And the '1'st normal stop order 'p/l border' element should have red color
    # And the '1'st stop max quantity validation should be correct
    # fill valid stop quantity
    When I fill the '1'st normal stop linked order 'quantity' with value 'max valid*0.1' in the 'current market'
    Then the '1'st normal stop order 'price border' element should have red color
    And the '1'st normal stop order 'points border' element should have red color
    And the '1'st normal stop order 'p/l border' element should have red color
    And 'buy' 'current market' main '1'st stop price validation should be correct
    When I fill 'quantity' with value 'max valid*1.5'
    Then 'current market' order 'max quantity' validation should be correct
    When I fill the '2'nd limit linked order 'quantity' with value 'max valid*1.2' in the 'current market'
    And I fill 'quantity' with value 'max valid*0.5'
    Then the order 'quantity' field should have no color
    And the '2'nd limit order 'quantity border' element should have red color
    # And the '2'nd limit max quantity validation should be correct
    When I fill the '2'nd limit linked order 'price' with value 'buy*0.90' in the 'current market'
    Then the '2'nd limit order 'quantity border' element should have red color
    And the '2'nd limit order 'price border' element should have red color
    And the '2'nd limit order 'points border' element should have red color
    And the '2'nd limit order 'p/l border' element should have red color
    # And the '2'nd limit max quantity validation should be correct
    When I fill the '2'nd limit linked order 'quantity' with value 'max valid*0.1' in the 'current market'
    Then the '2'nd limit order 'price border' element should have red color
    And the '2'nd limit order 'points border' element should have red color
    And the '2'nd limit order 'p/l border' element should have red color
    And 'buy' 'current market' main '2'nd limit price validation should be correct
    When I expand add stop limit dropdown
    And I select 'Guaranteed stop' from expanded dropdown
    # fill stop quantity more than general Quantity (max valid*0.5)
    And I fill the '3'rd guaranteed stop linked order 'quantity' with value 'max valid*0.7' in the 'current market'
    Then the '3'rd guaranteed stop order 'quantity border' element should have red color
    And the '3'rd stop max quantity validation should be correct
    When I fill the '3'rd guaranteed stop linked order 'price' with value 'buy*1.01' in the 'current market'
    Then the '3'rd guaranteed stop order 'quantity border' element should have red color
    And the '3'rd guaranteed stop order 'price border' element should have red color
    And the '3'rd guaranteed stop order 'points border' element should have red color
    And the '3'rd guaranteed stop order 'p/l border' element should have red color
    And the '3'rd stop max quantity validation should be correct
    # fill stop quantity, for sum with other stops is more than general Quantity (max valid*0.5)
    When I fill the '3'rd guaranteed stop linked order 'quantity' with value 'max valid*0.2' in the 'current market'
    Then the '3'rd guaranteed stop order 'price border' element should have red color
    And the '3'rd guaranteed stop order 'points border' element should have red color
    And the '3'rd guaranteed stop order 'p/l border' element should have red color
    And buy 'current market' '3'rd guaranteed stop price validation should be correct
    When I expand add stop limit dropdown
    And I select 'Limit' from expanded dropdown
    # fill stop quantity more than general Quantity (max valid*0.5)
    And I fill the '4'th limit linked order 'quantity' with value 'max valid*0.7' in the 'current market'
    Then the '4'th limit max quantity validation should be correct
    When I fill the '4'th limit linked order 'price' with value 'buy*0.90' in the 'current market'
    Then the '4'th limit order 'quantity border' element should have red color
    And the '4'th limit order 'price border' element should have red color
    And the '4'th limit order 'points border' element should have red color
    And the '4'th limit order 'p/l border' element should have red color
    And the '4'th limit max quantity validation should be correct
    When I fill the '4'th limit linked order 'quantity' with value 'max valid*0.2' in the 'current market'
    Then the '4'th limit order 'price border' element should have red color
    And the '4'th limit order 'points border' element should have red color
    And the '4'th limit order 'p/l border' element should have red color
    And 'buy' 'current market' main '4'th limit price validation should be correct

  @smoke @quick @risking-and-margin-calculator-removing-with-incorrect-quantity
  Scenario Outline: Risking and Margin calculator, removing with incorrect quantity
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I click on '<Direction>' in the '<Market name>' market
    And I remember max valid quantity for 'current' market
    And I remember min valid quantity for 'current' market
    Then the 'Deal ticket' panel should be visible
    When I fill 'quantity' with value 'min valid+1'
    When I wait for '300'
    Then 'submit button' element text should be 'Place Trade'
    # Risk details in deal ticket to be in account ccy
    # https://jira.gaincapital.com/browse/TPDWT-16584
    # https://jira.gaincapital.com/browse/TPDWT-11092
    # KVP EnableFXRateConversion - will be API call for this key
    And margin calculator should contain correct information
    When I fill 'quantity' with value '0'
    Then 'submit button' element text should be 'Quantity too low'
    And margin calculator should contain nothing
    When I fill 'quantity' with value 'max valid+1'
    Then 'submit button' element text should be 'Quantity too high'
    And margin calculator should contain nothing

    Examples:
      | Market name | Direction |
      | USD/JPY     | buy       |
      | GBP/USD DFT | sell      |

  @smoke @bug @decimal-places-restriction
  Scenario: Decimal places restriction can't be bypassed in price and points fields
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I click on 'sell' in the 'UK 100 DFT' market
    Then the 'Deal ticket' panel should be visible
    When I check 'Stop' checkbox
    And I fill the '1'st normal stop linked order 'price' with value '8555.666' in the 'current market'
    Then the '1'st normal stop linked order 'price' input should be '8555.6'
    When I check 'Limit' checkbox
    And I fill the '2'nd limit linked order 'pips/points' with value '1000.555' in the 'current market'
    Then the '2'st limit linked order 'pips/points' input should be '1000.5'


  @AUD/USD @last-0-digits-are-shown-in-confirmation-modal
  Scenario: Last 0 digits are shown in confirmation modal
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I click on 'sell' in the 'AUD/USD' market
    Then the 'Deal ticket' panel should be visible
    When I fill 'quantity' with value '1000'
    And I wait for 'sell' price has trailing zeros
    And I click on 'submit' button
    Then open sell confirmation message should be displayed correctly
