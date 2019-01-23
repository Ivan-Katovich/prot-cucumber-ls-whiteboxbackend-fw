@orderticket
Feature: Order Ticket panel
  As a user
  I can open order ticket panel
  So all functionality should work fine for the panel

  Background:
    Given I am logged in to the application with default state

  @functional-smoke @regression @applicability-good-till-time @wt-1525-v7
  Scenario: Applicability - Good Till Time
    #1
    Then the 'Watchlist' panel should be visible
    # Popular Markets changed after 1.23
    And markets of 'Popular Markets' watchlist should be visible
    And I find any market
    And I click on 'buy' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    When I remember min valid quantity for 'current' market
    And I move panel to the 'top-right' corner
    And I switch to 'order' tab
    Then 'order' ticket type should be 'selected'
    When I click on 'advancedTicket' link
    #2
    When I fill 'quantity' with value 'min valid+1'
    When I fill 'current market' price with value not between current prices on 'buy'
    Then 'submit button' element should be enabled
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
    And 'submit button' element should be enabled
    #4
    And 'main good till dropdown' element text should be 'Good 'til canceled (GTC)'
    When I expand 'good till dropdown link' dropdown
    And I select 'GTT' from expanded dropdown
    Then the order ticket standard view panel should contain items:
      | itemName    |
      | date picker |
    And date picker input should be defined with '0' minutes more than now
    #5,6
    When I expand 'date picker' dropdown
    And date picker input should be defined with '0' minutes more than now
    Then 'date picker' dropdown should be visible
    And 'previous month' should not be visible inside date/time picker
    And 'current day-1' should not be visible inside date/time picker
    #7, 8
    When I add to date/time picker '2' hours and click outside
    Then date picker input should be defined with '2' hours more than now
    When I click on 'submit' button
    And I click on 'ok' button
    #9, 10
    Then the 'Positions And Orders' panel should be visible
    When I select 'Orders' list
    Then the 'previously added' market should be present on the list
    And the 'previously added' market 'stop price' cell should contain 'correct' data
    And the 'previously added' market 'limit price' cell should contain 'correct' data
    #11, 12 - requires mocks

#    =================================================================================================================================
#                                                    Functional smoke
#                                                            |
#                                                        Regression
#    =================================================================================================================================

  @regression @order-ticket-standard-view @wt-143-v11
  Scenario Outline: Order Ticket - Standard View
  #1
    When I make 'Watchlist' panel active
    And I expand 'Popular Markets' watchlist
    And I find any market
    And I click on '<Direction>' in the 'current' market
    Then the 'Deal ticket' panel should be visible
  #2
    When I switch to 'order' tab
    Then 'order' ticket type should be 'selected'
    And 'trade label' element text should be 'trade'
    And 'order label' element text should be 'order'
    And 'set alert label' element text should be 'set alert'
    And 'market info' element text should be 'current market'
    And '<Opposite direction>' price should change with time
    And '<Direction>' price should change with time
    And the order ticket standard view panel should contain items:
        | itemName             |
        | order price          |
        | quantity             |
        | advanced ticket link |
        | oco link             |
        | good till dropdown   |
    # Price, QTY and GTC fields are shown in grey background box
    And 'order price' should be inside 'grey' background box
    And 'quantity' should be inside 'grey' background box
    And 'GTC dropdown' should be inside 'grey' background box
    And 'current' 'quantity' placeholder should be correct
    And the '1'st normal stop order should contain fields:
        | itemName |
        | checkbox |
        | dropdown |
        | price    |
        | points   |
        | p/l      |
    And the '2'nd limit order should contain fields:
        | itemName |
        | checkbox |
        | label    |
        | price    |
        | points   |
        | p/l      |
    And the '1'st normal stop linked order 'price' element should be disabled
    And the '1'st normal stop linked order 'pips/points' element should be disabled
    And the '1'st normal stop linked order 'p/l' element should be disabled
    And the '2'nd limit linked order 'price' element should be disabled
    And the '2'nd limit linked order 'pips/points' element should be disabled
    And the '2'nd limit linked order 'p/l' element should be disabled
    And 'hedging status' element text should be 'Hedging is OFF'
    And 'submit button' element should be disabled
    And 'submit button' element text should be 'Choose quantity'
  #3
    And '<Opposite direction>' tick should be correct color
    And '<Direction>' tick should be correct color
  #4
  # stop dropdown cannot be expanded w/o checking 'stop' checkbox
    When I check 'stop' checkbox
    And I expand '1'st linked order types dropdown
    And I select 'trailing' from expanded dropdown
    Then the '1'st trailing stop order should contain fields:
        | itemName    |
        | checkbox    |
        | dropdown    |
        | pips/points |
    And the '1'st normal stop linked order 'pips/points away' should be displayed and fit the ticket width
  #5
  # 'Checkbox style corresponds to the design' not automated
    When I expand '1'st linked order types dropdown
    And I select 'stop' from expanded dropdown
    And I check 'limit' checkbox
    Then the '1'st normal stop linked order 'price' element should be enabled
    And the '1'st normal stop linked order 'pips/points' element should be enabled
    And the '1'st normal stop linked order 'p/l' element should be enabled
    And the '2'nd limit linked order 'price' element should be enabled
    And the '2'nd limit linked order 'pips/points' element should be enabled
    And the '2'nd limit linked order 'p/l' element should be enabled
  # placeholder should be grey not implemented
  # Then the '1'st normal stop linked order 'price placeholder' should be colored grey
  # And the '1'st normal stop linked order 'pips/points placeholder' should be colored grey
  # And the '1'st normal stop linked order 'p/l placeholder' should be colored grey
  # And the '2'nd limit linked order 'price placeholder' should be colored grey
  # And the '2'nd limit linked order 'pips/points placeholder' should be colored grey
  # And the '2'nd limit linked order 'p/l placeholder' should be colored grey
  #6
    When I remember min valid quantity for 'current' market
    And I fill 'quantity' with value 'min valid*1'
    And I fill 'order price' with value '200'
    And I fill the '1'st normal stop linked order 'pips/points' with value '10' in the 'current market'
    Then the '1'st normal stop linked order 'price' input should be autopopulated
    And the '1'st normal stop linked order 'p/l' input should be autopopulated
    When I fill the '2'nd limit linked order 'pips/points' with value '10' in the 'current market'
    Then the '2'nd limit linked order 'price' input should be autopopulated
    And the '2'nd limit linked order 'p/l' input should be autopopulated
    And 'submit button' element should be enabled
    And 'submit button' element text should be 'Place Order'
  #7
    When I click on '<Opposite direction>' label
    Then 'submit button' element should be enabled
    And 'submit button' element text should be 'Place Order'
  #8
    When I uncheck 'stop' checkbox
    And I uncheck 'limit' checkbox
    And I click on the '2'nd limit linked order 'price border' field
    Then the '2'nd limit linked order 'price' element should be enabled
    And the '2'nd limit linked order 'pips/points' element should be enabled
    And the '2'nd limit linked order 'p/l' element should be enabled
  #9
    When I close 'deal ticket' panel
    And I make 'Watchlist' panel active
    And I expand 'Popular Markets' watchlist
    And I find market with at least '5' decimal places
    And I click on '<Direction>' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    When I switch to 'order' tab
    Then 'order' ticket type should be 'selected'
  #10
    When I remember min valid quantity for 'current' market
    And I fill 'quantity' with value 'min valid*1'
    And I fill 'order price' with value '200.12345'
    And I check 'stop' checkbox
    And I fill the '1'st normal stop linked order 'price' with value '200.01234' in the 'current market'
    And I check 'limit' checkbox
    And I fill the '2'nd limit linked order 'price' with value '200.54321' in the 'current market'
  #11
    When I click on 'submit' button
    And I click on 'ok' button
    And I make 'Positions And Orders' panel active
    And I select 'Orders' list
    Then the 'previously added' market should be present on the list
    When I complete 'previously added' market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
    And 'order price' should be filled with '200.12345'
    And the '1'st normal stop linked order 'price' should be filled with '200.01234'
    And the '2'nd limit linked order 'price' should be filled with '200.54321'

  Examples:
    | Direction | Opposite direction |
    | buy       | sell               |

  @regerssion @buy-trigger-active-order-spread-market @wt-121-v4
  Scenario: Buy - Trigger Active Order SPREAD Market
  #1
    When I make 'Watchlist' panel active
    And I expand 'Popular Markets' watchlist
    And I find Spread market
    And I click on 'buy' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    When I switch to 'order' tab
    Then 'order' ticket type should be 'selected'
  #2
    When I remember min valid quantity for 'current' market
    And I remember all quantity sizes for 'current' market
    And I fill 'order price' with value 'valid order price'
    Then 'validation message' in deal ticket panel should not be displayed
  #3
    When I fill 'quantity' with value 'min valid*1'
    Then 'validation message' in deal ticket panel should not be displayed
  #4
    Then 'main good till dropdown' element text should contain 'GTC'
  #5
    When I click on 'submit' button
    Then trade confirmation appeared in right places
    And 'confirmation' element text should be 'Order placed'
    And 'market name' element text should be 'current market'
    And open buy 'current' order without stops and limits confirmation message should be correct
  #6
    When I click on 'ok' button
    And I make 'Positions And Orders' panel active
    And I select 'Orders' list
    Then the 'previously added' order should be present on the list
  #7
  # Step 7 not automated, mocks required
  # When I wait till buy price for 'current' market reaches 'valid'
  # And I select 'Order History' list
  # Then the 'previously added' order should be present on the list
  # And the 'previously added' order should have 'open' status
  # When I select 'Positions' list
  # Then the 'previously added' market should be present on the list


@regerssion @sell-trigger-active-order-cfd-market @wt-1430-v4
  Scenario: Sell - Trigger Active Order CFD Market
  #1
    When I make 'Watchlist' panel active
    And I expand 'Popular Markets' watchlist
    And I find CFD market
    And I click on 'sell' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    When I switch to 'order' tab
    Then 'order' ticket type should be 'selected'
  #2
    When I remember min valid quantity for 'current' market
    And I remember all quantity sizes for 'current' market
    And I fill 'order price' with value 'valid order price'
    Then 'validation message' in deal ticket panel should not be displayed
  #3
    When I fill 'quantity' with value 'min valid*1'
    Then 'validation message' in deal ticket panel should not be displayed
  #4
    Then 'main good till dropdown' element text should contain 'GTC'
  #5
    When I click on 'submit' button
    Then trade confirmation appeared in right places
    And 'confirmation' element text should be 'Order placed'
    And 'market name' element text should be 'current market'
    And open sell 'current' order without stops and limits confirmation message should be correct
  #6
    When I click on 'ok' button
    And I make 'Positions And Orders' panel active
    And I select 'Orders' list
    Then the 'previously added' order should be present on the list
  #7
  # Step 7 not automated, mocks required
  # When I wait till sell price for 'current' market reaches 'valid'
  # And I select 'Order History' list
  # Then the 'previously added' order should be present on the list
  # And the 'previously added' order should have 'open' status
  # When I select 'Positions' list
  # Then the 'previously added' market should be present on the list


  @regression @buy-place-order-stop/limit-spread-market @wt-122-v10
  Scenario: Buy - Place Order Stop/Limit Spread Market
  #1
    When I make 'Watchlist' panel active
    And I expand 'Popular Markets' watchlist
    And I find Spread market
    And I click on 'buy' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    When I switch to 'order' tab
    Then 'order' ticket type should be 'selected'
  # And 'Deal ticket' panel should be displayed in the center of the screen
  #2
    When I remember min valid quantity for 'current' market
    And I remember all quantity sizes for 'current' market
    And I fill 'order price' with value 'valid order price'
    Then 'validation message' in deal ticket panel should not be displayed
  #3
    When I fill 'quantity' with value 'min valid*1'
    Then 'validation message' in deal ticket panel should not be displayed
  #4
    When I check 'stop' checkbox
    And I fill the '1'st normal stop linked order 'price' with value 'valid stop price' in the 'current market'
    Then the '1'st normal stop linked order 'pips/points' input should be autopopulated
    And the '1'st normal stop linked order 'p/l' input should be autopopulated
    When I check 'limit' checkbox
    And I fill the '2'nd limit linked order 'price' with value 'valid limit price' in the 'current market'
    Then the '2'nd limit linked order 'pips/points' input should be autopopulated
    And the '2'nd limit linked order 'p/l' input should be autopopulated
    When I uncheck 'stop' checkbox
    And I uncheck 'limit' checkbox
    Then the '1'st normal stop linked order 'price' element should be disabled
    And the '1'st normal stop linked order 'price' should be filled with ''
    And the '1'st normal stop linked order 'pips/points' element should be disabled
    And the '1'st normal stop linked order 'pips/points' should be filled with ''
    And the '1'st normal stop linked order 'p/l' element should be disabled
    And the '1'st normal stop linked order 'p/l' should be filled with ''
    And the '2'nd limit linked order 'price' element should be disabled
    And the '2'nd limit linked order 'price' should be filled with ''
    And the '2'nd limit linked order 'pips/points' element should be disabled
    And the '2'nd limit linked order 'pips/points' should be filled with ''
    And the '2'nd limit linked order 'p/l' element should be disabled
    And the '2'nd limit linked order 'p/l' should be filled with ''
  #5
    When I check 'stop' checkbox
    And I fill the '1'st normal stop linked order 'price' with value 'valid stop price' in the 'current market'
    Then 'validation message' in deal ticket panel should not be displayed
    And the '1'st normal stop linked order 'pips/points' input should be autopopulated
    And the '1'st normal stop linked order 'p/l' input should be autopopulated
  #6
    When I check 'limit' checkbox
    And I fill the '2'nd limit linked order 'price' with value 'valid limit price' in the 'current market'
    Then 'validation message' in deal ticket panel should not be displayed
    And the '2'nd limit linked order 'pips/points' input should be autopopulated
    And the '2'nd limit linked order 'p/l' input should be autopopulated
    #7
    When 'buy' price should change with time
    Then the '1'st normal stop linked order 'p/l' should be filled with 'same'
    And the '2'nd limit linked order 'p/l' should be filled with 'same'
  #8
  # May fail due to after modifying value that <1 by arrow. For some markets it becomes 0.
    When I modify the '1'st normal stop linked order filled 'price' by typing 'ARROW_UP' key until the price will be above 'sell*1.001' in the 'current market'
    Then 'buy' 'current market' main '1'st stop price validation should be correct
    When I fill the '1'st normal stop linked order 'price' with value 'valid stop price' in the 'current market'
    And I modify the '2'nd limit linked order filled 'price' by typing 'ARROW_DOWN' key until the price will be below 'sell*0.999' in the 'current market'
    Then 'buy' 'current market' main '2'nd limit price validation should be correct
    When I fill the '2'nd limit linked order 'price' with value 'valid limit price' in the 'current market'
  #9
    Then 'main good till dropdown' element text should contain 'GTC'
  #10
    When I click on 'advancedTicket' link
    And I modify the '1'st normal stop linked order filled 'price' by typing 'ARROW_UP' key until the price will be above 'sell*1.001' in the 'current market'
    Then 'buy' 'current market' main '1'st stop price validation should be correct
    When I fill the '1'st normal stop linked order 'price' with value 'valid stop price' in the 'current market'
    And I modify the '2'nd limit linked order filled 'price' by typing 'ARROW_DOWN' key until the price will be below 'sell*0.999' in the 'current market'
    Then 'buy' 'current market' main '2'nd limit price validation should be correct
    When I fill the '2'nd limit linked order 'price' with value 'valid limit price' in the 'current market'
  #11
    When I click on 'submit' button
    Then trade confirmation appeared in right places
    And 'confirmation' element text should be 'Order placed'
    And 'market name' element text should be 'current market'
    And open buy 'current' order without stops and limits confirmation message should be correct
  #12
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
  #13
    When I make 'Positions And Orders' panel active
    And I select 'Orders' list
    Then the 'previously added' order should be present on the list
  #14
    When I make 'Watchlist' panel active
    And I expand 'Popular Markets' watchlist
    And I find Spread market
    And I click on 'buy' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    When I switch to 'order' tab
    And I check 'stop' checkbox
    And I check 'limit' checkbox
    Then max allowed symbols in 'quantity' field should be '15'
    And max allowed symbols in 'order price' field should be '15'
    And max allowed symbols in the '1'st normal stop linked order 'price' should be '15'
    And max allowed symbols in the '1'st normal stop linked order 'pips/points' should be '15'
    And max allowed symbols in the '1'st normal stop linked order 'p/l' should be '15'
    And max allowed symbols in the '2'nd limit linked order 'price' should be '15'
    And max allowed symbols in the '2'nd limit linked order 'pips/points' should be '15'
    And max allowed symbols in the '2'nd limit linked order 'p/l' should be '15'


  @regression @sell-place-order-stop/limit-cfd-market @wt-1431-v9
  Scenario: Sell - Place Order Stop/Limit CFD Market
  #1
    When I make 'Watchlist' panel active
    And I expand 'Popular Markets' watchlist
    And I find CFD market
    And I click on 'sell' in the 'current' market
    Then the 'Deal ticket' panel should be visible
  # And 'Deal ticket' panel should be displayed in the center of the screen
  #2
    When I switch to 'order' tab
    Then 'order' ticket type should be 'selected'
  #3
    When I remember min valid quantity for 'current' market
    And I remember all quantity sizes for 'current' market
    And I fill 'order price' with value 'valid order price'
    Then 'validation message' in deal ticket panel should not be displayed
  #4
    When I fill 'quantity' with value 'min valid*1'
    Then 'validation message' in deal ticket panel should not be displayed
  #5
    When I check 'stop' checkbox
    And I fill the '1'st normal stop linked order 'price' with value 'valid stop price' in the 'current market'
    Then the '1'st normal stop linked order 'pips/points' input should be autopopulated
    And the '1'st normal stop linked order 'p/l' input should be autopopulated
    When I check 'limit' checkbox
    And I fill the '2'nd limit linked order 'price' with value 'valid limit price' in the 'current market'
    Then the '2'nd limit linked order 'pips/points' input should be autopopulated
    And the '2'nd limit linked order 'p/l' input should be autopopulated
    When I uncheck 'stop' checkbox
    And I uncheck 'limit' checkbox
    Then the '1'st normal stop linked order 'price' element should be disabled
    And the '1'st normal stop linked order 'price' should be filled with ''
    And the '1'st normal stop linked order 'pips/points' element should be disabled
    And the '1'st normal stop linked order 'pips/points' should be filled with ''
    And the '1'st normal stop linked order 'p/l' element should be disabled
    And the '1'st normal stop linked order 'p/l' should be filled with ''
    And the '2'nd limit linked order 'price' element should be disabled
    And the '2'nd limit linked order 'price' should be filled with ''
    And the '2'nd limit linked order 'pips/points' element should be disabled
    And the '2'nd limit linked order 'pips/points' should be filled with ''
    And the '2'nd limit linked order 'p/l' element should be disabled
    And the '2'nd limit linked order 'p/l' should be filled with ''
  #6
    When I check 'stop' checkbox
    And I fill the '1'st normal stop linked order 'price' with value 'valid stop price' in the 'current market'
    Then 'validation message' in deal ticket panel should not be displayed
    And the '1'st normal stop linked order 'pips/points' input should be autopopulated
    And the '1'st normal stop linked order 'p/l' input should be autopopulated
  #7
    When I check 'limit' checkbox
    And I fill the '2'nd limit linked order 'price' with value 'valid limit price' in the 'current market'
    Then 'validation message' in deal ticket panel should not be displayed
    And the '2'nd limit linked order 'pips/points' input should be autopopulated
    And the '2'nd limit linked order 'p/l' input should be autopopulated
  #8
    When 'sell' price should change with time
    Then the '1'st normal stop linked order 'p/l' should be filled with 'same'
    And the '2'nd limit linked order 'p/l' should be filled with 'same'
  #9
  # May fail due to after modifying value that <1 by arrow. For some markets it becomes 0.
    When I modify the '1'st normal stop linked order filled 'price' by typing 'ARROW_DOWN' key until the price will be below 'sell*0.999' in the 'current market'
    Then 'sell' 'current market' main '1'st stop price validation should be correct
    When I fill the '1'st normal stop linked order 'price' with value 'valid stop price' in the 'current market'
    And I modify the '2'nd limit linked order filled 'price' by typing 'ARROW_UP' key until the price will be above 'sell*1.001' in the 'current market'
    Then 'sell' 'current market' main '2'nd limit price validation should be correct
    When I fill the '2'nd limit linked order 'price' with value 'valid limit price' in the 'current market'
  #10
    Then 'main good till dropdown' element text should contain 'GTC'
  #11
    When I click on 'advancedTicket' link
    And I modify the '1'st normal stop linked order filled 'price' by typing 'ARROW_DOWN' key until the price will be below 'sell*0.999' in the 'current market'
    Then 'sell' 'current market' main '1'st stop price validation should be correct
    When I fill the '1'st normal stop linked order 'price' with value 'valid stop price' in the 'current market'
    And I modify the '2'nd limit linked order filled 'price' by typing 'ARROW_UP' key until the price will be above 'sell*1.001' in the 'current market'
    Then 'sell' 'current market' main '2'nd limit price validation should be correct
    When I fill the '2'nd limit linked order 'price' with value 'valid limit price' in the 'current market'
  #12
    When I click on 'submit' button
    Then trade confirmation appeared in right places
    And 'confirmation' element text should be 'Order placed'
    And 'market name' element text should be 'current market'
    And open sell 'current' order without stops and limits confirmation message should be correct
  #13
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
  #14
    When I make 'Positions And Orders' panel active
    And I select 'Orders' list
    Then the 'previously added' order should be present on the list
    And the 'previously added' order 'quantity' cell should contain 'sell min valid*1' data
    And the 'previously added' order 'order price' cell should contain 'correct' data
    And the 'previously added' order 'stop price' cell should contain 'correct' data
    And the 'previously added' order 'limit price' cell should contain 'correct' data
  #15
    When I make 'Watchlist' panel active
    And I expand 'Popular Markets' watchlist
    And I find CFD market
    And I click on 'sell' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    When I switch to 'order' tab
    Then 'order' ticket type should be 'selected'
    When I remember min valid quantity for 'current' market
    And I remember all quantity sizes for 'current' market
    And I fill 'order price' with value 'valid order price'
    And I fill 'quantity' with value 'min valid*1'
    And I click on 'submit' button
    Then open sell 'current' order without stops and limits confirmation message should be correct
    When I click on the '1'st normal stop linked order 'price border' field
    Then the '1'st normal stop linked order 'price' element should be disabled
    And the '1'st normal stop linked order 'pips/points' element should be disabled
    And the '1'st normal stop linked order 'p/l' element should be disabled
    When I click on the '2'nd limit linked order 'price border' field
    Then the '2'nd limit linked order 'price' element should be disabled
    And the '2'nd limit linked order 'pips/points' element should be disabled
    And the '2'nd limit linked order 'p/l' element should be disabled


  @regression @buy-edit-order-price/quantity-spread-market @wt-1058-v6
  Scenario: Buy - Edit Order Price/Quantity Spread Market
  #pretest
    Then I make 'Watchlist' panel active
    And I expand 'Popular Markets' watchlist
    And I find Spread market
    And I click on 'buy' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    When I switch to 'order' tab
    Then 'order' ticket type should be 'selected'
    When I remember min valid quantity for 'current' market
    And I remember all quantity sizes for 'current' market
    And I fill 'order price' with value 'valid order price'
    And I fill 'quantity' with value 'min valid*1'
    And I check 'stop' checkbox
    And I fill the '1'st normal stop linked order 'price' with value 'valid stop price' in the 'current market'
    And I check 'limit' checkbox
    And I fill the '2'nd limit linked order 'price' with value 'valid limit price' in the 'current market'
    And I click on 'submit' button
    And I click on 'ok' button
  #1
    Then I make 'Positions And Orders' panel active
    And I select 'Orders' list
    Then the 'previously added' market should be present on the list
    When I complete 'previously added' market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'edit order'
    And 'market info' element text should be 'current market'
    And 'sell' price should change with time
    And 'buy' price should change with time
    And 'order price' input should be editable
    And 'order price' input should be predefined with 'same'
    And 'quantity' input should be editable
    And 'quantity' input should be predefined with 'same'
    And the edit ticket standard view panel should contain items:
        | itemName             |
        | order price          |
        | quantity             |
        | good till dropdown   |
        | advanced ticket link |
        | hedging status       |
        | oco link             |
    And the '1'st normal stop linked order 'checkbox input' element should be enabled
    And the '2'nd limit linked order 'checkbox input' element should be enabled
    And the '1'st normal stop linked order 'price' element should be enabled
    And the '2'nd limit linked order 'price' element should be enabled
    And the '1'st normal stop linked order 'p/l' element should be enabled
    And the '2'nd limit linked order 'p/l' element should be enabled
    And 'submit button' element should be disabled
  #2
    Then I fill the '1'st normal stop linked order 'price' with value '1' in the 'current market'
    And I fill the '2'nd limit linked order 'price' with value '1' in the 'current market'
    When I uncheck 'stop' checkbox
    And I uncheck 'limit' checkbox
    Then the '1'st normal stop linked order 'price' element should be disabled
    And the '1'st normal stop linked order 'price' should be filled with ''
    And the '1'st normal stop linked order 'pips/points' element should be disabled
    And the '1'st normal stop linked order 'pips/points' should be filled with ''
    And the '1'st normal stop linked order 'p/l' element should be disabled
    And the '1'st normal stop linked order 'p/l' should be filled with ''
    And the '2'nd limit linked order 'price' element should be disabled
    And the '2'nd limit linked order 'price' should be filled with ''
    And the '2'nd limit linked order 'pips/points' element should be disabled
    And the '2'nd limit linked order 'pips/points' should be filled with ''
    And the '2'nd limit linked order 'p/l' element should be disabled
    And the '2'nd limit linked order 'p/l' should be filled with ''
  #3
    When I check 'stop' checkbox
    And I fill the '1'st normal stop linked order 'price' with value 'valid stop price' in the 'current market'
    And I check 'limit' checkbox
    And I fill the '2'nd limit linked order 'price' with value 'valid limit price' in the 'current market'
    And I fill 'order price' with value 'valid limit price * 2'
    Then 'buy' 'current market' main '2'nd limit price validation should be correct
  #4
    When I fill 'order price' with value 'valid order price'
    And I fill 'order price' with value 'valid stop price / 2'
    Then 'buy' 'current market' main '1'st stop price validation should be correct
  #5
    When I fill the '1'st normal stop linked order 'price' with value 'valid stop price' in the 'current market'
    And I fill the '2'nd limit linked order 'price' with value 'valid limit price' in the 'current market'
    Then 'submit button' element text should be 'Update Order'
    And 'submit button' element should be enabled
    And 'submit button' element should be colored 'green'
  #6
    When I fill 'quantity' with value 'min valid+1'
    Then 'validation message' in deal ticket panel should not be displayed
  #7
    Then I store data from the '1'st normal stop linked order
    And I store data from the '2'nd limit linked order
    When I fill 'quantity' with value 'min valid*2'
    Then the '1'st normal stop linked order 'p/l' input should be changed
    And the '2'nd limit linked order 'p/l' input should be changed
  #8
    Then I store data from the '1'st normal stop linked order
    And I store data from the '2'nd limit linked order
    When I fill 'order price' with value 'valid order price * 2'
    Then the '1'st normal stop linked order 'p/l' input should be changed
    And the '2'nd limit linked order 'p/l' input should be changed
    When I fill the '1'st normal stop linked order 'price' with value 'valid stop price' in the 'current market'
    And I fill the '2'nd limit linked order 'price' with value 'valid limit price' in the 'current market'
  #9
    When I click on 'submit' button
    Then trade confirmation appeared in right places
    And 'confirmation' element text should be 'Order updated'
    And 'market name' element text should be 'current market'
    And 'confirmation message' element text should be 'Your order has been updated.'
  #10
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
  #11
    When I make 'Positions And Orders' panel active
    And I select 'Orders' list
    Then the 'previously added' order should be present on the list
    And the 'previously added' order 'quantity' cell should contain 'buy min valid*2' data
    And the 'previously added' order 'order price' cell should contain 'correct' data
    And the 'previously added' order 'stop price' cell should contain 'correct' data
    And the 'previously added' order 'limit price' cell should contain 'correct' data


  @regression @sell-edit-order-price/quantity-cfd-market @wt-1429-v4
  Scenario: Sell - Edit Order Price/Quantity CFD Market
  #pretest
    Then I make 'Watchlist' panel active
    And I expand 'Popular Markets' watchlist
    And I find CFD market
    And I click on 'sell' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    When I switch to 'order' tab
    Then 'order' ticket type should be 'selected'
    When I remember min valid quantity for 'current' market
    And I remember all quantity sizes for 'current' market
    And I fill 'order price' with value 'valid order price'
    And I fill 'quantity' with value 'min valid*1'
    And I check 'stop' checkbox
    And I fill the '1'st normal stop linked order 'price' with value 'valid stop price' in the 'current market'
    And I check 'limit' checkbox
    And I fill the '2'nd limit linked order 'price' with value 'valid limit price' in the 'current market'
    And I click on 'submit' button
    And I click on 'ok' button
  #1
    Then I make 'Positions And Orders' panel active
    And I select 'Orders' list
    Then the 'previously added' market should be present on the list
    When I complete 'previously added' market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'edit order'
    And 'market info' element text should be 'current market'
    And 'sell' price should change with time
    And 'buy' price should change with time
    And 'order price' input should be editable
    And 'order price' input should be predefined with 'same'
    And 'quantity' input should be editable
    And 'quantity' input should be predefined with 'same'
    And the edit ticket standard view panel should contain items:
        | itemName             |
        | order price          |
        | quantity             |
        | good till dropdown   |
        | advanced ticket link |
        | hedging status       |
        | oco link             |
    And the '1'st normal stop linked order 'checkbox input' element should be enabled
    And the '2'nd limit linked order 'checkbox input' element should be enabled
    And the '1'st normal stop linked order 'price' element should be enabled
    And the '2'nd limit linked order 'price' element should be enabled
    And the '1'st normal stop linked order 'p/l' element should be enabled
    And the '2'nd limit linked order 'p/l' element should be enabled
    And 'submit button' element should be disabled
  #2
    When I fill 'order price' with value 'valid limit price / 2'
    Then 'sell' 'current market' main '2'nd limit price validation should be correct
  #3
    When I fill 'order price' with value 'valid order price'
    And I fill 'order price' with value 'valid stop price * 2'
    Then 'sell' 'current market' main '1'st stop price validation should be correct
  #4
    When I fill the '1'st normal stop linked order 'price' with value 'valid stop price' in the 'current market'
    And I fill the '2'nd limit linked order 'price' with value 'valid limit price' in the 'current market'
    Then 'submit button' element text should be 'Update Order'
    And 'submit button' element should be enabled
    And 'submit button' element should be colored 'green'
  #5
    When I fill 'quantity' with value 'min valid+1'
    Then 'validation message' in deal ticket panel should not be displayed
  #6
    Then I store data from the '1'st normal stop linked order
    And I store data from the '2'nd limit linked order
    When I fill 'quantity' with value 'min valid*2'
    Then the '1'st normal stop linked order 'p/l' input should be changed
    And the '2'nd limit linked order 'p/l' input should be changed
  #7
    Then I store data from the '1'st normal stop linked order
    And I store data from the '2'nd limit linked order
    When I fill 'order price' with value 'valid order price * 2'
    Then the '1'st normal stop linked order 'p/l' input should be changed
    And the '2'nd limit linked order 'p/l' input should be changed
    When I fill the '1'st normal stop linked order 'price' with value 'valid stop price' in the 'current market'
    And I fill the '2'nd limit linked order 'price' with value 'valid limit price' in the 'current market'
  #8
    When I click on 'submit' button
    Then trade confirmation appeared in right places
    And 'confirmation' element text should be 'Order updated'
    And 'market name' element text should be 'current market'
    And 'confirmation message' element text should be 'Your order has been updated.'
  #9
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
  #10
    When I make 'Positions And Orders' panel active
    And I select 'Orders' list
    Then the 'previously added' order should be present on the list
    And the 'previously added' order 'quantity' cell should contain 'sell min valid*2' data
    And the 'previously added' order 'order price' cell should contain 'correct' data
    And the 'previously added' order 'stop price' cell should contain 'correct' data
    And the 'previously added' order 'limit price' cell should contain 'correct' data


  @regression @buy-edit-order-stop/limit-spread-market @wt-842-v7
  Scenario: Buy - Edit Order Stop/Limit SPREAD Market
  #pretest
    Then I make 'Watchlist' panel active
    And I expand 'Popular Markets' watchlist
    And I find Spread market
    And I click on 'buy' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    When I switch to 'order' tab
    Then 'order' ticket type should be 'selected'
    When I remember min valid quantity for 'current' market
    And I remember all quantity sizes for 'current' market
    And I fill 'order price' with value 'valid order price'
    And I fill 'quantity' with value 'min valid*1'
    And I check 'stop' checkbox
    And I fill the '1'st normal stop linked order 'price' with value 'valid stop price' in the 'current market'
    And I check 'limit' checkbox
    And I fill the '2'nd limit linked order 'price' with value 'valid limit price' in the 'current market'
    And I click on 'submit' button
    And I click on 'ok' button
  #1
    Then I make 'Positions And Orders' panel active
    And I select 'Orders' list
    Then the 'previously added' market should be present on the list
    When I complete 'previously added' market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'edit order'
    And 'market info' element text should be 'current market'
    And 'sell' price should change with time
    And 'buy' price should change with time
    And 'order price' input should be editable
    And 'order price' input should be predefined with 'same'
    And 'quantity' input should be editable
    And 'quantity' input should be predefined with 'same'
    And the edit ticket standard view panel should contain items:
        | itemName             |
        | order price          |
        | quantity             |
        | good till dropdown   |
        | advanced ticket link |
        | hedging status       |
        | oco link             |
    And the '1'st normal stop linked order 'checkbox input' element should be enabled
    And the '2'nd limit linked order 'checkbox input' element should be enabled
    And the '1'st normal stop linked order 'price' element should be enabled
    And the '2'nd limit linked order 'price' element should be enabled
    And the '1'st normal stop linked order 'p/l' element should be enabled
    And the '2'nd limit linked order 'p/l' element should be enabled
    And 'submit button' element should be disabled
  #2
    When I close panel
    Then the 'Deal ticket' panel should be invisible
  #3
    When I make 'Positions And Orders' panel active
    And I select 'Orders' list
    And I click on 'stop price' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    When I close panel
    Then the 'Deal ticket' panel should be invisible
  #4
    When I make 'Positions And Orders' panel active
    And I select 'Orders' list
    And I click on 'limit price' in the 'current' market
    Then the 'Deal ticket' panel should be visible
  #5
    When I store data from the main '1'st normal stop linked order
    And I fill the '1'st normal stop linked order 'price' with value 'valid stop price * 0.999' in the 'current market'
    Then the main '1'st normal stop linked order 'p/l' input should be changed
    And 'submit button' element text should be 'Update Order'
    And 'submit button' element should be enabled
    And 'submit button' element should be colored 'green'
  #6
    When I store data from the '2'nd limit linked order
    And I fill the '2'nd limit linked order 'price' with value 'valid limit price * 1.001' in the 'current market'
    Then the '2'nd limit linked order 'p/l' input should be changed
    And 'submit button' element text should be 'Update Order'
    And 'submit button' element should be enabled
    And 'submit button' element should be colored 'green'
  #7
    When I modify the '1'st normal stop linked order filled 'price' by typing 'ARROW_UP' key until the price will be above 'sell*1.001' in the 'current market'
    Then 'buy' 'current market' main '1'st stop price validation should be correct
    When I fill the '1'st normal stop linked order 'price' with value 'valid stop price' in the 'current market'
    And I modify the '2'nd limit linked order filled 'price' by typing 'ARROW_DOWN' key until the price will be below 'sell*0.999' in the 'current market'
    Then 'buy' 'current market' main '2'nd limit price validation should be correct
      When I fill the '2'nd limit linked order 'price' with value 'valid limit price' in the 'current market'
  #8
    When I click on 'advancedTicket' link
    And I modify the '1'st normal stop linked order filled 'price' by typing 'ARROW_UP' key until the price will be above 'sell*1.001' in the 'current market'
    Then 'buy' 'current market' main '1'st stop price validation should be correct
    When I fill the '1'st normal stop linked order 'price' with value 'valid stop price * 0.999' in the 'current market'
    And I modify the '2'nd limit linked order filled 'price' by typing 'ARROW_DOWN' key until the price will be below 'sell*0.999' in the 'current market'
    Then 'buy' 'current market' main '2'nd limit price validation should be correct
    When I fill the '2'nd limit linked order 'price' with value 'valid limit price * 1.001' in the 'current market'
  #9
    When I click on 'submit' button
    Then trade confirmation appeared in right places
    And 'confirmation' element text should be 'Order updated'
    And 'market name' element text should be 'current market'
    And 'confirmation message' element text should be 'Your order has been updated.'
  #10
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
  #11
    When I make 'Positions And Orders' panel active
    And I select 'Orders' list
    Then the 'previously added' order should be present on the list
    And the 'previously added' order 'stop price' cell should contain 'correct' data
    And the 'previously added' order 'limit price' cell should contain 'correct' data
  #12
    Then I make 'Positions And Orders' panel active
    And I select 'Orders' list
    Then the 'previously added' market should be present on the list
    When I complete 'previously added' market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
    When I click on 'advancedTicket' link
  #13
    When I expand add stop limit dropdown
    And I select 'Trailing stop' from expanded dropdown
    And I fill the '3'rd trailing stop linked order 'quantity' with value 'min valid*1' in the 'current market'
    And I expand add stop limit dropdown
    And I select 'Stop' from expanded dropdown
    And I fill the '4'th normal stop linked order 'quantity' with value 'min valid*1' in the 'current market'
    And I expand add stop limit dropdown
    And I select 'Limit' from expanded dropdown
    And I fill the '5'th limit linked order 'quantity' with value 'min valid*1' in the 'current market'
    And I fill 'quantity' with value 'min valid*5'
    Then 'validation message' in deal ticket panel should not be displayed
  #14
    When I fill the '3'rd trailing stop linked order 'points away' with value '3' in the 'current market'
    And I fill the '4'th normal stop linked order 'price' with value 'valid stop price' in the 'current market'
    And I fill the '5'th limit linked order 'price' with value 'valid limit price' in the 'current market'
    Then 'validation message' in deal ticket panel should not be displayed
    And 'submit button' element text should be 'Update Order'
    And 'submit button' element should be enabled
    And 'submit button' element should be colored 'green'
  #15
    When I click on 'submit' button
    Then trade confirmation appeared in right places
    And 'confirmation' element text should be 'Order updated'
    And 'market name' element text should be 'current market'
    And correct confirmation message about adding '3' linked orders should be displayed
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
  #16
    When I make 'Positions And Orders' panel active
    And I select 'Orders' list
    Then the 'previously added' order should be present on the list
    And the 'previously added' order 'stop price' cell should contain 'multiple' word
    And the 'previously added' order 'limit price' cell should contain 'multiple' word
  #17
    When I click on 'stop price' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'edit order'
  #18
    When I fill the '1'st normal stop linked order 'price' with value 'valid stop price * 0.98' in the 'current market'
    And I fill the '2'nd limit linked order 'price' with value 'valid limit price * 1.02' in the 'current market'
  # https://jira.gaincapital.com/browse/TPDWT-21355
    And I fill the '4'th limit linked order 'price' with value 'valid limit price * 1.01' in the 'current market'
    And I fill the '5'th normal stop linked order 'price' with value 'valid stop price * 0.99' in the 'current market'
    And I click on 'submit' button
    Then trade confirmation appeared in right places
    And 'confirmation' element text should be 'Order updated'
    And 'market name' element text should be 'current market'
    And 'confirmation message' element text should be 'Your order has been updated.'
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
  #19
    When I make 'Positions And Orders' panel active
    And I select 'Orders' list
    And I click on 'stop price' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    When I uncheck 'stop' checkbox
    And I uncheck 'limit' checkbox
    And I remove '3'rd trailing stop order
    And I remove '5'th normal stop order
    And I remove '4'th limit order
    And I click on 'submit' button
    Then trade confirmation appeared in right places
    And 'confirmation' element text should be 'Order updated'
    And 'market name' element text should be 'current market'
    And correct confirmation message about removing '5' linked orders should be displayed
  #20
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
    When I make 'Positions And Orders' panel active
    And I select 'Orders' list
    Then the 'previously added' order should be present on the list
    And the 'previously added' order 'stop price' cell should contain 'set' word
    And the 'previously added' order 'limit price' cell should contain 'set' word
  #21
    When I complete 'previously added' market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
    When I click on 'advancedTicket' link
  #22
    And I check 'Stop' checkbox
    And I check 'Limit' checkbox
    And I fill the '1'st normal stop linked order 'quantity' with value 'min valid*1' in the 'current market'
    And I fill the '1'st normal stop linked order 'price' with value 'valid stop price' in the 'current market'
    And I fill the '2'nd limit linked order 'quantity' with value 'min valid*1' in the 'current market'
    And I fill the '2'nd limit linked order 'price' with value 'valid limit price' in the 'current market'
    When I expand '1'st applicability dropdown
    And I select 'GTT' from expanded dropdown
    And I expand '1'st date picker dropdown
    And I add to date/time picker '2' hours and click outside
    When I expand '2'nd applicability dropdown
    And I select 'GTT' from expanded dropdown
    And I expand '2'nd date picker dropdown
    And I add to date/time picker '2' hours and click outside
    And I click on 'submit' button
    Then trade confirmation appeared in right places
    And 'confirmation' element text should be 'Order updated'
    And 'market name' element text should be 'current market'
    And correct confirmation message about adding '2' linked orders should be displayed
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
    When I make 'Positions And Orders' panel active
    And I select 'Orders' list
    Then the 'previously added' order should be present on the list
    And the 'previously added' order 'stop price' cell should contain 'correct' data
    And the 'previously added' order 'limit price' cell should contain 'correct' data
  #23
    When I complete 'previously added' market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
    And 'submit button' element text should be 'Update Order'
    And 'submit button' element should be disabled
    And 'submit button' element should be colored 'grey'


  @regression @sell-edit-order-stop/limit-cfd-market @wt-1432-v6
  Scenario: Sell - Edit Order Stop/Limit CFD Market
  #pretest
    Then I make 'Watchlist' panel active
    And I expand 'Popular Markets' watchlist
    And I find CFD market
    And I click on 'sell' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    When I switch to 'order' tab
    Then 'order' ticket type should be 'selected'
    When I remember min valid quantity for 'current' market
    And I remember all quantity sizes for 'current' market
    And I fill 'order price' with value 'valid order price'
    And I fill 'quantity' with value 'min valid*1'
    And I check 'stop' checkbox
    And I fill the '1'st normal stop linked order 'price' with value 'valid stop price' in the 'current market'
    And I check 'limit' checkbox
    And I fill the '2'nd limit linked order 'price' with value 'valid limit price' in the 'current market'
    And I click on 'submit' button
    And I click on 'ok' button
  #1
    Then I make 'Positions And Orders' panel active
    And I select 'Orders' list
    Then the 'previously added' market should be present on the list
    When I complete 'previously added' market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'edit order'
    And 'market info' element text should be 'current market'
    And 'sell' price should change with time
    And 'buy' price should change with time
    And 'order price' input should be editable
    And 'order price' input should be predefined with 'same'
    And 'quantity' input should be editable
    And 'quantity' input should be predefined with 'same'
    And the edit ticket standard view panel should contain items:
        | itemName             |
        | order price          |
        | quantity             |
        | good till dropdown   |
        | advanced ticket link |
        | hedging status       |
        | oco link             |
    And the '1'st normal stop linked order 'checkbox input' element should be enabled
    And the '2'nd limit linked order 'checkbox input' element should be enabled
    And the '1'st normal stop linked order 'price' element should be enabled
    And the '2'nd limit linked order 'price' element should be enabled
    And the '1'st normal stop linked order 'p/l' element should be enabled
    And the '2'nd limit linked order 'p/l' element should be enabled
    And 'submit button' element should be disabled
  #2
    When I close panel
    Then the 'Deal ticket' panel should be invisible
  #3
    When I make 'Positions And Orders' panel active
    And I select 'Orders' list
    And I click on 'stop price' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    When I close panel
    Then the 'Deal ticket' panel should be invisible
  #4
    When I make 'Positions And Orders' panel active
    And I select 'Orders' list
    And I click on 'limit price' in the 'current' market
    Then the 'Deal ticket' panel should be visible
  #5
    When I uncheck 'Stop' checkbox
    And I uncheck 'Limit' checkbox
    Then the '1'st normal stop linked order 'price' element should be disabled
    And the '1'st normal stop linked order 'price' should be filled with ''
    And the '1'st normal stop linked order 'pips/points' element should be disabled
    And the '1'st normal stop linked order 'pips/points' should be filled with ''
    And the '1'st normal stop linked order 'p/l' element should be disabled
    And the '1'st normal stop linked order 'p/l' should be filled with ''
    And the '2'nd limit linked order 'price' element should be disabled
    And the '2'nd limit linked order 'price' should be filled with ''
    And the '2'nd limit linked order 'pips/points' element should be disabled
    And the '2'nd limit linked order 'pips/points' should be filled with ''
    And the '2'nd limit linked order 'p/l' element should be disabled
    And the '2'nd limit linked order 'p/l' should be filled with ''
    When I check 'stop' checkbox
    And I fill the '1'st normal stop linked order 'price' with value 'valid stop price' in the 'current market'
    And I check 'limit' checkbox
    And I fill the '2'nd limit linked order 'price' with value 'valid limit price' in the 'current market'
  #6
    When I store data from the main '1'st normal stop linked order
    And I fill the '1'st normal stop linked order 'price' with value 'valid stop price * 1.001' in the 'current market'
    Then the main '1'st normal stop linked order 'p/l' input should be changed
    And 'submit button' element text should be 'Update Order'
    And 'submit button' element should be enabled
    And 'submit button' element should be colored 'green'
  #7
    When I store data from the '2'nd limit linked order
    And I fill the '2'nd limit linked order 'price' with value 'valid limit price * 0.999' in the 'current market'
    Then the '2'nd limit linked order 'p/l' input should be changed
    And 'submit button' element text should be 'Update Order'
    And 'submit button' element should be enabled
    And 'submit button' element should be colored 'green'
  #8
    When I modify the '1'st normal stop linked order filled 'price' by typing 'ARROW_UP' key until the price will be above 'sell*1.001' in the 'current market'
    Then 'sell' 'current market' main '1'st stop price validation should be correct
    When I fill the '1'st normal stop linked order 'price' with value 'valid stop price' in the 'current market'
    And I modify the '2'nd limit linked order filled 'price' by typing 'ARROW_DOWN' key until the price will be below 'sell*0.999' in the 'current market'
    Then 'sell' 'current market' main '2'nd limit price validation should be correct
    When I fill the '2'nd limit linked order 'price' with value 'valid limit price' in the 'current market'
  #9
    When I click on 'advancedTicket' link
    And I modify the '1'st normal stop linked order filled 'price' by typing 'ARROW_UP' key until the price will be above 'sell*1.001' in the 'current market'
    Then 'sell' 'current market' main '1'st stop price validation should be correct
    When I fill the '1'st normal stop linked order 'price' with value 'valid stop price * 0.999' in the 'current market'
    And I modify the '2'nd limit linked order filled 'price' by typing 'ARROW_DOWN' key until the price will be below 'sell*0.999' in the 'current market'
    Then 'sell' 'current market' main '2'nd limit price validation should be correct
    When I fill the '2'nd limit linked order 'price' with value 'valid limit price * 1.001' in the 'current market'
  #10
    When I click on 'submit' button
    Then trade confirmation appeared in right places
    And 'confirmation' element text should be 'Order updated'
    And 'market name' element text should be 'current market'
    And 'confirmation message' element text should be 'Your order has been updated.'
  #11
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
  #12
    When I make 'Positions And Orders' panel active
    And I select 'Orders' list
    Then the 'previously added' order should be present on the list
    And the 'previously added' order 'stop price' cell should contain 'correct' data
    And the 'previously added' order 'limit price' cell should contain 'correct' data
  #13
    Then I make 'Positions And Orders' panel active
    And I select 'Orders' list
    Then the 'previously added' market should be present on the list
    When I complete 'previously added' market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
    When I click on 'advancedTicket' link
  #14
    When I expand add stop limit dropdown
    And I select 'Trailing stop' from expanded dropdown
    And I fill the '3'rd trailing stop linked order 'quantity' with value 'min valid*1' in the 'current market'
    And I expand add stop limit dropdown
    And I select 'Stop' from expanded dropdown
    And I fill the '4'th normal stop linked order 'quantity' with value 'min valid*1' in the 'current market'
    And I expand add stop limit dropdown
    And I select 'Limit' from expanded dropdown
    And I fill the '5'th limit linked order 'quantity' with value 'min valid*1' in the 'current market'
    And I fill 'quantity' with value 'min valid*5'
    Then 'validation message' in deal ticket panel should not be displayed
  #15
    When I fill the '3'rd trailing stop linked order 'points away' with value '3' in the 'current market'
    And I fill the '4'th normal stop linked order 'price' with value 'valid stop price' in the 'current market'
    And I fill the '5'th limit linked order 'price' with value 'valid limit price' in the 'current market'
    Then 'validation message' in deal ticket panel should not be displayed
    And 'submit button' element text should be 'Update Order'
    And 'submit button' element should be enabled
    And 'submit button' element should be colored 'green'
  #16
    # https://jira.gaincapital.com/browse/TPDWT-21481
    When I click on 'submit' button
    Then trade confirmation appeared in right places
    And 'confirmation' element text should be 'Order updated'
    And 'market name' element text should be 'current market'
    And correct confirmation message about adding '3' linked orders should be displayed
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
  #17
    When I make 'Positions And Orders' panel active
    And I select 'Orders' list
    Then the 'previously added' order should be present on the list
    And the 'previously added' order 'stop price' cell should contain 'multiple' word
    And the 'previously added' order 'limit price' cell should contain 'multiple' word
  #18
    When I click on 'stop price' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'edit order'
  #19
    When I fill the '1'st normal stop linked order 'price' with value 'valid stop price * 0.98' in the 'current market'
    And I fill the '2'nd limit linked order 'price' with value 'valid limit price * 1.02' in the 'current market'
  # https://jira.gaincapital.com/browse/TPDWT-21355
    And I fill the '4'th limit linked order 'price' with value 'valid limit price * 1.01' in the 'current market'
    And I fill the '5'th normal stop linked order 'price' with value 'valid stop price * 0.99' in the 'current market'
    And I click on 'submit' button
    Then trade confirmation appeared in right places
    And 'confirmation' element text should be 'Order updated'
    And 'market name' element text should be 'current market'
    And 'confirmation message' element text should be 'Your order has been updated.'
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
  #20
    When I make 'Positions And Orders' panel active
    And I select 'Orders' list
    And I click on 'stop price' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    When I uncheck 'stop' checkbox
    And I uncheck 'limit' checkbox
    And I remove '3'rd trailing stop order
    And I remove '5'th normal stop order
    And I remove '4'th limit order
    And I click on 'submit' button
    Then trade confirmation appeared in right places
    And 'confirmation' element text should be 'Order updated'
    And 'market name' element text should be 'current market'
    And correct confirmation message about removing '5' linked orders should be displayed
  #21
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
    When I make 'Positions And Orders' panel active
    And I select 'Orders' list
    Then the 'previously added' order should be present on the list
    And the 'previously added' order 'stop price' cell should contain 'set' word
    And the 'previously added' order 'limit price' cell should contain 'set' word
  #22
    When I complete 'previously added' market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
    When I click on 'advancedTicket' link
  #23
    When I fill the '1'st normal stop linked order 'quantity' with value 'min valid*1' in the 'current market'
    And I fill the '1'st normal stop linked order 'price' with value 'valid stop price' in the 'current market'
    And I fill the '2'nd limit linked order 'quantity' with value 'min valid*1' in the 'current market'
    And I fill the '2'nd limit linked order 'price' with value 'valid limit price' in the 'current market'
    When I expand '1'st applicability dropdown
    And I select 'GTT' from expanded dropdown
    And I expand '1'st date picker dropdown
    And I add to date/time picker '2' hours and click outside
    When I expand '2'nd applicability dropdown
    And I select 'GTT' from expanded dropdown
    And I expand '2'nd date picker dropdown
    And I add to date/time picker '2' hours and click outside
    And I uncheck 'Stop' checkbox
    And I uncheck 'Limit' checkbox
    Then the '1'st normal stop linked order 'price' element should be disabled
    And the '1'st normal stop linked order 'price' should be filled with ''
    And the '1'st normal stop linked order 'pips/points' element should be disabled
    And the '1'st normal stop linked order 'pips/points' should be filled with ''
    And the '1'st normal stop linked order 'p/l' element should be disabled
    And the '1'st normal stop linked order 'p/l' should be filled with ''
    And the '2'nd limit linked order 'price' element should be disabled
    And the '2'nd limit linked order 'price' should be filled with ''
    And the '2'nd limit linked order 'pips/points' element should be disabled
    And the '2'nd limit linked order 'pips/points' should be filled with ''
    And the '2'nd limit linked order 'p/l' element should be disabled
    And the '2'nd limit linked order 'p/l' should be filled with ''
    And 'GTC' option should be selected in '1'st applicability dropdown
    And 'GTC' option should be selected in '2'nd applicability dropdown
  #24
    When I check 'Stop' checkbox
    And I check 'Limit' checkbox
    And I fill the '1'st normal stop linked order 'quantity' with value 'min valid*1' in the 'current market'
    And I fill the '1'st normal stop linked order 'price' with value 'valid stop price' in the 'current market'
    And I fill the '2'nd limit linked order 'quantity' with value 'min valid*1' in the 'current market'
    And I fill the '2'nd limit linked order 'price' with value 'valid limit price' in the 'current market'
    When I expand '1'st applicability dropdown
    And I select 'GTT' from expanded dropdown
    And I expand '1'st date picker dropdown
    And I add to date/time picker '2' hours and click outside
    When I expand '2'nd applicability dropdown
    And I select 'GTT' from expanded dropdown
    And I expand '2'nd date picker dropdown
    And I add to date/time picker '2' hours and click outside
    And I click on 'submit' button
    Then trade confirmation appeared in right places
    And 'confirmation' element text should be 'Order updated'
    And 'market name' element text should be 'current market'
    And 'confirmation message' element text should be 'Your order has been updated.'
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
    When I make 'Positions And Orders' panel active
    And I select 'Orders' list
    Then the 'previously added' order should be present on the list
    And the 'previously added' order 'stop price' cell should contain 'correct' data
    And the 'previously added' order 'limit price' cell should contain 'correct' data
  #25
    When I complete 'previously added' market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
    And 'submit button' element text should be 'Update Order'
    And 'submit button' element should be disabled
    And 'submit button' element should be colored 'grey'


  @regression @buy-delete-order-spread-market @wt-1059-v1
  Scenario: Buy - Delete Order Spread Market
  #pretest
    Then I make 'Watchlist' panel active
    And I expand 'Popular Markets' watchlist
    And I find Spread market
    And I click on 'buy' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    When I switch to 'order' tab
    Then 'order' ticket type should be 'selected'
    When I remember min valid quantity for 'current' market
    And I remember all quantity sizes for 'current' market
    And I fill 'order price' with value 'valid order price'
    And I fill 'quantity' with value 'min valid*1'
    And I check 'stop' checkbox
    And I fill the '1'st normal stop linked order 'price' with value 'valid stop price' in the 'current market'
    And I check 'limit' checkbox
    And I fill the '2'nd limit linked order 'price' with value 'valid limit price' in the 'current market'
    And I click on 'submit' button
    And I click on 'ok' button
  #1
    When I make 'Positions And Orders' panel active
    And I select 'Orders' list
    Then the 'previously added' order should be present on the list
    When I click on 'delete' in the 'previously added' order
    Then the 'previously added' order 'delete confirm' should be visible
    And the 'previously added' order 'delete cancel' should be visible
    And the 'previously added' order 'stop price' should be not visible
    And the 'previously added' order 'limit price' should be not visible
  #2
    When I click on 'delete cancel' in the 'previously added' order
    Then the 'previously added' order 'delete' should be visible
    And the 'previously added' order 'stop price' should be visible
    And the 'previously added' order 'limit price' should be visible
  #3
    When I click on 'delete' in the 'previously added' order
    And I click on 'delete confirm' in the 'previously added' order
    And I make 'Positions And Orders' panel active
    And I am on the 'Orders' list
    Then the 'previously added' order should be not present on the list
  #4
    When I add new 'Reports' panel in 'Default Workspace' tab
    And I move panel to the 'top-right' corner
    Then the 'Reports' panel should be visible
    When I select 'Order History' list
    And I get 'Order' History for 'Spread'
    Then Order History '1'st table row with cell 'name' should contain correct 'MarketName' data
    And Order History '1'st table row with cell 'date' should contain correct 'CreatedDateTimeUtc' data
    And Order History '1'st table row with cell 'quantity' should contain correct 'OriginalQuantity' data
    And Order History '1'st table row with cell 'price' should contain correct 'TriggerPrice' data
    And Order History '1'st table row with cell 'type' should contain correct 'OrderApplicabilityId' data
    And Order History '1'st table row with cell 'status' should contain correct 'StatusId' data
    And Order History '1'st table row with cell 'last-edit' should contain correct 'LastChangedDateTimeUtc' data


  @regression @sell-delete-order-cfd-market @wt-1433-v1
  Scenario: Sell - Delete Order CFD Market
  #pretest
    Then I make 'Watchlist' panel active
    And I expand 'Popular Markets' watchlist
    And I find CFD market
    And I click on 'sell' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    When I switch to 'order' tab
    Then 'order' ticket type should be 'selected'
    When I remember min valid quantity for 'current' market
    And I remember all quantity sizes for 'current' market
    And I fill 'order price' with value 'valid order price'
    And I fill 'quantity' with value 'min valid*1'
    And I check 'stop' checkbox
    And I fill the '1'st normal stop linked order 'price' with value 'valid stop price' in the 'current market'
    And I check 'limit' checkbox
    And I fill the '2'nd limit linked order 'price' with value 'valid limit price' in the 'current market'
    And I click on 'submit' button
    And I click on 'ok' button
  #1
    When I make 'Positions And Orders' panel active
    And I select 'Orders' list
    Then the 'previously added' order should be present on the list
    When I click on 'delete' in the 'previously added' order
    Then the 'previously added' order 'delete confirm' should be visible
    And the 'previously added' order 'delete cancel' should be visible
    And the 'previously added' order 'stop price' should be not visible
    And the 'previously added' order 'limit price' should be not visible
  #2
    When I click on 'delete cancel' in the 'previously added' order
    Then the 'previously added' order 'delete' should be visible
    And the 'previously added' order 'stop price' should be visible
    And the 'previously added' order 'limit price' should be visible
  #3
    When I click on 'delete' in the 'previously added' order
    And I click on 'delete confirm' in the 'previously added' order
    And I make 'Positions And Orders' panel active
    And I am on the 'Orders' list
    Then the 'previously added' order should be not present on the list
  #4
    When I add new 'Reports' panel in 'Default Workspace' tab
    And I move panel to the 'top-right' corner
    Then the 'Reports' panel should be visible
    When I select 'Order History' list
    And I get 'Order' History for 'CFD'
    Then Order History '1'st table row with cell 'name' should contain correct 'MarketName' data
    And Order History '1'st table row with cell 'date' should contain correct 'CreatedDateTimeUtc' data
    And Order History '1'st table row with cell 'quantity' should contain correct 'OriginalQuantity' data
    And Order History '1'st table row with cell 'price' should contain correct 'TriggerPrice' data
    And Order History '1'st table row with cell 'type' should contain correct 'OrderApplicabilityId' data
    And Order History '1'st table row with cell 'status' should contain correct 'StatusId' data
    And Order History '1'st table row with cell 'last-edit' should contain correct 'LastChangedDateTimeUtc' data


  @regression @trade-button-is-disabled-when-price-isn't-defined @wt-1293-v4
  Scenario: Trade button is disabled when price isn't defined
  # Mocks reqired


  @regression @edit-order-ticket-and-order-details-are-close-if-the-order-is-removed @wt-1308-v2
  Scenario: Edit order ticket and Order details are closed if the order is removed
  #pretest
    Then the 'Positions And Orders' panel should be visible
    When I select 'Orders' list
    And I add order with parameters:
      | MarketName | USD/JPY |
      | Direction  | Sell    |
      | Quantity   | 1000    |
      | Price      | 114     |
    When I add order with parameters:
      | MarketName | EUR/CHF |
      | Direction  | Buy     |
      | Quantity   | 1000    |
      | Price      | 1.1     |
    When I add order with parameters:
      | MarketName | USD/CAD |
      | Direction  | Sell    |
      | Quantity   | 1100    |
      | Price      | 1.7     |
    Then the 'USD/JPY' order should be present on the list
    Then the 'EUR/CHF' order should be present on the list
    Then the 'USD/CAD' order should be present on the list
  #1
    When I hover 'USD/JPY' market
    And I click on 'dropdown arrow' in the 'current' market
    And I select 'Edit Order' in dropdown menu in 'current' market
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'edit order'
    When I make 'Positions And Orders' panel active
    And I select 'Orders' list
    When I hover 'USD/JPY' market
    And I click on 'dropdown arrow' in the 'current' market
    And I select 'Order Details' in dropdown menu in 'current' market
    Then the 'details' panel should be visible
    When I make 'Positions And Orders' panel active
    And I select 'Orders' list
    And I click on 'delete' in the 'USD/JPY' market
    And I click on 'delete confirm' in the 'USD/JPY' market
    Then the 'USD/JPY' market should be not present on the list
    And the 'Deal ticket' panel should be invisible
    And the 'details' panel should be invisible
  #2
    When I make 'Positions and Orders' panel active
    And I select 'Orders' list
    And I hover 'EUR/CHF' market
    And I click on 'dropdown arrow' in the 'current' market
    And I select 'Edit Order' in dropdown menu in 'current' market
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'edit order'
    When I make 'Positions And Orders' panel active
    And I select 'Orders' list
    And I hover 'EUR/CHF' market
    And I click on 'dropdown arrow' in the 'current' market
    And I select 'Order Details' in dropdown menu in 'current' market
    Then the 'details' panel should be visible
    When I delete 'order' 'USD/CAD'
    And I make 'Positions And Orders' panel active
    And I select 'Orders' list
    Then the 'USD/CAD' market should be not present on the list
    And the 'Deal ticket' panel should be visible
    And the 'details' panel should be visible
  #3
  # Step 3 not implemented. Mocks required.
  #4
  # Step 4 not implemented. (IFE)


  @regression @confiration-message-on-order-update @wt-1086-v5
  Scenario: Confirmation message on Order update
  #1
    Then the 'Positions And Orders' panel should be visible
    When I select 'Orders' list
    And I add order with parameters:
      | MarketName | USD/JPY |
      | Direction  | Sell    |
      | Quantity   | 1000    |
      | Price      | 114     |
    Then the 'USD/JPY' order should be present on the list
  #2
    Then I make 'Positions And Orders' panel active
    And I select 'Orders' list
    Then the 'previously added' market should be present on the list
    When I complete 'previously added' market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'edit order'
  #3
    When I fill 'order price' with value 'valid limit price * 2'
    And I click on 'submit' button
    Then trade confirmation appeared in right places
    And 'confirmation' element text should be 'Order updated'
    And 'market name' element text should be 'current market'
    And 'confirmation message' element text should be 'Your order has been updated.'
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
    Then I make 'Positions And Orders' panel active
    And I select 'Orders' list
    And I complete 'previously added' market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
  #4
    When I remember min valid quantity for 'current' market
    And I fill 'quantity' with value 'min valid*2'
    And I click on 'submit' button
    Then trade confirmation appeared in right places
    And 'confirmation' element text should be 'Order updated'
    And 'market name' element text should be 'current market'
    And 'confirmation message' element text should be 'Your order has been updated.'
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
    Then I make 'Positions And Orders' panel active
    And I select 'Orders' list
    And I complete 'previously added' market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
  #5
    When I expand 'good till dropdown link' dropdown
    And I select 'GTT' from expanded dropdown
    And I expand 'date picker' dropdown
    And I add to date/time picker '2' hours and click outside
    And I click on 'submit' button
    Then trade confirmation appeared in right places
    And 'confirmation' element text should be 'Order updated'
    And 'market name' element text should be 'current market'
    And 'confirmation message' element text should be 'Your order has been updated.'
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
    Then I make 'Positions And Orders' panel active
    And I select 'Orders' list
    And I complete 'previously added' market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
  #6
    When I click on 'advancedTicket' link
    And I check 'Stop' checkbox
    And I fill the '1'st normal stop linked order 'quantity' with value 'min valid*1' in the 'current market'
    And I fill the '1'st normal stop linked order 'price' with value 'valid stop price' in the 'current market'
    And I click on 'submit' button
    Then trade confirmation appeared in right places
    And 'confirmation' element text should be 'Order updated'
    And 'market name' element text should be 'current market'
    And correct confirmation message about adding '1' linked orders should be displayed
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
    Then I make 'Positions And Orders' panel active
    And I select 'Orders' list
    And I complete 'previously added' market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
  #7
    When I check 'Limit' checkbox
    And I fill the '2'nd limit linked order 'quantity' with value 'min valid*1' in the 'current market'
    And I fill the '2'nd limit linked order 'price' with value 'valid limit price' in the 'current market'
    And I click on 'submit' button
    Then trade confirmation appeared in right places
    And 'confirmation' element text should be 'Order updated'
    And 'market name' element text should be 'current market'
    And correct confirmation message about adding '1' linked orders should be displayed
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
    Then I make 'Positions And Orders' panel active
    And I select 'Orders' list
    And I complete 'previously added' market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
  #8
    When I fill the '1'st normal stop linked order 'price' with value 'valid stop price * 1.02' in the 'current market'
    And I click on 'submit' button
    Then trade confirmation appeared in right places
    And 'confirmation' element text should be 'Order updated'
    And 'market name' element text should be 'current market'
    And 'confirmation message' element text should be 'Your order has been updated.'
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
    Then I make 'Positions And Orders' panel active
    And I select 'Orders' list
    And I complete 'previously added' market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
  #9
    When I fill the '2'nd limit linked order 'price' with value 'valid limit price * 0.98' in the 'current market'
    And I click on 'submit' button
    Then trade confirmation appeared in right places
    And 'confirmation' element text should be 'Order updated'
    And 'market name' element text should be 'current market'
    And 'confirmation message' element text should be 'Your order has been updated.'
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
    Then I make 'Positions And Orders' panel active
    And I select 'Orders' list
    And I complete 'previously added' market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
  #10
    When I uncheck 'Stop' checkbox
    And I click on 'submit' button
    Then trade confirmation appeared in right places
    And 'confirmation' element text should be 'Order updated'
    And 'market name' element text should be 'current market'
    And correct confirmation message about removing '1' linked orders should be displayed
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
    Then I make 'Positions And Orders' panel active
    And I select 'Orders' list
    And I complete 'previously added' market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
  #11
    When I uncheck 'Limit' checkbox
    And I click on 'submit' button
    Then trade confirmation appeared in right places
    And 'confirmation' element text should be 'Order updated'
    And 'market name' element text should be 'current market'
    And correct confirmation message about removing '1' linked orders should be displayed
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
    Then I make 'Positions And Orders' panel active
    And I select 'Orders' list
    And I complete 'previously added' market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
  #12
    When I click on 'advancedTicket' link
    And I check 'Stop' checkbox
    And I check 'Limit' checkbox
    And I expand add stop limit dropdown
    And I select 'Trailing stop' from expanded dropdown
    And I expand add stop limit dropdown
    And I select 'Stop' from expanded dropdown
    And I expand add stop limit dropdown
    And I select 'Limit' from expanded dropdown
    And I fill the '1'st normal stop linked order 'price' with value 'valid stop price * 1.02' in the 'current market'
    And I fill the '2'nd limit linked order 'price' with value 'valid limit price * 0.98' in the 'current market'
    And I fill the '3'rd trailing stop linked order 'points away' with value '3' in the 'current market'
    And I fill the '4'th normal stop linked order 'price' with value 'valid stop price' in the 'current market'
    And I fill the '5'th limit linked order 'price' with value 'valid limit price' in the 'current market'
    And I fill the '3'rd trailing stop linked order 'quantity' with value 'min valid*1' in the 'current market'
    And I fill the '4'th normal stop linked order 'quantity' with value 'min valid*1' in the 'current market'
    And I fill the '5'th limit linked order 'quantity' with value 'min valid*1' in the 'current market'
    And I fill 'quantity' with value 'min valid*5'
    And I click on 'submit' button
    Then trade confirmation appeared in right places
    And 'confirmation' element text should be 'Order updated'
    And 'market name' element text should be 'current market'
    And correct confirmation message about adding '5' linked orders should be displayed
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
    Then I make 'Positions And Orders' panel active
    And I select 'Orders' list
    And I complete 'previously added' market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
  #13
    When I fill the '3'rd trailing stop linked order 'points away' with value '10' in the 'current market'
    And I click on 'submit' button
    Then trade confirmation appeared in right places
    And 'confirmation' element text should be 'Order updated'
    And 'market name' element text should be 'current market'
    And 'confirmation message' element text should be 'Your order has been updated.'
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible


  @regression @order-values-are-updated-on-'orders'-list-in-wt-and-at-pro-app @wt-1711-v1
  Scenario: Order values are updated on 'Orders' list in WT and AT Pro app
  # Not implemented. (AT Pro)


  @regression @applicability-good-till-cancelled @wt-1523-v3
  Scenario: Applicability - Good Till Cancelled
  #1
    When I make 'Watchlist' panel active
    And I expand 'Popular Markets' watchlist
    And I find any market
    And I click on 'buy' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    When I switch to 'order' tab
    Then 'order' ticket type should be 'selected'
  #2
    When I remember min valid quantity for 'current' market
    And I remember all quantity sizes for 'current' market
    And I fill 'order price' with value 'valid order price'
    And I fill 'quantity' with value 'min valid*1'
    And I check 'Stop' checkbox
    And I fill the '1'st normal stop linked order 'price' with value 'valid stop price' in the 'current market'
    And I check 'limit' checkbox
    And I fill the '2'nd limit linked order 'price' with value 'valid limit price' in the 'current market'
    Then the '1'st normal stop linked order 'pips/points' input should be autopopulated
    And the '1'st normal stop linked order 'p/l' input should be autopopulated
    And the '2'nd limit linked order 'pips/points' input should be autopopulated
    And the '2'nd limit linked order 'p/l' input should be autopopulated
    And 'validation message' in deal ticket panel should not be displayed
    And 'submit button' element should be enabled
  #3
    And 'main good till dropdown' element text should contain 'GTC'
  #4
    When I click on 'submit' button
    Then 'confirmation' element text should be 'Order placed'
    And 'market name' element text should be 'current market'
    And open buy 'current' order confirmation message should be correct
  #5
    When I click on 'ok' button
    And I make 'Positions And Orders' panel active
    And I select 'Orders' list
    Then the 'previously added' order should be present on the list
    And the 'previously added' order 'stop price' cell should contain 'correct' data
    And the 'previously added' order 'limit price' cell should contain 'correct' data
  #6
  # Step 6: Not implemented. Mocks required.
  #7
    When I click on 'delete' in the 'previously added' order
    And I click on 'delete confirm' in the 'previously added' order
    And I make 'Positions And Orders' panel active
    And I am on the 'Orders' list
    Then the 'previously added' order should be not present on the list
  #8
  # Step 8: Not implemented. Mocks required.


  @regression @applicability-good-till-end-of-day @wt-1524-v2
  Scenario: Applicability - Good Till End of Day
  #1
    When I make 'Watchlist' panel active
    And I expand 'Popular Markets' watchlist
    And I find any market
    And I click on 'buy' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    When I switch to 'order' tab
    Then 'order' ticket type should be 'selected'
  #2
    When I remember min valid quantity for 'current' market
    And I remember all quantity sizes for 'current' market
    And I fill 'order price' with value 'valid order price'
    And I fill 'quantity' with value 'min valid*1'
    Then 'validation message' in deal ticket panel should not be displayed
    And 'submit button' element should be enabled
  #3
    When I check 'Stop' checkbox
    And I fill the '1'st normal stop linked order 'price' with value 'valid stop price' in the 'current market'
    And I check 'limit' checkbox
    And I fill the '2'nd limit linked order 'price' with value 'valid limit price' in the 'current market'
    Then the '1'st normal stop linked order 'pips/points' input should be autopopulated
    And the '1'st normal stop linked order 'p/l' input should be autopopulated
    And the '2'nd limit linked order 'pips/points' input should be autopopulated
    And the '2'nd limit linked order 'p/l' input should be autopopulated
    And 'validation message' in deal ticket panel should not be displayed
    And 'submit button' element should be enabled
  #4
    When I expand 'good till dropdown link' dropdown
    And I select 'GTD' from expanded dropdown
    And 'main good till dropdown' element text should contain 'GTD'
  #5
    When I click on 'submit' button
    Then 'confirmation' element text should be 'Order placed'
    And 'market name' element text should be 'current market'
    And open buy 'current' order confirmation message should be correct
  #6
    When I click on 'ok' button
    And I make 'Positions And Orders' panel active
    And I select 'Orders' list
    Then the 'previously added' order should be present on the list
  #7
    And the 'previously added' order 'stop price' cell should contain 'correct' data
    And the 'previously added' order 'limit price' cell should contain 'correct' data
  #8
  # Step 8: Not implemented. Mocks required.
  #9
  # Step 9: Not implemented. Mocks required.


  @regression @applicability-amend @wt-1532-v3
  Scenario: Applicability - Amend
  #pretest
    Then the 'Positions And Orders' panel should be visible
    When I select 'Orders' list
    And I add order with parameters:
      | MarketName | USD/JPY |
      | Direction  | Sell    |
      | Quantity   | 1000    |
      | Price      | 114     |
    Then the 'USD/JPY' order should be present on the list
  #1
    When I make 'Positions And Orders' panel active
    And I select 'Orders' list
    Then the 'previously added' market should be present on the list
    When I complete 'previously added' market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'edit order'
    When I expand 'good till dropdown link' dropdown
    And I select 'GTD' from expanded dropdown
    Then 'submit button' element text should be 'Update Order'
    And 'submit button' element should be enabled
    And 'submit button' element should be colored 'green'
  #2
    When I click on 'submit' button
    Then trade confirmation appeared in right places
    And 'confirmation' element text should be 'Order updated'
    And 'market name' element text should be 'current market'
    And 'confirmation message' element text should be 'Your order has been updated.'
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
  #3
    When I make 'Positions And Orders' panel active
    And I select 'Orders' list
    Then the 'previously added' market should be present on the list
    When I complete 'previously added' market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'edit order'
    And 'main good till dropdown' element text should contain 'GTD'
  #4
    When I expand 'good till dropdown link' dropdown
    And I select 'GTT' from expanded dropdown
    Then the order ticket standard view panel should contain items:
      | itemName    |
      | date picker |
    # https://jira.gaincapital.com/browse/TPDWT-17630
    And date picker input should be defined with '0' minutes more than now
    And 'submit button' element text should be 'Update Order'
    And 'submit button' element should be enabled
    And 'submit button' element should be colored 'green'
  #5
    When I expand 'date picker' dropdown
    Then 'date picker' dropdown should be visible
    When I add to date/time picker '2' hours and click outside
    Then date picker input should be defined with '2' hours more than now
    And 'submit button' element text should be 'Update Order'
    And 'submit button' element should be enabled
    And 'submit button' element should be colored 'green'
  #6
    When I click on 'submit' button
    And I click on 'ok' button
    And I make 'Positions And Orders' panel active
    And I select 'Orders' list
    And I complete 'previously added' market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
    And date picker input should be defined with '2' hours more than now
  #7
    When I add to date/time picker '13' hours and click outside
    Then date picker input should be defined with '15' hours more than now
    And 'submit button' element text should be 'Update Order'
    And 'submit button' element should be enabled
    And 'submit button' element should be colored 'green'
  #8
    When I click on 'submit' button
    And I click on 'ok' button
    And I make 'Positions And Orders' panel active
    And I select 'Orders' list
    And I complete 'previously added' market dropdown with value 'Edit order'
    Then the 'Deal ticket' panel should be visible
    And date picker input should be defined with '15' hours more than now


  @quick @smoke @USD/JPY @GBP/USD-DFT @order-ticket-standard-view-main-functionality-stop/limit @wt-122
  Scenario Outline: Order Ticket Standard View - main functionality, stop/limit
    When I add new tab
    And I add new 'Watchlist' panel in 'New workspace 2' tab
    And I resize panel with:
      | height | 600  |
      | width  | 1000 |
    And I expand 'Popular Markets' watchlist
    And I click on '<Direction>' in the '<Market name>' market
    Then the 'Deal ticket' panel should be visible
    When I switch to 'order' tab
    Then 'order' ticket type should be 'selected'
    And 'trade label' element text should be 'trade'
    And 'order label' element text should be 'order'
    And 'set alert label' element text should be 'set alert'
    And 'market info' element text should be '<Market name>'
    And '<Opposite direction>' price should change with time
    And '<Direction>' price should change with time
    And '<Market name>' 'quantity' placeholder should be correct
    And the '1'st normal stop order should contain fields:
      | itemName |
      | checkbox |
      | dropdown |
      | price    |
      | points   |
      | p/l      |
    And the '2'nd limit order should contain fields:
      | itemName |
      | checkbox |
      | label    |
      | price    |
      | points   |
      | p/l      |
    And the '1'st normal stop linked order 'price' element should be disabled
    And the '1'st normal stop linked order 'points' element should be disabled
    And the '1'st normal stop linked order 'p/l' element should be disabled
    And the '2'nd limit linked order 'price' element should be disabled
    And the '2'nd limit linked order 'points' element should be disabled
    And the '2'nd limit linked order 'p/l' element should be disabled
    And the order ticket standard view panel should contain items:
      | itemName             |
      | order price          |
      | quantity             |
      | advanced ticket link |
      | oco link             |
      | good till dropdown   |
    And 'hedging status' element text should be 'Hedging is OFF'
    And 'submit button' element should be disabled
    And 'submit button' element text should be 'Choose quantity'
    When I click on '<Opposite direction>' label
    Then the '<Opposite direction>' button should be '<Opposite color>' when it is 'clicked'
    When I click on '<Direction>' label
    Then the '<Direction>' button should be '<Color>' when it is 'clicked'
    When I fill 'quantity' with value '<Quantity>'
    Then 'submit button' element should be disabled
    And 'submit button' element text should be 'Enter a price'
    When I fill 'order price' with value '<Order price>'
    Then 'submit button' element should be enabled
    And 'submit button' element text should be 'Place Order'
    When I check 'stop' checkbox
    And I fill the '1'st normal stop linked order 'price' with value '<Stop price>' in the 'current market'
    Then the '1'st normal stop linked order 'points' input should be autopopulated
    And the '1'st normal stop linked order 'p/l' input should be autopopulated
    When I check 'limit' checkbox
    And I fill the '2'nd limit linked order 'price' with value '<Limit price>' in the 'current market'
    Then the '2'nd limit linked order 'points' input should be autopopulated
    And the '2'nd limit linked order 'p/l' input should be autopopulated
    When '<Direction>' price should change with time
    And '<Opposite direction>' price should change with time
    Then the '1'st normal stop linked order 'p/l' input should be autopopulated
    And the '2'nd limit linked order 'p/l' input should be autopopulated
    When I click on 'submit' button
    Then 'confirmation' element text should be 'Order placed'
    And 'market name' element text should be '<Market name>'
    # OPENED ISSUES: https://jira.gaincapital.com/browse/TPDWT-16713
    #                https://jira.gaincapital.com/browse/TPDWT-15622
    And open <Direction> '<Market name>' order confirmation message should be correct
    When I click on 'ok' button
    And I add new 'Positions And Orders' panel in 'current' tab
    And I resize panel with:
      | height | 600  |
      | width  | 800  |
    And I select 'Orders' list
    Then the 'previously added' market should be present on the list

    Examples:
      | Market name     | Quantity | Order price | Stop price | Limit price | Direction | Opposite direction | Color | Opposite color |
      | USD/JPY         | 1000     | 200         | 190        | 210         | buy       | sell               | blue  | red            |
      | GBP/USD DFT     | 1        | 3           | 4          | 2           | sell      | buy                | red   | blue           |

  @smoke @USD/JPY @order-ticket-advanced-view-add/remove-trailing-stop/limit @wt-865
  Scenario Outline: Order Ticket Advanced View - Add/Remove Trailing Stop/Limit
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I click on '<Direction>' in the '<Market name>' market
    Then the 'Deal ticket' panel should be visible
    When I switch to 'order' tab
    Then 'order' ticket type should be 'selected'
    When I click on 'advancedTicket' link
    Then 'market info' element text should be '<Market name>'
    And 'sell' price should change with time
    And 'buy' price should change with time
    And '<Market name>' 'quantity' placeholder should be correct
    And the '1'st normal stop order should contain fields:
      | itemName      |
      | checkbox      |
      | dropdown      |
      | quantity      |
      | price         |
      | points        |
      | p/l           |
      | applicability |
    And the '2'nd limit order should contain fields:
      | itemName      |
      | checkbox      |
      | label         |
      | quantity      |
      | price         |
      | points        |
      | p/l           |
      | applicability |
    And the order ticket advanced view panel should contain items:
      | itemName                     |
      | order price                  |
      | quantity                     |
      | good till dropdown           |
      | add stop limit dropdown link |
      | hedging toggle               |
      | hedging info icon            |
      | standard ticket link         |
    When I hover main order 'hedging info icon' element
    Then order ticket 'hedging tooltip' element is visible
    When I expand add stop limit dropdown
    Then add a stop or limit dropdown from order tab contains correct items
    When I select 'Trailing stop' from expanded dropdown
    Then 'standard ticket link' element should be disabled
    And the number of linked orders should be '3'
    And the '3'rd trailing stop order should contain fields:
      | itemName      |
      | trash icon    |
      | dropdown      |
      | quantity      |
      | points away   |
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
      | points        |
      | p/l           |
      | applicability |
    When I remove '4'th limit order
    Then the number of linked orders should be '3'
    When I remove '3'rd trailing stop order
    Then the number of linked orders should be '2'

    Examples:
        | Market name | Direction |
        | USD/JPY     | buy       |
        | GBP/USD DFT | sell      |

  @quick @smoke @GBP/USD-DFT @place-buy/sell-order-/w-multiple-linked-orders-cfd/spread-market
  Scenario Outline: Place buy/sell order with multiple linked orders - CFD/Spread market
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I click on '<Direction>' in the '<Market name>' market
    Then the 'Deal ticket' panel should be visible
    When I switch to 'order' tab
    Then 'order' ticket type should be 'selected'
    When I click on 'advancedTicket' link
    And I expand add stop limit dropdown
    Then add a stop or limit dropdown from order tab contains correct items
    And I select 'Trailing stop' from expanded dropdown
    Then 'standard ticket link' element should be disabled
    And the number of linked orders should be '3'
    And the '3'rd guaranteed stop order should contain fields:
      | itemName      |
      | trash icon    |
      | dropdown      |
      | quantity      |
      | points away   |
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
      | points        |
      | p/l           |
      | applicability |
    When I fill 'Order price' with value '<Order price>'
    And I fill 'Quantity' with value '<Quantity>'
    And I check 'stop' checkbox
    And I fill the '1'st normal stop linked order 'quantity' with value '<1st stop quantity>' in the 'current market'
    And I fill the '1'st normal stop linked order 'price' with value '<1st stop price>' in the 'current market'
    Then the '1'st normal stop linked order 'points' input should be autopopulated
    And the '1'st normal stop linked order 'p/l' input should be autopopulated
    When I check 'limit' checkbox
    And I fill the '2'nd limit linked order 'quantity' with value '<2nd limit quantity>' in the 'current market'
    And I fill the '2'nd limit linked order 'price' with value '<2nd limit price>' in the 'current market'
    Then the '2'nd limit linked order 'points' input should be autopopulated
    And the '2'nd limit linked order 'p/l' input should be autopopulated
    When I fill the '3'rd trailing stop linked order 'quantity' with value '<Trailing quantity>' in the 'current market'
    And I fill the '3'rd trailing stop linked order 'points away' with value '<Points>' in the 'current market'
    And I fill the '4'th limit linked order 'quantity' with value '<4th limit quantity>' in the 'current market'
    And I fill the '4'th limit linked order 'price' with value '<4th limit price>' in the 'current market'
    Then the '4'th limit linked order 'points' input should be autopopulated
    And the '4'th limit linked order 'p/l' input should be autopopulated
    When I click on 'submit' button
    Then 'confirmation' element text should be 'Order placed'
    And 'market name' element text should be '<Market name>'
    When I click on 'ok' button
    Then the 'Positions And Orders' panel should be visible
    And I select 'Orders' list
    Then the 'previously added' market should be present on the list
    And the 'previously added' market 'stop price' cell should contain 'multiple' word
    And the 'previously added' market 'limit price' cell should contain 'multiple' word

    Examples:
        | Market name | Direction | Order price | Quantity | 1st stop quantity | 1st stop price | 2nd limit quantity | 2nd limit price | Trailing quantity | Points | 4th limit quantity | 4th limit price |
        | USD/JPY     | buy       | 121.514     | 2100     | 1000              | 100            | 1000               | 155.5           | 1100              | 20     | 1000               | 134.7           |
        | GBP/USD DFT | sell      | 1.7         | 20       | 10                | 1.9            | 10                 | 1.1             | 1                 | 10     | 10                 | 1               |

  @smoke @USD/JPY @place-sell-order-/w-multiple-linked-orders-of-different-applicability-spread-market
  Scenario: Place sell order with multiple linked orders of different applicability - Spread market
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I click on 'buy' in the 'USD/JPY' market
    Then the 'Deal ticket' panel should be visible
    When I switch to 'order' tab
    Then 'order' ticket type should be 'selected'
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
    When I fill 'order price' with value '115'
    And I fill 'quantity' with value '2000'
    And I fill the '1'st normal stop linked order 'quantity' with value '1000' in the 'current market'
    Then 'submit button' element should be disabled
    And 'submit button' element text should be 'Choose stop and limit levels'
    When I fill the '1'st normal stop linked order 'price' with value '100' in the 'current market'
    Then the '1'st normal stop linked order 'points' input should be autopopulated
    And the '1'st normal stop linked order 'p/l' input should be autopopulated
    And 'submit button' element should be enabled
    When I check 'limit' checkbox
    Then 'submit button' element should be disabled
    And 'submit button' element text should be 'Choose quantity'
    When I expand '2'nd applicability dropdown
    And I select 'GTT' from expanded dropdown
    Then 'GTT' option should be selected in '2'nd applicability dropdown
    And the '2'nd limit order should contain fields:
      | itemName      |
      | date picker   |
    When I fill the '2'nd limit linked order 'quantity' with value '1000' in the 'current market'
    Then 'submit button' element should be disabled
    And 'submit button' element text should be 'Choose stop and limit levels'
    When I fill the '2'nd limit linked order 'price' with value '120' in the 'current market'
    Then the '2'nd limit linked order 'points' input should be autopopulated
    And the '2'nd limit linked order 'p/l' input should be autopopulated
    When I expand '2'nd date picker dropdown
    And I add to date/time picker '2' hours
    And 'submit button' element should be enabled
    When I expand add stop limit dropdown
    And I select 'Trailing stop' from expanded dropdown
    And I fill the '3'rd trailing stop linked order 'quantity' with value '1000' in the 'current market'
    And I fill the '3'rd trailing stop linked order 'points away' with value '30' in the 'current market'
    And I expand '3'rd applicability dropdown
    And I select 'GTD' from expanded dropdown
    Then 'GTD' option should be selected in '3'rd applicability dropdown
    And 'submit button' element should be enabled
    When I click on 'submit' button
    Then 'confirmation' element text should be 'Order placed'
    When I click on 'ok' button
    Then the 'Positions And Orders' panel should be visible
    When I select 'Orders' list
    Then the 'previously added' market should be present on the list
    When I click on 'stop price' in the 'USD/JPY' market
    Then the 'Deal ticket' panel should be visible
    And 'GTC' option should be selected in '1'st applicability dropdown
    And 'GTT' option should be selected in '2'nd applicability dropdown
    And 'GTD' option should be selected in '3'rd applicability dropdown

  @quick @smoke @USD/JPY @edit-an-order-with-multiple-linked-orders-price/qty-spread/cfd @wt-1058 @wt-1429
  Scenario Outline: Edit an order with multiple linked orders - Price/Quantity - Spread/CFD
    Then the 'Positions And Orders' panel should be visible
    When I add order with parameters:
      | MarketName | <Market name> |
      | Direction  | <Direction>   |
      | Quantity   | <Quantity>    |
      | Price      | <Order price> |
      | StopPrice  | <Stop price>  |
      | LimitPrice | <Limit price> |
    And I select 'Orders' list
    Then the 'previously added' market should be present on the list
    When I click on 'stop price' in the '<Market name>' market
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'edit order'
    When I click on 'advancedTicket' link
    And I fill 'order price' with value '<Greater price>'
    Then '<Direction>' '<Market name>' main 'default' <Linked order 1> price validation should be correct
    When I fill 'order price' with value '<Less price>'
    Then '<Direction>' '<Market name>' main 'default' <Linked order 2> price validation should be correct
    When I fill 'order price' with value '<Order price>'
    # if market CFD - p/l is converted to account currency
    # https://jira.gaincapital.com/browse/TPDWT-11092
    Then the '<Market name>' '1'st normal stop linked order p/l value should be correct
    And the '<Market name>' '2'nd limit linked order p/l value should be correct
    When I expand add stop limit dropdown
    And I select 'Trailing stop' from expanded dropdown
    Then the number of linked orders should be '3'
    And the '3'rd trailing stop order should contain fields:
      | itemName      |
      | trash icon    |
      | dropdown      |
      | quantity      |
      | points away   |
      | applicability |
    When I fill the '1'st normal stop linked order 'quantity' with value '<New stop qty>' in the 'current market'
    Then the '<Market name>' '1'st normal stop linked order p/l value should be correct
    When I fill the '2'nd limit linked order 'quantity' with value '<New limit qty>' in the 'current market'
    Then the '<Market name>' '2'nd limit linked order p/l value should be correct
    When I fill the '3'rd trailing stop linked order 'quantity' with value '<New trailing stop qty>' in the 'current market'
    And I fill the '3'rd trailing stop linked order 'points away' with value '<Points away>' in the 'current market'
    And I click on 'submit' button
    And I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
    When I make 'Positions And Orders' panel active
    And I select 'Orders' list
    Then the 'previously added' market should be present on the list
    And the 'previously added' market 'stop price' cell should contain 'multiple' word
    # skipped due to Adv+ issue
#     And the 'previously added' market 'limit price' cell should contain 'correct' data
    When I click on 'stop price' in the '<Market name>' market
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'edit order'
    # skipped due to Adv+ issue
#     And the number of linked orders should be '3'

    Examples:
      | Market name | Quantity | New stop qty | New limit qty | New trailing stop qty | Points away | Order price | Stop price | Limit price | Direction | Greater price | Less price | Linked order 1 | Linked order 2 |
      | USD/JPY     | 3000     | 1300         | 1300          | 1500                  | 10          | 200         | 190        | 210         | buy       | 260           | 150        | limit          | stop           |
      | GBP/USD DFT | 3        | 1            | 1             | 2                     | 100         | 3           | 4          | 2           | sell      | 5             | 1          | stop           | limit          |

  @quick @smoke @USD/JPY @edit-an-order-with-multiple-linked-orders-stop/limit-add-linked-order @wt-842 @wt-1432
  Scenario Outline: Edit an order with multiple linked orders - Stop/Limit - Spread/CFD
    Then the 'Positions And Orders' panel should be visible
    When I add order with parameters:
      | MarketName | <Market name> |
      | Direction  | <Direction>   |
      | Quantity   | <Quantity>    |
      | Price      | <Order price> |
      | StopPrice  | <Stop price>  |
      | LimitPrice | <Limit price> |
    And I select 'Orders' list
    Then the 'previously added' market should be present on the list
    When I hover '<Market name>' market
    And I click on 'dropdown arrow' in the 'current' market
    And I select 'Edit Order' in dropdown menu in 'current' market
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'edit order'
    And 'market info' element text should be '<Market name>'
    And 'sell' price should change with time
    And 'buy' price should change with time
    And 'order price' input should be predefined with '<Order price>'
    And 'quantity' input should be predefined with '<Quantity>'
    And the edit ticket standard view panel should contain items:
      | itemName             |
      | order price          |
      | quantity             |
      | good till dropdown   |
      | advanced ticket link |
      | hedging status       |
      | oco link             |
    And the '1'st normal stop order should contain fields:
      | itemName |
      | checkbox |
      | label    |
      | price    |
      | p/l      |
    And the '2'nd limit order should contain fields:
      | itemName |
      | checkbox |
      | label    |
      | price    |
      | p/l      |
    And the '1'st normal stop linked order 'checkbox input' element should be enabled
    And the '2'nd limit linked order 'checkbox input' element should be enabled
    And the '1'st normal stop linked order 'price' element should be enabled
    And the '2'nd limit linked order 'price' element should be enabled
    And the '1'st normal stop linked order 'p/l' element should be enabled
    And the '2'nd limit linked order 'p/l' element should be enabled
    And 'submit button' element should be disabled
    When I close 'deal ticket' panel
    Then the 'Deal ticket' panel should be invisible
    When I make 'Positions And Orders' panel active
    And I am on the 'Orders' list
    And I hover '<Market name>' market
    And I click on 'stop price' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'edit order'
    When I close 'deal ticket' panel
    Then the 'Deal ticket' panel should be invisible
    When I make 'Positions And Orders' panel active
    And I am on the 'Orders' list
    And I hover '<Market name>' market
    And I click on 'limit price' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'edit order'
    When I fill the '1'st normal stop linked order 'price' with value '<New stop price>' in the 'current market'
    # OPENED ISSUES: https://jira.gaincapital.com/browse/TPDWT-16713
    #                https://jira.gaincapital.com/browse/TPDWT-15622
    Then the '<Market name>' '1'st normal stop linked order p/l value should be correct
    And 'submit button' element should be enabled
    When I fill the '2'nd limit linked order 'price' with value '<New limit price>' in the 'current market'
    Then the '<Market name>' '2'nd limit linked order p/l value should be correct
    And 'submit button' element should be enabled
    When I click on 'submit' button
    Then 'confirmation' element text should be 'Order updated'
    And 'market name' element text should be '<Market name>'
    And 'confirmation message' element text should be 'Your order has been updated.'
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
    When I make 'Positions And Orders' panel active
    And I am on the 'Orders' list
    Then the 'previously added' order 'stop price' should contain correct data
    And the 'previously added' order 'limit price' should contain correct data
    When I hover 'previously added' order
    And I click on 'dropdown arrow' in the 'current' market
    And I select 'Edit Order' in dropdown menu in 'current' market
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'edit order'
    When I click on 'advancedTicket' link
    And I expand add stop limit dropdown
    And I select 'Normal stop' from expanded dropdown
    Then the number of linked orders should be '3'
    When I expand add stop limit dropdown
    And I select 'Limit' from expanded dropdown
    Then the number of linked orders should be '4'
    When I expand add stop limit dropdown
    And I select 'Trailing stop' from expanded dropdown
    Then the number of linked orders should be '5'
    When I fill the '1'st normal stop linked order 'quantity' with value '<New stop qty>' in the 'current market'
    And I fill the '1'st normal stop linked order 'price' with value '<Stop price>' in the 'current market'
    And I fill the '2'nd limit linked order 'quantity' with value '<New limit qty>' in the 'current market'
    And I fill the '2'nd limit linked order 'price' with value '<Limit price>' in the 'current market'
    And I fill the '3'rd normal stop linked order 'quantity' with value '<New stop qty>' in the 'current market'
    And I fill the '3'rd normal stop linked order 'price' with value '<Stop price>' in the 'current market'
    And I fill the '4'th limit linked order 'quantity' with value '<New limit qty>' in the 'current market'
    And I fill the '4'th limit linked order 'price' with value '<Limit price>' in the 'current market'
    And I fill the '5'th trailing stop linked order 'quantity' with value '<New trailing stop qty>' in the 'current market'
    And I fill the '5'th trailing stop linked order 'points away' with value '<Points away>' in the 'current market'
    And I click on 'submit' button
    Then correct confirmation message about adding '3' linked orders should be displayed
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
    When I make 'Positions And Orders' panel active
    And I am on the 'Orders' list
    Then the 'previously added' market 'stop price' cell should contain 'multiple' word
    And the 'previously added' market 'limit price' cell should contain 'multiple' word
    When I hover '<Market name>' market
    And I click on 'stop price' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'edit order'
    When I fill the '1'st normal stop linked order 'price' with value '<New stop price>' in the 'current market'
    And I fill the '2'nd limit linked order 'price' with value '<New limit price>' in the 'current market'
    And I fill the '3'rd normal stop linked order 'price' with value '<New stop price>' in the 'current market'
    And I fill the '4'th limit linked order 'price' with value '<New limit price>' in the 'current market'
    And I fill the '5'th trailing stop linked order 'points away' with value '<New points away>' in the 'current market'
    And I click on 'submit' button
    Then 'confirmation' element text should be 'Order updated'
    And 'market name' element text should be '<Market name>'
    And 'confirmation message' element text should be 'Your order has been updated.'
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
    When I make 'Positions And Orders' panel active
    And I am on the 'Orders' list
    And I hover '<Market name>' market
    And I click on 'limit price' in the 'current' market
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'edit order'
    When I check 'stop' checkbox
    And I check 'limit' checkbox
    And I remove '5'th trailing stop order
    And I remove '4'th limit order
    And I remove '3'rd normal stop order
    And I click on 'submit' button
    Then 'confirmation' element text should be 'Order updated'
    And 'market name' element text should be '<Market name>'
    And correct confirmation message about removing '5' linked orders should be displayed
    When I click on 'ok' button
    Then the 'Deal ticket' panel should be invisible
    When I make 'Positions And Orders' panel active
    And I am on the 'Orders' list
    Then the 'previously added' market 'stop price' cell should contain 'set' word
    And the 'previously added' market 'limit price' cell should contain 'set' word

    Examples:
      | Market name | Quantity | New stop qty | New limit qty | New trailing stop qty | Points away | New points away | Order price | Stop price | Limit price | Direction | New stop price | New limit price |
      | USD/JPY     | 5000     | 1300         | 1300          | 1500                  | 10          | 20              | 200         | 190        | 210         | buy       | 150            | 250             |
      | GBP/USD DFT | 5        | 1            | 1             | 2                     | 100         | 150             | 3           | 4          | 2           | sell      | 5              | 1               |

  @smoke @USD/JPY @edit-an-order-with-multiple-linked-orders-remove-linked-order
  Scenario Outline: Edit an order with multiple linked orders - Remove linked order
    Then the 'Watchlist' panel should be visible
    And I expand 'Popular Markets' watchlist
    And I click on '<Direction>' in the '<Market name>' market
    Then the 'Deal ticket' panel should be visible
    When I switch to 'order' tab
    Then 'order' ticket type should be 'selected'
    When I click on 'advancedTicket' link
    And I fill 'order price' with value '<Order price>'
    And I fill 'quantity' with value '<Quantity>'
    And I check 'stop' checkbox
    And I fill the '1'st normal stop linked order 'quantity' with value '<New stop qty>' in the 'current market'
    And I fill the '1'st normal stop linked order 'price' with value '<Stop price>' in the 'current market'
    Then the '1'st normal stop linked order 'points' input should be autopopulated
    And the '1'st normal stop linked order 'p/l' input should be autopopulated
    When I check 'limit' checkbox
    And I fill the '2'nd limit linked order 'quantity' with value '<New limit qty>' in the 'current market'
    And I fill the '2'nd limit linked order 'price' with value '<Limit price>' in the 'current market'
    Then the '2'nd limit linked order 'points' input should be autopopulated
    And the '2'nd limit linked order 'p/l' input should be autopopulated
    When I expand add stop limit dropdown
    And I select 'Trailing stop' from expanded dropdown
    And I fill the '3'rd trailing stop linked order 'quantity' with value '<New trailing stop qty>' in the 'current market'
    And I fill the '3'rd trailing stop linked order 'points away' with value '<Points away>' in the 'current market'
    And I click on 'submit' button
    And I click on 'ok' button
    Then the 'Positions And Orders' panel should be visible
    When I select 'Orders' list
    Then the 'previously added' market should be present on the list
    When I click on 'stop price' in the '<Market name>' market
    Then the 'Deal ticket' panel should be visible
    And 'ticket label' element text should be 'edit order'
    And the number of linked orders should be '3'
    When I remove '3'rd trailing stop order
    Then the '3'rd trailing stop order should contain fields:
    | itemName    |
    | undo button |
    And 'delete message' element text should be 'Changes will take effect once you click "Update Order" below'
    When I click on 'submit' button
    And I click on 'ok' button
    And I make 'Positions And Orders' panel active
    And I select 'Orders' list
    Then the 'previously added' market 'stop price' cell should contain 'correct' data

    Examples:
      | Market name | Quantity | New stop qty | New limit qty | New trailing stop qty | Points away | Order price | Stop price | Limit price | Direction |
      | USD/JPY     | 3000     | 1500         | 1300          | 1300                  | 10          | 200         | 190        | 210         | buy       |
      | GBP/USD DFT | 3        | 2            | 1             | 1                     | 100         | 3           | 4          | 2           | sell      |


  @quick @smoke @ppe @delete-watchlist @trade-button-is-disabled-when-price-isn't-defined @wt-1293 @ignore
  Scenario: Trade button is disabled when price isn't defined
    Then 'Default Workspace' tab should be active
    When I make 'Watchlist' panel active
    And I create 'New Watchlist 1' watchlist
    Then the 'New Watchlist 1' watchlist should be visible
    When I expand 'New Watchlist 1' watchlist
    And I type 'US 2 YR T-Note - DECIMAL (per 0.01) Dec 18 CFD' name of market in 'New Watchlist 1' watchlist
    Then the 'market from dropdown' element should be visible on 'New Watchlist 1' watchlist
    When I add '2'nd market from market dropdown
    Then the 'previously added' market is visible
    When I click on 'buy' in the 'US 2 YR T-Note - DECIMAL (per 0.01) Dec 18 CFD' market
    Then the 'Deal ticket' panel should be visible
    And 'trade' ticket type should be 'selected'
    When I fill 'quantity' with value '1'
    Then 'submit button' element should be disabled


  @smoke @quick @order-error-handling-missing-price/quantity,invalid-price/quantity-stop/limit-price-buy/sell-cfd/spread
  Scenario Outline: Order Error Handling - Missing Price/Quantity, Invalid Price/Quantity - Stop/Limit Price - Buy/Sell CFD/Spread
    Then the 'Watchlist' panel should be visible
    And I expand 'Popular Markets' watchlist
    And I click on '<Direction>' in the '<Market name>' market
    Then the 'Deal ticket' panel should be visible
    When I switch to 'order' tab
    Then 'order' ticket type should be 'selected'
    And 'submit button' element should be disabled
    And 'submit button' element text should be 'Choose quantity'
    When I fill main 'quantity' with value '<Less than min qty>'
    Then '<Market name>' main order 'min quantity' validation should be correct
    And 'submit button' element text should be 'Quantity too low'
    When I fill main 'quantity' with value '<Greater than max qty>'
    Then '<Market name>' main order 'max quantity' validation should be correct
    And 'submit button' element text should be 'Quantity too high'
    When I clear 'quantity' field
    Then 'submit button' element should be disabled
    And 'submit button' element text should be 'Choose quantity'
    When I fill main 'quantity' with value '<Quantity>'
    Then 'submit button' element should be disabled
    And 'submit button' element text should be 'Enter a price'
    When I fill '<Market name>' main price with value between current prices
    Then '<Market name>' main order 'between price' validation should be correct
    And 'submit button' element should be disabled
    And 'submit button' element text should be 'Enter valid order price'
    When I fill main 'order price' with value '<Order price>'
    Then 'submit button' element should be enabled
    And 'submit button' element text should be 'Place Order'
    When I check 'stop' checkbox
    Then 'submit button' element should be disabled
    And 'submit button' element text should be 'Choose stop and limit levels'
    When I fill the '1'st normal stop linked order 'price' with value '<Stop price>' in the 'current market'
    Then '<Direction>' '<Market name>' main '1'st stop price validation should be correct
    And 'submit button' element should be disabled
    And 'submit button' element text should be '<Submit btn Stop txt>'
    When I uncheck 'stop' checkbox
    And I check 'limit' checkbox
    Then 'submit button' element should be disabled
    And 'submit button' element text should be 'Choose stop and limit levels'
    When I fill the '2'nd limit linked order 'price' with value '<Limit price>' in the 'current market'
    Then '<Direction>' '<Market name>' main '2'nd limit price validation should be correct
    And 'submit button' element should be disabled
    And 'submit button' element text should be '<Submit btn Limit txt>'

    Examples:
      | Market name | Direction | Quantity | Order price | Less than min qty | Greater than max qty | Stop price | Limit price | Submit btn Stop txt | Submit btn Limit txt |
      | USD/JPY     | buy       | 1010     | 200         | 900               | 50000002             | 250        | 90          | stop level too high | limit level too low  |
      | GBP/USD DFT | sell      | 2        | 3           | 0.05              | 6370                 | 1          | 5           | stop level too low  | limit level too high |

  @smoke @quick @validation @order-error-handling-multiple-stop/limit-quantity-buy/sell-cfd/spread
  Scenario Outline: Order Error Handling - Multiple - Stop/Limit Quantity - Buy/Sell CFD/Spread
    Then the 'Watchlist' panel should be visible
    And I expand 'Popular Markets' watchlist
    And I click on '<Direction>' in the '<Market name>' market
    Then the 'Deal ticket' panel should be visible
    When I switch to 'order' tab
    Then 'order' ticket type should be 'selected'
    And 'submit button' element should be disabled
    And 'submit button' element text should be 'Choose quantity'
    When I fill main 'quantity' with value '<Quantity>'
    Then 'submit button' element should be disabled
    And 'submit button' element text should be 'Enter a price'
    When I fill main 'order price' with value '<Order price>'
    Then 'submit button' element should be enabled
    And 'submit button' element text should be 'Place Order'
    When I click on 'advancedTicket' link
    And I check 'stop' checkbox
    Then 'submit button' element should be disabled
    And 'submit button' element text should be 'Choose stop and limit levels'
    When I fill the main '1'st normal stop linked order 'quantity' with value '<1st stop quantity>' in the 'current market'
    And I check 'limit' checkbox
    And I fill the main '2'nd limit linked order 'quantity' with value '<2nd limit quantity>' in the 'current market'
    When I expand add stop limit dropdown
    And I select 'Normal stop' from expanded dropdown
    And I fill the main '3'rd normal stop linked order 'quantity' with value '<3rd stop quantity>' in the 'current market'
    Then the main '3'rd stop max quantity validation should be correct
    When I expand add stop limit dropdown
    And I select 'Limit' from expanded dropdown
    And I fill the main '4'th limit linked order 'quantity' with value '<4th limit quantity>' in the 'current market'
    Then the main '4'th limit max quantity validation should be correct

    Examples:
      | Market name | Direction | Quantity | Order price | 1st stop quantity | 2nd limit quantity | 3rd stop quantity | 4th limit quantity |
      | USD/JPY     | buy       | 2500     | 130         | 1000              | 1100               | 1600              | 1700               |
      | GBP/USD DFT | sell      | 10       | 2           | 3                 | 4                  | 8                 | 10                 |

  @smoke @bug @points-away-precision
  Scenario: Points Away precision
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I click on 'sell' in the 'UK 100 DFT' market
    Then the 'Deal ticket' panel should be visible
    When I switch to 'order' tab
    And I click on 'advancedTicket' link
    And I expand add stop limit dropdown
    And I select 'Trailing stop' from expanded dropdown
    And I fill the '3'rd trailing stop linked order 'quantity' with value '2' in the 'current market'
    And I fill the '3'rd trailing stop linked order 'points away' with value '1234.4444' in the 'current market'
    Then the '3'rd trailing stop linked order 'points away' input should be '1234.4'

  @smoke @USD/JPY @UK-100-DFT @order-auto-populated-fields @wt-154
  Scenario Outline: Order auto-populated fields
    Then the 'Watchlist' panel should be visible
    When I expand 'Popular Markets' watchlist
    And I click on '<Direction>' in the '<Market name>' market
    Then the 'Deal ticket' panel should be visible
    When I switch to 'order' tab
    And I fill main 'quantity' with value '<Quantity>'
    And I fill main 'order price' with value '<Order price>'
    And I check 'stop' checkbox
    Then I store data from the main '1'st normal stop linked order
    And I fill the main '1'st normal stop linked order 'points' with value '<Points>' in the 'current market'
    # OPENED ISSUES: https://jira.gaincapital.com/browse/TPDWT-16713
    #                https://jira.gaincapital.com/browse/TPDWT-15622
    Then the main '1'st normal stop linked order 'price' input should be changed
    And the main '1'st normal stop linked order 'p/l' input should be changed
    When I clear the main '1'st normal stop linked order 'points' input field
    Then the main '1'st normal stop linked order 'points' input should be blank
    And the main '1'st normal stop linked order 'price' input should be blank
    And the main '1'st normal stop linked order 'p/l' input should be blank
    Then I store data from the main '1'st normal stop linked order
    When I fill the main '1'st normal stop linked order 'price' with value '<Stop price>' in the 'current market'
    Then the main '1'st normal stop linked order 'points' input should be changed
    And the main '1'st normal stop linked order 'p/l' input should be changed
    When I clear the main '1'st normal stop linked order 'price' input field
    Then the main '1'st normal stop linked order 'points' input should be blank
    And the main '1'st normal stop linked order 'price' input should be blank
    And the main '1'st normal stop linked order 'p/l' input should be blank
    Then I store data from the main '1'st normal stop linked order
    When I fill the main '1'st normal stop linked order 'p/l' with value '<Loss>' in the 'current market'
    Then the main '1'st normal stop linked order 'points' input should be changed
    And the main '1'st normal stop linked order 'price' input should be changed
    When I check 'limit' checkbox
    Then I store data from the main '2'nd limit linked order
    And I fill the main '2'nd limit linked order 'points' with value '<Points>' in the 'current market'
    Then the main '2'nd limit linked order 'price' input should be changed
    And the main '2'nd limit linked order 'p/l' input should be changed
    When I clear the main '2'nd limit linked order 'points' input field
    Then the main '2'nd limit linked order 'points' input should be blank
    And the main '2'nd limit linked order 'price' input should be blank
    And the main '2'nd limit linked order 'p/l' input should be blank
    Then I store data from the main '2'nd limit linked order
    When I fill the main '2'nd limit linked order 'price' with value '<Limit price>' in the 'current market'
    Then the main '2'nd limit linked order 'points' input should be changed
    And the main '2'nd limit linked order 'p/l' input should be changed
    When I clear the main '2'nd limit linked order 'price' input field
    Then the main '2'nd limit linked order 'points' input should be blank
    And the main '2'nd limit linked order 'price' input should be blank
    And the main '2'nd limit linked order 'p/l' input should be blank
    Then I store data from the main '2'nd limit linked order
    When I fill the main '2'nd limit linked order 'p/l' with value '<Profit>' in the 'current market'
    Then the main '2'nd limit linked order 'points' input should be changed
    And the main '2'nd limit linked order 'price' input should be changed
    When I fill main 'quantity' with value '<Quantity 2>'
    Then the main '1'st normal stop linked order 'points' input should be changed
    Then the main '1'st normal stop linked order 'price' input should be changed
    And the main '2'nd limit linked order 'points' input should be changed
    And the main '2'nd limit linked order 'price' input should be changed

    Examples:
      | Market name | Quantity | Direction | Points | Stop price | Limit price | Loss | Profit | Quantity 2 | Order price |
      | USD/JPY     | 1000     | buy       | 100    | 90         | 120         | -100 | 1000   | 2000       | 100         |
      | UK 100 DFT  | 3        | sell      | 100    | 8000       | 6000        | -30  | 300    | 6          | 7000        |
